library(tidyverse)
# Sys.setlocale("LC_ALL","English")
movies = read_csv("clean_data.csv") #%>%
#     mutate(release_date = as.Date(release_date, format = "%B %d, %Y"))

load_ratings = function(need_ratings = FALSE) {
    if (need_ratings) {
        ratings = read_csv("our_ratings.csv")
    } else {
        ratings = NULL
    }
    return(ratings)
}
ratings = load_ratings(FALSE)



test_actor = get_movie_rows(c("actors"), c("Arnold Schwarzenegger"))

our_ratings_cmprsd = read_csv("our_ratings_cmprsd.csv")

test_ratings = get_ratings(test_actor, our_ratings_cmprsd)

test_full = left_join(test_actor, test_ratings, by = "imdb_id") %>%
    # Ensure each movie can be treated as a separate group
    mutate(imdb_id = as.factor(imdb_id))

ggplot(test_full) +
    geom_boxplot(mapping = aes(x = imdb_id, y = score, color = title))

    test_rating = our_ratings_cmprsd %>%
    filter(imdb_id %in% test_actor$imdb_id) %>%
    left_join(
        y = test_actor[, c("imdb_id", "title", "release_date")], 
        by = "imdb_id"
    ) %>%
    arrange(release_date)



decmprsd_ratings = test_rating %>%
    group_by(imdb_id) %>%
    summarise(score = rep(rating, score_count), .groups = "drop") %>%
    mutate(imdb_id = as.factor(imdb_id))



# get_columns = function(columns) {
#     if (("rating" %in% columns) & is.null(ratings)) {
#         # load ratings data
#         ratings = load_ratings(TRUE)
#         # remove "rating" from vars vector to use it in movies data
#         columns = columns[-which(columns == "rating")]
#     }
#     
# }
# get_data = function(columns, row_cond = NULL) {
#     
# }