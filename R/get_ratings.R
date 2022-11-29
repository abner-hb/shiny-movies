get_ratings = function(slctd_movies, cmprsd_ratings) {
    # Loading compressed ratings
    slctd_cmprsd_ratings = our_ratings_cmprsd %>%
        filter(imdb_id %in% slctd_movies$imdb_id) %>%
        left_join(
            y = slctd_movies[, c("imdb_id", "title", "release_date")], 
            by = "imdb_id"
        ) %>%
        arrange(release_date)
    # Transforming compressed ratings into
    decmprsd_ratings = slctd_cmprsd_ratings %>%
        group_by(imdb_id) %>%
        summarise(
            # each rating is repeated the necessary number of times to
            # recover all the original ratings
            score = rep(rating, score_count), 
            .groups = "drop"
        ) #%>%
        # Ensure each movie can be treated as a separate group
        # mutate(imdb_id = as.factor(imdb_id))
    
    return(decmprsd_ratings)
}
