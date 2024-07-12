#' @title Identify rich-club nodes in a network
#'
#' @description
#' This function identifies rich-club nodes (hubs) using the pre-computed rich-club coefficients for
#' the sutdy network and random networks
#'
#' @param study_network a study network igraph object
#' @param rc_coeff.df a dataframe containing the calculated rich-club coefficients for the study network and random networks, along with normalized values. Calculated using the compare_rc_coeff() function.
#' @param method method for getting the core nodes: "all" or "peak"
#' @param cut_off A cut off value for the core nodes. Value between 1-10
#' @param weighted the option to calculate an edge weighted or unweighted rich-club coefficient
#'
#' @return Network of hub nodes
#' @export
#'
#' @importFrom brainGraph rich_club_coeff
#' @import tidyverse
#' @import igraph
#' @import scales
#'
#' @examples core_nodes(study_network,rc_coeff.df, methods = "all", cut_off = 1,weighted=F)

core_nodes <- function(study_network,rc_coeff.df, method = "all", cut_off = 1,weighted=F)

{


  find_drop_start_index <- function(column) {
    max_value <- max(column)
    max_index <- which(column == max_value)[1]
    for (i in (max_index + 1):length(column)) {
      if (column[i] < column[i-1]) {
        return(i)
      }
    }
    return(NA)
  }

  if(method == "peak")

  {k.c <- find_drop_start_index(rc_coeff.df$Norm.phi)} else if (method == "all")

  {

    k_cutoff <- which(rc_coeff.df$Norm.phi > 1.1)[1]
    sub.df <- rc_coeff.df[k_cutoff:nrow(rc_coeff.df), ]
    sub.df <- subset(sub.df,Rand.phi <1)
    x <- seq(0, 10, by = 0.1)
    s <- rescale(x, to=c(min(sub.df$Norm.phi),max(sub.df$Norm.phi)))
    s_k <- s[x == cut_off]
    k.c <- sub.df$degree[sub.df$Norm.phi == s_k]


  } else {"Error: No method selected"}


e <- as_adjacency_matrix(study_network)
g.RC.coef <- rich_club_coeff(study_network, k= k.c, weighted = weighted, A= e)
g.RC <- g.RC.coef$graph

 gg.RC <- subgraph(study_network, names(V(g.RC)))


return(gg.RC)

}
