get_movie_rows = function(cols_to_filter, containing) {
    if (length(cols_to_filter) != length(containing)) {
        stop("Each column must have one condition")
    }
    new_movies = movies
    for (i in 1:length(cols_to_filter)) {
        column_name = cols_to_filter[i]
        if (is_character(new_movies[, column_name, drop = TRUE])) {
            new_movies = new_movies %>%
                filter(grepl(containing[i], .data[[column_name]]))
        }
        if (nrow(new_movies) == 0) {
            # Finish if data set is empty
            stop("We found no movies with the desired conditions")
            # break
        }
    }
    return(new_movies)
}
