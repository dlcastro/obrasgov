# obrasgov: Brazil's Obrasgov API data reader <img src="obrasgov_logo_140.png" height="139" align="right"/>

[![CRAN status](https://www.r-pkg.org/badges/version/obrasgov)](https://cran.r-project.org/package=obrasgov) ![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)

`obrasgov` is an R package designed to simplify interaction with the Obrasgov.BR API (<https://api.obrasgov.gestao.gov.br/obrasgov/api/swagger-ui/index.html#/>). It provides intuitive functions to extract data from all available endpoints, allowing analysts and researchers to access information on federal public works investment projects, financial execution, physical execution, and georeferencing directly within their R workflows.

## Why use `obrasgov`?

* **Simplified Access**: Abstracts the complexity of HTTP requests and JSON handling.
* **Structured Data**: Returns API data directly in R-friendly formats (data frames). Nested data handling is resolved internally.
* **Focus on Analysis**: Allows you to concentrate on data analysis rather than data collection.
* **Comprehensive**: Covers all endpoints of the Obras.gov.br API.
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

After installation, you can load the package and start using its functions. Each function corresponds to an Obras.gov.br API endpoint and accepts parameters to filter the query, just like in the official API documentation.

### 1. Loading the Package

```r
library(obrasgov)
```

### 2. Common Function Parameters

Most data extraction functions in `obrasgov` share a set of parameters to control the download process:

* `tamanhoDaPagina`: Sets the number of results per page. A larger value reduces the number of API calls but is subject to API limits.
* `showProgress`: A logical value (`TRUE`/`FALSE`) to control whether a progress bar is displayed during download. Defaults to `TRUE`.
* `max_pages`: An integer to limit the maximum number of pages to download. *Use `Inf` to get all available pages. Defaults to `Inf`.*
* `parallel`: A logical value (`TRUE`/`FALSE`) to enable parallel processing for faster downloads on multi-core machines. Defaults to `FALSE`.
* `workers`: An integer specifying the number of parallel workers (cores) to use when `parallel = TRUE`. Defaults to `2`.

### 3. Data Extraction Functions

The functions in `obrasgov` are clearly named to reflect the API endpoints. Below are examples of how to use each one.

#### `read_project()`

This function allows you to query investment projects. The result is a **list of data frames**, where the main data frame (`projects`) contains the general data, and the other list elements contain the nested data (like `geometrias`, `executores`, etc.), already with an `idUnico` column to facilitate joins.

**Parameters:**

* `idUnico`: Unique identifier of the intervention.
* `situacao`: Situation of the intervention (e.g., "Em Execução", "Paralisada", "Concluída").
* `uf`: Main state (UF) of the intervention (e.g., "DF", "SP").
* `geometry`: A logical value (`TRUE`/`FALSE`). If `TRUE` (default), it attempts to convert the WKB geometry column to an `sfc` (Simple Feature Column) object and adds it as `geom_converted` in the `geometrias` data frame.

**Example:** Get completed investment projects in the Federal District (DF).

```r
# Get completed projects in PR state, fetching 15 results per page
project_list_df <- read_project(
  situacao = "Concluída",
  uf = "PR",
  tamanhoDaPagina = 15,
  max_page = Inf
)

# Access the main projects data frame
main_projects <- project_list_df$projects

# Access the geometries data frame (with the converted column)
geometries <- project_list_df$geometries

# View the first few rows of each
head(main_projects)
head(geometries)
```

#### `read_financial_progress()`

Queries financial execution data for the interventions.

**Parameters:**

* `idProjetoInvestimento`: The investment project ID.
* `nrNotaEmpenho`: The commitment note number.
* `ugEmitente`: The issuing management unit code.
* `anoInicial`: The starting year for the filter.
* `anoFinal`: The ending year for the filter.

**Example:** Get financial execution data for a specific commitment note from a given year.

```r
# NOTE: Replace with a real commitment note number and year.
financial_execution <- read_financial_progress(
  nrNotaEmpenho = "123456789",
  anoInicial = 2023
)

head(financial_execution)
```

#### `read_accounting_balance()`

Queries the accounting balance of the interventions.

**Parameters:**

* `ugEmitente`: The issuing management unit code.
* `nrNotaEmpenho`: The commitment note number.

**Example:** Get the accounting balance for a specific commitment note.

```r
# NOTE: Replace with a real management unit and commitment note number.
accounting_balance <- read_accounting_balance(
  ugEmitente = "123456",
  nrNotaEmpenho = "987654321"
)

head(accounting_balance)
```

#### `read_physical_progress()`

Queries physical execution data of the interventions.

**Parameters:**

* `idUnico`: Unique identifier of the intervention.
* `situacao`: Situation of the intervention (e.g., "Em Execução", "Paralisada").

**Example:** Get physical execution data for a specific `idUnico`.

```r
# NOTE: Replace 'YOUR_UNIQUE_ID_HERE' with a real ID from an intervention.
physical_execution <- read_physical_progress(
  idUnico = "YOUR_UNIQUE_ID_HERE"
)

head(physical_execution)
```

#### `read_media()`

Queries files (photos and videos) related to an intervention.

**Parameters:**

* `idUnico`: Unique identifier of the intervention. *(This parameter is required)*.

**Example:** Get the files for an intervention for a specific `idUnico`.

```r
# NOTE: Replace 'YOUR_UNIQUE_ID_HERE' with a real ID from an intervention.
media_files <- read_media(
  idUnico = "YOUR_UNIQUE_ID_HERE"
)

head(media_files)
```

## Contribution

Contributions are welcome! If you find a bug, have a suggestion for improvement, or want to add new features, please open an issue or submit a pull request in the [GitHub repository](https://github.com/dlcastro/obrasgov).

## License

This package is distributed under the [GPL (>= 3)](http://www.gnu.org/licenses/gpl-3.0.en.html) license. See the `LICENSE` file for more details.

