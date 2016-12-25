setwd("C:/Users/Benjamin/Desktop/Projects/dchr_salary/")
source(paste0(getwd(),"/code/",dir(paste0(getwd(),"/code"))[1]))

pdf <- dir(paste0(getwd(),"/pdf"))[2]
link <- paste0(getwd(),"/pdf/",pdf)
test_page(link)

salary <- foreach(i=1:get_n_pages(link),.combine='rbind') %dopar% tabulizer::extract_tables(link,pages=i,method="data.frame")

for(a in 2:length(salary)){
    if(length(names(salary[[a]]))==8){
        salary[[a]] <- rbind(salary[[a]],names(salary[[a]]))
        names(salary[[a]]) <- names(salary[[1]])
        salary[[a]]$Compensation <- NULL
        names(salary[[a]])[7] <- "Hire.Date"
        names(salary[[a]])[6] <- "Compensation"
    }
}

salary <- do.call(rbind,salary)
names(salary) <- c("Type_of_Appointment","Agency_Name","Last_Name","First_Name","Position_Title","Annual_Rate","Hire_Date")
row.names(salary) <- 1:nrow(salary)

salary <- salary[,colSums(is.na(salary))<nrow(salary)] %>%
    mutate(Export_Date=disclose_date(2015,3),
           Hire_Date=gsub("X","",Hire_Date),
           Hire_Date=gsub(".","/",Hire_Date,fixed=T),
           Hire_Date=as.Date(Hire_Date,"%m/%d/%Y"),
           Type_of_Appointment=gsub("[^\\x{00}-\\x{7f}]","-",Type_of_Appointment,perl=TRUE),
           Type_of_Appointment=gsub("---","-",Type_of_Appointment),
           Type_of_Appointment=gsub("."," ",Type_of_Appointment,fixed=T),
           Type_of_Appointment=gsub(" -   "," - ",Type_of_Appointment,fixed=T),
           Last_Name=gsub("[^\\x{00}-\\x{7f}]","-",Last_Name,perl=TRUE),
           Last_Name=gsub("---","-",Last_Name),
           First_Name=gsub("[^\\x{00}-\\x{7f}]","-",First_Name,perl=TRUE),
           First_Name=gsub("---","-",First_Name),
           Position_Title=gsub("[^\\x{00}-\\x{7f}]","-",Position_Title,perl=TRUE),
           Position_Title=gsub("---","-",Position_Title),
           Position_Title=gsub("."," ",Position_Title,fixed=T),
           Annual_Rate=gsub("X","",Annual_Rate),
           Agency_Name=gsub(".."," ",Agency_Name,fixed=T),
           Agency_Name=gsub("."," ",Agency_Name,fixed=T),
           Agency_Name=gsub(",","",Agency_Name,fixed=T),
           Agency_Name=gsub("  "," ",Agency_Name,fixed=T),
           Agency_Name=gsub("[^\\x{00}-\\x{7f}]","-",Agency_Name,perl=TRUE),
           Agency_Name=gsub("---","-",Agency_Name),
           Agency_Name=gsub("D C","DC",Agency_Name),
           Agency_Name=ifelse(Agency_Name=="People s Counsel Ofc of the","People's Counsel Ofc of the",
           ifelse(Agency_Name=="PS J Cluster Ofc of Dep Mayor","PS&J Cluster Ofc of Dep Mayor",Agency_Name))) %>%
           sapply(.,trimws) %>% 
           as.data.frame
substr(salary$Annual_Rate,1,4) <- sub('.',',',substr(salary$Annual_Rate,1,4),fixed=T)

salary %>%
  mutate(Annual_Rate=as.numeric(gsub('[$,]','',salary$Annual_Rate)),
    Hire_Date=as.Date(Hire_Date),
    Export_Date=as.Date(Export_Date)) %>%
write.csv(.,"csv/salary_2015_q3.csv",row.names=F)