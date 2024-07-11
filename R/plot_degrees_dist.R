#' @title Plot network degrees distribution
#'
#' @description
#' This function visualizes the degrees distribution in the interaction network,
#' to ensure a scale-free network topology with power-law degrees distribution.
#'
#' @param network an igraph network object
#'
#' @return Visualize the degrees distribution in the interaction network
#' @export
#'
#' @import brainGraph
#' @import tidyverse
#'
#' @examples plot_degrees_dist(network)

plot_degrees_dist <- function(network)
{
  g.RC <- rich_club_all(network)
  g.RC <- g.RC[!is.nan(g.RC$phi), ]
  ggplot(g.RC, aes(x = k, y= Nk)) +
    theme_bw() +
    geom_smooth(color= "black", alpha=0) +
    geom_point(color= "black", alpha=0.4) +
    labs(y = "Nodes with degree > k", x= "Degree(k)", title = "Degree(k) Distribution" ) +
    guides(fill = T)
}

