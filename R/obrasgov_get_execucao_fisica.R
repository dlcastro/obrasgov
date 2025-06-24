

#\" Get Physical Execution Data
#\" 
#\" This function retrieves physical execution data from the Obrasgov API.
#\" @param idUnico Unique identifier of the intervention.
#\" @param page Page number (0-based).
#\" @param size Page size.
#\" @return A data frame with physical execution data.
#\" @export
obrasgov_get_execucao_fisica <- function(
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

  obrasgov_api_request("/execucao-fisica", query_params)
}




#\" Get Intervention Files (Photos and Videos)
#\" 
#\" This function retrieves files (photos and videos) related to an intervention from the Obrasgov API.
#\" @param idUnico Unique identifier of the intervention.
#\" @param page Page number (0-based).
#\" @param size Page size.
#\" @return A data frame with intervention files data.
#\" @export
obrasgov_get_arquivos_intervencao <- function(
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

  obrasgov_api_request("/execucao-fisica/arquivos-da-intervencao", query_params)
}


