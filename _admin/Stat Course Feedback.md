Course Learning Outcomes

1. Learn how to describe data using summary statistics and graphs.  
2. Learn fundamental concepts of inferential statistics.  
3. Use R to investigate data, summarize and visualize data, and perform hypothesis tests  
4. Perform and interpret regression analysis with R and by hand.

- [ ] Discussion section guide  
- [ ] What portion is async, and what portion is sync?  
      - [ ] Pull out async materials that are more definitions  
      - [ ] Delete async language in syllabus  
- [ ] Include “notation guide” that lets students know how to read/pronounce notations/commands

## Lecture 1.1

Learning Goal: Understand what and how to access R and R Studio

* Course introduction (Who? What? Why?)  
* Examples of R usage  
* Directories and filepaths

- [ ] The learning goal should be updated  
      - [ ] what, how, and example use cases of R/RStudio  
      - [ ] Working directory  
- [ ] Include why this course is “for social sciences”?

- [ ] Include practice on downloading and accessing R/RStudio  
- [ ] Include practice of very basic codes to run in the beginning (ex. basic calculation?)

- [ ] Who’s the audience for these lectures? Is it a script? Is it an outline?  
      - [ ] Rmd line 205   
- [ ] R project link (Rmd line 283\)

## Lecture 1.2

Learning Goal: Understand what and how to access R and R Studio

* Tidyverse package  
* Dplyr package

- [ ] The learning goal should be updated– in this lecture, students not only access R/RStudio, but they get an understanding of some fundamental data management functions, objects, variable types, etc.  
- [ ] Will this all fit in a 1.5 hour lecture?

## Lecture 2.1 

Learning goal \- Apply basic Dplyr functions in R and produce graphs of continuous and categorical variables.

* Pipe %\>%  
  * str(), count()  
* Bar chart

- [x] Consider including a quick explanation on why we’re learning pipe in \#\#\#What are “pipes” section (ex. It helps us simplify, etc.)  
- [ ] This is the first time students are creating bar charts; I wonder if we need more scaffolding for this task.

## Lecture 2.2

Learning goal \- Apply basic Dplyr functions in R and produce graphs of continuous and categorical variables.

* Scatterplot, boxplot (ggplot)  
* Layers and aesthetics  
  * geom\_point()  
  * geom\_smooth()  
  * geom\_bar()  
  * geom\_col()  
  * Colors, themes  
* Statistical transformation  
* Position adjustment  
* Facets   
* Exporting 

- [ ] Ggplot cheatsheet- we can pull out these cheatsheets and create a central resources doc for easy access for students  
- [x] ~~“Speach” typo (line 227\)~~  
- [ ] Will this fit in a 1-hour lecture? What might we cut? (ex. Knowledge not needed for pset)  
      - [ ] Can probably cut 347-352 on jitter position for geom\_point  
- [ ] Pdf file of the 2.2 lecture is also too big (shows up as 31.8MB) github has limit for files or uploads smaller than 25KB

## Problem Set 1 (Weeks 1, 2\)

* File directory  
* Render to PDF  
* Data frames  
* Variable type/structure  
* Ordering data  
* Pipes  
* Scatterplot   
* Bar chart

- [x] Need a version without the answer keys

- [x] .qmd and pdf seem like different versions? Fixed and also updated 2 questions at the end\!

## Lecture 3.1 Descriptive Statistics

Learning goal: Identify descriptive statistics in order to describe individual variables.

* Understanding data  
  * Mean, median, percentiles; mode  
* IPEDS vs. College Scorecard (why use one over the other)  
  * Key terms and definitions  
  * Assumptions   
* IPEDS  
  * filter(), select(), rename(), mutate(), var\_label(), %\>%, glimpse(), norm\_dist, sample, p-value, critical value, t-distribution  
* Standard Deviation  
  * Variance, range, interquartile range

- [ ] The learning goal should be updated (suggested language below)  
      - [ ] Students will be able to use descriptive statistics to understand datasets  
      - [ ] Students will be able to evaluate datasets and determine which one is most appropriate for addressing a specific research question  
      - [ ] Students will be able to use basic statistical commands to measure standard deviation and central tendencies

- [ ] Do we need to show how to arrange the dataset in ascending order? (Rmd line 38\)  
- [ ] Typos: (line 520 “to getter a better response”)

## Lecture 3.2 Distributions

Learning goal: articulate the descriptors of normal distribution and skewness

* Distributions  
  * Frequency, central tendency, variability, normal, skewness  
  * hist(), plot(), boxplot()  
* Normal distribution  
  * Skewness  
  * Empirical rule & why is it important?  
  * Z-score  
* Standard normal distribution

- [ ] Skewness: switch the order (provide the examples first, then explain their characteristics)

## Lecture 4.1 Distributions

Learning goal: Apply understanding of central limit theorem and sampling distributions towards how to evaluate inferential statistics in R

* Central Limit Theorem  
  * What is it?  
  * Why is it important?  
* How do we know if the sample we collected is representative of the population?  
  * Sampling distribution & sample means  
  * Interactive link [https://onlinestatbook.com/stat\_sim/sampling\_dist/index.html](https://onlinestatbook.com/stat_sim/sampling_dist/index.html) 

- [ ] Typo? Line 335 “when a population is repeatedly sample’d’ “?  
- [ ] The interactive link (which is awesome\!) appears twice (line 335 & 392\)  
      - [ ] I wonder if it makes sense to just include it after we discuss sampling distribution more in depth (aka just leave it at line 392?)

## Lecture 4.2 Fundamentals of Inferential Statistics

Learning goal: Apply understanding of central limit theorem and sampling distributions towards how to evaluate inferential statistics in R

* Population parameters  
  * Number of cases, mean, standard deviation, variance, range  
* Sample statistics

- [ ] Bit short? Maybe we can add more examples and provide datasets for students to calculate their own population parameters and sample statistics?

## PSET 2 (Week 3, 4\)

Practice with descriptive statistics

* Create an R project  
* Render file  
* Load and investigate R data frame  
  * Sample statistics  
* Apply basic functions to better understand distributions  
  * Mean, median, SD  
  * Variance, range  
  * Z-score

- [ ] Line 46 \- (typo?) if package “is” not yet installed, then “it” must “be” installed before you load?  
- [ ] Line 64 \- typo? “Also, define in your own words what ~~does~~ the median represent**s**”  
- [ ] Line 74 \- typo? “In general, what **does a** high SD mean compared to a low SD?  
- [ ] Line 81 \- typo? “Explain in your own words what ~~is~~ the Central Limite Theorem **is**.”

## Lecture 5.1 Inferential Statistics, single variable

Learning goal: Formulate hypothesis testing both by hand and with infer commands for a single population mean

* What is inferential statistics  
* Hypothesis testing about a single population mean (by hand)  
  * What and why of hypothesis testing  
  * Steps in hypothesis testing  
    * Hypothesis, assumptions, test statistic, p-value, alpha level  
  * Univariate & bivariate analysis

- [ ] There are a lot of definitions and examples in this lecture; there are opportunities to show the examples first and ask students to identify its characteristics (ex. This is an example of a hypothesis. What do you notice?)  
- [ ] The pdf doesn’t render past page 17, so it doesn’t contain the section on alpha level & conclusion

- [ ] Line 525 \- typo “the population mean cost of attendance for ~~for~~ full-time…”  
- [ ] Line 528 \- typo “the population mean ~~mean~~ cost of attendance for ~~for~~ full-time…”  
- [ ] Line 690 \- “let Pr(obs\>t) **be** the probability…”

## Lecture 5.2 Inferential Statistics, single variable

Learning goal: Formulate hypothesis testing both by hand and with infer commands for a single population mean

* Assumptions  
* Hypothesis test example

- [ ] This feels very short, while 5.1 feels a bit long. Perhaps we can move some content from 5.1 to 5.2? Also, we can come up with another example that students can try in class if time.

- [ ] Line 102 \-  “we just care about the absolute value of te t-statistic., which…” (delete period before the comma)

## Lecture 6.1 Comparing Two Groups

Learning goal: evaluate two groups with hypothesis testing and comparing population means

* Example of two sample t-test (pizza)

- [ ] The content can feel short, but I can see it being an interactive lecture where students try out the testing on their own instead of the instructor just walking through the example

## Lecture 6.2 Comparing Two Groups

Learning goal: evaluate two groups with hypothesis testing and comparing population means

* Fundamental concepts in causal inference  
  * Descriptive vs. causal research questions  
* Hypothesis testing comparing population means of two groups  
  * Example: class size on reading test score

- [ ] Interactive component idea: what are examples of causal research question in your area of interest?

## PSET 3 (Week 5, 6\)

* Conceptual understanding of hypothesis testing and components of t-test  
  * alternative hypothesis  
  * Calculate t-test value by hand and by function, explain  
* Conceptual understanding of hypothesis testing and components of p-value  
  * Comparing tow groups  
- [ ] Overview is the same as pset 2 – should be updated

## Lecture 7.1 Introduction to Bivariate Regression

Learning goal: Demonstrate estimation and prediction of bivariate regression analysis in R

* Bivariate regression  
  * Relationships (positive, negative, none)  
  * Strength   
* Scatterplot, covariance, correlation  
* Population linear regression model  
  * Linear regression  
  * Error term / Residual

- [ ] Students might need scaffolding on what a regression is before talking about bivariate regression  
      - [ ] What is a regression (definition) and why is it important?  
      - [ ] Can flip some of the order with the later regression section

- [ ] Line 79 \- The sentence within parentheses isn’t complete

## Lecture 7.2 Introduction to Bivariate Regression (cont)

Learning goal: Demonstrate estimation and prediction of bivariate regression analysis in R

* Running regression in R  
  * lm()  
  * summary()  
* Estimation, prediction, hypothesis testing  
  * Estimate, estimator, estimation

- [ ] Line 41 \- remove “?”  
- [ ] Line 143 \- at the very end “argumen**t**”  
- [ ] Line 259 \- typo? “We are how far off in total”

## Lecture 8.1 Bivariate Regression, Part II

Learning goal: apply understanding of bivariate regression to do hypothesis testing for continuous variables

* Research question  
* Model Fit  
  * R^2, the coefficient of determination  
  * Interpreting R^2  
  * Components of R^2 (TSS, ESS, SSR)  
  * Calculating R^2 by hand & in R  
* Standard Error of the Regression (SER)

- [ ] Line 20 & 258 \- “Standard Error ~~of the~~ of the Regression”

- [ ] Unable to render, it keeps telling me at line 33 that object ‘mod1’ not found. But I triple checked how the els was loaded into the .qmd file and it’s the same as week 7’s lecture, which work? (so the pdf file generated ends at line 33 basically)

## Lecture 8.2 Bivariate Regression, Hypothesis Testing

Learning goal: apply understanding of bivariate regression to do hypothesis testing for continuous variables

* Hypothesis testing  
* Regression with continuous variables  
  * Research question  
  * Correlational way vs. causal effects way  
* Hypothesis testing about B1  
* Factor Variables

- [ ] Line 135 \- “we our pretending” → “we are pretending”  
- [ ] Line 210 area, can’t get the plot\_t\_distribution() function to work. It’s a created function. So I made a different plot, does look a bit clunky to me though. Left code of plot\_t\_distribution in the code chunk in case someone can figure it out  
- [ ] Line 260 \- “we estimate that a test score increase *in* reading test score is…”  
- [ ] Line 282 links to the Attributes and Class lecture from R; is this helpful? Do we specify specific sections within the 82-page doc? Do we link to a video lecture instead?

## Lecture 9.1 Interpretation of Beta hat with Categorical Variables

Learning goal \- Acquire understanding of beta hat with categorical variables, confidence intervals, and assumptions. 

* Regression with categorical variables  
  * Factors  
  * Reference groups  
  * Interpretation of estimate on categorical X  
  * Hypothesis testing

- [ ] Lines 193-198, opportunities ask students to identify categorical variable in these questions

## Lecture 9.2 Confidence Intervals and Assumptions

Learning goal \- Acquire understanding of beta hat with categorical variables, confidence intervals, and assumptions. 

* Confidence intervals  
* OLS assumptions

- [ ] Line 196, we might consider creating a more up-to-date example

## PSET 4 (Week 7, 8, 9\)

* Bivariate Regression short answers  
* SER short answers  
* Regression  
  * Investigate  
  * Average cost  
  * Run regression & interpret findings  
* Confidence Interval  
  * Explain and calculate

- [ ] Overview is the same as pset 2 – should be updated  
- [ ] Line 241 \- “calculate ~~the~~ both the”

## Lecture 10.1 Introduction to Multivariate Regression

Learning goal \- Test multivariate regression and interpret findings to estimate causal effects. 

* Multivariate regression model  
* Interpretation  
  * Bias and efficiency/precision

- [ ] Do we want to introduce multivariate regression (a new concept) in the last week of the course? If we’re not including this in the final exam, maybe we can use this week for something else

## Lecture 10.2 Introduction to Multivariate Regression (Cont)

Learning goal \- Test multivariate regression and interpret findings to estimate causal effects. 

* Linear probability model  
* Using multiple regression to estimate causal effects  
* Conditional independence assumption  
* Omitted variable bias

## Final Exam

Course Learning Outcomes

1. Learn how to describe data using summary statistics and graphs.  
   1. Give students raw data and ask them to create a specific type of graph to summarize the data, along with brief interpretation of the graph  
2. Learn fundamental concepts of inferential statistics.  
   1. Present a scenario with a null and alternative hypothesis and ask students to conduct a hypothesis test using the provided data   
      1. Calculate test statistic, p-value, and interpret results  
3. Use R to investigate data, summarize and visualize data, and perform hypothesis tests  
   1. Interpreting outputs?  
4. Perform and interpret regression analysis with R and by hand.  
   1. Hand calculation, then calculate using R

- Reuse some of the questions from psets but with different datasets

DRAFT 1 (Take Home?, \~ 2 Hours)

- Intro  
- Create R Project, formatting, file path  
- Key term definitions (10)  
  * Fix format  
  * Reorder or cut? Short \-\> Long  
- Summary Statistics and Graphing   
  * Investigate dataframe (pull it up)  
  * Create a scatterplot  
- Conduct group hypothesis test  
  * Same dataset  
  * Null & alternative hypothesis  
  * Conduct it by hand first → calculate using t.test()  
  * What is the p-value? What can we conclude?

- [ ] Make notes for the instructor  
- [ ] Ask Patricia to test the Final  
      - [ ] Length of each lecture, where to cut?  
      - [ ] Would any content from Week 10 be appropriate to include in the final?