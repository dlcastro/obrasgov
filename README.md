# obrasgovR: Um Pacote R para Acesso à API do Obrasgov

![R-CRAN-Badge](https://img.shields.io/badge/R-4.0%2B-blue.svg) ![License](https://img.shields.io/badge/License-MIT-green.svg)

O `obrasgovR` é um pacote R desenvolvido para simplificar a interação com a API do Obrasgov (https://api.obrasgov.gestao.gov.br/obrasgov/api/swagger-ui/index.html#/). Ele oferece funções intuitivas para extrair dados de todos os endpoints disponíveis, permitindo que analistas e pesquisadores acessem informações sobre projetos de investimento, execução financeira, execução física e georreferenciamento de obras públicas federais diretamente em seus fluxos de trabalho em R.

## Por que usar `obrasgovR`?

*   **Acesso Simplificado**: Abstrai a complexidade das requisições HTTP e do tratamento de JSON.
*   **Dados Estruturados**: Retorna os dados da API diretamente em formatos amigáveis do R (data frames).
*   **Foco na Análise**: Permite que você se concentre na análise dos dados, em vez de na coleta.
*   **Abrangente**: Cobre todos os endpoints da API do Obrasgov.

## Instalação

Para instalar a versão de desenvolvimento do `obrasgovR` diretamente do GitHub, você precisará do pacote `devtools`. Se você ainda não o tem, instale-o primeiro:

```R
# 1. Instale o pacote 'devtools' (se ainda não tiver)
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools", repos = "http://cran.us.r-project.org")
}

# 2. Instale o pacote 'obrasgovR' do GitHub
devtools::install_github("dlcastro/obrasgovR").
```

## Como Usar: Um Guia Rápido

Após a instalação, você pode carregar o pacote e começar a usar suas funções. Cada função corresponde a um endpoint da API do Obrasgov e aceita parâmetros que filtram a consulta, assim como na documentação oficial da API.

### 1. Carregando o Pacote

```R
library(obrasgovR)
```

### 2. Funções de Extração de Dados

As funções do `obrasgovR` são nomeadas de forma clara para refletir os endpoints da API. Abaixo estão exemplos de como usar cada uma delas.

#### `obrasgov_get_projetos_investimento()`

Esta função permite consultar projetos de investimento. Você pode filtrar por situação, UF, município, eixo, etc.

**Parâmetros Comuns:**
*   `idUnico`: Identificador único da intervenção.
*   `situacao`: Situação da intervenção (e.g., "Em Execução", "Paralisada", "Cancelada", "Castrada", "Concluída" ou "Inacabada").
*   `uf`: UF principal da intervenção (e.g., "DF", "SP").
*   `municipio`: Município principal da intervenção (e.g., "Brasília", "São Paulo").
*   `eixo`: Eixo do projeto de investimento (e.g., "EDUCAÇÃO", "SAÚDE").
*   `dataInicio`, `dataFim`: Datas de início e fim da intervenção (formato: "yyyy-MM-dd").
*   `page`, `size`: Parâmetros de paginação para controlar o número de resultados e a página.

**Exemplo:** Obter projetos de investimento com situação "Concluída" no Distrito Federal.

```R
projetos_concluidos_df <- obrasgov_get_projetos_investimento(
  situacao = "Concluída",
  uf = "DF",
  size = 50 # Aumenta o número de resultados por página
)

# Visualize as primeiras linhas do resultado
head(projetos_concluidos_df)

# Verifique a estrutura dos dados
str(projetos_concluidos_df)
```

#### `obrasgov_get_execucao_financeira()`

Consulta dados de execução financeira para intervenções.

**Parâmetros Comuns:**
*   `idUnico`: Identificador único da intervenção.
*   `page`, `size`: Parâmetros de paginação.

**Exemplo:** Obter dados de execução financeira para um ID único específico.

```R
# **ATENÇÃO**: Substitua 'SEU_ID_UNICO_AQUI' por um ID único real de uma intervenção.
execucao_financeira <- obrasgov_get_execucao_financeira(
  idUnico = "SEU_ID_UNICO_AQUI"
)

head(execucao_financeira)
```

#### `obrasgov_get_saldo_contabil()`

Consulta o saldo contábil de intervenções.

**Parâmetros Comuns:**
*   `idUnico`: Identificador único da intervenção.
*   `page`, `size`: Parâmetros de paginação.

**Exemplo:** Obter saldo contábil para um ID único específico.

```R
# **ATENÇÃO**: Substitua 'SEU_ID_UNICO_AQUI' por um ID único real de uma intervenção.
saldo_contabil <- obrasgov_get_saldo_contabil(
  idUnico = "SEU_ID_UNICO_AQUI"
)

head(saldo_contabil)
```

#### `obrasgov_get_execucao_fisica()`

Consulta dados de execução física de intervenções.

**Parâmetros Comuns:**
*   `idUnico`: Identificador único da intervenção.
*   `page`, `size`: Parâmetros de paginação.

**Exemplo:** Obter dados de execução física para um ID único específico.

```R
# **ATENÇÃO**: Substitua 'SEU_ID_UNICO_AQUI' por um ID único real de uma intervenção.
execucao_fisica <- obrasgov_get_execucao_fisica(
  idUnico = "SEU_ID_UNICO_AQUI"
)

head(execucao_fisica)
```

#### `obrasgov_get_arquivos_intervencao()`

Consulta arquivos (fotos e vídeos) relacionados a uma intervenção.

**Parâmetros Comuns:**
*   `idUnico`: Identificador único da intervenção.
*   `page`, `size`: Parâmetros de paginação.

**Exemplo:** Obter arquivos de intervenção para um ID único específico.

```R
# **ATENÇÃO**: Substitua 'SEU_ID_UNICO_AQUI' por um ID único real de uma intervenção.
arquivos_intervencao <- obrasgov_get_arquivos_intervencao(
  idUnico = "SEU_ID_UNICO_AQUI"
)

head(arquivos_intervencao)
```

#### `obrasgov_get_geometria()`

Consulta dados de georreferenciamento de intervenções.

**Parâmetros Comuns:**
*   `idUnico`: Identificador único da intervenção.
*   `page`, `size`: Parâmetros de paginação.

**Exemplo:** Obter dados de georreferenciamento para um ID único específico.

```R
# **ATENÇÃO**: Substitua 'SEU_ID_UNICO_AQUI' por um ID único real de uma intervenção.
geometria <- obrasgov_get_geometria(
  idUnico = "SEU_ID_UNICO_AQUI"
)

head(geometria)
```

## Contribuição

Contribuições são bem-vindas! Se você encontrar um bug, tiver uma sugestão de melhoria ou quiser adicionar novas funcionalidades, por favor, abra uma issue ou envie um pull request no repositório do GitHub.

## Licença

Este pacote é distribuído sob a licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.


