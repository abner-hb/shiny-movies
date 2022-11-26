library(tidyverse)
# Sys.setlocale("LC_ALL","English")
# movies = read_csv("clean_data.csv") %>%
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

get_rows = function(cols_to_filter, containing) {
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

get_rows(c("actors", "actors"), c("Arnold Schwarzenegger", "Sylvester Stallone"))

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