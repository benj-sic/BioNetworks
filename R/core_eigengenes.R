#' @title Calculate rich-club nodes eigengenes
#'
#' @description
#' Calculate rich-club nodes eigengenes
#'
#' @param data microarray counts dataframe with rownames as genes and observations as columns
#' @param study_network a study network igraph object
#' @param rc_network a rich-club network igraph object
#'
#' @return Dataframe with degrees
#' @export
#'
#' @import brainGraph
#' @import tidyverse
#' @import igraph
#' @import tmod
#'
#' @examples core_eigengenes(study_network, rc_network)

core_eigengenes <- function(data, study_network, rc_network)
{

  RC.genes <- as.data.frame(V(rc_network))
  DEG.genes <- as.data.frame(V(study_network))

  RC.groups <- data.frame(ID=c("a","b"), Title=c("RC", "All"))
  RC.genes.list <- list(a =c(paste(rownames(RC.genes))), b = c (paste(unique(DEG.genes))))
  RC.tmod <- makeTmodGS(gs2gene= RC.genes.list, gs= RC.groups)
  RC.tmod.set <- RC.tmod[grep("RC", RC.tmod$gs$Title)]
  RC.eigv1 <- eigengene(data, g= rownames(data), mset= RC.tmod.set, k=1)
  RC.eigv2 <- eigengene(data, g= rownames(data), mset= RC.tmod.set, k=2)
  RC.eigv3 <- eigengene(data, g= rownames(data), mset= RC.tmod.set, k=3)
  RC.egenes <- data.frame(a = t(RC.eigv1), b= t(RC.eigv2), c= t(RC.eigv3))

return(RC.egenes)

  }
