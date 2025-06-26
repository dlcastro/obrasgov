#' Get Media Files (Photos and Videos)
#' 
#' This function retrieves files (photos and videos) related to an project from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @return A data frame with intervention files data.
#' @export
read_media <- function(
    idUnico = NULL,
    showProgress = TRUE
) {
  
  
  # Verify if idUnico is filled.
  if (is.null(idUnico)) {
    stop("idUnico needs to be filled in")
  }
  
  
  query_params <- list(
    idUnico = idUnico
  )
  
  query_params <- query_params[!sapply(query_params, is.null)]
  
  obrasgov_api_request("/execucao-fisica/arquivos-da-intervencao", query_params, showProgress = showProgress)
}
