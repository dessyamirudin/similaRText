#' Text Similarity Id
#'
#' Generate unique ID for identical text
#'
#' @param input_text A vector of text that need to be cleaned
#' @param space A logical indicating whether to include space in the calculation. Default TRUE
#' @param ignore_case A logical indicating whether to ignore case. Default TRUE
#' @param score A numeric value indicating the score accepted as similar. Default 0
#' @param eps A numeric value to measure if text is close to each other, the larger the value indicating that we accept the similarity loosely. Default 0.15
#'
#' @author Dessy Amirudin
#'
#' @import stringr
#' @import dplyr
#' @import dbscan
#'
#' @return A data frame contain of the original text and the unique ID assigned to the text
#'
#' @example
#' text_similarity_id(unique(data_sample$Country))
#'
#'@export
#'

text_similarity_id = function(input_text,space=FALSE,ignore_case=TRUE,score=80,eps=0.15){

  # keeping the original input intact
  input_text_original = input_text

  if (space==TRUE){
    input_text =tolower(gsub("[[:space:]]|[.]|[,]", "", input_text))
  }

  #distance using Levenshtein
  dist.input_text = adist(input_text,input_text, ignore.case=ignore_case)

  # distance of original text
  df_return = data.frame(expand.grid(input_text,input_text))%>%
    rename(
      input_text = Var1,
      target_text = Var2) %>%
    mutate(across(where(is.factor), as.character))

  # distance of original text
  # scaling distance name
  input_length = expand.grid(str_length(input_text),str_length(input_text))
  input_length = input_length %>% mutate(sum=Var1+Var2)
  input_length_matrix = matrix(input_length$sum,length(input_text),length(input_text))
  df_return_scale = (input_length_matrix-dist.input_text)/input_length_matrix

  # take where the value >= score
  df_return_scale.clean = ifelse(df_return_scale>=score/100,df_return_scale,0)

  # labeling by clustering the end result using DBSCAN
  db.cluster = dbscan(df_return_scale.clean,eps = eps,minPts = 1)

  #assigning label to customer
  output_file = as.data.frame(input_text_original)
  output_file$id = db.cluster$cluster
  output_file = output_file %>% arrange(id) %>% rename(
    input_text = input_text_original)

  # output
  return(output_file)
}
