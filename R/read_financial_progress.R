#' Get Financial Execution Data
#' 
#' This function retrieves financial execution data from the Obrasgov API.
#' @param idProjetoInvestimento PREENCHER.
#' @param nrNotaEmpenho PREENCHER.  
#' @param ugEmitente description.
#' @param anoInicial preencher.
#' @param anoFinal preencher.
#' @param tamanhoDaPagina NSet the page size. A larger value reduces the number of API calls.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @param max_pages An integer to limit the maximum number of pages to download. Defaults to `Inf` (all pages).
#' @param parallel A logical value to enable parallel processing for downloads. Defaults to `FALSE`.
#' @param workers An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`.
#' @return A data frame with financial execution data.
#' @export
read_financial_progress <- function(
    idProjetoInvestimento = NULL,
    nrNotaEmpenho = NULL,
    ugEmitente = NULL,
    anoInicial = NULL,
    anoFinal = NULL,
    tamanhoDaPagina = 10,
    showProgress = TRUE,
    max_pages = Inf,
    parallel = FALSE,
    workers = 2
) {
  query_params <- list(
    idProjetoInvestimento = idProjetoInvestimento,
    nrNotaEmpenho = nrNotaEmpenho,
    ugEmitente = ugEmitente,
    anoInicial = anoInicial,
    anoFinal = anoFinal
  )
  
  query_params <- query_params[!sapply(query_params, is.null)]
  
  obrasgov_api_request(
    path = "/execucao-financeira", 
    query_params = query_params, 
    showProgress = showProgress, 
    max_pages = max_pages,
    parallel = parallel,
    workers = workers
  )
}

