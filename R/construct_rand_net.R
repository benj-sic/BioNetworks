#' @title Construction of random networks
#'
#' @description
#' Construction of random networks of similar weighted degree distribution based on Fabien Viger and Matthieu Latapy algorithm.
#'
#' @param network an igraph network object
#'
#' @return Visualize the degrees distribution in the interaction network
#' @export
#'
#' @import tidyverse
#' @import igraph
#'
#' @examples construct_rand_net(study_network, number = 100)
#'
construct_rand_net <- function(study_network, number = 100)
{
rand.n <- number
RR <- list()
for(i in 1:rand.n) {
  RR[[i]] <- sample_degseq(degree(study_network), method = c("vl"))
  E(RR[[i]])$study_network <- sample(E(study_network)$weight)}
return(RR)
}
