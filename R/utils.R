#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr bind_rows
NULL

#' Base function to make API requests to Obrasgov
#'
#' This function is not exported and is for internal package use only.
#' @param path The API endpoint path (e.g., "/projeto-investimento").
#' @param query_params A list of query parameters.
#' @return A data frame with the API response.
#' @keywords internal
obrasgov_api_request <- function(path, query_params = list()) {
  base_url <- "https://api.obrasgov.gestao.gov.br/obrasgov/api"
  url <- paste0(base_url, path)
  
  response <- httr::GET(url, query = query_params)
  
  if (httr::http_error(response)) {
    stop(paste("API request failed:", httr::http_status(response)$reason))
  }
  
  content <- httr::content(response, "text", encoding = "UTF-8")
  data <- jsonlite::fromJSON(content, flatten = TRUE)
  
  if ("content" %in% names(data)) {
    return(data$content)
  } else {
    return(data)
  }
}


#' Get Financial Execution Data
#' 
#' This function retrieves financial execution data from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param page Page number (0-based).
#' @param size Page size.
#' @return A data frame with financial execution data.
#' @export
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


#' Get Financial Balance Data
#' 
#' This function retrieves financial balance data from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param page Page number (0-based).
#' @param size Page size.
#' @return A data frame with financial balance data.
#' @export
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


#' Get Physical Execution Data
#' 
#' This function retrieves physical execution data from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param page Page number (0-based).
#' @param size Page size.
#' @return A data frame with physical execution data.
#' @export
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


#' Get Intervention Files (Photos and Videos)
#' 
#' This function retrieves files (photos and videos) related to an intervention from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param page Page number (0-based).
#' @param size Page size.
#' @return A data frame with intervention files data.
#' @export
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


#' Get Georeferencing Data
#' 
#' This function retrieves georeferencing data from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param page Page number (0-based).
#' @param size Page size.
#' @return A data frame with georeferencing data.
#' @export
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


#' Get Investment Projects
#' 
#' This function retrieves investment projects from the Obrasgov API.
#' @param idUnico Unique identifier of the intervention.
#' @param situacao Situation of the intervention (e.g., "Em Execução", "Paralisada", "Cancelada", "Castrada", "Concluída" or "Inacabada").
#' @param codigoOrganizacao Organization code participating in the intervention.
#' @param nomeOrganizacao Organization name participating in the intervention.
#' @param uf Main UF of the intervention (e.g., "DF").
#' @param municipio Main municipality of the intervention (e.g., "Brasília").
#' @param eixo Investment project axis (e.g., "EDUCAÇÃO").
#' @param subEixo Investment project sub-axis (e.g., "EDUCAÇÃO BÁSICA").
#' @param tipoIntervencao Type of intervention (e.g., "OBRAS").
#' @param naturezaIntervencao Nature of intervention (e.g., "CONSTRUÇÃO").
#' @param fonteRecurso Source of resource (e.g., "ORÇAMENTO GERAL DA UNIÃO").
#' @param dataInicio Start date of the intervention (format: yyyy-MM-dd).
#' @param dataFim End date of the intervention (format: yyyy-MM-dd).
#' @param page Page number (0-based).
#' @param size Page size.
#' @return A data frame with investment projects.
#' @export
obrasgov_get_projetos_investimento <- function(
    idUnico = NULL,
    situacao = NULL,
    codigoOrganizacao = NULL,
    nomeOrganizacao = NULL,
    uf = NULL,
    municipio = NULL,
    eixo = NULL,
    subEixo = NULL,
    tipoIntervencao = NULL,
    naturezaIntervencao = NULL,
    fonteRecurso = NULL,
    dataInicio = NULL,
    dataFim = NULL,
    page = 0,
    size = 10
) {
  query_params <- list(
    idUnico = idUnico,
    situacao = situacao,
    codigoOrganizacao = codigoOrganizacao,
    nomeOrganizacao = nomeOrganizacao,
    uf = uf,
    municipio = municipio,
    eixo = eixo,
    subEixo = subEixo,
    tipoIntervencao = tipoIntervencao,
    naturezaIntervencao = naturezaIntervencao,
    fonteRecurso = fonteRecurso,
    dataInicio = dataInicio,
    dataFim = dataFim,
    page = page,
    size = size
  )
  
  # Remove NULL parameters
  query_params <- query_params[!sapply(query_params, is.null)]
  
  obrasgov_api_request("/projeto-investimento", query_params)
}
