################################################################################
##
## [ PROJ ] < Create analysis dataset from College Scorecard for EDUC152 teaching purposes # >
## [ FILE ] < read_scorecard_data.R >
## [ AUTH ] < Ozan Jaqeutte / ozanj >
## [ INIT ] < 3/19/2021 >
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(rscorecard)

## ---------------------------
## directory paths
## ---------------------------


#data_dir <- file.path('.','..','college_scorecard')
#data_dir
#list.files(path = data_dir)

input_data_dir <- file.path('.','data','college_scorecard','input_data')
input_data_dir
list.files(path = input_data_dir)

output_data_dir <- file.path('.','data','college_scorecard','output_data')
output_data_dir
list.files(path = output_data_dir)

## ---------------------------
## create a function to download scorecard data
## ---------------------------

download_scorecard <- function(url, zip_file_name, unzip_file_name, file_date, file_extension) {

  # create objects for: url; path and name of zip-file; path and name of unzipped file  
  data_url <- str_c(url,zip_file_name,file_date,'.zip')
  writeLines(str_c('data_url object = ',data_url))
  
  data_zipfile <- file.path(input_data_dir, str_c(zip_file_name, file_date, '.zip'))
  writeLines(str_c('data_zipfile object = ',data_zipfile))
  
  data_unzipped <- file.path(input_data_dir, str_c(unzip_file_name,file_extension))
  writeLines(str_c('data_unzipped object = ',data_unzipped))
  
  # download and unzip file [if necessary]
  if (!file.exists(data_zipfile)) {
    writeLines(str_c('Downloading file: ', data_zipfile, ' & Unzipping file: ', data_unzipped))
    download.file(url = data_url, destfile = data_zipfile)
    unzip(zipfile = data_zipfile, exdir = input_data_dir)
  } else if (!file.exists(data_unzipped)) {
    writeLines(str_c('Unzipping file: ', data_unzipped))
    unzip(zipfile = data_zipfile, exdir = input_data_dir)
  } else {
    writeLines(str_c('Already have files: ', data_zipfile, ' & ', data_unzipped))
  }
  
}

# Most recent institution-level data

  inst_url <- 'https://data.ed.gov/dataset/9dc70e6b-8426-4d71-b9d5-70ce6094a3f4/resource/823ac095-bdfc-41b0-b508-4e8fc3110082/download/'
  inst_file_name <- 'most-recent-cohorts-all-data-elements'
  inst_file_date <- '_01192021'
  
  download_scorecard(url = inst_url, zip_file_name = inst_file_name , unzip_file_name = inst_file_name, file_date = inst_file_date, file_extension = '.csv')
  
  # delete objects for url, file name, etc.
  rm(inst_url,inst_file_name,inst_file_date)

# Most recent data by field of study
  
  field_url <- 'https://data.ed.gov/dataset/9dc70e6b-8426-4d71-b9d5-70ce6094a3f4/resource/ff68afc4-6d23-459d-9f60-4006e4f85583/download/'
  field_file_name <- 'most-recent-cohorts-field-of-study'
  field_file_date <- '_01192021'
  
  download_scorecard(url = field_url, zip_file_name = field_file_name , unzip_file_name = field_file_name, file_date = field_file_date, file_extension = '.csv')
  
  # delete objects for url, file name, etc.
  rm(field_url,field_file_name,field_file_date)

# all data 
  # !!! note: function needs to be modified to for all data/all years because all has a sub-directory "Raw Data Files" that contains multiple CSV files !!!

  all_url <- 'https://ed-public-download.app.cloud.gov/downloads/'
  all_zip_file_name <- 'CollegeScorecard_Raw_Data'
  all_unzip_file_name <- 'Raw Data Files'
  all_file_date <- '_01192021'
  
  download_scorecard(url = all_url, zip_file_name = all_zip_file_name , unzip_file_name = all_unzip_file_name, file_date = all_file_date, file_extension = '')
  
  # delete objects for url, file name, etc.
  rm(all_url,all_zip_file_name,all_unzip_file_name,all_file_date)
    

## ---------------------------
## create function to read scorecard data
## ---------------------------

read_scorecard <- function(file_name) {
  
  df <- read_csv(file = file.path(input_data_dir, str_c(file_name,'.csv')))
  
  names(df) <- str_to_lower(names(df))
  
  df # what to return
}
  
# read most recent institution level data
  
  df_inst_recent <- read_scorecard(file_name = 'most-recent-cohorts-all-data-elements')
  
  df_inst_recent
  #rm(df_inst_recent)

# read most recent institution-field level data
  
  #df_field_recent <- read_scorecard(file_name = 'most-recent-cohorts-field-of-study')
  #rm(df_field_recent)

# read data from all files, all years
  
  # institution-field level data
  df_field_1516 <- read_scorecard(file_name = 'Raw Data Files/FieldOfStudyData1415_1516_PP')
  df_field_1617 <- read_scorecard(file_name = 'Raw Data Files/FieldOfStudyData1516_1617_PP')
  df_field_1718 <- read_scorecard(file_name = 'Raw Data Files/FieldOfStudyData1617_1718_PP')
  
  # create variable that defines year of data for field of study data
  
  df_field_1516$field_ay <- '2015-16'
  df_field_1617$field_ay <- '2016-17'
  df_field_1718$field_ay <- '2017-18'
  
  # append multiple years of institution-field level data and sort data
    # 
  df_field_panel <- bind_rows(df_field_1516,df_field_1617,df_field_1718) %>% arrange(opeid6,unitid,cipcode,credlev,desc(field_ay))
  
  df_field_panel %>% count(field_ay)
  df_field_panel %>% glimpse()
  

  

## ---------------------------
## Create analysis file that contains variables from institution level and institution-field level data
## ---------------------------

  # Investigate structure of data

    # institution level data: 
      #unitid uniquely identifies obs
      df_inst_recent %>% group_by(unitid) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)

    # institution-field level data: 
  
      # opeid6-unitid-cipcode-credlev uniquely identifies obs
      df_field_1718 %>% group_by(opeid6,unitid,cipcode,credlev) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
    
      # after filtering man == 1, opeid6-cipcode-credlev does not uniquely identify obs but comes close
      df_field_1718 %>% filter(main == 1) %>% group_by(opeid6,cipcode,credlev) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
      
      # for panel dataset, opeid6-unitid-cipcode-credlev-field_ay uniquely identifies obs
      df_field_panel %>% group_by(opeid6,unitid,cipcode,credlev,field_ay) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)


# join data
    
  # create institution level dataset with subset of variables
  df_inst_somevars <- df_inst_recent %>% 
    select(unitid,city,stabbr,zip,main,accredagency,numbranch,highdeg,st_fips,region,locale,locale2,latitude,longitude,ccbasic,
      hbcu,annhi,tribal,aanapii,hsi,nanti,relaffil)
    # note: excluded these vars because keeping versions from institution-field level data: instnm,control,main
      
  df_inst_somevars %>% glimpse()
  df_inst_somevars %>% count(region)
  
  # left join with x=df_field_panel and y = df_inst_recent
    # keep only main campuses

  df_debt_earn_panel <- df_field_panel  %>%
    # keep only main campuses
    filter(main ==1) %>%
    # select vars to keep from inst-field level data
    select(-main,-contains('male'),-contains('pell'),-starts_with('bbrr'),-contains('nwne'),-contains('cntover150')) %>% 
    # left join
    left_join(y=df_inst_somevars %>% mutate(unitid = as.character(unitid)), by = 'unitid') %>% 
    # order of variables
    relocate(opeid6,unitid,instnm,control,ccbasic,stabbr,city,cipcode,cipdesc,credlev,creddesc,field_ay,ipedscount1,ipedscount2,
      contains('stgp'),contains('_pp'),starts_with('earn'),
      main,numbranch,accredagency,highdeg,st_fips,region,zip,locale,locale2,latitude,longitude,relaffil,hbcu,annhi,tribal,aanapii,hsi,nanti) %>% 
    mutate(unitid = as.numeric(unitid))      
    
  df_debt_earn_panel %>% glimpse()
  #rm(df_debt_earn_panel)
  
  
# save institution-field level panel dataset as .RDS file
  
  save(df_debt_earn_panel, file = file.path(output_data_dir, 'df_debt_earn_panel.RData'))
  
  # load data from local pc
  load(file = file.path(output_data_dir, 'df_debt_earn_panel.RData'))
  
  # load data from github
  load(file = url('https://github.com/anyone-can-cook/educ152/raw/main/data/college_scorecard/output_data/df_debt_earn_panel.RData'))

  
  
###################################    
# OZAN'S NOTES TO SELF ON WHICH YEAR OF IPEDS TUITION PRICE DATA TO MERGE TO WHICH YEAR OF SCORECARD DATA
###################################

  # SCORECARD DATA
    # df_debt_earn_panel_labelled, field_ay=='2017-18' refers to "FieldOfStudyData1617_1718"
    # terms scorecard uses to refer to year/time period
      # Acad yr	Academic Year; differs by institution, but generally the period from September to June (e.g., AcadYr 2013-14 = 9/1/2013 - 5/31/2014)
      # AY	Award Year (e.g. AY 2013-14 = 7/1/2013-6/30/2014)
      # CY	Calendar Year (e.g. CY 2014 = 1/1/14-12/31/14)
      # DCY	IPEDS Data Collection Year (e.g., DCY2013-14 = the 2013-14 IPEDS collection)

    # variables
      # ipedscount1 = Number of awards to all students in year 1 of the pooled debt cohort
        # for scorecard "FieldOfStudyData1617_1718" data, this refers to degrees granted in AY 2016-17 reported in IPEDS DCY2017-18
      # ipedscount2 = number of awards to all students in year 2 of the pooled debt cohort
        # for scorecard "FieldOfStudyData1617_1718" data, this refers to degrees granted in AY 2017-18 reported in IPEDS DCY2018-19

    # assumptions about relationship between MA degree awards and when students started MA program
      # Most (full-time) MA programs take one or two academic years to complete

      # Assuming two years for MA degree completion:

        # students awarded MA degrees in AY 2016-17 (e.g., May 2017) initially enrolled in Fall 2015 of 2015-16 academic year (year 1 = 2015-16; year 2 = 2016-17)
          # first paid tuition in fall 2015
        # students awarded MA degrees in AY 2017-18 (e.g., May 2018) initially enrolled in Fall 2016 of 2016-17 academic year (year 1 = 2016-17; year 2 = 2017-18)
          # first paid tuition in fall 2016

  # IPEDS DATA

    # if you are matching IPEDS tuition price to ipedscount1 of "FieldOfStudyData1617_1718" data
      # choose tuition price from fall 2015 of 2015-16 academic year
        # file ic2015 provides tuition price for 2015-16 academic year
        # in df_ipeds_panel data frame, this is associated with year==2015
    # if you are matching IPEDS tuition price to ipedscount2  of "FieldOfStudyData1617_1718" data
      # choose tuition price from fall 2016 of 2016-17 academic year
        # file ic2016 provides tuition price for 2016-17 academic year
        # in df_ipeds_panel data frame, this is associated with year==2016

  # DECISION
    # assume we are matching IPEDS tuition price to ipedscount2  of "FieldOfStudyData1617_1718" data
    # therefore: filter(year==2016)

    
###################################  
# investigate analysis dataset
###################################
  
  # vars that uniquely identify
  df_debt_earn_panel %>% group_by(opeid6,unitid,cipcode,credlev,field_ay) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
  
  df_debt_earn_panel %>%
    # keep most recent year of data
    %>% filter(credlev == 5)
    # keep master's degrees
    %>% filter(credlev == 5)
    # carnegie categories to keep: 15 = Doctoral Universities: Very High Research Activity; 16 = Doctoral Universities: High Research Activity; 17 = Doctoral/Professional Universities
    filter(ccbasic %in% c(15,16,17)) 
    
    %>%
  
  sc_dict('ccbasic')
    
# investigate which obs from table x = df_field_panel did not have a matching value from table y = df_inst_somevars
  
  field_no_inst <- df_field_panel %>% filter(main ==1) %>%
    select(opeid6,unitid,cipcode,credlev,field_ay,instnm,control,main,cipdesc,creddesc,ipedscount1,ipedscount2) %>%
    anti_join(y=df_inst_somevars, by='unitid') 
  
  field_no_inst %>% glimpse()
  
  field_no_inst %>% count(field_ay) # missing data in all years
  
  field_no_inst %>% count(main) # about half are not main campuses
  field_no_inst %>% count(unitid) # about half are not main campuses
  
  field_no_inst %>% count(control) # about half are not main campuses # most are foreign or private-for-profit
  
  field_no_inst %>% filter(control %in% c('Private, nonprofit','Public')) %>% count(control)
  field_no_inst %>% filter(control %in% c('Private, nonprofit','Public')) %>% count(main)
  
  field_no_inst %>% filter(control %in% c('Private, nonprofit','Public')) %>% count(unitid)
  field_no_inst %>% filter(control %in% c('Private, nonprofit','Public')) %>% count(instnm)
  
  field_no_inst %>% filter(control %in% c('Private, nonprofit','Public')) %>% count(field_ay)
  
  field_no_inst %>% filter(control %in% c('Private, nonprofit','Public')) %>% count(instnm) %>% print(n = 400)
  
  # print publics from field_ay == 2017-18 cohort that didn't have institution level data
  field_no_inst %>% filter(control %in% c('Public'), field_ay == '2017-18') %>% count(instnm) %>% print(n = 400)

  # print publics from field_ay == 2017-18 cohort that didn't have institution level data and were main campuses; VERDICT == NOT MISSING MUCH
  field_no_inst %>% filter(control %in% c('Public'), field_ay == '2017-18',main ==1) %>% count(instnm) %>% print(n = 400)

      
  # print not-for-profits from field_ay == 2017-18 cohort that didn't have institution level data 
  field_no_inst %>% filter(control %in% c('Private, nonprofit'), field_ay == '2017-18') %>% count(instnm) %>% print(n = 400)
  
  # print not-for-profits from field_ay == 2017-18 cohort that didn't have institution level data and were main campuses; VERDICT = NOT MISSING MUCH
  field_no_inst %>% filter(control %in% c('Private, nonprofit'), field_ay == '2017-18', main ==1) %>% count(instnm) %>% print(n = 400)
  
  
## ---------------------------
## investigations of institution level and institution-field level data
## ---------------------------

# Investigate structure of institution level data

  # uniquely identify obs
    
    # unitid uniquely identifies obs
    df_inst_recent %>% group_by(unitid) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
  
    # opeid6 does not uniquely identify obs
    df_inst_recent %>% group_by(opeid6) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
    
    # opeid does not uniquely identify obs
    df_inst_recent %>% group_by(opeid) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
  
    
  # which variables to keep
    
    df_inst_recent %>% select(unitid,instnm,city,stabbr,zip,accredagency,main,numbranch,highdeg,control,st_fips,region,locale,locale2,latitude,longitude,ccbasic,
             hbcu,annhi,tribal,aanapii,hsi,nanti,relaffil)
    
# Investigate structure of institution-field level data  

  # uniquely identify obs
    
    df_field_1718
    df_field_1718 %>% glimpse()
    
    df_field_1718 %>% count(main)
    
    # unitid-cipcode-credlev does not uniquely identify obs, but gets closer than anything else i can find
    df_field_1718 %>% group_by(unitid,cipcode,credlev) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
    
    # filter first by main == 1, then group_by unitid-cipcode-credlev does not uniquely identify obs
    df_field_1718 %>% filter(main == 1) %>% group_by(unitid,cipcode,credlev) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
    
    # opeid6-cipcode-credlev does not uniquely identify obs [does worse than unitid]
    df_field_1718 %>% group_by(opeid6,cipcode,credlev) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)
  
    
  # identify variables of interest to keep
    # variable name suffixes of note
      # stgp = stafford and grad plus
        # note: safford = direct subsidized and direct unsubsidized
      # pp = parent plus
      # eval = debt statistics for loans originated only at the institution where the debt is reported
      # any = loans originated at any institution the student attended
    
    
    # drop variables you don't want
    df_field_1718 %>% select(-contains('male'),-contains('pell'),-starts_with('bbrr'),-contains('nwne'),-contains('cntover150')) %>% glimpse()
## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
