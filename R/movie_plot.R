#function plot. Function by Sihle
movie_plot<-function(inputv,xcol,ycol){
    ggplot(data=inputv, aes(x=.data[[xcol]], y=.data[[ycol]], colour=title)) + 
        geom_point(aes(size=.data[[ycol]]))+
        theme(axis.text.x = element_text(angle=90, vjust = 0.5, hjust = 1))+
        geom_text(aes(label=title), check_overlap = TRUE) +
        theme(legend.position="none")
    
}
