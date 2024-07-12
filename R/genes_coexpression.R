#' @title Genes co-expression using WGCNA
#'
#' @description
#' This function calculated genes co-expression using WGCNA soft-power adjusted adjacency matrix
#'
#' @param data microarray counts table
#' @param deg A vector of differentially expressed genes
#'
#' @return A dataframe with gene-gene co-expression score
#' @export
#'
#' @import WGCNA
#'
#' @examples genes_coexpression(data = data, method = c("pearson", "scaled"))

genes_coexpression <- function(data = data, deg =deg, method = c("pearson", "scaled")) {

data <- data[deg,]

    if (method == "scaled") {

      data.t <- as.data.frame(t(data))

sft <- pickSoftThreshold(data.t, RsquaredCut = 0.8, powerVector = c(1:100),
                         networkType = "unsigned", verbose = 5)
sft_power <- sft$powerEstimate

co_expression.df <- as.data.frame(as.table(adjacency(t(data), power = sft_power)))
co_expression.df <- co_expression.df[co_expression.df$Var1 != co_expression.df$Var2, ]

return(co_expression.df)

} else if (method == "pearson") {

  data.cor <- as.data.frame(t(data))
  data.cor[] <- sapply(data.cor, as.numeric)

  expr.cor <- rcorr(as.matrix(data.cor),type="pearson")
  expr.cor$r <- ifelse(expr.cor$P >= 0.05, 0.01, expr.cor$r)
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

  print("Note: Pearson correlation: P>0.05 r is converted to 0.01 and the correlations are unsigned")

  return(gene.coExp)}

    else { "Error: No method selected"}


}
