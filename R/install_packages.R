# https://gist.github.com/stevenworthington/3178163

ipak <- function(pkg){
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}

# usage
packages = c('ggplot2', 'data.table', 'dplyr', 'tools')
ipak(packages)

#installed in personal library:
#~/R/x86_64-pc-linux-gnu-library/3.2