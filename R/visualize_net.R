#' @title Visualize interactive network
#'
#' @description
#' This function visualizes the interaction network with Cytoscape.
#' Must have Cytoscape application open before using this function.
#'
#' @param network an igraph network object
#'
#' @return Returns as interactive network visualized on Cytoscape
#' @export
#'
#' @import RCy3
#'
#' @examples visualize_net(network)

visualize_net <- function(network)
{
  createNetworkFromIgraph(network, title = "DEGs Interaction Network")
  setEdgeLineWidthMapping("weight", widths=c(0,1))
  setEdgeColorDefault("grey")
  setNodeColorMapping("degree", colors = paletteColorBrewerGreens)
  setNodeSizeMapping("strength")
}

