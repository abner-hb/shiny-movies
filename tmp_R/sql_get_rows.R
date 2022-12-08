library(RSQLite)
library(tidyverse)
source("R/get_movie_rows.R")
movies = read_csv("clean_data.csv")[, -1]

test_input = tibble(
    fields = c("actors", "director", "budget"),
    conditions = c("Not including", "Including", ">="),
    values = c("Brad Pitt", "Quentin Tarantino", 20000000),
    groups = c(1, 1, 2),
    joiners = c("AND", "AND", "")
)
test = get_movie_rows_sql(test_input)

conn <- dbConnect(RSQLite::SQLite(), ":memory:", extended_types = TRUE)
dbWriteTable(conn, "movies", movies)
dbListTables(conn)

build_filter_mat = function(input_mat) {
    # fields, conditions, values, groups, joiners
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
            )
        )
    return(filter_mat)
}
test_input = tibble(
    fields = c("actors", "director", "budget"),
    conditions = c("Not including", "Including", ">="),
    values = c("Brad Pitt", "Quentin Tarantino", 20000000),
    groups = c(1, 1, 2),
    joiners = c("AND", "AND", "")
)
build_filter_mat(test_input)


paste(build_filter_mat(test_input)[1, ], collapse = "")
# sql_get_movie_rows
get_movie_rows_sql = function(input_mat) {
    filter_mat = build_filter_mat(input_mat)
    num_filters = length(input_mat$fields)
    # Create list of values to use in SQL query
    vals_list = as.list(filter_mat$values)
    names(vals_list) = paste("val", 1:num_filters, sep = "")
    filter_mat[, "values"] = paste(":", names(vals_list), sep = "")
    # Build the string filter
    filters = filter_mat %>%
        group_by(groups)
        summarise(filter = paste(fields, conditions, values, joiners))
    sql_fltr = paste(filters[, 1, drop = TRUE], collapse = " ")
    # Write SQL query
    qry = paste('SELECT * FROM movies WHERE', sql_fltr)
    # return(qry)
    # Fetch data
    new_movies = dbGetQuery(
        conn = conn, 
        statement = qry,
        params = vals_list
    )
    if (nrow(new_movies) == 0) {
        # Inform that data set is empty
        stop("We found no movies with the desired conditions")
    }
    return(new_movies)
}
test = get_movie_rows_sql(test_input)
test_input2 = data.frame(
    fields = c("actors", "actors", "duration"),
    conditions = c("Including", "Including", ">="),
    values = c("Robert Downey Jr.", "Gwyneth Paltrow", 50000),
    joiners = c("OR", "AND", "")
)
test2 = get_movie_rows_sql(test_input2)

get_movie_rows_sql = function(input_mat) {
    if (is.null(input_mat$fields)){
        # If nothing is filtered, output full file
        return(movies)
    }
    qry = get_sql_qry(input_mat)
    new_movies = dbGetQuery(
        conn = conn, 
        qry,
        params = list(:val1 = "%Margot Robbie%")
    )
}

test = movies %>% mutate(actors = tolower(actors))

tmp = dbGetQuery(
    conn, 
    'SELECT * FROM movies WHERE "duration" LIKE :val1',
    params = list(val1 = "%Margot Robbie%")
)

tmp = dbGetQuery(
    conn, 
    'SELECT * FROM movies WHERE "main_country" NOT LIKE :x',
    params = list(x = "%United States%")
)

tmp = dbGetQuery(
    conn, 
    'SELECT * FROM movies WHERE duration >= :val1',
    params = list(val1 = 3000)
)

tmp = dbGetQuery(
    conn, 
    "
    SELECT * FROM movies WHERE (actors LIKE :val1 AND director LIKE :val2) OR duration >= :val3 
    ",
    params = list(
        val1 = "%Brad Pitt%", 
        val2 = "%Quentin Tarantino%",
        val3 = "120"
    )
)

tmp = dbGetQuery(
    conn, 
    'SELECT CAST("1995-01-01" AS DATE) FROM movies WHERE "release_date" >= :x',
    params = list(x = "CAST('1995-01-01' AS DATE)")
)

movies %>%
    filter(grepl("Tom Hanks", .data[["actors"]]))

tmp2 = dbGetQuery(
    conn, 
    'SELECT * FROM movies WHERE :x',
    params = list(x = "budget" > 1e10)
)


dbDisconnect(conn)
