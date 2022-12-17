source("R/get_movie_rows.R")
source("R/movie_plot.R")
build_plot = function(xcol, ycol, input_mat){
    # fltrd_movies = get_movie_rows(
    #     cols_to_filter = cols_to_filter, 
    #     containing = containing
    # )
    fltrd_movies = get_movie_rows_sql(input_mat)
    plot = movie_plot(inputv = fltrd_movies, xcol = xcol, ycol = ycol)
    return(plot)
}
