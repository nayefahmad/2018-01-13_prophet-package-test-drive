

#*********************************
# EXPLORATORY GRAPHS FOR ED DATA 
#*********************************

library("here")
library("dplyr")
library("magrittr")
library("prophet")
library("ggplot2")
library("readr")

# source scripts: ------------
source(here("src", "2018-01-26_clean-ed-data.R")) 

# TODO: ------------------------------------
# > here and lubridate packages don't seem to play well 
# > todo: fix week graph, ggsave month and week 
# > save plots
# > time series by date 
#*******************************************


# basic graphs:-------------
unloadNamespace("lubridate")  # otherwise here package doesn't work 

# boxplot by year: 
p1.ed.boxplot <- 
      ggplot(df1.ed, 
             aes(x=year, y=numvisits)) + 
      geom_boxplot() + 
      stat_summary(fun.y = mean, 
                   geom = "point") + 
      
      theme_classic(); p1.ed.boxplot


# boxplot by month: 
p2.ed.boxplot.month <- 
      ggplot(df1.ed[1:365,], 
             aes(x=month, y=numvisits)) + 
      geom_boxplot() + 
      stat_summary(fun.y = mean, 
                   geom = "point") + 
      
      # mytheme + 
      theme_classic(); p2.ed.boxplot.month




# time series by week 
p3.ed.time.series.by.week <- 
      ggplot(# summarzie data by week: 
            group_by(df1.ed, week) %>% 
                  summarize(week.mean = mean(numvisits)),
            # now add aes
            aes(x=week, 
                y=week.mean, 
                group=1)) + 
      
      geom_line() + 
      
      theme_classic(); p3.ed.time.series.by.week


# time series by month 
p4.ed.time.series.by.month <- 
      ggplot(
            # summarzie data by month: 
            group_by(df1.ed, month) %>% 
                  summarize(month.mean = mean(numvisits)),
            # now add aes  
            aes(x=month, 
                y=month.mean, 
                group=1)) +  # note the use of group =1 
      
      geom_line() + 
      
      theme_classic() ; p4.ed.time.series.by.month



# save all plots in one pdf: ----------
plots <- list(p1.ed.boxplot )
