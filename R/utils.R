#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_rows
NULL

#' Base function to make API requests to Obrasgov
#'
#' @param path The API endpoint path (e.g., "/projeto-investimento").
#' @param query_params A list of query parameters.
#' @return A data frame with the API response.
#' @export
obrasgov_api_request <- function(path, query_params = list()) {
  base_url <- "https://api.obrasgov.gestao.gov.br/obrasgov/api"
  url <- paste0(base_url, path)

  response <- httr::GET(url, query = query_params)

  if (httr::http_error(response)) {
    stop(paste("API request failed:", httr::http_status(response)$reason))
  }

  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, flatten = TRUE)

  if ("content" %in% names(data)) {
    return(data$content)
  } else {
    return(data)
  }
}


