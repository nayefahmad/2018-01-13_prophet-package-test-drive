

#*********************************
# EXPLORATORY GRAPHS FOR ED DATA 
#*********************************

library("here")
library("dplyr")
library("magrittr")
# library("prophet")
library("ggplot2")
library("readr")
library("fpp")

# help(package="forecast")
rm(list = ls())

# source scripts: ------------
source(here("src", "2018-01-26_clean-ed-data.R"))  # note that site has been set

# TODO: ------------------------------------
# > note: here and lubridate packages don't seem to play well 
# > stl( ) graph 
# > identify site, include in plot titles, output file
#*******************************************


# identify site for plot titles and filenames: 
if (!length(table(df1.ed$FacilityLongName)) == 1) {
      print("error: more than 1 site in data")
} else {
      site.name <- df1.ed$FacilityLongName[1]
}
# site.name

# id first and last years: 
first.date <- min(df1.ed$StartDate)  %>% print 
last.date <- max(df1.ed$StartDate)  %>% print 



# basic graphs:-------------
unloadNamespace("lubridate")  # otherwise here package doesn't work 

# boxplot by year: 
p1.ed.boxplot <- 
      ggplot(df1.ed, 
             aes(x=year, y=numvisits)) + 
      geom_boxplot() + 
      stat_summary(fun.y = mean, 
                   geom = "point") + 
      labs(title = paste(site.name, "ED visits by year")) + 
      theme_classic(); p1.ed.boxplot


# boxplot by month: 
p2.ed.boxplot.month <- 
      ggplot(df1.ed, 
             aes(x=month, y=numvisits)) + 
      facet_wrap(~year) + 
      geom_boxplot() + 
      stat_summary(fun.y = mean, 
                   geom = "point") + 
      labs(title = paste(site.name, "ED visits by month and year")) + 
      theme_classic(); p2.ed.boxplot.month


# seasonal boxplot: 
p3.seasonal.box <- 
      ggplot(
            # get avg per month for each year:  
            group_by(df1.ed, year, month) %>% 
                  summarize(month.avg = mean(numvisits)), 
            
            # now add aes: 
             aes(x=month, 
                 y=month.avg)) + 
      geom_boxplot() + 
      labs(title = paste(site.name, "ED visits by month across years"), 
           subtitle = paste(first.date, "to", last.date)) + 
      theme_classic(); p3.seasonal.box


# seasonality graph: 
p4.seasonal.line <- 
      ggplot(
            # get avg per month for each year:  
            group_by(df1.ed, year, month) %>% 
                  summarize(month.avg = mean(numvisits)),
            
            # now add aes( ): 
             aes(x=month, 
                 y=month.avg, 
                 group=year, 
                 col=year)) + 
      geom_line() + 
      labs(title = paste(site.name, "Avg ED visits by month across years"), 
           subtitle = paste(first.date, "to", last.date)) +
      theme_classic(); p4.seasonal.line






#************************************
# TIME SERIES PLOTS: -------------------
#************************************

# time series by day: 
p5.ed.time.series.by.day <- 
      ggplot(df1.ed,
            aes(x=StartDate, 
                y=numvisits)) + 
      
      geom_line() +  # try geom_point for an alternate view 
      
      labs(title = paste(site.name, "ED daily visits"), 
           subtitle = paste(first.date, "to", last.date)) +
      
      theme_classic(); p5.ed.time.series.by.day




# time series by week 
p6.ed.time.series.by.week <- 
      ggplot(# summarzie data by week: 
            group_by(df1.ed, week) %>% 
                  summarize(week.mean = mean(numvisits)),
            # now add aes
            aes(x=week, 
                y=week.mean, 
                group=1)) + 
      
      geom_line() + 
      
      labs(title = paste(site.name, "Avg ED daily visits by week"), 
           subtitle = paste(first.date, "to", last.date)) +
      
      theme_classic(); p6.ed.time.series.by.week


# time series by month 
p7.ed.time.series.by.month <- 
      ggplot(
            # summarzie data by month: 
            group_by(df1.ed, month.year) %>% 
                  summarize(month.mean = mean(numvisits)) %>% 
                  slice(1:n()),  # change endpoint to slice 
            # now add aes  
            aes(x=month.year, 
                y=month.mean, 
                group=1)) +  # note the use of group =1 
      
      geom_line() + 
      
      labs(title = paste(site.name, "Avg ED daily visits by month"), 
           subtitle = paste(first.date, "to", last.date)) +
      
      theme_classic() ; p7.ed.time.series.by.month


# decompose using stl( ): 
# stl.fit <- stl(as.ts(df1.ed$numvisits, 
#                      start=c(2009, 1), 
#                      frequency=365))
# 


#********************************************
# testing normality: 

# density plot: 
p8.density <- ggplot(df1.ed, 
                  aes(x=numvisits)) + 
      # geom_histogram() + 
      geom_density() + 
      theme_classic(); p8.density

# qqnorm: 
p9.qqnorm <- ggplot(df1.ed, 
                    aes(sample = df1.ed$numvisits)) + 
      stat_qq() + 
      geom_abline(slope = 1,
                  intercept = 0, 
                  col="black") + 
      theme_classic(); p9.qqnorm


# save all plots in one pdf: ----------
plots <- list(p1.ed.boxplot, 
              p2.ed.boxplot.month, 
              p3.seasonal.box, 
              p4.seasonal.line,
              p5.ed.time.series.by.day, 
              p6.ed.time.series.by.week, 
              p7.ed.time.series.by.month)

# save all plots in 1 pdf: 
filename <- paste0("2018-02-01_",
                  gsub(" ", "-", tolower(site.name)),
                  "_ed-exploratory-graphs.pdf")

pdf(here("output from src", filename))
plots[1:7]
dev.off()
