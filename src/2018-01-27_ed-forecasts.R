

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
# > change histo to fit in latest.df
#*******************************************

# input variables: --------------
# set cutoff date for forecast: 
start.date <- as.Date("2017-11-30")
start.index <- match(start.date, as.Date(df2.ed.prophet$ds))

# set forecast horizon: 
horizon = 31 


# fit model using histo data up to cutoff: ---------------
df3.ed.histo <-  as.data.frame(df2.ed.prophet) %>% 
      slice(1:start.index) %>% as.data.frame
# max(df3.ed.histo$ds)  

# retain actuals to compare: 
df4.ed.actual <- df2.ed.prophet[(start.index + 1):nrow(df2.ed.prophet), ]

# apparently ggplot needs POSIXct: 
df4.ed.actual$ds <- as.POSIXct(df4.ed.actual$ds)
str(df4.ed.actual)

#*******************************************
# fit model: 
ed.model <- prophet(df3.ed.histo)

# df of forecsat horizon: 2 weeks ----------
future <- make_future_dataframe(ed.model, 
                                periods = horizon,
                                freq = "day")  

tail(future,horizon)  


# predict with predict( ): -----
fcast <- predict(ed.model, future)

str(fcast); summary(fcast)
tail(fcast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])


#**************************************
# plot the forecast: --------
plot(ed.model, fcast)
# plot(fcast)  # prduces something crazy 


#**************************************
# how to plot only last few dates? ------------
latest.fcast <- select(fcast, ds, yhat) %>% 
      rename(historical = yhat) %>% 
      mutate(fcast = historical)

# set historical series to NA after cutoff: 
latest.fcast$historical[(start.index+1):nrow(latest.fcast)] <- NA

# set fcast series to NA before cutoff: 
latest.fcast$fcast[1:start.index] <- NA

# now subset fcast using cutoff, going back 2*horizon: 
latest.fcast <- 
      latest.fcast[(start.index-2*horizon):nrow(latest.fcast), ]
str(latest.fcast)


# finally, plot it: 
p1.fcast <- ggplot() + 
      
      # add historical line: 
      geom_line(data=latest.fcast, 
                aes(x=ds, y=historical)) + 
      
      # now add fcast line: 
      geom_line(data=latest.fcast,
                aes(x=ds, y=fcast), 
                colour="blue") + 
      
      # todo: now add actuals line: 
      geom_line(data=df4.ed.actual, 
                aes(x=ds, y=y), 
                colour="red") + 
      
      # change breaks on x axis: 
      scale_x_datetime(date_breaks = "5 day") + 
      
      theme_classic() + 
      theme(axis.text.x = element_text(angle=90)); p1.fcast


# decompose time series: --------
prophet_plot_components(ed.model, fcast)  
# todo: flat trend since 2016?? Does that make sense? 