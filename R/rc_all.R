#' @title rc_all
#'
#' @description
#' Comparing the degrees between Rich-club and non-Rich-club genes
#'
#' @param study_network a study network igraph object
#' @param rc_network a rich-club network igraph object
#'
#' @return Dataframe with degrees
#' @export
#'
#' @import tidyverse
#' @import igraph
#'
#' @examples compare_core_nodes_degrees(study_network, rc_network)

rc_all <- function (g, weighted = FALSE, A = NULL)
{

  check_degree <- function(g) {
    if ('degree' %in% vertex_attr_names(g)) V(g)$degree else degree(g)}

  stopifnot(is_igraph(g))
  k <- check_degree(g)
  deg_range <- seq_len(max(k))
  R <- lapply(deg_range, function(x) rich_club_coeff(g, x,
                                                     weighted, A = A))
  phi <- vapply(R, with, numeric(1L), phi)
  Nk <- vapply(R, with, numeric(1L), Nk)
  Ek <- vapply(R, with, numeric(1L), Ek)
  dt.rich <- data.table(k = deg_range, phi = phi, Nk = Nk,
                        Ek = Ek)
  return(dt.rich)
}
