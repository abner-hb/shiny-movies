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


get_right_data = function(
    cols_to_filter = c("actors", "actor"), 
    containing = c("Arnold", "Abner H"),
    need_rating = FALSE
) {
    #STUFF 
    print("hello")
}

test_actor = get_movie_rows(
    c("actors"), 
    c("Arnold")
)

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

do_everyting = function(args){
    abner_function()
    plot = sihle_function()
    return(plot)
}

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

tmp = get_movie_rows(cols_to_filter = c("actors"),
                   containing = c("Tom Hanks")
    )

movie_plot(movies, xcol = "release_date", ycol = "revenue")

build_plot(
    xcol = "budget", 
    ycol = "revenue", 
    cols_to_filter = c("director"),
    containing = c("Martin Scorsese")
)

ggplot(data=movies, aes(x={{"release_date"}}, y={{"revenue"}})) + geom_point()
