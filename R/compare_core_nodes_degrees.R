#' @title Comparing the degrees between Rich-club and non-Rich-club genes
#'
#' @description
#' Comparing the degrees between Rich-club and non-Rich-club genes
#'
#' @param study_network a study network igraph object
#' @param rc_network a rich-club network igraph object
#'
#' @return Dataframe with degrees
#' @export
#'
#' @import tidyverse
#' @import igraph
#' @import gdata
#'
#' @examples compare_core_nodes_degrees(study_network, rc_network)

compare_core_nodes_degrees <- function(study_network, rc_network)
  {
RC.genes <- as.data.frame(V(rc_network))
degree.g.df <- as.data.frame(degree(study_network))

degree.RC <- filter(degree.g.df, rownames(degree.g.df) %in% paste(rownames(RC.genes)))
degree.not.RC <- filter(degree.g.df, !rownames(degree.g.df) %in% paste(rownames(RC.genes)))
degree.RC.df <- data.frame(RC.genes = rownames(degree.RC), RC.genes.degrees = degree.RC[,1])
degree.not.RC.df <- data.frame(Non.RC.genes = rownames(degree.not.RC), Non.RC.genes.degrees = degree.not.RC[,1])
degree.rc.vs.not.df <- cbindX(degree.RC.df,degree.not.RC.df)

return(degree.rc.vs.not.df)


}
