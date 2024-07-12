#' @title Identify interactions
#'
#' @description
#' This function constructs a gene/protein interactive network using interactions from STRING-database
#'
#' @param data microarray counts table
#'
#' @return A dataframe with gene-gene interactions
#' @export
#'
#' @import STRINGdb
#' @import tidyverse
#'
#' @examples ident_interactions(genes_list,species= "Hs", score_threshold=200)

ident_interactions <- function(genes_list, species= c("Hs","Mm"), score_threshold=200){

  sp <- ifelse(species=="Hs",9606,ifelse(species=="Mm", 10090,))
  genes.df <- as.data.frame(genes_list)
  genes.df$genes <- genes.df[,1]

  string_db <- STRINGdb$new(version="12.0", species=sp,
                            score_threshold=score_threshold, network_type="full", input_directory="")

  mapped <- string_db$map(genes.df, "genes", removeUnmappedRows = TRUE)

  ppi <- string_db$get_interactions(mapped$STRING_id)

  ppi$STRING_id <- ppi$from
  ppi <- string_db$add_proteins_description(ppi)
  ppi$from <- ppi$preferred_name
  ppi <- ppi[,2:4]
  #change to
  ppi$STRING_id <-ppi$to
  ppi <- string_db$add_proteins_description(ppi)
  ppi$to <- ppi$preferred_name
  ppi <- ppi[,2:4]

  #Clean_up
  ppi <- ppi %>% unique() %>% subset(!(from==to))

 ppi <- ppi %>%
    dplyr::mutate(pair = ifelse(from < to, paste(from, to, sep = "-"), paste(to, from, sep = "-"))) %>%
    dplyr::distinct(pair, .keep_all = TRUE) %>%
    dplyr::select(-pair)

  return(ppi)

}
