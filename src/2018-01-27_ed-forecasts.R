

#*********************************************
# FORECASTING ED VISITS USING PROPHET
#*********************************************

library("here")
library("dplyr")
library("magrittr")
library("prophet")
library("ggplot2")
library("readr")

# help(package="prophet")
rm(list=ls())

# source scripts: ------------
unloadNamespace("lubridate")
source(here("src", "2018-01-26_clean-ed-data.R"))

# TODO: ------------------------------------
# > here and lubridate packages don't seem to play well 
# > add holidays df in prophet( ); colnames holiday, ds, 
#     lower_window, upper_window as nums 
#*******************************************


# fit model using histo data up to 30 nov 2017: ---------------
df3.ed.subset <-  as.data.frame(df2.ed.prophet) %>% 
      slice(1:3256) %>% as.data.frame

max(df3.ed.subset$ds)  

ed.model <- prophet(df3.ed.subset)

# df of forecsat horizon: 2 weeks ----------
future <- make_future_dataframe(ed.model, 
                                periods = 365,
                                freq = "day")  

tail(future,10)  


# predict with predict( ): -----
fcast <- predict(ed.model, future)

str(fcast)
tail(fcast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])


# plot the forecast: --------
plot(ed.model, fcast)
# plot(fcast)  # prduces something crazy 

# how to plot only last few dates? 
latest.fcast <- select(fcast, ds, yhat)
latest.fcast <- latest.fcast[3600:nrow(latest.fcast) , ]
str(latest.fcast)

p1.fcast <- ggplot(latest.fcast, 
                   aes(x=ds, y=yhat)) + 
      geom_line() + 
      theme_classic(); p1.fcast


# decompose time series: --------
prophet_plot_components(ed.model, fcast)  
# todo: flat trend since 2016?? Does that make sense? 