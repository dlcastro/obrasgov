

#\" Get Georeferencing Data
#\" 
#\" This function retrieves georeferencing data from the Obrasgov API.
#\" @param idUnico Unique identifier of the intervention.
#\" @param page Page number (0-based).
#\" @param size Page size.
#\" @return A data frame with georeferencing data.
#\" @export
obrasgov_get_geometria <- function(
  idUnico = NULL,
  page = 0,
  size = 10
) {
  query_params <- list(
    idUnico = idUnico,
    page = page,
    size = size
  )
  
  # Remove NULL parameters
  query_params <- query_params[!sapply(query_params, is.null)]

  obrasgov_api_request("/geometria", query_params)
}


