################################################################################
##
## [ PROJ ] < Create analysis dataset from ELS BY to PETS # >
## [ FILE ] < read_els_by_pets.R >
## [ AUTH ] < Ozan Jaqeutte / ozanj >
## [ INIT ] < 5/11/2021 >
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

options(max.print=99)
library(tidyverse)
library(haven)
library(labelled)

#library(questionr) # don't think we need this one
  #install.packages('questionr') # if you haven't installed already
    # I could not install package questionr because package 'htmltools' was out of date; 
      # I hade difficulty installing package html tools; worked when I opened R not in an R project
      #install.packages('htmltools') # C:\Users\ozanj\AppData\Local\Temp\Rtmpc1kAUo\downloaded_packages
    # I could not install/load package questionr because package rlang was out of date



## ---------------------------
## directory paths
## ---------------------------

# comment these outs because students will read directly from url of 
#input_data_dir <- file.path('.','data','els','input_data')
#input_data_dir
#list.files(path = input_data_dir)

output_data_dir <- file.path('.','data','els','output_data')
output_data_dir
list.files(path = output_data_dir)

## ---------------------------
## Read els data from Stata
## ---------------------------

#els_02_12_byf1sch_v1_0.dta # high school-level data
#els_02_12_byf3pststu_v1_0.dta # core student-level data
#els_02_12_f2inst_v1_0.dta # PSI institution-level data, follow-up 2
#els_02_12_f3inst_v1_0.dta # PSI institution-level data, follow-up 3


# url of stata dataset stored on Dropbox
  els_stu_url <- 'https://www.dropbox.com/s/y3b7bsobq43cokb/els_02_12_byf3pststu_v1_0.dta?dl=1'


# read in data 
  df_els_stu_all <- read_dta(
    file= file.path(els_stu_url),
    encoding = NULL,
    col_select = NULL,
    skip = 0,
    n_max = Inf,
    .name_repair = "unique"
  )
  #file= file.path(input_data_dir,'els_02_12_byf3pststu_v1_0.dta'),

# replace upper case variable names with lower case variable names
  names(df_els_stu_all) <- tolower(names(df_els_stu_all))

  
# Look for variables based on variable names and variable labels
  #lookfor(data=df_els_stu_all, 'real',labels = TRUE, ignore.case = TRUE, details = TRUE)
  lookfor(data=df_els_stu_all, 'ps1start',labels = TRUE, ignore.case = TRUE, details = TRUE)
  
  
# create vector of variable names to keep, and create upper case and lower case versions of this vector  
  keepvars <- c('stu_id','sch_id','strat_id','psu','f3univ','g10cohrt','f1pared','byincome','bystexp','byparasp','bytxstat','bypqstat','bytxmstd','bynels2m',
                'bytxrstd','bysctrl','byurban','byregion','byfcomp','bysibhom','bys34a','f1sex','f1race','f1stlang','f1homlng','f1mothed','f1fathed','f1ses1',
                'f1ses1qu','f1stexp','f1txmstd','f1rgpp2','f1s24cc','f1s24bc','f2everdo','f2dostat',
                'F2EVRATT','F2PS1','F2PS1LVL','F2PS1CTR','F2PS1SEC','F2PS1SLC',
                'f2rtype','f2c01','f2c24_p','f2c25a','f2c25a','f2c29_p','f2c30a',
                'F3HSSTAT','F3HSCPDR','f3edstat','f3a01d',
                'F3EVRATT','F3EDSTAT','F3PS1START','F3PS1LVL','F3PS1CTR','F3PS1SEC','F3PS1SLC','F3PS1OUT','F3PS1RETAIN','F3PSTIMING',
                'f3tztranresp','f3tzcoverage',
                'f3tzrectrans','f3tzreqtrans','f3tzschtotal','f3tzps1sec','f3tzps1slc','f3tzps1start','f3tzhs2ps1',
                'f3tzever2yr','f3tzever4yr','f3tzremtot','f3tzrempass','f3tzremengps','f3tzrementot','f3tzremmthps','f3tzremmttot',
                'f3tzanydegre','f3tzhighdeg','F3TZCERT1DT','F3TZCRT1CIP2','F3TZASOC1DT','F3TZASC1CIP2','f3tzbach1dt','f3tzbch1cip2',
                'f3stloanamt','f3stloanevr','f3stloanpay','F3ERN2011','F3TZPOSTATT','F3TZPOSTERN','F1RMAT_P')
              # drop these vars cuz suppressed "f3tzps1ctr"   "f3tzps1lvl" ;

  


  keepvars_lower <- tolower(keepvars)
  keepvars_lower
  
  keepvars_upper <- toupper(keepvars)
  keepvars_upper

# create dataset with subset of variables

df_els_stu_allobs <- df_els_stu_all %>%
  select(keepvars_lower) %>%
  # create new variables
  mutate(
    # create continuous measure of loans
    f3totloan = as.numeric(if_else(f3stloanevr==1,f3stloanamt,0)),
    # create 0/1 measure of whether student enrolled in postsecondary education in 04-05
    f2enroll0405 = case_when(
      f2c24_p %in% c(-3) ~ 0, # note: f2c24_p applies to: Second follow-up respondents who were enrolled at a post-secondary institution during the 04-05 school year.
      f2c24_p %in% c(0,1,2,3,4) ~ 1
    ),
    # create 0/1 measure of whether student enrolled in postsecondary education in 05-06
    f2enroll0506 = case_when(
      f2c29_p %in% c(-3) ~ 0, # note: f2c29_p applies to: Second follow-up respondents who were enrolled at a post-secondary institution during the 05-06 school year.
      f2c29_p %in% c(0,1,2,3,4) ~ 1
    ),
    # create 0/1 measure of whether students Held internship or co-op job while enrolled in 2004-2005 school year
      # non-missing for students enrolled in 2004-05 school year
      # cross-checks for var
        #df_els_stu %>% count(f2enroll0405,f2intern0405)
        #df_els_stu %>% filter(f2enroll0405==1) %>% count(f2c25a,f2intern0405)    
    f2intern0405 = case_when(
      f2enroll0405==1 & f2c25a %in% c(-3,0) ~ 0, # enrolled, intern legit skip (so no job) >> 0; enrolled, no internship (so yes job, but no internship) >> 0
      f2enroll0405==1 & f2c25a %in% c(1) ~ 1 # enrolled, no internship (so yes job, but no internship) >> 1
    ),
    # create 0/1 measure of whether students Held internship or co-op job while enrolled in 2005-2006 school year
      # non-missing for students enrolled in 2005-06 school year
      # cross-checks for var
        #df_els_stu %>% count(f2enroll0506,f2intern0506)
        #df_els_stu %>% filter(f2enroll0506==1) %>% count(f2c30a,f2enroll0506)    
    f2intern0506 = case_when(
      f2enroll0506==1 & f2c30a %in% c(-3,0) ~ 0, # enrolled, intern legit skip (so no job) >> 0; enrolled, no internship (so yes job, but no internship) >> 0
      f2enroll0506==1 & f2c30a %in% c(1) ~ 1 # enrolled, no internship (so yes job, but no internship) >> 1
    ),
    # create continuous measure of base year family income
    parent_income = case_when(
      byincome ==1 ~ 0, # 1  1 [None]
      byincome ==2 ~ 500, # 2  2 [$1,000 or less]
      byincome ==3 ~ 3000, # 3  3 [$1,001-$5,000]
      byincome ==4 ~ 7500, # 4  4 [$5,001-$10,000]
      byincome ==5 ~ 12500, # 5  5 [$10,001-$15,000]
      byincome ==6 ~ 17500, # 6  6 [$15,001-$20,000]
      byincome ==7 ~ 22500, # 7  7 [$20,001-$25,000]
      byincome ==8 ~ 30000, # 8  8 [$25,001-$35,000]
      byincome ==9 ~ 32500, # 9  9 [$35,001-$50,000]
      byincome ==10 ~ 62500, #10 10 [$50,001-$75,000]
      byincome ==11 ~ 87500, #11 11 [$75,001-$100,000]
      byincome ==12 ~ 150000, #12 12 [$100,001-$200,000]
      byincome ==13 ~ 250000, #13 13 [$200,001 or more]
    ),
    # create revised categorical measure of race
      f1race_v2 = case_when(
        f1race == 7 ~ 1, # white
        f1race == 2 ~ 2, # API
        f1race == 3 ~ 3, # Black
        f1race %in% c(4,5) ~ 4, # Hispanic
        f1race == 1 ~ 5, # Amer. Indian/Alaska Native, non-Hispanic
        f1race == 6 ~ 6 # multi
      ),
    # categorical math; convert zero to less than 2
      hs_math_cred = if_else(as.numeric(f1rmat_p)==0,1,as.numeric(f1rmat_p)),
    # create 0/1 indicator of whether student takes developmental math course in postsecondary education
     dev_math_01 = case_when(
      f3tzremmttot == 0 ~ 0, # 0 courses
      f3tzremmttot >= 1 ~ 1, # 1+ courses
    ),
    # create 4 category indicator of whether student takes developmental math course in postsecondary education
     dev_math_cat4 = case_when(
      f3tzremmttot == 0 ~ 1, # 0 courses
      f3tzremmttot == 1 ~ 2, # 1 courses
      f3tzremmttot == 2 ~ 3, # 2 courses
      f3tzremmttot > 2 ~ 4, # 3+ courses
    ),
    # create 3 category indicator of whether student takes developmental math course in postsecondary education
     dev_math_cat3 = case_when(
      f3tzremmttot == 0 ~ 1, # 0 courses
      f3tzremmttot == 1 ~ 2, # 1+ courses
      f3tzremmttot > 1 ~ 3, # 2+ courses
    )        
  ) %>% 
  # add value labels to categorical variables you created
    set_value_labels(
      f2enroll0405 = c('no' = 0,'yes' = 1),
      f2enroll0506 = c('no' = 0,'yes' = 1),
      f2intern0405 = c('no' = 0,'yes' = 1),
      f2intern0506 = c('no' = 0,'yes' = 1),
      dev_math_01 =  c('no' = 0,'yes' = 1),
      f1race_v2 = c('white'=1, 'api'=2, 'black'=3, 'latinx'=4, 'native'=5, 'multi'=6),
      dev_math_cat4 =  c('0 courses' = 1,'1 course' = 2, '2 courses' = 3, '3+ courses' = 4),
      dev_math_cat3 =  c('0 courses' = 1,'1 course' = 2, '2+ courses' = 3)
      ) 
  # assign attributes
  attributes(df_els_stu_allobs$hs_math_cred) <- attributes(df_els_stu_allobs$f1rmat_p)

# add variable labels
    var_label(df_els_stu_allobs[['f3totloan']]) <- 'total loans taken out to pay for postsecondary education as of f3 (2013)'
    var_label(df_els_stu_allobs[['f2enroll0405']]) <- '0/1 (no/yes) enrolled in 2004-05, based on student survey follow-up 2'
    var_label(df_els_stu_allobs[['f2enroll0506']]) <- '0/1 (no/yes) enrolled in 2005-06, based on student survey follow-up 2'
    var_label(df_els_stu_allobs[['f2intern0405']]) <- '0/1 (no/yes) held an internship or co-op in 2004-05; NA if not enrolled in postsecondary education in 2004-05'
    var_label(df_els_stu_allobs[['f2intern0506']]) <- '0/1 (no/yes) held an internship or co-op in 2005-06; NA if not enrolled in postsecondary education in 2005-06'
    var_label(df_els_stu_allobs[['parent_income']]) <- 'continuous measure of base year parental household income, calculated from categorical variable byincome'
    var_label(df_els_stu_allobs[['f1race_v2']]) <- 'categorical measure of race based on variable f1race'
    var_label(df_els_stu_allobs[['dev_math_01']]) <- 'dichotomous indicator of whether student took any developmental math courses in postsecondary education (based on f3tzremmttot)'
    var_label(df_els_stu_allobs[['dev_math_cat4']]) <- 'four category indicator of whether student took any developmental math courses in postsecondary education (based on f3tzremmttot)'
    var_label(df_els_stu_allobs[['dev_math_cat3']]) <- 'three category indicator of whether student took any developmental math courses in postsecondary education (based on f3tzremmttot)'

    glimpse(df_els_stu_allobs)

  df_els_stu_allobs_fac <- as_factor(df_els_stu_allobs, only_labelled = TRUE)
  glimpse(df_els_stu_allobs_fac)
  # convert continuous variables we know we want numeric back to numeric
  for (v in c('bytxmstd','bytxrstd','bynels2m','bys34a','f1txmstd','f3stloanamt','f3stloanpay','f3ern2011','f3tzrectrans','f3tzreqtrans','f3tzschtotal','f3tzpostern','f3tzpostatt',
              'f3tzremtot','f3tzrempass','f3tzremengps','f3tzrementot','f3tzremmthps','f3tzremmttot','f3tzps1start','f3hscpdr')) {
    df_els_stu_allobs_fac[[v]] <- df_els_stu_allobs[[v]]  
  }
  glimpse(df_els_stu_allobs_fac)    

# save file with all observations to disk
save(df_els_stu_allobs,df_els_stu_allobs_fac, file = file.path(output_data_dir, 'els_stu.RData'))

#opening data
#rm(df_els_stu_allobs)
load(file = file.path(output_data_dir, 'els_stu.RData'))
load(file = url('https://github.com/anyone-can-cook/educ152/raw/main/data/els/output_data/els_stu.RData'))
  
    
# create data frame that removes students that did not attend postsecondary education    
df_els_stu <- df_els_stu_allobs %>%
  # keep students who:
    # completed by, f1, f2, and f3 surveys [f3univ]
    # ever attended postsecondary education as of f3 [f3evratt]
    # received hs diploma with known date, or received GED [f3hsstat]
    # hs completion date known [f3hscpdr]
  filter(f3univ=='1111', f3evratt ==1, f3hsstat %in% c(1,2,3,6), !(f3hscpdr %in% c(-9,-3))) %>%
  # keep students whose enrollment in first postsecondary institution started same year of hs graduation or after hs graduation or year of first postsecondary institution unkown 
    # (i.e, drop students who enrolled in first postsecondary institution prior to high school graduation year) 
      #df_els_stu %>% filter(f3ps1start<f3hscpdr & f3ps1start !=-9) %>% count(f3ps1start)
      #df_els_stu %>% filter(f3ps1start<f3hscpdr & f3ps1start !=-9) %>% count(f3hscpdr)
  filter(f3ps1start>=f3hscpdr | f3ps1start ==-9) %>%
  # keep students whose first self-reported postsecondary institution is not a 4yr public or 4yr private non-profit or missing
  #filter(!(f3ps1sec %in% c(-9,1,2))) %>% 
  # keep students whose first postsecondary institution based on transcript data is not a 4yr public or 4yr private non-profit or missing
  #filter(!(f3tzps1sec %in% c(-9,1,2))) %>% 
  # keep students who reported attending postsecondary education and who are "transcript respondents" [f3tztranresp]
  filter(f3tztranresp==1) %>%
  # keep if f3tzanydegre is not missing []
  filter(f3tzanydegre!=-9) 

  rm(df_els_stu_allobs)    

# Create a dataframe df_els_stu_fac that has categorical variables as factor class variables rather than labelled class variables    
  df_els_stu_fac <- as_factor(df_els_stu, only_labelled = TRUE)
  # convert continuous variables we know we want numeric back to numeric
  for (v in c('bytxmstd','bytxrstd','bynels2m','bys34a','f1txmstd','f3stloanamt','f3stloanpay','f3ern2011','f3tzrectrans','f3tzreqtrans','f3tzschtotal','f3tzpostern','f3tzpostatt',
              'f3tzremtot','f3tzrempass','f3tzremengps','f3tzrementot','f3tzremmthps','f3tzremmttot','f3tzps1start','f3hscpdr')) {
    df_els_stu_fac[[v]] <- df_els_stu[[v]]  
  }


## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
