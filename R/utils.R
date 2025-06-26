#' @importFrom httr GET content http_error http_status
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_rows tibble
#' @importFrom progress progress_bar
#' @importFrom furrr future_map_dfr
#' @importFrom future plan multisession
#' @importFrom progressr with_progress handlers
NULL

#' Base function to make API requests to Obrasgov
#'
#' This function now handles pagination automatically, displays a progress bar,
#' and allows limiting the number of pages, with an option for parallel downloads.
#' It also handles API inconsistencies in parameter naming (page/pagina).
#' @param path The API endpoint path.
#' @param query_params A list of query parameters.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @param max_pages An integer to limit the maximum number of pages to download.
#' @param parallel A logical value to enable parallel processing.
#' @param workers An integer specifying the number of parallel workers (cores) to use.
#' @return A data frame with the API response.
#' @keywords internal
obrasgov_api_request <- function(path, query_params = list(), showProgress = TRUE, max_pages = Inf, parallel = FALSE, workers = 2) {
  base_url <- "https://api.obrasgov.gestao.gov.br/obrasgov/api"
  url <- paste0(base_url, path)
  
  # The 'projeto-investimento' endpoint uses 'pagina' and 'tamanhoDaPagina'.
  # Other endpoints use 'page' and 'size'. We detect which one to use.
  is_proj_invest_endpoint <- path == "/projeto-investimento"
  page_param_name <- if (is_proj_invest_endpoint) "pagina" else "page"
  
  # Initial request to get metadata
  query_params[[page_param_name]] <- 0
  response <- httr::GET(url, query = query_params)
  
  if (httr::http_error(response)) {
    stop(paste("API request failed:", httr::http_status(response)$reason))
  }
  
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, flatten = TRUE)
  
  if (is.null(data$content) || length(data$content) == 0) {
    return(dplyr::tibble())
  }
  
  first_page_data <- data$content
  total_pages <- data$totalPages
  pages_to_fetch <- min(total_pages, max_pages, na.rm = TRUE)
  
  if (pages_to_fetch <= 1) {
    return(first_page_data)
  }
  
  remaining_pages <- 1:(pages_to_fetch - 1)
  
  if (parallel) {
    if (showProgress) {
      progressr::handlers(global = TRUE)
      progressr::handlers("progress") 
    }
    
    future::plan(future::multisession, workers = workers)
    
    fetch_page <- function(page_num, .progress = TRUE) {
      q_params <- query_params
      q_params[[page_param_name]] <- page_num
      
      tryCatch({
        resp <- httr::GET(url, query = q_params)
        if (httr::http_error(resp)) return(NULL)
        cont <- httr::content(resp, "text", encoding = "UTF-8")
        jsonlite::fromJSON(cont, flatten = TRUE)$content
      }, error = function(e) {
        warning(paste("Request for page", page_num, "failed:", e$message))
        return(NULL)
      })
    }
    
    message(paste("Iniciando download paralelo com", workers, "workers..."))
    
    remaining_data <- NULL
    progressr::with_progress({
      p <- progressr::progressor(steps = length(remaining_pages))
      remaining_data <- furrr::future_map_dfr(remaining_pages, ~{
        res <- fetch_page(.x)
        p() 
        res
      }, .options = furrr::furrr_options(seed = TRUE))
    })
    
    return(dplyr::bind_rows(first_page_data, remaining_data))
    
  } else {
    all_data_list <- list(first_page_data)
    
    if (showProgress) {
      pb <- progress::progress_bar$new(
        format = "Downloading page :current from :total [:bar] :percent in :elapsed",
        total = pages_to_fetch, clear = FALSE, width = 60
      )
      pb$tick()
    }
    
    for (page_num in remaining_pages) {
      query_params[[page_param_name]] <- page_num
      response <- httr::GET(url, query = query_params)
      
      if (showProgress) pb$tick()
      
      if (httr::http_error(response)) {
        warning(paste("Request for page", page_num, "failed. Skipping."))
        next
      }
      
      content <- httr::content(response, "text", encoding = "UTF-8")
      page_data <- jsonlite::fromJSON(content, flatten = TRUE)
      
      if (!is.null(page_data$content) && length(page_data$content) > 0) {
        all_data_list <- append(all_data_list, list(page_data$content))
      }
    }
    return(dplyr::bind_rows(all_data_list))
  }
}





#' Flatten Nested Project Data
#'
#' This function takes the nested data.frame returned by `read_project()` and
#' transforms it into a list of flat data.frames. The main data.frame contains
#' all non-list columns, and each nested list column is converted
#' into its own separate data.frame.
#'
#' @param project_data A data.frame, typically the result from the `read_project()` function.
#' @return A list of data.frames. The first element, named 'projects', contains
#'   the main project data. Subsequent elements are named after
#'   the original nested columns (e.g., 'tomadores', 'executores') and contain
#'   the flattened data from those columns, with an `idUnico` column for joining
#'   and prefixed column names.
#' @importFrom dplyr select select_if rename_with
#' @importFrom tidyr unnest
#' @importFrom rlang sym
#' @export
#' @examples
#' \dontrun{
#' # First, fetch the project data
#' nested_projects <- read_project(uf = "DF", situacao = "Concluída")
#'
#' # Now, flatten the nested data
#' project_list <- flatten_projects(nested_projects)
#'
#' # Access the main projects data.frame
#' main_df <- project_list$projects
#'
#' # Access the flattened geometries data.frame
#' geometries_df <- project_list$geometries
#'
#' # Display the first few rows of the geometries data.frame
#' head(geometries_df)
#' }
flatten_projects <- function(project_data) {
  
  # Returns an empty list if the input data.frame is invalid or empty
  if (!is.data.frame(project_data) || nrow(project_data) == 0) {
    return(list())
  }
  
  # 1. Separate the main data.frame (columns that are not lists)
  # Corrected the syntax to use the formula notation `~` required by dplyr's select_if.
  main_df <- project_data |> 
    dplyr::select(dplyr::where(~!is.list(.x)))
  
  # 2. Get the names of the columns that are lists
  list_cols <- names(project_data)[sapply(project_data, is.list)]
  
  # 3. Create the results list, starting with the main data.frame
  result_list <- list(projects = main_df)
  
  # 4. Process each list column
  for (col_name in list_cols) {
    
    # Key step: For each nested column, we select the project's `idUnico` 
    # along with the list column itself. The `tidyr::unnest` function then 
    # flattens the list, replicating the corresponding `idUnico` for each 
    # nested element. This ensures the connection between the main data (projects) 
    # and this secondary data is maintained.
    flattened_df <- project_data |>
      dplyr::select(idUnico, !!rlang::sym(col_name)) |>
      tidyr::unnest(cols = c(!!rlang::sym(col_name)), keep_empty = TRUE)
    
    # Check if unnesting produced any columns besides `idUnico`
    if (ncol(flattened_df) > 1) {
      
      # 5. Add a prefix to the new columns, avoiding renaming `idUnico`
      flattened_df <- flattened_df |>
        dplyr::rename_with(
          ~ paste(col_name, .x, sep = "_"),
          -idUnico
        )
      
      # Add the flattened data.frame to the results list
      result_list[[col_name]] <- flattened_df
    }
    # If unnesting results only in `idUnico` (i.e., all nested lists 
    # were empty or null), the data.frame is not added to the list to avoid redundancy.
  }
  
  return(result_list)
}

