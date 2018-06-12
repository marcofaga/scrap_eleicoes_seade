#Projeto: crawler_seade =====================
#Data: 09 de fevereiro de 2018
# 
#Criado por: Marco Antonio Faganello
#

#BASE ======================================================================
stop()
setwd("C:\\projetos\\crawler_seade\\crawler_seade\\crawler_seade\\R")
load("crawler_seade_R.RData")

source("functions/insere_index.R")
source("functions/clean_apag.R")

#library ===================================================================
#install.packages("stringdist")
library(stringdist)

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

#08 de março de 2018
#Adicionando dados de 1996 à base
remove(list = ls())
load("crawler_seade_R.RData")
apag <- read.csv("../arquivos_finais/dados_captados_1996.csv",sep=";",header = F)
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
apag2 <- read.csv("../arquivos_finais/dados_captados_1996_vereador.csv",sep=";",header = F)
apag2$turno <- '1'
names(apag2) <- c("candidato","partido","votosnom","votosper","municipio","eleicao","cargo","situacao","turno")
apag2 <- apag2[,c(1:7,9,8)]
bd01_pref_sp <- rbind(bd01_pref_sp, apag)
bd02_ver_sp <- rbind(bd02_ver_sp, apag2)
index <- insereindex("bd01_pref_sp","Dados das Eleições Municipais de 1982, 1988, 1992 e 1996 de todo o Estado de SP")
index <- insereindex("bd02_ver_sp","Dados das Eleições Municipais de 1982, 1988, 1992 e 1996 de todo o Estado de SP")
write.csv(bd01_pref_sp,"../arquivos_finais/dados_captados_prefeito.csv",row.names = F)
write.csv(bd02_ver_sp,"../arquivos_finais/dados_captados_vereador.csv",row.names = F)
remove(apag, apag2, apag3, apag4, apag5, each)
save.image("crawler_seade_R.RData")

#11 de junho de 2018
#v1.5 - Inserindo variáveis: código IBGe e TSE dos municípios de São Paulo
apag <- read.csv2("../Data/TSE_IBGE.csv", sep = ";", colClasses = rep("character", 8))
apag <- apag[apag$UF == "SP", ]

bd01_pref_sp$municipio <- as.character(bd01_pref_sp$municipio)

bd02_ver_sp$municipio <- as.character(bd02_ver_sp$municipio)

apag2 <- data.frame(mun = unique(c(bd01_pref_sp$municipio, bd02_ver_sp$municipio)))

#usando pacote soundex para achar as strings aproximadas

apag4 <- data.frame()

for(ap1 in apag2$mun) {
  
  ap2 <- stringdist(ap1, apag$Municipio, "cosine")
  ap2 <- apag$Municipio[which(ap2 == min(ap2))]
  
  apag4 <- rbind(apag4, c(ap1, ap2))
  
}

apag4$ibge <- apag$IBGEcod[match(apag4$X.ADAMANTINA..1, apag$Municipio)]

bd01_pref_sp$ibge_cod <- apag4$ibge[match(bd01_pref_sp$municipio, apag4$X.ADAMANTINA.)]
bd01_pref_sp$tse_cod <- apag$TSEcod[match(bd01_pref_sp$ibge_cod, apag$IBGEcod)]

bd02_ver_sp$ibge_cod <- apag4$ibge[match(bd02_ver_sp$municipio, apag4$X.ADAMANTINA.)]
bd02_ver_sp$tse_cod <- apag$TSEcod[match(bd02_ver_sp$ibge_cod, apag$IBGEcod)]

bd01_pref_sp <- bd01_pref_sp[, c(6, 7, 5, 10, 11, 8, 1:4, 9)]

bd02_ver_sp <- bd02_ver_sp[, c(6, 7, 5, 10, 11, 8, 1:4, 9)]

bd01_pref_sp$candidato <- as.character(bd01_pref_sp$candidato)

bd02_ver_sp$candidato <- as.character(bd02_ver_sp$candidato)

apag <- data.frame(vars = names(bd01_pref_sp))
apag$descricao <- c("ano da eleição",
                    "cargo disputado",
                    "nome do município",
                    "código ibge do município",
                    "código tse do município",
                    "turno da eleição",
                    "nome do candidato",
                    "sigla do partido do candidato",
                    "número absoluto de votos no candidato",
                    "percentual de votos do candidato no município",
                    "situação do candidato na eleição")
apag$class <- sapply(bd01_pref_sp, function(x) class(x))

dicionario <- apag

index <- insereindex("dicionario", "dicionário descrevendo as variáveis em bd01 e bd02")
  
showapag()
write.csv(bd01_pref_sp,"../arquivos_finais/dados_captados_prefeito.csv",row.names = F)
write.csv(bd02_ver_sp,"../arquivos_finais/dados_captados_vereador.csv",row.names = F)
save.image("crawler_seade_R.RData")
