library(tidyverse)
library(readr)

# Reading original data
movies = tibble(read.csv("data.csv", header = TRUE))
# Transforming money strings into numbers
movies = movies %>% 
    mutate(
        budget = parse_number(budget),
        revenue = parse_number(revenue)
    )

# Writing file with clean data
write.csv(movies, file = "clean_data.csv")
# movie_ids = tibble(read_csv("movielens/links.csv")) %>%
#     # only need imdb and movielens id's
#     select(movieId, imdbId) %>%
#     mutate(imdbId = as.integer(imdbId))