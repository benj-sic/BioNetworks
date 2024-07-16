#' @title Construct interactive network
#'
#' @description
#' This function constructs an interactive network using the pre-identified interactions and co-epxression values.
#'
#' @param network.df a dataframe with interacting genes/proteins in columns 1 and 2. And an additional column of interaction strength (e.g. co-expression values)
#' @param interaction_score Name of column containing the interaction scores
#' @return Returns as interactive network
#' @export
#'
#' @import igraph
#'
#' @examples construct_network(network.df, interaction_column ="Correlation_r")

construct_network <- function(network.df, interaction_score ="col_name")

{
  DEGs.g <- graph_from_data_frame(network.df[,c(1,2)])
  E(DEGs.g)$weight <- network.df[[interaction_score]]
  V(DEGs.g)$degree <- degree(DEGs.g)
  V(DEGs.g)$node.betweenness <- betweenness(DEGs.g)
  V(DEGs.g)$node.corness <- coreness(DEGs.g)
  V(DEGs.g)$strength <- strength(DEGs.g)
  V(DEGs.g)$transitivity <- transitivity(DEGs.g)

  return(DEGs.g)

}



