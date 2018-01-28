

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
# > df3 problem: why date isn't being subsetted??? 
#*******************************************


# fit model using histo data up to 30 nov 2017: ---------------
df3.ed.subset <-  as.data.frame(df2.ed.prophet) %>% 
      slice(1:3256) %>% as.data.frame

max(df3.ed.subset$ds)  
# todo: how is this "2018-01-16"??? if I subset for 9862? 
# why do i have to set it to subset to 3256 to get 
#     2017-11-30?? 

ed.model <- prophet(df3.ed.subset)

# df of forecsat horizon: 2 weeks ----------
future <- make_future_dataframe(ed.model, 
                                periods = 1,
                                freq = "day")  

tail(future,10)  # todo: doesn't seem right


# predict with predict( ): -----
fcast <- predict(ed.model, future)

str(fcast)
tail(fcast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])


# plot the forecast: --------
plot(ed.model, fcast)
