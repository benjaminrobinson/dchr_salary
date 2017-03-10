options(stringsAsFactors=F)
options(scipen=10)
library(dplyr)
library(rvest)
library(RCurl)
library(devtools)
# install_github("Gimperion/tomkit")
# install_github("ropenscilabs/tabulizerjars")
# install_github("ropenscilabs/tabulizer")
library(tomkit)
library(tabulizer)
library(doParallel)

# Initiate cluster
registerDoParallel(3)

#CREATE FUNCTION TO PROVIDE QUARTERLY DATES FOR DATA SUBMISSIONS
disclose_date <- function(year,quarter){
    x <- as.Date(
        paste0(year,
               ifelse(quarter==1,"-03-31",
                      ifelse(quarter==2,"-06-30",
                             ifelse(quarter==3,"-09-30","-12-31")))))
    return(x)
}

`%notin%` <- function(x,y) !(x %in% y)

outersect <- function(x, y) {
    sort(c(setdiff(x, y),
           setdiff(y, x)))
}

# test_page <- function(x) {
# if(nrow(extract_tables(x,pages=1,method="data.frame")[[1]])==0){
# 	return("Failed")
# 	stop()
# 	} else {
# 	print("Passed")
# 	}
# }
