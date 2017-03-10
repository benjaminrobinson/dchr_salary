setwd("C:/Users/Benjamin/Desktop/Projects/dchr_salary/")
source(paste0(getwd(),"/code/",dir(paste0(getwd(),"/code"))[1]))
pdf <- dir(paste0(getwd(),"/pdf"))[4]
link <- paste0(getwd(),"/pdf/",pdf)

salary <- foreach(i=1:get_n_pages(link),.combine='rbind') %dopar% tabulizer::extract_tables(link,pages=i,method="data.frame",header=FALSE)

tmp <- c()
for(a in 1:length(salary)){
    if(length(salary[[a]]) != 7) {
        for(b in outersect(names(salary[[a]]),c("V1","V2","V3","V4","V5","V6","V7","V8"))) {
            tmp <- c(tmp,a)
            salary[[a]][paste(b)] <- NA
        }
    }
}