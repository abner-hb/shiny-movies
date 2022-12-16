# Dplyr version ----------
get_movie_rows = function(cols_to_filter, containing) {
    if (tolower(cols_to_filter) == "none"){
        # If nothing is filtered, output full file
        return(movies)
    }
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


# SQL version --------------
build_filter_mat = function(input_mat) {
    # fields, conditions, values, joiners
    # Write the correct SQL commands
    filter_mat = input_mat %>% 
        mutate(
            conditions = case_when(
                conditions == "Including" ~ "LIKE",
                conditions == "Not including" ~ "NOT LIKE",
                TRUE ~ conditions
            ),
            values = case_when(
                tolower(fields) %in% 
                    c("budget", "revenue", "duration") ~ values,
                TRUE ~ paste("%", values, "%", sep = "")
            ), 
            joiners = if_else(toupper(joiners) == "NONE", true = "", joiners)
        )
    return(filter_mat)
}

get_qry_components = function(input_mat) {
    filter_mat = build_filter_mat(input_mat)
    num_filters = length(input_mat$fields)
    # Create list of values to use in SQL query
    vals_list = as.list(filter_mat$values)
    names(vals_list) = paste("val", 1:num_filters, sep = "")
    filter_mat[, "values"] = paste(":", names(vals_list), sep = "")
    # Build the string filter
    filters = filter_mat %>%
        summarise(filter = paste(fields, conditions, values, joiners))
    sql_fltr = paste(filters[, 1, drop = TRUE], collapse = " ")
    # Write SQL query
    qry = paste('SELECT * FROM movies WHERE', sql_fltr)
    return(list(qry = qry, vals_list = vals_list))
}

get_movie_rows_sql = function(input_mat) {
    qry_comps = get_qry_components(input_mat)
    vals_list = qry_comps$vals_list
    qry = qry_comps$qry
    # Fetch data
    ## Open SQL connection 
    conn <- dbConnect(RSQLite::SQLite(), ":memory:", extended_types = TRUE)
    dbWriteTable(conn, "movies", movies)
    new_movies = dbGetQuery(
        conn = conn, 
        statement = qry,
        params = vals_list
    )
    dbDisconnect(conn)
    if (nrow(new_movies) == 0) {
        # Inform that data set is empty
        stop("We found no movies with the desired conditions")
    }
    return(new_movies)
}
