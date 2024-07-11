#' @title Calculate cluster-coefficient for a  networks
#'
#' @description
#' Calculate cluster-coefficient for a graph
#'
#' @param study_network a networks
#'
#' @return Visualize the degrees distribution in the interaction network
#' @export
#'
#' @import brainGraph
#' @import tidyverse
#' @import igraph
#'
#' @examples net_clu_coeff(rand_networks)
#'

net_clu_coeff <- function(study_networks)
{
  cc <- transitivity(study_networks)
  return(cc)
}
