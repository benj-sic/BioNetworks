#' @title Genes co-expression using WGCNA
#'
#' @description
#' This function calculated genes co-expression using WGCNA soft-power adjusted adjacency matrix
#'
#' @param data microarray counts table
#'
#' @return A dataframe with gene-gene co-expression score
#' @export
#'
#' @import WGCNA
#'
#' @examples genes_coexpression(data = data)

genes_coexpression <- function(data = data) {


sft <- pickSoftThreshold(data, RsquaredCut = 0.8, powerVector = c(1:100),
                         networkType = "unsigned", verbose = 5)
sft_power <- sft$powerEstimate

co_expression.df <- as.data.frame(as.table(adjacency(t(data), power = sft_power)))
co_expression.df <- co_expression.df[co_expression.df$Var1 != co_expression.df$Var2, ]

return(co_expression.df)

}
