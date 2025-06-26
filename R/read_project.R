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
#' @param tamanhoDaPagina Set the page size. A larger value reduces the number of API calls.
#' @param geometry Converts WKB code to Geometry.  Defaults to `TRUE`. Turn FALSE if you feel it is breaking the downloading.
#' @param showProgress A logical value to control whether the progress bar is displayed.
#' @param max_pages Maximum number of pages to download. Change to `Inf` to download all pages.
#' @param parallel A logical value to enable parallel processing for downloads. Defaults to `FALSE`.
#' @param workers An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`.
#' @return A data frame with investment projects.
#' @importFrom sf st_as_sfc
#' @export
read_project <- function(
    idUnico = NULL,
    situacao = NULL,
    codigoOrganizacao = NULL,
    nomeOrganizacao = NULL,
    uf = NULL,
    dataCadastro = NULL,
    natureza = NULL,
    tamanhoDaPagina = 10,
    geometry = TRUE,
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
  project <- obrasgov_api_request(
    path = "/projeto-investimento", 
    query_params = query_params, 
    showProgress = showProgress, 
    max_pages = max_pages,
    parallel = parallel,
    workers = workers
  )
  
  db <- flatten_projects(project)
  
  if (geometry) {
    
    
    
    # The tryCatch block ONLY attempts to create the new geometry column.
    # It does not modify 'db' directly.
    nova_coluna_geom <- tryCatch({
      
      # --- TRY Block ---
      wkb_data <- db[["geometrias"]]$geometrias_geometria
      
      # It only calculates and returns the new column.
      sf::st_as_sfc(structure(as.list(wkb_data), class = "WKB"), EWKB=TRUE)
      
    }, error = function(e) {
      
      # --- ERROR Block ---
      message("WARNING: Could not convert the geometry column.")
      # message("Error detail: ", e$message)
      
      # Returns NULL to signal that the operation failed.
      return(NULL)
    })
    
    # After the tryCatch, we check if the column creation was successful.
    if (!is.null(nova_coluna_geom)) {
      # If it is not NULL, the operation worked!
      # Now, we perform the final assignment safely.
      db[["geometrias"]]$geom_converted <- nova_coluna_geom
      message("Geometry column (geom_converted) added successfully to geometrias dataframe.")
    }
    # If 'nova_coluna_geom' is NULL, nothing happens, and the original 'db' is preserved.
  }
  
  # Returns 'db', whether modified or not.
  return(db)
  
}
