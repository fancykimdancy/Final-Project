library(rscorecard)
library(dplyr)
library(readxl)
library(stringr)
library(ggplot2)

setwd("~/Desktop/Stat 479/Final-Project/Data")
download.file("https://studentaid.gov/sites/default/files/fsawg/datacenter/library/ACSD.xls", filename)
dischargereport<-read_excel(filename, sheet=2, skip=5, col_names=c("opeid6", "name", "city", "state", "type", "discharged_borrowers","discharged_amount"), col_types=c("text", "text", "text", "text", "text", "numeric", "numeric"))
dischargereport<-filter(dischargereport, !is.na(name))

download.file("https://ed-public-download.app.cloud.gov/downloads/CollegeScorecard_Raw_Data.zip", filename)
unzip(filename)
scorecard2010<-read.csv("CollegeScorecard_Raw_Data/MERGED2010_11_PP.csv", na.strings="NULL")
scorecard2011<-read.csv("CollegeScorecard_Raw_Data/MERGED2011_12_PP.csv", na.strings="NULL")
scorecard2012<-read.csv("CollegeScorecard_Raw_Data/MERGED2012_13_PP.csv", na.strings="NULL")
scorecard2013<-read.csv("CollegeScorecard_Raw_Data/MERGED2013_14_PP.csv", na.strings="NULL")
scorecard2014<-read.csv("CollegeScorecard_Raw_Data/MERGED2014_15_PP.csv", na.strings="NULL")
scorecard2015<-read.csv("CollegeScorecard_Raw_Data/MERGED2015_16_PP.csv", na.strings="NULL")
scorecard2016<-read.csv("CollegeScorecard_Raw_Data/MERGED2016_17_PP.csv", na.strings="NULL")
scorecard2017<-read.csv("CollegeScorecard_Raw_Data/MERGED2017_18_PP.csv", na.strings="NULL")
scorecard2018<-read.csv("CollegeScorecard_Raw_Data/MERGED2018_19_PP.csv", na.strings="NULL")
names(scorecard2010)<-tolower(names(scorecard2010))
names(scorecard2011)<-tolower(names(scorecard2011))
names(scorecard2012)<-tolower(names(scorecard2012))
names(scorecard2013)<-tolower(names(scorecard2013))
names(scorecard2014)<-tolower(names(scorecard2014))
names(scorecard2015)<-tolower(names(scorecard2015))
names(scorecard2016)<-tolower(names(scorecard2016))
names(scorecard2017)<-tolower(names(scorecard2017))
names(scorecard2018)<-tolower(names(scorecard2018))

scorecard2010<-mutate(scorecard2010, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2010)
closures2010<-inner_join(scorecard2010, dischargereport)

scorecard2011<-mutate(scorecard2011, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2011)
closures2011<-inner_join(scorecard2011, dischargereport)

scorecard2012<-mutate(scorecard2012, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2012)
closures2012<-inner_join(scorecard2012, dischargereport)

scorecard2013<-mutate(scorecard2013, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2013)
closures2013<-inner_join(scorecard2013, dischargereport)

scorecard2014<-mutate(scorecard2014, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2014)
closures2014<-inner_join(scorecard2014, dischargereport)

scorecard2015<-mutate(scorecard2015, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2015)
closures2015<-inner_join(scorecard2015, dischargereport)

scorecard2016<-mutate(scorecard2016, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2016)
closures2016<-inner_join(scorecard2016, dischargereport)

scorecard2017<-mutate(scorecard2017, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8), year=2017)
closures2017<-inner_join(scorecard2017, dischargereport)

scorecard2018<-mutate(scorecard2018, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8),year=2018)
closures2018<-inner_join(scorecard2018, dischargereport)

closures<-rbind(closures2010, closures2011, closures2012, closures2013, closures2014, closures2015, closures2016, closures2017, closures2018)
not_all_na <- function(x) any(!is.na(x))
closures<-select_if(closures, not_all_na) %>%
  mutate(average_discharge=discharged_amount/discharged_borrowers*1000, level=ifelse(preddeg==1, "Certificate", ifelse(preddeg==2, "Associate's", ifelse(preddeg==3, "Bachelor's", "Other")))) %>%
  mutate(level2=factor(level, levels=c("Certificate", "Associate's", "Bachelor's", "Other"))) %>%
  rowwise() %>% 
  mutate(Enrollment = sum(ug12mn, g12mn, na.rm = TRUE))
         
closures_recent<-closures %>% group_by(opeid6) %>%
  mutate(year_recent=max(year)) %>%
  filter(year_recent==year) %>%
  select_if(not_all_na)


write.csv(closures_recent, "closures_recent")



