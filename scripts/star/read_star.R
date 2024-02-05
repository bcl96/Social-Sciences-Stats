################################################################################
##
## [ PROJ ] < Script to create dataset from Tennessee STAR data # >
## [ FILE ] < read_star.R >
## [ AUTH ] < Ozan Jaquette / ozanj >
## [ INIT ] < 4/14/2021 >
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(labelled)
library(AER)

# remove all objects
  rm(list = ls())

## ---------------------------
## directory paths
## ---------------------------

star_dir <- file.path('.', 'data','star')
  star_dir
  list.files(path = star_dir)



## -----------------------------------------------------------------------------
## load STAR data
## -----------------------------------------------------------------------------

data("STAR")
#df_star <- STAR
#rm(STAR)

#df_star %>% glimpse()




## reshape data from wide into long format
## 1. variables and their levels
nam <- c("star", "read", "math", "lunch", "school", "degree", "ladder",
  "experience", "tethnicity", "system", "schoolid")
lev <- c("k", "1", "2", "3")
## 2. reshaping
star <- reshape(STAR, idvar = "id", ids = row.names(STAR),
  times = lev, timevar = "grade", direction = "long",
  varying = lapply(nam, function(x) paste(x, lev, sep = "")))
## 3. improve variable names and type
names(star)[5:15] <- nam
star$id <- factor(star$id)
star$grade <- factor(star$grade, levels = lev, labels = c("kindergarten", "1st", "2nd", "3rd"))
rm(nam, lev)
rm(STAR)

#investigate data structure
  # one observation per id and grade

star %>% group_by(id,grade) %>% summarise(n_per_key=n()) %>% ungroup() %>% count(n_per_key)

# convert variables with class = factor to class = labelled

star %>% glimpse()


for(v in names(star)) {
  
  if (is.factor(star[[v]])==1) {
    star[[v]] <- to_labelled(star[[v]])
  }
}

star %>% glimpse()

# show value labels
star %>% val_labels()

# convert variables with class = labelled to class = factor
  # as_factor(star, only_labelled = TRUE)

df_star_panel <- star
rm(star)

# save file to disk
save(df_star_panel, file = file.path(star_dir, 'star_panel_data.RData'))

#opening data
rm(df_star_panel)

load(file = file.path(star_dir, 'star_panel_data.RData'))


load(file = url('https://github.com/anyone-can-cook/educ152/raw/main/data/star/star_panel_data.RData'))


## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
