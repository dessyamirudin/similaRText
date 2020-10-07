# similaRText
 package to clean text by measure the similarity between text
 
## function

This package have two function with below description

### Getting the similarity score between text

	text_similarity_score(
		input_text,
		target_text,
		space = TRUE,
		ignore_case = TRUE,
		score = 0
	)	

### Getting the similarity score between text
	text_similarity_id(
	  input_text,
	  space = FALSE,
	  ignore_case = TRUE,
	  score = 80,
	  eps = 0.15
	)


### Sample data and the usage
data("sample_data")