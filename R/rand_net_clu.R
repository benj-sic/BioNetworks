#' @title Calculate cluster-coefficient for a lists of random networks
#'
#' @description
#' Calculate cluster-coefficient for random graph
#'
#' @param rand_networks a list of random networks
#'
#' @return Visualize the degrees distribution in the interaction network
#' @export
#'
#' @import brainGraph
#' @import tidyverse
#' @import igraph
#'
#' @examples rand_net_clu(rand_networks)
#'

rand_net_clu <- function(rand_networks)
{
clu.phi <- vector()
for (i in 1:length(rand_networks)) {clu.phi[i] <- transitivity(rand_networks[[i]])}

return(clu.phi)
}
