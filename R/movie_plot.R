#function plot. Function by Sihle
movie_plot<-function(inputv, xcol, ycol){
    ggplot(data=inputv, aes_string(x={{xcol}}, y={{ycol}})) + geom_point()
}
