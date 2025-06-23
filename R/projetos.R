

#\' Get Investment Projects
#\' 
#\' This function retrieves investment projects from the Obrasgov API.
#\' @param idUnico Unique identifier of the intervention.
#\' @param situacao Situation of the intervention (e.g., "Em Execução", "Paralisada", "Cancelada", "Castrada", "Concluída" or "Inacabada").
#\' @param codigoOrganizacao Organization code participating in the intervention.
#\' @param nomeOrganizacao Organization name participating in the intervention.
#\' @param uf Main UF of the intervention (e.g., "DF").
#\' @param municipio Main municipality of the intervention (e.g., "Brasília").
#\' @param eixo Investment project axis (e.g., "EDUCAÇÃO").
#\' @param subEixo Investment project sub-axis (e.g., "EDUCAÇÃO BÁSICA").
#\' @param tipoIntervencao Type of intervention (e.g., "OBRAS").
#\' @param naturezaIntervencao Nature of intervention (e.g., "CONSTRUÇÃO").
#\' @param fonteRecurso Source of resource (e.g., "ORÇAMENTO GERAL DA UNIÃO").
#\' @param dataInicio Start date of the intervention (format: yyyy-MM-dd).
#\' @param dataFim End date of the intervention (format: yyyy-MM-dd).
#\' @param page Page number (0-based).
#\' @param size Page size.
#\' @return A data frame with investment projects.
#\' @export
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


