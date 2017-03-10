setwd("C:/Users/Benjamin/Desktop/Projects/dchr_salary/")
source(paste0(getwd(),"/code/",dir(paste0(getwd(),"/code"))[1]))
pdf <- dir(paste0(getwd(),"/pdf"))[3]
link <- paste0(getwd(),"/pdf/",pdf)

salary <- foreach(i=1:get_n_pages(link),.combine='rbind') %dopar% tabulizer::extract_tables(link,pages=i,method="data.frame",header=FALSE)

salary <- do.call(rbind,salary[,colSums(is.na(salary))<nrow(salary)])
names(salary)[1:7] <- c("Type_of_Appointment","Agency_Name","Last_Name","First_Name","Position_Title","Annual_Rate","Hire_Date")

salary[,colSums(is.na(salary))<nrow(salary)] %>%
    filter(Type_of_Appointment!="") %>%
    mutate(Export_Date=disclose_date(2014,1),
           Hire_Date=as.Date(Hire_Date,"%m/%d/%Y"),
           Type_of_Appointment=gsub("[^\\x{00}-\\x{7f}]","-",Type_of_Appointment,perl=TRUE),
           Type_of_Appointment=gsub("---","-",Type_of_Appointment),
           Last_Name=gsub("[^\\x{00}-\\x{7f}]","-",Last_Name,perl=TRUE),
           Last_Name=gsub("---","-",Last_Name),
           First_Name=gsub("[^\\x{00}-\\x{7f}]","-",First_Name,perl=TRUE),
           First_Name=gsub("---","-",First_Name),
           Position_Title=gsub("[^\\x{00}-\\x{7f}]","-",Position_Title,perl=TRUE),
           Position_Title=gsub("---","-",Position_Title),
           Annual_Rate=gsub("\\$","",Annual_Rate),
           Annual_Rate=as.numeric(gsub(",","",Annual_Rate))) %>%
    distinct %>%
write.csv(.,"csv/2014_03.csv",row.names=F)