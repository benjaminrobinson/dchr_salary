setwd("C:/Users/Benjamin/Desktop/Projects/dchr_salary/")
source(paste0(getwd(),"/code/",dir(paste0(getwd(),"/code"))[1]))
pdf <- dir(paste0(getwd(),"/pdf"))[2]
link <- paste0(getwd(),"/pdf/",pdf)

salary <- foreach(i=1:get_n_pages(link),.combine='rbind') %dopar% tabulizer::extract_tables(link,pages=i,method="data.frame",header=FALSE)

tmp <- c()
for(a in 1:length(salary)){
    if(length(salary[[a]]) != 8) {
        for(b in outersect(names(salary[[a]]),c("V1","V2","V3","V4","V5","V6","V7","V8"))) {
            tmp <- c(tmp,a)
            salary[[a]][paste(b)] <- NA
        }
    }
}

for(d in tmp){
  names(salary[[d]]) <- c("V1","V2","V3","V4","V5","V7","V8","V6")
}


salary <- do.call(rbind,salary)
names(salary) <- c("Type_of_Appointment","Agency_Name","Last_Name","First_Name","Position_Title","Annual_Rate","Hire_Date","V6")

salary %>%
    filter(Type_of_Appointment!="Type Appt ") %>%
    mutate(V6=NULL,
           Export_Date=disclose_date(2015,3),
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
write.csv(.,"csv/2015_09.csv",row.names=F)