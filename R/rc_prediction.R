#' @title Compare the correlation between Rich-club genes expression versus non-Rich-club genes with outcomes
#'
#' @description
#' Compare the correlation between Rich-club genes expression versus non-Rich-club genes with outcomes,
#' using a GLM model with PCA 1, 2 and 3.
#'
#' @param rc_eigengenes.df Cacluated using rc_eigengenes() function
#' @param non_rc_eigengenes.df Cacluated using non_rc_eigengenes() function
#' @param outcomes.df an outcomes dataframe for the same observations
#' @param tested_outcome outcome in the outcomes.df to be tested
#'
#' @return Predictions
#' @export
#'
#' @import brainGraph
#' @import tidyverse
#' @import igraph
#' @import tmod
#'
#' @examples rc_prediction <- function(rc_eigengenes.df, non_rc_eigengenes.df, outcomes.df, tested_outcome)

rc_prediction <- function(rc_eigengenes.df, non_rc_eigengenes.df, outcomes.df, tested_outcome) {

  # 1. Merging eigengenes with outcomes
  RC.egenes.outcomes <- merge(rc_eigengenes.df, outcomes.df, by = 'row.names')
  rand.EG <- list()
  for (i in 1:length(non_rc_eigengenes.df)) {
    rand.EG[[i]] <- merge(non_rc_eigengenes.df[[i]], outcomes.df, by = 'row.names')
  }

  # 2. Linear model for Rich-Club eigengenes
  rc.eigen.model <- summary(lm(as.formula(paste(tested_outcome, "~ a + a.1 + a.2")), data = RC.egenes.outcomes))

  # 3. Correlating random non-Rich-club gene sets eigengenes with outcomes
  rand.EG.lm <- list()
  rand.EG.lm.R2 <- list()
  for (i in 1:length(rand.EG)) {
    rand.EG.lm[[i]] <- summary(lm(as.formula(paste(tested_outcome, "~ a + a.1 + a.2")), data = rand.EG[[i]]))
    rand.EG.lm.R2[[i]] <- rand.EG.lm[[i]]$r.squared
  }
  non.rc.model <- data.frame(R2 = unlist(rand.EG.lm.R2), row.names = 1:length(rand.EG))

  # 4. T-test
  t.test_results <- t.test(non.rc.model[, 1], mu = rc.eigen.model$r.squared, alternative = "two.sided", paired = FALSE, var.equal = FALSE, conf.level = 0.95)

  return(list(rc_eigen_model = rc.eigen.model, non_rc_model = non.rc.model, t_test_results = t.test_results))
}






