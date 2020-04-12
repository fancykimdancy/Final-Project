library(rscorecard)
library(dplyr)
library(readxl)
library(stringr)
library(ggplot2)

setwd("~/Desktop/Stat 479/Final-Project/Data")
download.file("https://studentaid.gov/sites/default/files/fsawg/datacenter/library/ACSD.xls", filename)
dischargereport<-read_excel(filename, sheet=2, skip=5, col_names=c("opeid6", "name", "city", "state", "type", "discharged_borrowers","discharged_amount"))
dischargereport<-filter(dischargereport, !is.na(name))

sc_key("bk0cLyNPPdUahxCeXpv5SdZpjFuhw1Sawsf8iZLN")
vars<-sc_dict(".", return_df=T, limit="Inf")
varnames<-c("OPEID")
for(scyear in 2012:2018) {
scyear<-sc_init() %>%
  sc_select(UNITID,
            OPEID,
            OPEID6,
            INSTNM, 
            CITY,
            STABBR,
            ZIP,
            ACCREDAGENCY,
            HCM2,
            MAIN,
            NUMBRANCH,
            PREDDEG, 
            CONTROL,
            LATITUDE,
            LONGITUDE,
            CCBASIC,
            HBCU,
            PBI,
            ANNHI,
            TRIBAL,
            AANAPII,
            HSI,
            NANTI,
            MENONLY,
            WOMENONLY,
            RELAFFIL,
            ADM_RATE,
            ADM_RATE_ALL,
            SAT_AVG,
            SAT_AVG_ALL,
            UGDS_WHITE,
            UGDS_BLACK,
            UGDS_HISP,
            UGDS_ASIAN,
            UGDS_AIAN,
            UGDS_NHPI,
            UGDS_2MOR,
            UGDS_NRA,
            UGDS_UNKN,
            PPTUG_EF,
            PPTUG_EF2,
            NPT4_PUB,
            NPT4_PRIV,
            NPT4_PROG,
            NPT4_OTHER,
            TUITFTE,
            INEXPFTE,
            AVGFACSAL,
            PFTFAC,
            PCTPELL,
            PCTFLOAN,
            UG25ABV,
            INC_PCT_LO,
            DEP_STAT_PCT_IND,
            IND_INC_PCT_LO,
            DEP_INC_PCT_LO,
            PAR_ED_PCT_1STGEN,
            INC_PCT_M1,
            INC_PCT_M2,
            INC_PCT_H1,
            INC_PCT_H2,
            DEP_INC_PCT_M1,
            DEP_INC_PCT_M2,
            DEP_INC_PCT_H1,
            DEP_INC_PCT_H2,
            IND_INC_PCT_M1,
            IND_INC_PCT_M2,
            IND_INC_PCT_H1,
            IND_INC_PCT_H2,
            PAR_ED_PCT_MS,
            PAR_ED_PCT_HS,
            PAR_ED_PCT_PS,
            DEBT_MDN,
            GRAD_DEBT_MDN,
            WDRAW_DEBT_MDN,
            LO_INC_DEBT_MDN,
            MD_INC_DEBT_MDN,
            HI_INC_DEBT_MDN,
            DEP_DEBT_MDN,
            IND_DEBT_MDN,
            PELL_DEBT_MDN,
            NOPELL_DEBT_MDN,
            FEMALE_DEBT_MDN,
            MALE_DEBT_MDN,
            FIRSTGEN_DEBT_MDN,
            NOTFIRSTGEN_DEBT_MDN,
            DEBT_N,
            GRAD_DEBT_N,
            WDRAW_DEBT_N,
            LO_INC_DEBT_N,
            MD_INC_DEBT_N,
            HI_INC_DEBT_N,
            DEP_DEBT_N,
            IND_DEBT_N,
            PELL_DEBT_N,
            NOPELL_DEBT_N,
            FEMALE_DEBT_N,
            MALE_DEBT_N,
            FIRSTGEN_DEBT_N,
            NOTFIRSTGEN_DEBT_N) %>%
  sc_filter(curroper==0) %>%
  sc_year(year) %>%
  sc_get()
  scyear<-mutate(scyear, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8))
  filename=paste("scorecard", year)
  write.csv(scyear, filename)
}

scorecard2018<-read.csv("scorecard 2018")
scorecard2018<-mutate(scorecard2018, opeid=str_pad(opeid, 8, side=c("left"), pad="0"), opeid6=substring(opeid, 1, 6), opeidend=substring(opeid, 7,8))
closures<-inner_join(scorecard2018, dischargereport, by="opeid6")

gg
