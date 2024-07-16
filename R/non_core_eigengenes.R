#' @title Calculate non-rich-club nodes eigengenes
#'
#' @description
#' Calculate non-rich-club nodes eigengenes for multiple different sampling of network node sets with
#' similar number to the rich-club nodes
#'
#' @param data microarray counts dataframe with rownames as genes and observations as columns
#' @param study.net a study network igraph object
#' @param core.nodes a rich-club network igraph object
#' @param number number of sampling iterations to perform
#'
#' @return Dataframe with degrees
#' @export
#'
#' @import tidyverse
#' @import igraph
#' @import tmod
#'
#' @examples non_core_eigengenes(study_network, rc_network)

non_core_eigengenes <- function(data, study.net, core.nodes, number =100)
{

  RC.genes <- as.data.frame(V(core.nodes))
  DEG.genes <- as.data.frame(V(study.net))

  rownames(RC.genes) <- toupper(rownames(RC.genes))
  rownames(DEG.genes) <- toupper(rownames(DEG.genes))
  rownames(data) <- toupper(rownames(data))

  genes.not.RC <- unique(DEG.genes[!(DEG.genes %in% rownames(RC.genes))])

  rand.EG <- list()
  for (i in 1:number) {
    rand.groups <- data.frame(ID = c("a", "b"), Title = c("Rand", "All"))
    rand.genes <- sample(rownames(genes.not.RC), size = nrow(RC.genes))
    rand.gene.list <- list(a = c(paste(rand.genes)), b = c(paste(unique(rownames(DEG.genes)))))
    rand.tmod <- makeTmodGS(gs2gene = rand.gene.list, gs = rand.groups)
    rand.tmod.set <- rand.tmod[grep("Rand", rand.tmod$gs$Title)]
    rand.eigv1 <- eigengene(data, g = rownames(data), mset = rand.tmod.set, k = 1)
    rand.eigv2 <- eigengene(data, g = rownames(data), mset = rand.tmod.set, k = 2)
    rand.eigv3 <- eigengene(data, g = rownames(data), mset = rand.tmod.set, k = 3)
    rand.egenes <- data.frame(a = t(rand.eigv1), b = t(rand.eigv2), c = t(rand.eigv3))
  }
  return(rand.egenes)

}
