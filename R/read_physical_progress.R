#' Get Physical Execution Data
#' 
#' This function retrieves physical execution data from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param situacao Situation of the intervention ("Em Execução", "Paralisada", "Cancelada", "Cadastrada", "Concluída" or "Inacabada").
#' @param tamanhoDaPagina Set the page size. A larger value reduces the number of API calls.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @param max_pages An integer to limit the maximum number of pages to download. Defaults to `Inf` (all pages).
#' @param parallel A logical value to enable parallel processing for downloads. Defaults to `FALSE`.
#' @param workers An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`.
#' @return A data frame with physical execution data.
#' @export
read_physical_progress <- function(
    idUnico = NULL,
    situacao = NULL,
    showProgress = TRUE,
    tamanhoDaPagina = 10,
    max_pages = Inf,
    parallel = FALSE,
    workers = 2
) {
  query_params <- list(
    idUnico = idUnico,
    situacao = situacao
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

