#' @title Calculate rich club coefficient
#'
#' @description
#' This function calculates the rich club coefficient for the study network and compares it with
#' a list of random networks.
#'
#' @param study_net Study network
#' @param rand_nets a list of random networks
#' @param weighted the option to calculate an edge weighted or unweighted rich-club coefficient
#'
#' @return Average rich club coefficient for a list of networks
#' @export
#'
#' @import brainGraph
#' @import tidyverse
#' @import igraph
#'
#' @examples compare_rc_coeff(study_net,rand_nets,weighted = F)
#'
compare_rc_coeff <- function(study_net,rand_nets,weighted= F)

{
  r.RC <- list()
  for (i in 1:length(rand_nets)) {
    r.RC[[i]] <- rich_club_all(rand_nets[[i]], weighted = weighted)}

  rand.phi <- matrix(0, nrow = nrow(r.RC[[1]]) , ncol = 1)
  for (row in 1:nrow(r.RC[[1]])) {
    row_values <- sapply(r.RC, function(x) x[row,]$phi)
    rand.phi[row, ] <- mean(row_values)}

DEGs.g.RC <- rich_club_all(study_net, weighted = weighted)

#if (length(rand.phi) > length(DEGs.g.RC$phi)) {rand.phi <- rand.phi[1:length(DEGs.g.RC$phi)]}

norm.RC.phi <- (DEGs.g.RC$phi/rand.phi)
RC.df <- data.frame(degree = DEGs.g.RC$k, Network.phi = DEGs.g.RC$phi, Rand.phi = rand.phi, Norm.phi = norm.RC.phi)
RC.df <- RC.df[!is.nan(RC.df$Network.phi), ]



return(RC.df)

}






