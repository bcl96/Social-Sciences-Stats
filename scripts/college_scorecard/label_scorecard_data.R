library(tidyverse)
library(readxl)
library(labelled)


# Directory paths
scorecard_dir <- file.path('.', 'data', 'college_scorecard')
data_dir <- file.path(scorecard_dir, 'output_data')
dict_dir <- file.path(scorecard_dir, 'documentation')


# Function to read in data dictionary
get_data_dict <- function(sheet_name) {
  dict_df <- read_excel(file.path(dict_dir, 'CollegeScorecardDataDictionary.xlsx'),
                                  sheet = sheet_name,
                                  col_types = 'text') %>% 
    select(`VARIABLE NAME`, `NAME OF DATA ELEMENT`, `VALUE`, `LABEL`)
  
  names(dict_df) <- c('var_name', 'var_label', 'val_name', 'val_label')
  dict_df$var_name <- str_to_lower(dict_df$var_name)
  
  prev_var <- dict_df[[1, 'var_name']]
  for (i in 1:nrow(dict_df)) {
    curr_var <- dict_df[[i, 'var_name']]
    
    if (is.na(curr_var)) {
      dict_df[[i, 'var_name']] <- prev_var
    } else {
      prev_var <- curr_var
    }
  }
  
  dict_df
}

# Read in data dictionary
df_institution_dict <- get_data_dict(sheet_name = 'institution_data_dictionary')
df_fieldofstudy_dict <- get_data_dict(sheet_name = 'FieldOfStudy_data_dictionary')
df_scorecard_dict <- union(df_institution_dict, df_fieldofstudy_dict)

# save(df_scorecard_dict, file = file.path(dict_dir, 'df_scorecard_dict.RData'))
# load(file = file.path(dict_dir, 'df_scorecard_dict.RData'))


# Function to label dataframe
label_df <- function(data_df, dict_df) {
  
  # Filter dict_df for only variables contained in data_df
  d <- dict_df %>% filter(var_name %in% names(data_df))

  for (i in 1:nrow(d)) {
    rn <- d[[i, 'var_name']]
    rl <- d[[i, 'var_label']]
    ln <- d[[i, 'val_name']]
    ll <- d[[i, 'val_label']]
    
    # Label variable
    if (!is.na(rl)) {
      var_label(data_df[[rn]]) <- rl
    }
    
    # Label value
    if (!is.na(ln)) {
      if (is.numeric(data_df[[rn]])) {
        ln <- as.numeric(ln)
      }
      
      val_label(data_df[[rn]], ln) <- ll
    }
  }
  
  data_df
}


# Label dataframe
load(file.path(data_dir, 'df_debt_earn_panel.RData'))

df_debt_earn_panel_labelled <- label_df(df_debt_earn_panel, df_scorecard_dict)
var_label(df_debt_earn_panel_labelled)
val_labels(df_debt_earn_panel_labelled)

save(df_debt_earn_panel_labelled, file = file.path(data_dir, 'df_debt_earn_panel_labelled.RData'))

df_debt_earn_panel_labelled %>% glimpse()