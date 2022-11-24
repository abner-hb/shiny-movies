library(tidyverse)
# library(jsonlite)
# Cleaning movies data -----------------------------------------------------
# Reading original data
movies = tibble(read.csv("data.csv", header = TRUE))
# Transforming money strings into numbers
movies = movies %>% 
    mutate(
        budget = parse_number(budget),
        revenue = parse_number(revenue)
    ) %>%
    select(-X)

# Writing file with clean data
write.csv(movies, file = "clean_data.csv")


# Cleaning ratings ---------------------------------------------
movies = tibble(read.csv("clean_data.csv", header = TRUE))
movie_ids = tibble(read_csv("ml-25m/links.csv")) %>%
    # only need imdb and movielens id's
    select(movieId, imdbId) %>%
    rename(imdb_id = imdbId, movie_id = movieId) %>%
    mutate(imdb_id = as.integer(imdb_id))

ratings = read_csv("ml-25m/ratings.csv")

ratings = ratings %>%
    rename(movie_id = movieId) %>%
    left_join(movie_ids, by = "movie_id")

ratings = inner_join(ratings, movies[, "imdb_id"], "imdb_id")
# test = ratings %>%
#     group_by(imdb_id) %>%
#     summarise(count = n())

write_csv(ratings, "our_ratings.csv")

