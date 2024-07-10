#' @title Identify rich-club nodes in a network
#'
#' @description
#' This function identifies rich-club nodes (hubs) using the pre-computed rich-club coefficients for
#' the sutdy network and random networks
#'
#' @param study_network a study network igraph object
#' @param rc_coeff.df a dataframe containing the calculated rich-club coefficients for the
#' study network and random networks, along with normalized values. Calculated using the compare_rc_coeff() function.
#' @param weighted the option to calculate an edge weighted or unweighted rich-club coefficient
#'
#' @return Network of hub nodes
#' @export
#'
#' @import brainGraph
#' @import tidyverse
#' @import igraph
#'
#' @examples rc_nodes(study_network,rc_coeff.df,weighted=F)

rc_nodes <- function(study_network,rc_coeff.df,weighted=F)

{
find_k_for_consecutive_dec_phi <- function(column) {
  for (i in 3:(length(column) - 2)) {
    if (column[i] < column[i-1] && column[i-1] < column[i-2] &&
        column[i-2] < column[i-3] && column[i-3] < column[i-4]) {
      return(i) }}
  return(NA)}

k_cutoff <- find_k_for_consecutive_dec_phi(rc_coeff.df$Norm.phi)

e <- as_adjacency_matrix(study_network)
g.RC.coef <- rich_club_coeff(g, k= k_cutoff, weighted = weighted, A= e)
g.RC <- g.RC.coef$graph

return(g.RC)

}
