#retorna todos os duplicados

dup_all <- function(df) {
  
  return(c(duplicated(df) | duplicated(df, fromLast=TRUE)))
  
  
}