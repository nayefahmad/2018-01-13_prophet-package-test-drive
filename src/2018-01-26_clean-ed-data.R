

#*******************************************
# CLEAN, EXPLORE ED DATA 
#*******************************************

library("here")
library("dplyr")
library("magrittr")
library("prophet")
library("ggplot2")
library("readr")

help(package="prophet")
rm(list=ls())

# source scripts: ------------
source(here("src", "ggtheme.R"))
source(here("src", "weeknum_function.R"))

# TODO: ------------------------------------
# > here and lubridate packages don't seem to play well 

#*******************************************


# read ed data in: --------------------------------
unloadNamespace("lubridate")
df1.ed <- read_csv(here("data", "2018-01-17_daily-ed-visits-data.csv"))

# here and lubridate packages don't seem to play well, so we do this later
library("lubridate")

df1.ed %<>% 
      mutate(year = floor_date(StartDate,
                               unit = "year") %>% 
                   as.character %>% 
                   substr(1,4) %>% 
                   as.factor, 
             week = floor_date(StartDate, 
                               unit = "week") %>% 
                   week.fn %>% 
                   as.factor)

summary(df1.ed); head(df1.ed)
as.data.frame(df1.ed)

# basic graphs:-------------
unloadNamespace("lubridate")  # otherwise here package doesn't work 

p1.ed.boxplot <- 
      ggplot(df1.ed, 
             aes(x=year, y=numvisits)) + 
                   geom_boxplot() + 
      stat_summary(fun.y = mean, 
                   geom = "point") + 
      
      # mytheme + 
      theme_classic() + 
      
      ggsave(here("output from src", 
                  "p1_ed-boxplot.pdf")); p1.ed.boxplot


p2.ed.time.series.by.month. <- 
      ggplot(df1.ed,
             aes(x=week, 
                 y=numvisits)) + 
      geom_line(); p2.ed.time.series