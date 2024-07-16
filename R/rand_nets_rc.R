#' @title Calculate average rich club coefficient for a list of networks
#'
#' @description
#' Calculate average rich club coefficient for a list of networks
#'
#' @param rand_networks a list of random networks
#' @param weighted the option to calculate an edge weighted or unweighted rich-club coefficient
#'
#' @return Average rich club coefficient for a list of networks
#' @export
#'
#' @import tidyverse
#' @import igraph
#'
#' @examples rand_net_clu(rand_networks)
#'
rand_nets_rc <- function(rand_nets,weighted= F )

{
r.RC <- list()
for (i in 1:length(rand_nets)) {
  r.RC[[i]] <- rc_all(rand_nets[[i]], weighted = weighted)}

rand.phi <- matrix(0, nrow = nrow(r.RC[[1]]) , ncol = 1)
for (row in 1:nrow(r.RC[[1]])) {
  row_values <- sapply(r.RC, function(x) x[row,]$phi)
  rand.phi[row, ] <- mean(row_values)}

return(rand.phi)

}
