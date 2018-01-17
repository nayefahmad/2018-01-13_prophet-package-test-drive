

#*****************
# forecast monthly Air passengers 
#*****************

library("here")
library("dplyr")
library("magrittr")
library("prophet")
library("ggplot2")

help(package="prophet")

# data: -----
str(AirPassengers)  # monthly total passengers 

df <- data.frame(ds = seq(as.Date("1949-01-01"),
                          as.Date("1960-12-31"),
                          by="1 month"), 
                 y = as.numeric(AirPassengers))

str(df)
summary(df)

# examine data: -----
p1.historical <- ggplot(df, aes(x=ds, y=y)) + 
      geom_line(); p1.historical

# fit model: --------
m <- prophet(df)

# create future df: ---------
future <- make_future_dataframe(m, periods = 960)  # 40 years
tail(future)  # todo: this isn't right; should be monthly


# predict with predict( ): -----
fcast <- predict(m, future)

str(fcast)
tail(fcast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])

# plot with plot( ): -----
plot(m, fcast)

# decompose series : -----
prophet_plot_components(m, fcast)  
# not really working: there shouldn't be any day of year 
#     seasonality 


# write output: ------

