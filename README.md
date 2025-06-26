# obrasgov: An R Package for reading data from Obrasgov API

![R-CRAN-Badge](https://img.shields.io/badge/R-4.0%2B-blue.svg) ![License](https://img.shields.io/badge/License-MIT-green.svg)

`obrasgov` is an R package designed to simplify interaction with the Obrasgov API (<https://api.obrasgov.gestao.gov.br/obrasgov/api/swagger-ui/index.html#/>). It provides intuitive functions to extract data from all available endpoints, enabling analysts and researchers to access information on federal public works investment projects, financial execution, physical execution, and georeferencing directly within their R workflows.

## Why use `obrasgov`?

* **Simplified Access**: Abstracts the complexity of HTTP requests and JSON handling.

* **Structured Data**: Returns API data directly in R-friendly formats (data frames).

* **Focus on Analysis**: Allows you to concentrate on data analysis rather than data collection.

* **Comprehensive**: Covers all endpoints of the Obrasgov API.

* **Advanced Features**: Includes built-in support for pagination, progress bars, and parallel downloads to handle large datasets efficiently.

## Installation

To install the development version of `obrasgov` directly from GitHub, you will need the `devtools` package. If you don't have it yet, install it first:

```r
# 1. Install the 'devtools' package (if you haven't already)
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

# 2. Install the 'obrasgov' package from GitHub
devtools::install_github("dlcastro/obrasgov")
```

## How to Use: A Quick Guide

After installation, you can load the package and start using its functions. Each function corresponds to an Obrasgov API endpoint and accepts parameters to filter the query, just like in the official API documentation.

### 1. Loading the Package

```r
library(obrasgov)
```

### 2. Common Function Parameters

Most data extraction functions in `obrasgov` share a set of parameters to control the download process:

* `tamanhoDaPagina` (or `size`): Sets the number of results per page. A larger value reduces the number of API calls but is subject to API limits. Defaults to `20`.

* `showProgress`: A logical value (`TRUE`/`FALSE`) to control whether a progress bar is displayed during download. Defaults to `TRUE`.

* `max_pages`: An integer to limit the maximum number of pages to download. Use `Inf` to get all available pages. Defaults to `Inf`.

* `parallel`: A logical value (`TRUE`/`FALSE`) to enable parallel processing for faster downloads on multi-core machines. Defaults to `FALSE`.

* `workers`: An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`. Defaults to `2`.

### 3. Data Extraction Functions

The functions in `obrasgov` are clearly named to reflect the API endpoints. Below are examples of how to use each one.

#### `obrasgov_get_projetos_investimento()`

This function allows you to query investment projects. You can filter by situation, state (UF), organization, etc.

**Parameters:**

* `idUnico`: Unique identifier of the intervention.

* `situacao`: Situation of the intervention (e.g., "Em Execução", "Paralisada", "Concluída").

* `codigoOrganizacao`: Organization code participating in the intervention.

* `nomeOrganizacao`: Organization name participating in the intervention.

* `uf`: Main state (UF) of the intervention (e.g., "DF", "SP").

* `dataCadastro`: Intervention registration date (format: "YYYY-MM-DD").

* `natureza`: Nature of the intervention (e.g., "Obra").

**Example:** Get completed investment projects in the state of Distrito Federal (DF).

```r
# Get completed projects in DF, fetching 50 results per page
completed_projects_df <- obrasgov_get_projetos_investimento(
  situacao = "Concluída",
  uf = "DF",
  tamanhoDaPagina = 50 
)

# View the first few rows of the result
head(completed_projects_df)
```

#### `obrasgov_get_execucao_financeira()`

Queries financial execution data for interventions.

**Parameters:**

* `idProjetoInvestimento`: The investment project ID.

* `nrNotaEmpenho`: The commitment note number.

* `ugEmitente`: The issuing management unit code.

* `anoInicial`: The starting year for the filter.

* `anoFinal`: The ending year for the filter.

**Example:** Get financial execution data for a specific commitment note from a given year.

```r
# NOTE: Replace with a real commitment note number and year.
financial_execution <- obrasgov_get_execucao_financeira(
  nrNotaEmpenho = "123456789",
  anoInicial = 2023
)

head(financial_execution)
```

#### `obrasgov_get_saldo_contabil()`

Queries the accounting balance of interventions.

**Parameters:**

* `ugEmitente`: The issuing management unit code.

* `nrNotaEmpenho`: The commitment note number.

**Example:** Get the accounting balance for a specific commitment note.

```r
# NOTE: Replace with a real management unit and commitment note number.
accounting_balance <- obrasgov_get_saldo_contabil(
  ugEmitente = "123456",
  nrNotaEmpenho = "987654321"
)

head(accounting_balance)
```

#### `obrasgov_get_execucao_fisica()`

Queries physical execution data of interventions.

**Parameters:**

* `idUnico`: Unique identifier of the intervention.

* `situacao`: Situation of the intervention (e.g., "Em Execução", "Paralisada").

**Example:** Get physical execution data for a specific unique ID.

```r
# NOTE: Replace 'YOUR_UNIQUE_ID_HERE' with a real unique ID from an intervention.
physical_execution <- obrasgov_get_execucao_fisica(
  idUnico = "YOUR_UNIQUE_ID_HERE"
)

head(physical_execution)
```

#### `obrasgov_get_arquivos_intervencao()`

Queries files (photos and videos) related to an intervention.

**Parameters:**

* `idUnico`: Unique identifier of the intervention. *(This parameter is required)*.

**Example:** Get intervention files for a specific unique ID.

```r
# NOTE: Replace 'YOUR_UNIQUE_ID_HERE' with a real unique ID from an intervention.
intervention_files <- obrasgov_get_arquivos_intervencao(
  idUnico = "YOUR_UNIQUE_ID_HERE"
)

head(intervention_files)
```

#### `obrasgov_get_geometria()`

Queries georeferencing data (latitude/longitude) of interventions.

**Parameters:**

* `idUnico`: Unique identifier of the intervention. *(This parameter is required)*.

**Example:** Get georeferencing data for a specific unique ID.

```r
# NOTE: Replace 'YOUR_UNIQUE_ID_HERE' with a real unique ID from an intervention.
geometry_data <- obrasgov_get_geometria(
  idUnico = "YOUR_UNIQUE_ID_HERE"
)

head(geometry_data)
```

## Contribution

Contributions are welcome! If you find a bug, have a suggestion for improvement, or want to add new features, please open an issue or submit a pull request in the [GitHub repository](https://github.com/dlcastro/obrasgov).

## License

This package is distributed under the MIT license. See the `LICENSE` file for more details.
