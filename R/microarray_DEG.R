#' @title Microarray DEGs
#'
#' @description
#' This function identifies differentially expressed genes (DEGs) from microarray data
#'
#' @param data Microarray counts table with observations as columns and genes as rows with gene names as row-names
#' @param control beginning label of control observations e.g. CTL (in: CTL.1, CTL.2,..)
#' @param condition beginning label of condition observations e.g. Rx (in: Rx.1, Rx.2,..)
#'
#' @return Returns names of DEGs
#' @export
#'
#' @import tidyverse
#'
#' @examples microarray_DEGS(data= data, control ="CTL",condition= "Rx")

microarray_degs <- function(data,control, condition) {

t_test_results <- data %>%
  rowwise() %>%
  mutate(p_value = t.test(c_across(starts_with(control)),c_across(starts_with(condition)))$p.value) %>%
  ungroup() %>% as.data.frame()
row.names(t_test_results) <- row.names(data)
DEGs <- t_test_results %>% filter(p_value < 0.05) %>% rownames()
return(DEGs)
}
