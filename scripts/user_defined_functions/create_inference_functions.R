################################################################################
##
## [ PROJ ] < Create user defined functions to aid teaching fundamentals of statistical inference # >
## [ FILE ] < create_inference_functions.R >
## [ AUTH ] < Crystal Han / cyouh95 >
## [ INIT ] < 4/13/2021 >
##
################################################################################

## ---------------------------
## libraries
## ---------------------------

library(tidyverse)
library(labelled)
library(patchwork)


## ---------------------------
## directory paths
## ---------------------------

## ---------------------------
## Create data for applying functions to
## ---------------------------

if (FALSE) {

# IPEDS data

  # Load ipeds dataset from course website url
  load(file = url('https://github.com/anyone-can-cook/educ152/raw/main/data/ipeds/output_data/panel_data.RData'))
  
  # Create ipeds data frame with fewer variables/observations
  df_ipeds_pop <- panel_data %>%
    # keep data from fall 2019
    filter(year == 2019) %>%
    # which universities to keep:
      # 2015 carnegie classification: keep research universities (15,16,17) and master's universities (18,19,20)
    filter(c15basic %in% c(15,16,17,18,19,20)) %>%
    # which variables to keep
    select(instnm,unitid,opeid6,opeid,control,c15basic,stabbr,city,zip,locale,obereg, # basic institutional characteristics
           tuition6,fee6,tuition7,fee7, # avg tuition and fees for full-time grad, in-state and out-of-state
           isprof3,ispfee3,osprof3,ospfee3, # avg tuition and fees for MD, in-state and out-of-state
           isprof9,ispfee9,osprof9,ospfee9, # avg tuition and fees for Law, in-state and out-of-state
           chg4ay3,chg7ay3,chg8ay3) %>% # [undergraduate] books+supplies; off-campus (not with family) room and board; off-campus (not with family) other expenses
    # rename variables; syntax <new_name> = <old_name>
    rename(region = obereg, # revion
           tuit_grad_res = tuition6, fee_grad_res = fee6, tuit_grad_nres = tuition7, fee_grad_nres = fee7, # grad
           tuit_md_res = isprof3, fee_md_res = ispfee3, tuit_md_nres = osprof3, fee_md_nres = ospfee3, # md
           tuit_law_res = isprof9, fee_law_res = ispfee9, tuit_law_nres = osprof9, fee_law_nres = ospfee9, # law
           books_supplies = chg4ay3, roomboard_off = chg7ay3, oth_expense_off = chg8ay3) %>% # [undergraduate] expenses
    # create measures of tuition+fees
    mutate(
      tuitfee_grad_res = tuit_grad_res + fee_grad_res, # graduate, state resident
      tuitfee_grad_nres = tuit_grad_nres + fee_grad_nres, # graduate, non-resident
      tuitfee_md_res = tuit_md_res + fee_md_res, # MD, state resident
      tuitfee_md_nres = tuit_md_nres + fee_md_nres, # MD, non-resident
      tuitfee_law_res = tuit_law_res + fee_law_res, # Law, state resident
      tuitfee_law_nres = tuit_law_nres + fee_law_nres) %>% # Law, non-resident  
    # create measures of cost-of-attendance (COA) as the sum of tuition, fees, book, living expenses
    mutate(
      coa_grad_res = tuit_grad_res + fee_grad_res + books_supplies + roomboard_off + oth_expense_off, # graduate, state resident
      coa_grad_nres = tuit_grad_nres + fee_grad_nres + books_supplies + roomboard_off + oth_expense_off, # graduate, non-resident
      coa_md_res = tuit_md_res + fee_md_res + books_supplies + roomboard_off + oth_expense_off, # MD, state resident
      coa_md_nres = tuit_md_nres + fee_md_nres + books_supplies + roomboard_off + oth_expense_off, # MD, non-resident
      coa_law_res = tuit_law_res + fee_law_res + books_supplies + roomboard_off + oth_expense_off, # Law, state resident
      coa_law_nres = tuit_law_nres + fee_law_nres + books_supplies + roomboard_off + oth_expense_off) %>% # Law, non-resident    
    # keep only observations that have non-missing values for the variable coa_grad_res
      # this does cause us to lose some interesting universities, but doing this will eliminate some needless complications with respect to learning core concepts about statistical inference
    filter(!is.na(coa_grad_res))
  
  # Add variable labels to the tuit+fees variables and coa variables
    # tuition + fees variables
      var_label(df_ipeds_pop[['tuitfee_grad_res']]) <- 'graduate, full-time, resident; avg tuition + required fees'
      var_label(df_ipeds_pop[['tuitfee_grad_nres']]) <- 'graduate, full-time, non-resident; avg tuition + required fees'
      var_label(df_ipeds_pop[['tuitfee_md_res']]) <- 'MD, full-time, state resident; avg tuition + required fees'
      var_label(df_ipeds_pop[['tuitfee_md_nres']]) <- 'MD, full-time, non-resident; avg tuition + required fees'
      var_label(df_ipeds_pop[['tuitfee_law_res']]) <- 'Law, full-time, state resident; avg tuition + required fees'
      var_label(df_ipeds_pop[['tuitfee_law_nres']]) <- 'Law, full-time, non-resident; avg tuition + required fees'
      
    # COA variables
      var_label(df_ipeds_pop[['coa_grad_res']]) <- 'graduate, full-time, state resident COA; == tuition + fees + (ug) books/supplies + (ug) off-campus room and board + (ug) off-campus other expenses'
      var_label(df_ipeds_pop[['coa_grad_nres']]) <- 'graduate, full-time, non-resident COA; == tuition + fees + (ug) books/supplies + (ug) off-campus room and board + (ug) off-campus other expenses'
      var_label(df_ipeds_pop[['coa_md_res']]) <- 'MD, full-time, state resident COA; == tuition + fees + (ug) books/supplies + (ug) off-campus room and board + (ug) off-campus other expenses'
      var_label(df_ipeds_pop[['coa_md_nres']]) <- 'MD, full-time, non-resident COA; == tuition + fees + (ug) books/supplies + (ug) off-campus room and board + (ug) off-campus other expenses'
      var_label(df_ipeds_pop[['coa_law_res']]) <- 'Law, full-time, state resident COA; == tuition + fees + (ug) books/supplies + (ug) off-campus room and board + (ug) off-campus other expenses'
      var_label(df_ipeds_pop[['coa_law_nres']]) <- 'Law, full-time, non-resident COA; == tuition + fees + (ug) books/supplies + (ug) off-campus room and board + (ug) off-campus other expenses'
  
  df_ipeds_pop %>% glimpse()



# Create data frame of generated variables, with each variable meant to represent the entire population

  num_obs <- 10000
  
  # Generate normal distribution w/ custom mean and sd
  set.seed(124)
  norm_dist <- rnorm(n = num_obs, mean = 50, sd = 5)
  
  # Generate right-skewed distribution
  set.seed(124)
  rskew_dist <- rbeta(n = num_obs, shape1 = 2, shape2 = 5)
  
  # Generate left-skewed distribution
  set.seed(124)
  lskew_dist <- rbeta(n = num_obs, shape1 = 5, shape2 = 2)
  
  # Generate standard normal distribution (default is mean = 0 and sd = 1)
  set.seed(124)
  stdnorm_dist <- rnorm(n = num_obs, mean = 0, sd = 1)  # equivalent to rnorm(10)
  
  # Create dataframe
  df_generated_pop <- data.frame(norm_dist, rskew_dist, lskew_dist, stdnorm_dist)
  
  # drop individual objects associated with each variable
  rm(norm_dist,rskew_dist,lskew_dist,stdnorm_dist)
  rm(num_obs)



# Create sample versions of generated population data frame and IPEDS population data frame


  # create sample version of our generated data
    set.seed(124) # set seed so that everyone ends up with the same random sample
    
    df_generated_sample <- df_generated_pop %>% sample_n(size = 200)
    df_generated_sample %>% glimpse()
  
  
  # create sample version of our ipeds data
  
    set.seed(124) # set seed so that everyone ends up with the same random sample
    
    df_ipeds_sample <- df_ipeds_pop %>% sample_n(size = 200) 

}

##########
# # Function to get sampling distribution (default: 1000 samples of size 200)
##########
    
get_sampling_distribution <- function(data_vec, num_samples = 1000, sample_size = 200) {
  sample_means <- vector(mode = 'numeric', num_samples)

  for (i in 1:length(sample_means)) {
    samp <- sample(data_vec, sample_size)
    sample_means[[i]] <- mean(samp, na.rm = T)
  }

  sample_means
}

# example function calls

  #function call on its own (creates a vector of length = sample_size where each element is a sample mean)
  #get_sampling_distribution(data_vec = df_ipeds_pop$tuitfee_grad_res, num_samples = 1000, sample_size = 200) %>% str()
    
##########
# Create function to generate plots of variable distributions
##########

plot_distribution <- function(data_vec1, data_vec2 = NULL, data_df = NULL, data_var = NULL, group_var = NULL, group_cat = NULL, pop_labels = NULL, show_group_hist = F, sampling_dist = F, plot_title = '') {
  
  two_pop <- !is.null(group_var) || !is.null(data_vec2)
  two_dist <- two_pop && !sampling_dist
  
  # Prep dataframe
  if (!is.null(data_df)) {
    data_df[[data_var]] <- unclass(data_df[[data_var]])  # unclass haven_labelled
    if (two_pop) {
      data_df[[group_var]] <- unclass(data_df[[group_var]])
    }
    
    data_df <- data_df %>% filter(!is.na(get(data_var)))  # remove NA rows
    
    # If group_cat not provided, use 2 values from group_var
    if (two_pop && is.null(group_cat)) {
      group_cat <- sort(unique(na.omit(data_df[[group_var]])))[1:2]
    }
    
    # Create population vector(s)
    if (!two_pop) {  # single population
      data_vec1 <- data_df[[data_var]]
    } else {  # two populations
      data_vec1 <- (data_df %>% filter(get(group_var) == group_cat[[1]]))[[data_var]]
      data_vec2 <- (data_df %>% filter(get(group_var) == group_cat[[2]]))[[data_var]]
    }
  }

  # Get sampling distribution
  if (sampling_dist) {
    if (!two_pop) {  # single population
      data_vec1 <- get_sampling_distribution(data_vec1)
    } else {  # two populations
      data_vec1_samp <- get_sampling_distribution(data_vec1)
      data_vec2_samp <- get_sampling_distribution(data_vec2)
      
      data_vec1 <- data_vec1_samp - data_vec2_samp
    }
  }
  
  # Legend text
  legend_text <- c(paste('Mean:', round(mean(data_vec1), 2),
                         '\nStd Dev:', round(sd(data_vec1), 2)),
                   paste('Median:', round(median(data_vec1), 2)))
  
  if (two_dist) {
    legend_text <- c(legend_text, 
                     paste('Mean:', round(mean(data_vec2), 2),
                           '\nStd Dev:', round(sd(data_vec2), 2)),
                     paste('Median:', round(median(data_vec2), 2)))
  }
  
  if (!is.null(pop_labels)) {
    pop1 <- pop_labels[[1]]
    pop2 <- pop_labels[[2]]
  } else if (!is.null(group_var)) {
    pop1 <- str_c(group_var, '=', group_cat[[1]])
    pop2 <- str_c(group_var, '=', group_cat[[2]])
  } else {
    pop1 <- 'Pop1'
    pop2 <- 'Pop2'
  }
  
  # Create statistics dataframe
  if (!two_dist) {
    lines_vec <- c('dotted')
    stats_vec <- c(mean(data_vec1), median(data_vec1))
    legend_title <- 'Statistics'
    
    if (two_pop && sampling_dist) {
      legend_title <- str_c('Statistics\n(', pop1, ' - ', pop2, ')')
    }
  } else {
    lines_vec <- c('dotted', 'dotdash')
    stats_vec <- c(mean(data_vec1), median(data_vec1), mean(data_vec2), median(data_vec2))
    legend_title <- str_c('Statistics\n(', pop1, ' vs. ', pop2, ')')
  }
  
  stats_df <- data.frame(
    pop = rep(lines_vec, each = 2),
    stat = rep(c('blue', 'red'), times = if_else(two_dist, 2, 1)),
    val = stats_vec
  )
  stats_df$pop <- factor(stats_df$pop, levels = c('dotted', 'dotdash'))
  
  # Plot distribution(s)
  p <- ggplot() +
    ggtitle(plot_title) + xlab('') + ylab('') +
    geom_density(aes(x = data_vec1), alpha = 0.8)
  
  if (!two_dist || show_group_hist) {  # show histogram only if 1 pop or show_group_hist is TRUE
    p <- p +
      geom_histogram(aes(x = data_vec1, y = ..density..), alpha = 0.4, position = 'identity')
  }
  
  if (two_dist) {
    p <- p +
      geom_density(aes(x = data_vec2), alpha = 0.8)
    
    if (show_group_hist) {  # show histogram only if show_group_hist is TRUE
      p <- p +
        geom_histogram(aes(x = data_vec2, y = ..density..), alpha = 0.4, position = 'identity', fill = 'wheat4')
    }
  }
  
  p <- p +
    geom_vline(data = stats_df,
               aes(xintercept = val, color = interaction(stat, pop), linetype = interaction(stat, pop)),
               size = 0.6, alpha = 0.8) +
    scale_color_manual(name = legend_title,
                       labels = legend_text,
                       values = as.character(stats_df$stat)) +
    scale_linetype_manual(name = legend_title,
                          labels = legend_text,
                          values = as.character(stats_df$pop)) +
    theme(plot.title = element_text(size = 10, face = 'bold', hjust = 0.5),
          legend.title = element_text(size = 9, face = 'bold'),
          legend.text = element_text(size = 8)) +
    guides(col = guide_legend(ncol = if_else(two_dist, 2, 1)))
  
  p
}

#### example function calls
   
  #SINGLE POPULATION
  
    #plot_distribution(df_ipeds_pop$tuitfee_grad_res)

    # IPEDS data: tuitfee_grad_res
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res')
    
  # TWO POPULATIONS
  
    # IPEDS data: tuitfee_grad_res by control (default: use first 2 categorical values in group_var)
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', group_var = 'control')
    
    # IPEDS data: tuitfee_grad_res by control, shade histogram
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', group_var = 'control',show_group_hist = T)
    
    # IPEDS data: tuitfee_grad_res by control, custom order
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', group_var = 'control',group_cat = c(2, 1))
    
    # IPEDS data: tuitfee_grad_res by control, custom categories
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', group_var = 'control',group_cat = c(2, 3))
    
    # Alternatively, prepare 2 populations first to pass in
    #pop1 <- (df_ipeds_pop %>% filter(unclass(control) == 1))$tuitfee_grad_res
    #pop2 <- (df_ipeds_pop %>% filter(unclass(control) == 2))$tuitfee_grad_res
    
    #plot_distribution(pop1, pop2)
  
  # Custom labels
    #plot_distribution(pop1, pop2, pop_labels = c('Public', 'Private not-for-profit'))

    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', group_var = 'control',group_cat = c(1, 2), pop_labels = c('Public', 'Private not-for-profit'))

  # PLOT SAMPLING DISTRIBUTION, SINGLE POPULATION
  
    # IPEDS data: tuitfee_grad_res
    #plot_distribution(df_ipeds_pop$tuitfee_grad_res, sampling_dist = T)
    
    # IPEDS data: tuitfee_grad_res
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', sampling_dist = T) # sampling_dist = T runs the get_sampling_distribution function and plots the sampling distribution
    
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', sampling_dist = F) # sampling_dist = F plots underlying variable  
  
  
  # PLOT SAMPLING DISTRIBUTION, TWO POPULATIONS
    # IPEDS data: tuitfee_grad_res by control (control=1 minus control=2)
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', group_var = 'control',sampling_dist = T, pop_labels = c('Public', 'Private'))
  
    # IPEDS data: tuitfee_grad_res by control (control=2 minus control=1)
    #plot_distribution(data_df = df_ipeds_pop, data_var = 'tuitfee_grad_res', group_var = 'control',group_cat = c(2, 1), sampling_dist = T, pop_labels = c('Private', 'Public'))



  #plot population; one sample; sampling distribution
  #plot_distribution(df_ipeds_pop$tuitfee_grad_res, plot_title = 'Population distribution') +
  #plot_distribution(df_ipeds_sample$tuitfee_grad_res, plot_title = 'Single sample distribution') +
  #plot_distribution(get_sampling_distribution(df_ipeds_pop$tuitfee_grad_res),plot_title = 'Sampling distribution') +
  #plot_layout(ncol = 1)
    
##########
# Write Function to generate sampling distribution (with t-test value) assuming null hypothesis is correct
##########


# Function to generate t-distribution plot
plot_t_distribution <- function(data_vec1, data_vec2 = NULL, data_df = NULL, data_var = NULL, group_var = NULL, group_cat = NULL, mu = 0, alpha = 0.05, alternative = 'two.sided', plot_title = '', shade_rejection = T, shade_pval = T, stacked = F, beta_y = NULL, beta_x = NULL, beta_x_cat = 1) {
  
  two_pop <- !is.null(group_var) || !is.null(data_vec2)
  
  # Prep dataframe
  if (!is.null(data_df) && is.null(beta_y)) {
    data_df[[data_var]] <- unclass(data_df[[data_var]])  # unclass haven_labelled
    if (two_pop) {
      data_df[[group_var]] <- unclass(data_df[[group_var]])
    }
    
    data_df <- data_df %>% filter(!is.na(get(data_var)))  # remove NA rows
    
    # If group_cat not provided, use 2 values from group_var
    if (two_pop && is.null(group_cat)) {
      group_cat <- sort(unique(na.omit(data_df[[group_var]])))[1:2]
    }
    
    # Create samples
    if (!two_pop) {  # single sample
      data_vec1 <- data_df[[data_var]]
    } else {  # two samples
      data_vec1 <- (data_df %>% filter(get(group_var) == group_cat[[1]]))[[data_var]]
      data_vec2 <- (data_df %>% filter(get(group_var) == group_cat[[2]]))[[data_var]]
    }
  }
  
  # Calculate stats
  if (!is.null(beta_y)) {  # beta testing
    mod <- summary(lm(formula = get(beta_y) ~ get(beta_x), data = data_df))
    
    idx <- beta_x_cat + 1
    
    deg_freedom <- mod$df[[2]]
    std_err <- mod$coefficients[[idx, 'Std. Error']]
    t <- mod$coefficients[[idx, 't value']]
  } else if (!two_pop) {  # single sample
    data_vec1 <- na.omit(data_vec1)
    
    # Calculate t-statistics
    sample_size <- length(data_vec1)
    deg_freedom <- sample_size - 1
    xbar <- mean(data_vec1)
    s <- sd(data_vec1)
    
    std_err <- s / sqrt(sample_size)
    t <- (xbar - mu) / std_err
  } else {  # two samples
    data_vec1 <- na.omit(data_vec1)
    data_vec2 <- na.omit(data_vec2)
    
    # Calculate t-statistics
    xbar1 <- mean(data_vec1)
    xbar2 <- mean(data_vec2)
    s1 <- sd(data_vec1)
    s2 <- sd(data_vec2)
    n1 <- length(data_vec1)
    n2 <- length(data_vec2)
    
    deg_freedom <- (s1**2/n1 + s2**2/n2)**2 / ((s1**2/n1)**2/(n1-1) + (s2**2/n2)**2/(n2-1))
    std_err <- sqrt(s1**2/n1 + s2**2/n2)
    t <- (xbar1 - xbar2) / std_err
  }
  
  # Calculate critical value and p-value
  if (alternative == 'less') {  # left-tailed
    cv_lower <- qt(p = alpha, df = deg_freedom, lower.tail = T)
    cv_legend <- round(cv_lower, 2)
    cv_legend2 <- round(cv_lower * std_err + mu, 2)
    pval <- round(pt(q = t, df = deg_freedom, lower.tail = T), 4)
  } else if (alternative == 'greater') {  # right-tailed
    cv_upper <- qt(p = alpha, df = deg_freedom, lower.tail = F)
    cv_legend <- round(cv_upper, 2)
    cv_legend2 <- round(cv_upper * std_err + mu, 2)
    pval <- round(pt(q = t, df = deg_freedom, lower.tail = F), 4)
  } else {  # two-tailed
    cv_lower <- qt(p = alpha / 2, df = deg_freedom, lower.tail = T)
    cv_upper <- qt(p = alpha / 2, df = deg_freedom, lower.tail = F)
    cv_legend <- str_c('\u00B1', round(cv_upper, 2))
    cv_legend2 <- str_c(round(cv_lower * std_err + mu, 2), ' & ', round(cv_upper * std_err + mu, 2))
    pval_half <- round(pt(q = t, df = deg_freedom, lower.tail = t < 0), 4)
    pval <- str_c(pval_half, ' + ', pval_half, ' = ', 2 * pval_half)
  }
  
  # Plot t-distribution
  p <- ggplot(data.frame(x = -c(-4, 4)), aes(x)) +
    ggtitle(plot_title) + xlab('') + ylab('') +
    stat_function(fun = dt, args = list(df = deg_freedom), xlim = c(-4, 4))
  
  # Shade rejection region using critical value
  if (alternative != 'greater') {
    p <- p + geom_vline(aes(xintercept = cv_lower, color = 'cval'),
                        linetype = 'dotted', size = 0.8, alpha = 0.8)
    
    if (shade_rejection) {
      p <- p + stat_function(fun = dt, args = list(df = deg_freedom),
                             xlim = c(-4, cv_lower),
                             geom = 'area', alpha = 0.3, fill = 'red')
    }
    
    if (shade_pval) {
      p <- p + stat_function(fun = dt, args = list(df = deg_freedom),
                             xlim = c(-4, if_else(alternative == 'two.sided', -abs(t), t)),
                             geom = 'area', alpha = 0.3, fill = 'blue')
    }
  }
  if (alternative != 'less') {
    p <- p + geom_vline(aes(xintercept = cv_upper, color = 'cval'),
                        linetype = 'dotted', size = 0.8, alpha = 0.8)
    
    if (shade_rejection) {
      p <- p + stat_function(fun = dt, args = list(df = deg_freedom),
                             xlim = c(cv_upper, 4),
                             geom = 'area', alpha = 0.3, fill = 'red')
    }
    
    if (shade_pval) {
      p <- p + stat_function(fun = dt, args = list(df = deg_freedom),
                             xlim = c(if_else(alternative == 'two.sided', abs(t), t), 4),
                             geom = 'area', alpha = 0.3, fill = 'blue')
    }
  }
  
  # Legend text
  legend_text <- c('t-statistics / p-value', 'critical value / alpha')
  
  if (stacked) {
    legend_text <- c(str_c('t-statistics: ', round(t, 2),
                           '\n(p-value: ', str_extract(pval, '[\\d.-]+$'), ')'),
                     str_c('Critical value: ', cv_legend,
                           '\n(alpha: ', round(alpha, 2), ')'))
  }
  
  stats_text <- c(str_c('t-statistics: ', round(t, 2)),
                  str_c('SE: ', round(std_err, 2)),
                  str_c('p-val: ', pval),
                  str_c('Critical value: ', cv_legend),
                  str_c('alpha: ', round(alpha, 2)))
  
  if (!stacked) {
    p <- p +
      annotate('text', size = 9*5/14, x = 4.84, y = 0.14, hjust = 0,
               label = 'bold(Statistics)', parse = T) +
      annotate('text', size = 8*5/14, x = 4.89, y = 0:4 * -0.015 + 0.12, hjust = 0,
               label = stats_text)
  }
  
  # Label plot
  p <- p +
    geom_vline(aes(xintercept = t, color = 'tstat'),
               linetype = 'dotted', size = 0.8, alpha = 0.8) +
    scale_x_continuous(sec.axis = sec_axis(trans = ~ . * std_err + mu)) +
    scale_color_manual(name = if_else(stacked, 'Statistics', 'Legend'),
                       breaks = c('tstat', 'cval'),
                       labels = legend_text,
                       values = c(tstat = 'blue', cval = 'red')) +
    theme(plot.title = element_text(size = 10, face = 'bold', hjust = 0.5),
          plot.margin = unit(c(5.5, if_else(stacked, 5.5, 30), 5.5, 5.5), 'pt'),
          legend.title = element_text(size = 9, face = 'bold'),
          legend.text = element_text(size = 8)) +
    coord_cartesian(xlim = c(-4, 4),
                    clip = 'off')
  
  p
}

### EXAMPLE FUNCTION CALLS

  # BETA TESTING

    # summary(lm(formula = debt_all_stgp_eval_mean ~ coa_grad_res, data = df_socialwork))
    # plot_t_distribution(beta_y = 'debt_all_stgp_eval_mean', beta_x = 'coa_grad_res', data_df = df_socialwork)
  
  # SINGLE POPULATION
  
    # H0: population mean of coa_grad_res is $29,000
    # Ha: population mean of coa_grad_res is NOT $29,000 (two-sided test)
    # Verdict: Fail to reject H0
    #t.test(df_ipeds_sample$coa_grad_res, mu = 29000)
    #plot_t_distribution(df_ipeds_sample$coa_grad_res, mu = 29000)
    
    # H0: population mean of coa_grad_res is $32,000
    # Ha: population mean of coa_grad_res is NOT $32,000 (two-sided test)
    # Verdict: Reject H0
    #t.test(df_ipeds_sample$coa_grad_res, mu = 32000)
    #plot_t_distribution(data_df = df_ipeds_sample, data_var = 'coa_grad_res', mu = 32000)
    
    # H0: population mean of coa_grad_res is $33,000
    # Ha: population mean of coa_grad_res is LESS THAN $33,000 (left-sided test)
    # Verdict: Reject H0
    #t.test(df_ipeds_sample$coa_grad_res, mu = 33000, alternative = 'less')
    #plot_t_distribution(df_ipeds_sample$coa_grad_res, mu = 33000, alternative = 'less')
    
    # H0: population mean of coa_grad_res is $31,000
    # Ha: population mean of coa_grad_res is GREATER THAN $31,000 (right-sided test)
    # Verdict: Fail to reject H0
    #t.test(df_ipeds_sample$coa_grad_res, mu = 31000, alternative = 'greater')
    #plot_t_distribution(df_ipeds_sample$coa_grad_res, mu = 31000, alternative = 'greater')  
  
  
  # TWO POPULATIONS  
  
    # H0: population mean of tuitfee_grad_res is equal for control=1 and control=2
    # Ha: population means are NOT equal
    # Verdict: Reject H0
    #t.test(formula = tuitfee_grad_res ~ control, data = df_ipeds_sample, subset = unclass(control) %in% c(1, 2))
    #t.test(formula = tuitfee_grad_res ~ control, data = df_ipeds_sample %>% filter(control %in% c(1,2)))
    # Here, the t-statistics line is off the grid
    #plot_t_distribution(data_df = df_ipeds_sample, data_var = 'tuitfee_grad_res',group_var = 'control', group_cat = c(1, 2))
    
    # Alternatively, prepare 2 samples first to pass in
    #sample1 <- (df_ipeds_sample %>% filter(unclass(control) == 1))$tuitfee_grad_res
    #sample2 <- (df_ipeds_sample %>% filter(unclass(control) == 2))$tuitfee_grad_res
    
    #t.test(sample1, sample2)
    #plot_t_distribution(sample1, sample2)
    
    # compare locale = tuitfee_grad_nres between public and private
    #plot_t_distribution(data_df = df_ipeds_sample, data_var = 'coa_grad_nres',group_var = 'control', group_cat = c(1, 2))
    
    # compare locale = city-large (11) to suburb-large (21)
    #plot_t_distribution(data_df = df_ipeds_sample, data_var = 'roomboard_off',group_var = 'locale', group_cat = c(11, 21))
  
  
# see some chicken scratch on different ways to test whether two means differ
  
  # tuitfee_grad_res at public vs. private
  
  #df_ipeds_sample %>% count(control)
  #df_ipeds_sample %>% filter(control %in% c(1,2)) %>% group_by(control) %>% summarize(
  #    n = n(),
  #    n_nonmiss = sum(!is.na(tuitfee_grad_res)),
  #    mean = mean(tuitfee_grad_res, na.rm = TRUE),
  #    sd = sd(tuitfee_grad_res, na.rm = TRUE)
  #    )

  # calculate t by hand
    # point estimate [priv - pub]
    #18822 - 10227
    # se
    #sqrt(11987^2/97 + 3839^2/91)
    
    # t stat
    #(18822 - 10227)/sqrt(11987^2/97 + 3839^2/91) # = 6.704
    
  # calculate using t-test function
    
    # create two separate vectors and then run t.test
    #tuitfee_grad_pub <- df_ipeds_sample$tuitfee_grad_res[df_ipeds_sample$control==1]
    #tuitfee_grad_pub %>% str()
    
    #tuitfee_grad_priv <- df_ipeds_sample$tuitfee_grad_res[df_ipeds_sample$control==2]
    #tuitfee_grad_priv %>% str()
    
    #run t.test
    #t.test(x= tuitfee_grad_priv, y = tuitfee_grad_pub, mu = 0)
    
    # use  formula class
    #t.test(formula = tuitfee_grad_res ~ control, mu = 0, data = df_ipeds_sample, subset = control != 3)
    #t.test(formula = tuitfee_grad_res ~ control, mu = 0, data = df_ipeds_sample %>% filter(control !=3))
    

    
## -----------------------------------------------------------------------------
## END SCRIPT
## -----------------------------------------------------------------------------
