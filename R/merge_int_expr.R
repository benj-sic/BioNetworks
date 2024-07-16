#' @title Merge gene interaction and co-expression data
#'
#' @description
#' This function merges gene interaction and co-expression data.
#' Function will adjust case sensitivity as needed.
#'
#'
#' @param gene_int.df dataframe with genes interactions
#' @param gene_coexpr dataframe with genes co-expression score
#' @param int_cols names of the two gene names columns in the gene_int.df
#' @param expr_cols names of the two gene names columns in the gene_coexpr.df
#'
#' @return A dataframe with gene-gene co-expression score
#' @export
#'
#' @import tidyverse
#'
#' @examples merge_int_expr(gene_int.df,gene.coexpr.df, int_cols= c("gene1","gene2"),
#'  expr_cols=c("Var1","Var2"))

merge_int_expr <- function(gene_int.df, gene.coexpr.df, int_cols= c("int.col1","int.col2"),
                           coexpr_cols=c("exp.col1","exp.col2"))

{
gene_int.df[int_cols] <- lapply(gene_int.df[int_cols], as.character)
gene.coexpr.df[coexpr_cols] <- lapply(gene.coexpr.df[coexpr_cols], as.character)
gene_int.df <- gene_int.df %>% mutate(across(everything(), ~ if (is.character(.)){ toupper(.)} else {.}))
gene.coexpr.df <- gene.coexpr.df %>% mutate(across(everything(), ~ if (is.character(.)) {toupper(.)} else {.}))
m_data <- merge(gene_int.df, gene.coexpr.df, by.x =int_cols , by.y = coexpr_cols)
return(m_data)
}

