# 📊 Extração e Organização de Dados Históricos das Eleições Municipais Paulistas (1982–1996)

**Projeto:** `scrap_eleicoes_seade` — **Versão 1.5**

Este projeto tem como objetivo a **extração automatizada e a organização de dados eleitorais históricos** das eleições municipais do estado de São Paulo, compreendendo os anos de **1982, 1985, 1988, 1992 e 1996**. A coleta foi realizada por meio de *web scraping* sobre os arquivos disponibilizados pelo site da Fundação SEADE:  
👉 [http://produtos.seade.gov.br/produtos/moveleitoral/index.php](http://produtos.seade.gov.br/produtos/moveleitoral/index.php)

A partir do desenvolvimento de spiders em Python, foi possível estruturar um banco de dados limpo e padronizado contendo informações detalhadas das eleições para os cargos de **prefeito** e **vereador** (exceto 1985, quando não houve eleição para vereador).

---

## 📁 Arquivos Gerados

- `dados_captados_prefeito.csv` — Resultados das eleições para prefeito  
- `dados_captados_vereador.csv` — Resultados das eleições para vereador  
- Versão dos dados em `.RData` para uso direto no R  
- Dicionário de variáveis documentando o conteúdo e formato dos campos

---

## 🔧 Estrutura do Projeto

- **Spiders** implementadas em Python (pasta `Spider`)  
- **Scripts de processamento e limpeza de dados**  
- Dados finais salvos em `arquivos_finais`

---

## 🆕 Melhorias na Versão 1.5

- Inclusão dos **códigos IBGE e TSE** dos municípios para facilitar integração com outras bases  
- Inclusão de **dicionário de variáveis** para facilitar o reuso do banco por outros pesquisadores

---

Este projeto integra meu portfólio como uma demonstração de competências em **web scraping, organização de bases históricas e preparação de dados para análise em larga escala**, contribuindo para estudos sobre eleições, comportamento político e desenvolvimento regional.
