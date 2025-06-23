

#\" Get Financial Execution Data
#\" 
#\" This function retrieves financial execution data from the Obrasgov API.
#\" @param idUnico Unique identifier of the intervention.
#\" @param page Page number (0-based).
#\" @param size Page size.
#\" @return A data frame with financial execution data.
#\" @export
obrasgov_get_execucao_financeira <- function(
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

  obrasgov_api_request("/execucao-financeira", query_params)
}




#\" Get Financial Balance Data
#\" 
#\" This function retrieves financial balance data from the Obrasgov API.
#\" @param idUnico Unique identifier of the intervention.
#\" @param page Page number (0-based).
#\" @param size Page size.
#\" @return A data frame with financial balance data.
#\" @export
obrasgov_get_saldo_contabil <- function(
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

  obrasgov_api_request("/execucao-financeira/saldo-contabil", query_params)
}


