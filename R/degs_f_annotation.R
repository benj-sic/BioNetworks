#' @title DEGs functional annotations
#'
#' @description
#' This function functionally annotates the identifed DEGs using Gene ontology analysis (biological processes, cellular components and molecular functions)
#'
#' @param genes Gene symbols
#' @param control beginning label of control observations e.g. CTL (in: CTL.1, CTL.2,..)
#' @param condition beginning label of condition observations e.g. Rx (in: Rx.1, Rx.2,..)
#'
#' @return A dataframe with Gene Ontology
#' @export
#'
#' @importFrom clusterProfiler enrichGO
#' @import tidyverse
#' @import org.Mm.eg.db
#' @import org.Hs.eg.db
#'
#' @examples degs_f_annotation(genes=genes, species = "Hs")

degs_f_annotation <- function(genes,species=c("Hs","Mm")) {

  sp <- ifelse(species=="Hs","org.Hs.eg.db",ifelse(species=="Mm", "org.Mm.eg.db",""))
  results <- enrichGO(gene = genes, OrgDb = sp, keyType = "SYMBOL", ont = "ALL")
  results <- mutate(results, `-log10(p.adjust)` = -log10(p.adjust))
  results.df <- as.data.frame(results)

  return(results.df)
}
