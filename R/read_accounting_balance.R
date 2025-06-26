
#' Get Financial Balance Data
#' 
#' This function retrieves financial balance data from the Obrasgov API.
#' @param ugEmitente UG Emitente
#' @param nrNotaEmpenho Número do Empenho.
#' @param tamanhoDaPagina NSet the page size. A larger value reduces the number of API calls.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @param max_pages An integer to limit the maximum number of pages to download. Defaults to `Inf` (all pages).
#' @param parallel A logical value to enable parallel processing for downloads. Defaults to `FALSE`.
#' @param workers An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`.
#' @return A data frame with financial balance data.
#' @export
read_accounting_balance <- function(
    ugEmitente = NULL,
    nrNotaEmpenho = NULL,
    tamanhoDaPagina = 10,
    showProgress = TRUE,
    max_pages = Inf,
    parallel = FALSE,
    workers = 2
) {
  query_params <- list(
    ugEmitente = ugEmitente,
    nrNotaEmpenho = nrNotaEmpenho
  )
  
  query_params <- query_params[!sapply(query_params, is.null)]
  
  obrasgov_api_request(
    path = "/execucao-financeira/saldo-contabil", 
    query_params = query_params, 
    showProgress = showProgress, 
    max_pages = max_pages,
    parallel = parallel,
    workers = workers
  )
}
