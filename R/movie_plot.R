#function plot. Function by Sihle
movie_plot<-function(inputv, xcol, ycol){
    ggplot(data=inputv, aes(x=.data[[xcol]], y=.data[[ycol]])) + geom_point()
}
