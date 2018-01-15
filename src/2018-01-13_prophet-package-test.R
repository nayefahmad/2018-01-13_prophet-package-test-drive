
#***********************************
# TESTING PACKAGE PROPHET 
#***********************************

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


# test whether g++ can be called (todo: C compiler???)
system('g++ -v')  # todo: not working :( 
                  # running command 'g++ -v' had status 127 

system('where make')  # works! 



