
#************************************
# FN TO DETACH PACKAGE
#************************************
# lubridate and here don't play well together, so have to detach
#     lubridate 

detach_package <- function(pkg, character.only = FALSE)
{
      if(!character.only)
      {
            pkg <- deparse(substitute(pkg))
      }
      search_item <- paste("package", pkg, sep = ":")
      while(search_item %in% search())
      {
            detach(search_item, unload = TRUE, character.only = TRUE)
      }
}