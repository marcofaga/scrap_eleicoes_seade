#Projeto: crawler_seade =====================
#Data: 09 de fevereiro de 2018
# 
#Criado por: Marco Antonio Faganello
#

#BASE ======================================================================
stop()
setwd("C:\\Users\\Marco Faganello\\Dropbox\\projetos\\crawler_seade\\crawler_seade\\crawler_seade\\R")
load()

source("functions/insere_index.R")

#script bd01 =====================================================================
#08 de Fevereiro de 2018
#Arrumando os csvs de São Paulo
#Inclusão da coluna de eleitos e não eleitos nos dados para prefeito
#Inclusão dos dados em versão R
#Dados foram Scrapeados do site do SEADE: http://produtos.seade.gov.br/produtos/moveleitoral/index.php
apag <- read.csv("../arquivos_finais/dados_captados_prefeito.csv",sep=";",header = F)
names(apag) <- c("candidato","partido","votosnom","votosper","municipio","eleicao","cargo")
apag$turno <- "1"
apag$key <- paste(apag$municipio, apag$eleicao,sep="_")
apag$key2 <- c(1:dim(apag)[1])
apag2 <- unique(apag$key)
apag$situacao <- "NAO ELEITO"

for(each in apag2) {
  
  apag3 <- apag[apag$key == each,]
  apag3 <- apag3$key2[apag3$votosnom == max(apag3$votosnom)]
  apag$situacao[apag$key2 == apag3] <- "ELEITO" 
  
  
}

apag$key <- paste(apag$candidato, apag$municipio, apag$eleicao)
apag$key2 <- duplicated(apag$key) | duplicated(apag$key, fromLast = T)
apag$turno[apag$situacao == "ELEITO" & apag$key2 == T] <- "2"
apag3 <- apag$candidato[apag$turno == "2"]
apag$situacao[apag$situacao == "NAO ELEITO" & apag$candidato %in% apag3] <- "PASSOU AO 2 TURNO"
apag$situacao[apag$situacao == "ELEITO" & apag$candidato %in% apag3] <- "ELEITO 2 TURNO"
apag$key <- paste(apag$eleicao, apag$municipio)
apag3 <- unique(apag$key[apag$key2 == T])[-1]
apag4 <- unique(apag$candidato[apag$situacao == "NAO ELEITO" & apag$key %in% apag3 & apag$key2 == T])
apag$key3 <- c(1:dim(apag)[1])
for(each in apag4) {
  
  apag3 <- apag[apag$candidato == each & apag$key2 == T,] 
  apag5 <- apag3$key3[apag3$votosnom == max(apag3$votosnom)]
  apag$turno[apag$key3 == apag5] <- "2"
  
}

apag$situacao[apag$turno == "2" & apag$situacao == "NAO ELEITO"] <- "NAO ELEITO 2 TURNO"
apag$situacao[apag$key2 == T & apag$turno== "1"] <- "PASSOU AO 2 TURNO"
apag <- apag[,-c(9,10,12)]
apag2 <- read.csv("../arquivos_finais/dados_captados_vereador.csv",sep=";",header = F)
apag2$turno <- '1'
names(apag2) <- c("candidato","partido","votosnom","votosper","municipio","eleicao","cargo","situacao","turno")
apag2 <- apag2[,c(1:7,9,8)]
bd01_pref_sp <- apag
bd02_ver_sp <- apag2
index <- insereindex("bd01_pref_sp","Dados das Eleições Municipais de 1982, 1988 e 1992 de todo o Estado de SP")
index <- insereindex("bd02_ver_sp","Dados das Eleições Municipais de 1982, 1988 e 1992 de todo o Estado de SP")
write.csv(bd01_pref_sp,"../arquivos_finais/dados_captados_prefeito.csv",row.names = F)
write.csv(bd02_ver_sp,"../arquivos_finais/dados_captados_vereador.csv",row.names = F)
remove(apag, apag2, apag3, apag4, apag5, each)
save.image("crawler_seade_R.RData")

#07 de março de 2018
#Adicionando dados de 1985 à base
remove(list = ls())
load("crawler_seade_R.RData")
apag <- read.csv("../arquivos_finais/dados_captados_1985.csv",sep=";",header = F)
names(apag) <- c("candidato","partido","votosnom","votosper","municipio","eleicao","cargo")
apag$turno <- "1"
apag$key <- paste(apag$municipio, apag$eleicao,sep="_")
apag$key2 <- c(1:dim(apag)[1])
apag2 <- unique(apag$key)
apag$situacao <- "NAO ELEITO"
for(each in apag2) {
  
  apag3 <- apag[apag$key == each,]
  apag3 <- apag3$key2[apag3$votosnom == max(apag3$votosnom)]
  apag$situacao[apag$key2 == apag3] <- "ELEITO" 
  
  
}
apag <- apag[,-c(9,10)]
apag2 <- read.csv("../arquivos_finais/dados_captados_prefeito.csv", sep=",", header = T)
apag3 <- apag2[apag2$eleicao >= 1988,]
apag2 <- apag2[apag2$eleicao < 1988,]
apag4 <- rbind(apag2, apag, apag3)
bd01_pref_sp <- apag4
remove(apag, apag2, apag3, apag4, each)
write.csv(bd01_pref_sp,"../arquivos_finais/dados_captados_prefeito.csv",row.names = F)
index <- insereindex("bd01_pref_sp","Dados das Eleições Municipais de 1982, 1985, 1988 e 1992 de todo o Estado de SP")
save.image("crawler_seade_R.RData")
