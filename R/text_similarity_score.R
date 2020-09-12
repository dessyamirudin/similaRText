#' Text Similarity Score
#'
#' Generate similarity score between two text
#'
#' @param input_text A vector of text that need to be cleaned
#' @param target_text A vector of text as the standard text format
#' @param space A logical indicating whether to include space in the calculation. Default TRUE
#' @param ignore_case A logical indicating whether to ignore case. Default TRUE
#' @param score A numeric value indicating the score accepted as similar. Default 0
#'
#' @author Dessy Amirudin
#'
#' @import stringr
#' @import dplyr
#'
#' @return A dataframe contain the origital text, target text and the score
#'
#' @export
#'
#' @example
#' text_similarity_score(unique(data_sample$Country),"South Korea")
#'
text_similarity_score = function(input_text,target_text,space=TRUE,ignore_case=TRUE,score=0){

  # keeping the original input intact
  df_input_original = data.frame(expand.grid(input_text,target_text)) %>%
    rename(
      input_text_original=Var1,
      target_text_original=Var2) %>%
    mutate(across(where(is.factor), as.character))

  if (space==FALSE){
    input_text =tolower(gsub("[[:space:]]|[.]|[,]", "", input_text))
    target_text = tolower(gsub("[[:space:]]|[.]|[,]", "", target_text))
  }

  #distance using Levenshtein
  dist.input_text = adist(input_text,target_text, ignore.case=ignore_case)

  # distance of original text
  df_return = data.frame(expand.grid(input_text,target_text))%>%
    rename(
      input_text = Var1,
      target_text = Var2) %>%
    mutate(across(where(is.factor), as.character))

  # distance of original text
  # scaling distance name
  input_target_length = expand.grid(str_length(input_text),str_length(target_text))
  input_target_length = input_target_length %>% mutate(sum=Var1+Var2)
  input_target_length_matrix = matrix(input_target_length$sum,length(input_text),length(target_text))
  df_return_scale = (input_target_length_matrix-dist.input_text)*100/input_target_length_matrix
  df_return_reshape = matrix(df_return_scale,length(input_text)*length(target_text),1)


  # scaling the distance into 0 to 100
  df_return = data.frame(df_return,df_return_reshape) %>%
    rename(similarity_score = df_return_reshape)

  df_output = df_return %>% mutate(similarity_score=round(similarity_score,2))
  df_output = data.frame(df_input_original,df_output) %>% select('input_text_original','target_text_original','similarity_score') %>%
    rename(
      input_text = input_text_original,
      target_text = target_text_original) %>%
    filter(similarity_score>=score)

  # output
  return(df_output)
}
