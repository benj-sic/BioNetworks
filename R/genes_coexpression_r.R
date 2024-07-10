#' @title Genes co-expression using Pearson correlation
#'
#' @description
#' This function calculated genes co-expression using pearson's correlation r value
#'
#' @param data microarray counts table
#'
#' @return A dataframe with gene-gene co-expression pearson's r
#' @export
#'
#' @import Hmisc
#' @import tidyverse
#'
#' @examples genes_coexpression_r(data = data)

genes_coexpression_r <- function(data = data) {


  data.cor <- as.data.frame(t(data))
  data.cor[] <- sapply(data.cor, as.numeric)

  expr.cor <- rcorr(as.matrix(data.cor),type="pearson")
  expr.cor$r <- ifelse(expr.cor$P >= 0.05, 0.001, expr.cor$r)
  expr.cor$r <- abs(expr.cor$r)

  expr.cor.r.df <- as.data.frame(expr.cor$r)

  net_a_r <- data.frame(expr.cor$r) %>% mutate(gene1 = row.names(.)) %>%
    pivot_longer(-gene1) %>% dplyr::rename(gene2 = name, correlation = value) %>%
    unique() %>% subset(!(gene1==gene2))
  net_a_p <- data.frame(expr.cor$P) %>% mutate(gene1 = row.names(.)) %>%
    pivot_longer(-gene1) %>% dplyr::rename(gene2 = name, correlation = value) %>%
    unique() %>% subset(!(gene1==gene2))

  gene.coExp <- merge(net_a_r, net_a_p, by.x = c("gene1", "gene2"), by.y = c("gene1", "gene2"))
  colnames(gene.coExp)[colnames(gene.coExp) %in% c("correlation.x", "correlation.y")] <- c("Correlation_r_value", "Correlation_P_value")

  print("Note: Pearson correlation: P>0.05 r is converted to 0.001 and negative sign removed")

  return(gene.coExp)
}
