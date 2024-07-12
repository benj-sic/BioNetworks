#' @title rc_coeff
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
#' @import gdata
#'
#' @examples compare_core_nodes_degrees(study_network, rc_network)

rc_coeff <- function (g, k = 1, weighted = FALSE, A = NULL)
{
  stopifnot(is_igraph(g))
  degs <- check_degree(g)
  Nv <- vcount(g)
  Nk <- sum(degs > k)
  if (Nk == 0L)
    return(list(phi = NaN, graph = make_empty_graph(), Nk = 0L,
                Ek = 0))
  eattr <- wts <- NULL
  if (isTRUE(weighted)) {
    eattr <- "weight"
    wts <- TRUE
  }
  if (is.null(A))
    A <- as_adj(g, names = FALSE, sparse = FALSE, attr = eattr)
  vids <- order(degs)[(Nv - Nk + 1L):Nv]
  g.rich <- graph_from_adjacency_matrix(A[vids, vids, drop = FALSE],
                                        mode = "undirected", diag = FALSE, weighted = wts)
  Ek <- ecount(g.rich)
  if (isTRUE(weighted)) {
    Wr <- sum(E(g.rich)$weight)
    weights <- sort(E(g)$weight, decreasing = TRUE)[seq_len(Ek)]
    phi <- Wr/sum(weights)
  }
  else {
    phi <- graph.density(g.rich)
  }
  return(list(phi = phi, graph = g.rich, Nk = Nk, Ek = Ek))
}
