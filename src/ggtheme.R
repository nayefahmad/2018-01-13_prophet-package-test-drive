
#****************************
# GGPLOT THEME THAT CAN BE CALLED IN OTHER SCRIPTS
#****************************

mytheme <- theme(axis.text.x=element_text(size = 16),
                 axis.text.y=element_text(size=14),
                 axis.title.x=element_text(size=20), 
                 axis.title.y=element_text(size=18), 
                          
                 strip.text.x=element_text(size=18), 
                                  
                 panel.background = element_rect(fill = NA))