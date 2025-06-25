#' Get Investment Projects
#' 
#' This function retrieves investment projects from the Obrasgov API.
#' It supports filtering, pagination control, and parallel downloads.
#' 
#' @param idUnico Unique identifier of the intervention.
#' @param situacao Situation of the intervention (e.g., "Em Execução").
#' @param codigoOrganizacao Organization code participating in the intervention.
#' @param nomeOrganizacao Organization name participating in the intervention.
#' @param uf Main UF of the intervention (e.g., "DF").
#' @param dataCadastro Intervention Registration Date "YYYY-MM-DD".
#' @param natureza Intervation nature (e.g, "Obra").
#' @param tamanhoDaPagina NSet the page size. A larger value reduces the number of API calls.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @param max_pages An integer to limit the maximum number of pages to download. Defaults to `Inf` (all pages).
#' @param parallel A logical value to enable parallel processing for downloads. Defaults to `FALSE`.
#' @param workers An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`.
#' @return A data frame with investment projects.
#' @export
obrasgov_get_projetos_investimento <- function(
    idUnico = NULL,
    situacao = NULL,
    codigoOrganizacao = NULL,
    nomeOrganizacao = NULL,
    uf = NULL,
    dataCadastro = NULL,
    natureza = NULL,
    tamanhoDaPagina = 20,
    showProgress = TRUE,
    max_pages = Inf,
    parallel = FALSE,
    workers = 2
) {
  # Collect all filter arguments into a list
  query_params <- list(
    idUnico = idUnico,
    situacao = situacao,
    codigoOrganizacao = codigoOrganizacao,
    nomeOrganizacao = nomeOrganizacao,
    uf = uf,
    dataCadastro = dataCadastro,
    natureza = natureza,
    tamanhoDaPagina = tamanhoDaPagina
  )
  
  # Remove any NULL parameters that might have been passed
  query_params <- query_params[!sapply(query_params, is.null)]
  
  # Call the base request function, passing all parameters along
  obrasgov_api_request(
    path = "/projeto-investimento", 
    query_params = query_params, 
    showProgress = showProgress, 
    max_pages = max_pages,
    parallel = parallel,
    workers = workers
  )
}
