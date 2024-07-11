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

visualize_net <- function(network, direction = "other", title = "Interaction Network")
{

nodescolors <- ifelse(direction == "Up", paletteColorBrewerReds,
                      ifelse(direction == "Down", paletteColorBrewerBlues, paletteColorBrewerGreens))

  createNetworkFromIgraph(network, title = title)
  setEdgeLineWidthMapping("weight", widths = c(0,1))
  setEdgeColorDefault("grey")
  setNodeColorMapping("degree", colors = nodescolors)
  setNodeSizeMapping("strength")

  }

