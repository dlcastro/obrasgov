#' Get Georeferencing Data
#' 
#' This function retrieves Projects' georeferencing data from the Obrasgov.BR API.
#' @param idUnico Unique identifier of the intervention.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @return A data frame with georeferencing data.
#' @export
read_geom <- function(
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
  
  obrasgov_api_request(
    path = "/geometria",
    query_params = query_params,
    showProgress = showProgress
  )
}