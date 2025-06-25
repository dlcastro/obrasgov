#' Get Physical Execution Data
#' 
#' This function retrieves physical execution data from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param situacao Situation of the intervention (e.g., "Em Execução").
#' @param tamanhoDaPagina NSet the page size. A larger value reduces the number of API calls.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @param max_pages An integer to limit the maximum number of pages to download. Defaults to `Inf` (all pages).
#' @param parallel A logical value to enable parallel processing for downloads. Defaults to `FALSE`.
#' @param workers An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`.
#' @return A data frame with physical execution data.
#' @export
obrasgov_get_execucao_fisica <- function(
    idUnico = NULL,
    situacao = NULL,
    showProgress = TRUE
) {
  query_params <- list(
    idUnico = idUnico,
    size = 200 # Using a larger fixed size for pagination
  )
  
  query_params <- query_params[!sapply(query_params, is.null)]
  
  obrasgov_api_request(
    path = "/execucao-fisica", 
    query_params = query_params, 
    showProgress = showProgress, 
    max_pages = max_pages,
    parallel = parallel,
    workers = workers
  )
}


#' Get Intervention Files (Photos and Videos)
#' 
#' This function retrieves files (photos and videos) related to an intervention from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @return A data frame with intervention files data.
#' @export
obrasgov_get_arquivos_intervencao <- function(
    idUnico = NULL,
    showProgress = TRUE
) {
  query_params <- list(
    idUnico = idUnico,
    size = 200 # Using a larger fixed size for pagination
  )
  
  query_params <- query_params[!sapply(query_params, is.null)]
  
  obrasgov_api_request("/execucao-fisica/arquivos-da-intervencao", query_params, showProgress = showProgress)
}
