library(tidyverse)
movies = tibble(read.csv("cleaned_data.csv", header = TRUE))
movie_ids = tibble(read_csv("movielens/links.csv")) %>%
    # only need imdb and movielens id's
    select(movieId, imdbId) %>% 
    rename(imdb_id = imdbId, movie_id = movieId) %>%
    mutate(imdb_id = as.integer(imdb_id))

movies_full = inner_join(x = movies, y = movie_ids, by = "imdb_id")

ratings = tibble(read_csv("movielens/ratings.csv"))
ratings_means = ratings %>%
    group_by(movieId) %>%
    summarise(mean_rating = mean(rating)) %>%
    ungroup()
ratings_means = ratings_means %>%
    rename(movie_id = movieId)

movies_full = inner_join(x = movies_full, y = ratings_means, by = "movie_id")

View(
    movies_full %>% 
        filter(grepl("Tom Hanks", actors))
)

movies_with_actor = function(name) {
    out = movies_full %>% 
        filter(grepl(name, actors))
}
View(movies_with_actor("Arnold Schwarzenegger"))
microbenchmark::microbenchmark(movies_with_actor("Arnold Schwarzenegger"))

ggplot(movies_full) +
    geom_point(aes(x = ))