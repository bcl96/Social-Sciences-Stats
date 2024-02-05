################################################################################
##
## [ PROJ ] < Script to download, read, and label ipeds data # >
## [ FILE ] < read_ipeds.R >
## [ AUTH ] < Ozan Jaquette / ozanj >
## [ INIT ] < 3/31/2021 >
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(labelled)

## ---------------------------
## directory paths
## ---------------------------

ipeds_dir <- file.path('.', 'data','ipeds')
  #ipeds_dir
  #list.files(path = ipeds_dir)

input_dir <- file.path(ipeds_dir,'input_data')
  #input_dir
  #list.files(path = input_dir)

csv_dir <- file.path(input_dir, 'csv_data')
  #csv_dir
  #list.files(path = csv_dir)
dict_dir <- file.path(input_dir, 'dictionaries')
  #dict_dir
  #list.files(path = dict_dir)
stata_dir <- file.path(input_dir, 'stata_files')
  #stata_dir
  #list.files(path = stata_dir)

output_dir <- file.path(ipeds_dir, 'output_data')

## -----------------------------------------------------------------------------
## function to download ipeds files
## -----------------------------------------------------------------------------

url <- 'https://nces.ed.gov/ipeds/datacenter/data/'



#download_file2 <- function(dir_name, file_prefix, file_year, file_suffix, file_type, file_extension) {
download_file <- function(file_type, file_prefix, file_year, file_suffix) {

  # create objects for which directory, file extension, etc. based on whether reading csv data, dictionrary, or stata do file
  if (file_type == 'csv') {
    dir_name <- csv_dir
    type_extension <- ''
    file_extension <- '.csv'
        
  } else if (file_type == 'dict') {
    dir_name <- dict_dir
    type_extension <- '_dict'
    file_extension <- '.xlsx'
    
  } else { # stata code
    dir_name <- stata_dir
    type_extension <- '_Stata'
    file_extension <- '.do'
    
  }
  
  # create objects for: file_name, data_url, data_zipfile, data_unzipped file
  file_name <- str_c(file_prefix,file_year,file_suffix)
    writeLines(str_c('file_name object = ',file_name))
  data_url <- str_c(url, file_name, type_extension, '.zip')
    writeLines(str_c('data_url object = ',data_url))
  data_zipfile <- file.path(dir_name, str_c(file_name, type_extension, '.zip'))
    writeLines(str_c('data_zipfile object = ',data_zipfile))
  data_unzipped <- file.path(dir_name, str_c(file_name, file_extension))
    writeLines(str_c('data_unzipped object = ',data_unzipped))
    
  # download and unzip files
  if (!file.exists(data_zipfile)) {
    writeLines(str_c('Downloading file: ', data_zipfile, ' & Unzipping file: ', data_unzipped))
    download.file(url = data_url, destfile = data_zipfile)
    unzip(zipfile = data_zipfile, exdir = dir_name)
  } else if (!file.exists(data_unzipped)) {
    writeLines(str_c('Unzipping file: ', data_unzipped))
    unzip(zipfile = data_zipfile, exdir = dir_name)
  } else {
    writeLines(str_c('Already have files: ', data_zipfile, ' & ', data_unzipped))
  }
  
}


# loop across file_type and year

file_types <- c('csv','dict','stata')

years <- c('2015','2016','2017','2018','2019')

# loop for data year
for (y in 1:length(years)) { 
  
  writeLines(str_c("\n y=", y, "; year=", years[[y]]))
  
  # loop for file_types c('csv','dict','stata')
  for (i in 1:length(file_types)) { 
    
    writeLines(str_c("\n i=", i, "; file_type=", file_types[[i]]))
  
    # institutional characteristics, flags
    download_file(file_type = file_types[[i]], file_prefix = 'flags', file_year = years[[y]], file_suffix = '')
      
    # institutional characteristics, hd
    download_file(file_type = file_types[[i]], file_prefix = 'hd', file_year = years[[y]], file_suffix = '')
    
    # Imstitutional characteristics, Educational offerings, organization, services and athletic associations Educational offerings, organization, services and athletic associations
    download_file(file_type = file_types[[i]], file_prefix = 'ic', file_year = years[[y]], file_suffix = '')
    
    # instituional characteristics, student charges for academic year programs
    download_file(file_type = file_types[[i]], file_prefix = 'ic', file_year = years[[y]], file_suffix = '_ay')
    
    
  }
}

## -----------------------------------------------------------------------------
## functions to label ipeds files
## -----------------------------------------------------------------------------

# Function to read in CSV data (default is use revised version if available)
csv_to_df <- function(dir_name, file_name, year, rv = TRUE) {
  if (rv && file.exists(file.path(dir_name, str_c(file_name, '_rv', '.csv')))) {
    file_name <- str_c(file_name, '_rv')
  }
  
  writeLines(file.path(dir_name, str_c(file_name, '.csv')))
  df <- read_csv(file = file.path(dir_name, str_c(file_name, '.csv')), na = c('.'))
  names(df) <- str_to_lower(names(df))
  
  df <- df %>% add_column(year = year, .before = 1)
  
  df
}

# Function to get labels from stata file
get_stata_labels <- function(dir_name, file_name) {
  stata <- readLines(file.path(dir_name, str_c(file_name, '.do')), encoding = 'latin1')
  stata_vars <- str_subset(stata, '^label variable')
  stata_vals <- str_subset(stata, '^\\*?label define')
  
  var_labels <- str_match(stata_vars, 'label variable (\\S+)\\s+"([^"]+)"')
  val_labels <- str_match(stata_vals, '(\\*)?label define label_(\\S+) (\\S+) "([^"]+)"')
  
  list(var_labels = as.data.frame(var_labels, stringsAsFactors = F), val_labels = as.data.frame(val_labels, stringsAsFactors = F))
}

# Function to add variable labels
add_var_labels <- function(df, var_labels) {
  for (i in 1:nrow(var_labels)) {
    n <- var_labels[[i, 2]]  # col name
    l <- var_labels[[i, 3]]  # col label
    
    var_label(df[[n]]) <- l  # add var label
  }
  
  df
}

# Function to add value labels
add_val_labels <- function(df, val_labels) {
  for (i in seq_len(nrow(val_labels))) {
    n <- val_labels[[i, 3]]  # col name
    v <- val_labels[[i, 4]]  # val name
    l <- val_labels[[i, 5]]  # val label
    
    if (is.na(n)) next
    
    if (is.na(val_labels[[i, 2]]) && !is.character(df[[n]])) {
      v <- as.numeric(v)
    }

    val_label(df[[n]], v) <- l  # add val label
  }
  
  df
}

# Function to append data from multiple years
get_panel_data <- function(years, file_prefix, file_suffix = '') {
  all_data <- vector(mode = 'list', length = length(years))
  all_var_labels <- vector(mode = 'list', length = length(years))
  all_val_labels <- vector(mode = 'list', length = length(years))
  
  for (y in 1:length(years)) { 
    # Read in CSV data
    file_name <- str_c(file_prefix, years[[y]], file_suffix)
    all_data[[y]] <- csv_to_df(csv_dir, file_name, years[[y]])
    
    # Read in stata file labels
    stata_labels <- get_stata_labels(stata_dir, file_name)
    all_var_labels[[y]] <- stata_labels$var_labels
    all_val_labels[[y]] <- stata_labels$val_labels
  }
  
  # https://stackoverflow.com/a/29419402/6373540
  combined_data <- dplyr::bind_rows(all_data)
  combined_var_labels <- dplyr::bind_rows(all_var_labels) %>% unique()
  combined_val_labels <- dplyr::bind_rows(all_val_labels) %>% unique()

  combined_data %>% add_var_labels(combined_var_labels) %>% add_val_labels(combined_val_labels)
}


# hd2015 <- get_panel_data(years = '2015', file_prefix = 'hd')
hd <- get_panel_data(years = years, file_prefix = 'hd')
var_label(hd)
val_labels(hd)

hd <- hd %>% add_column(opeid6 = str_sub(hd$opeid, start = 1, end = 6), .after = 'opeid')
var_label(hd[['opeid6']]) <- 'First 6 digits of OPEID'

save(hd, file = file.path(output_dir, 'hd_panel_data.RData'))

flags <- get_panel_data(years = years, file_prefix = 'flags')
var_label(flags)
val_labels(flags)
save(flags, file = file.path(output_dir, 'flags_panel_data.RData'))

ic <- get_panel_data(years = years, file_prefix = 'ic')
var_label(ic)
val_labels(ic)
save(ic, file = file.path(output_dir, 'ic_panel_data.RData'))

ic_ay <- get_panel_data(years = years, file_prefix = 'ic', file_suffix = '_ay')
var_label(ic_ay)
val_labels(ic_ay)
save(ic_ay, file = file.path(output_dir, 'ic_ay_panel_data.RData'))

panel_data <- hd %>%
  left_join(flags, by = c('year', 'unitid')) %>% 
  left_join(ic, by = c('year', 'unitid')) %>% 
  left_join(ic_ay, by = c('year', 'unitid'))
save(panel_data, file = file.path(output_dir, 'panel_data.RData'))
rm(panel_data)


load(file = file.path(output_dir, 'panel_data.RData'))
rm(panel_data)

load(file = url('https://github.com/anyone-can-cook/educ152/raw/main/data/ipeds/output_data/panel_data.RData'))

panel_data %>% glimpse()


#confirm one obs per unitid-year
panel_data %>% group_by(unitid,year) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)

panel_data %>% count(year)


  # load data from github
  
  
  

## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
