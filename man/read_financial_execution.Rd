% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/read_financial_execution.R
\name{read_financial_execution}
\alias{read_financial_execution}
\title{Get Financial Execution Data}
\usage{
read_financial_execution(
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
)
}
\arguments{
\item{idProjetoInvestimento}{idUnico equivalent. The investment project ID.}

\item{nrNotaEmpenho}{The commitment note number.}

\item{ugEmitente}{The issuing management unit code.}

\item{anoInicial}{The starting year for the filter.}

\item{anoFinal}{The ending year for the filter.}

\item{tamanhoDaPagina}{NSet the page size. A larger value reduces the number of API calls.}

\item{showProgress}{A logical value to control whether the progress bar is displayed.}

\item{max_pages}{An integer to limit the maximum number of pages to download. Defaults to \code{Inf} (all pages).}

\item{parallel}{A logical value to enable parallel processing for downloads. Defaults to \code{FALSE}.}

\item{workers}{An integer specifying the number of parallel workers (cores) to use when \code{parallel = TRUE}.}
}
\value{
A data frame with financial execution data.
}
\description{
This function retrieves financial execution data from the Obrasgov API.
}
