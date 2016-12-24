#DOWNLOAD FILES
#LINK TO DATA SHEETS HERE:  http://dchr.dc.gov/public-employee-salary-information
setwd("C:/Users/Benjamin/Desktop/Projects/dchr_salary/pdf")
source(paste0(getwd(),"/code/",dir(paste0(getwd(),"/code"))[1]))

urls <- read_html("http://dchr.dc.gov/public-employee-salary-information") %>%
    html_nodes("a") %>%
    html_attr("href")
#REMOVE NON-PDF LINKS
urls <- urls[grep("pdf",urls)]
urls <- c(urls[length(urls)],urls[1:(length(urls)-1)])


for(a in urls){
save <- paste0(getwd(),"/",gsub("http://dchr.dc.gov/sites/default/files/dc/sites/dchr/publication/attachments/","",a))
download.file(a,save,mode="wb")
}