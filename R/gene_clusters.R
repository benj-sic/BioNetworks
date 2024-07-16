#' @title Genes co-expression using WGCNA
#'
#' @description
#' This function calculated genes co-expression using WGCNA soft-power adjusted adjacency matrix
#'
#' @param data Expression counts table
#' @param deg A vector of differentially expressed genes
#' @param method The method to use to calculate the co-expression values
#'
#' @return A dataframe with gene-gene co-expression score
#' @export
#'
#'
#' @examples genes_clusters(data = data, method = c("pearson", "scaled"))

genes_clusters <- function(data = data, deg =deg) {

  data <- data[deg,]



  spellman.cor <- dplyr::select(spellman, -time, -expt) %>%
    cor(use="pairwise.complete.obs")

  spellman.dist <- as.dist(1 - spellman.cor)


  spellman.tree <- hclust(spellman.dist, method="complete")

  clusters <- cutree(spellman.dend, k=4)
  clusters <- cutree(spellman.dend, k=8, order_clusters_as_data = FALSE)


}

#https://bio723-class.github.io/Bio723-book/clustering-in-r.html
