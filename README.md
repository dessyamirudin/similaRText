# similaRText
Package to clean text by measuring the similarity between text

## Install Package
devtools::install_github("dessyamirudin/similaRText")
 
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

To understand the function, use help function
	?text_similarity_score

Example:
a. What is the similarity between "South Korea" and "south korea"? (not case sensitive)

	text_similarity_score("South Korea","south korea")
	
	  input_text target_text similarity_score
	1 South Korea south korea              100
	
b. What is the similarity between "South Korea" and ("south korea","Indonesia")? (case sensitive)

	text_similarity_score("South Korea",c("south korea","Indonesia"),ignore_case = FALSE)
	
	  input_text target_text similarity_score
	1 South Korea south korea            90.91
	2 South Korea   Indonesia            50.00


### Grouping similar text into 1 ID
	text_similarity_id(
	  input_text,
	  space = FALSE,
	  ignore_case = TRUE,
	  score = 80,
	  eps = 0.15
	)

To understand the function, use help function

	?text_similarity_id

a. Grouping similar text into one id. Will be useful to give ID for person when the ID in the database is missing.

Sample 1

	text_similarity_id(c("south korea","Indonesia","South Korea"))
	
	  input_text id
	1 south korea  1
	2 South Korea  1
	3   Indonesia  2

Sample 2

	text_similarity_id(c("Budi S","Budi Susilo","Kadir"),score=70)
	
	  input_text id
	1      Budi S  1
	2 Budi Susilo  1
	3       Kadir  2

### Sample data and the usage
Sample data is downloaded from Kaggle https://www.kaggle.com/alexisbcook/pakistan-intellectual-capital
This data contain the list of Professor from Pakistan

	data("sample_data")

To understand the data, use help function
	
	?sample_data
