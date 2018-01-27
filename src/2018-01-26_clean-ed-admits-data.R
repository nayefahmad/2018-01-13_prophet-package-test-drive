

#*******************************************
# CLEAN, EXPLORE ED, ADMIT DATA 
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
source(here("src", "detach_package_function.R"))
source(here("src", "ggtheme.R"))


# TODO: ------------------------------------
# > here and lubridate packages don't seem to play well 
# > detach_package_function doesn't work 
#*******************************************


# read ed data in: --------------------------------
df1.ed <- read_csv(here("data", "2018-01-17_daily-ed-visits-data.csv"))

# here and lubridate packages don't seem to play well, so we do this later
library("lubridate")

df1.ed %<>% 
      mutate(year = as.factor(floor_date(StartDate, 
                               unit = "year"))) 

summary(df1.ed); head(df1.ed)


# basic graphs:-------------
p1.ed.boxplot <- 
      ggplot(df1.ed, 
             aes(x=year, y=numvisits)) + 
                   geom_boxplot() + 
      ggsave(); p1.ed.boxplot


