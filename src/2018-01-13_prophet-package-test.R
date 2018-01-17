
#***********************************
# TESTING PACKAGE PROPHET 
#***********************************

library("here")
library("dplyr")
library("magrittr")
library("prophet")

help(package="prophet")

# todo: ----------------------------


#***********************************

# SETUP: -------------
# https://github.com/stan-dev/rstan/wiki/Installing-RStan-on-Windows 

# first test if Rtools is installed
Sys.getenv("PATH")  # looks good! 

# first elements in output: 
# [1] "C:\\Rtools\\bin;
# C:\\--SOFTWARE--\\R\\R-3.4.3\\R-3.4.3\\bin\\x64;
# C:\\--SOFTWARE--\\R\\R-3.4.3\\R-3.4.3\\bin\\x64
# C:\\Rtools\\mingw_32\\bin         # this is the C compiler? 

# test whether g++ can be called (todo: C compiler???)
system('g++ -v')  # works!
system('where make')  # works! 


#************************************
# read data: -----
df <- read.csv(paste0(here("data"), 
                      "/example_wp_peyton_manning.csv")) %>% 
      mutate(y=log(y))

str(df)
summary(df)

# fit model: -----
m <- prophet(df)
summary(m)

# create future dates : -----
future <- make_future_dataframe(m, periods = 365)
tail(future)

# predict with predict( ): -----
fcast <- predict(m, future)

str(fcast)
tail(fcast[c('ds', 'yhat', 'yhat_lower', 'yhat_upper')])


# plot with plot( ): -----
plot(m, fcast)


# decompose series : -----
prophet_plot_components(m, fcast)

