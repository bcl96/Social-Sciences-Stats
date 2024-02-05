---
title: "EDUC 152, Course Brainstorm"
author: Ozan Jaquette
date: 
urlcolor: blue
output: 
  html_document:
    toc: true
    toc_depth: 3
    toc_float: true # toc_float option to float the table of contents to the left of the main document content. floating table of contents will always be visible even when the document is scrolled
      #collapsed: false # collapsed (defaults to TRUE) controls whether the TOC appears with only the top-level (e.g., H2) headers. If collapsed initially, the TOC is automatically expanded inline when necessary
      #smooth_scroll: true # smooth_scroll (defaults to TRUE) controls whether page scrolls are animated when TOC items are navigated to via mouse clicks
    number_sections: true
    fig_caption: true # ? this option doesn't seem to be working for figure inserted below outside of r code chunk    
    highlight: tango # Supported styles include "default", "tango", "pygments", "kate", "monochrome", "espresso", "zenburn", and "haddock" (specify null to prevent syntax    
    theme: default # theme specifies the Bootstrap theme to use for the page. Valid themes include default, cerulean, journal, flatly, readable, spacelab, united, cosmo, lumen, paper, sandstone, simplex, and yeti.
    df_print: tibble #options: default, tibble, paged
    keep_md: true # may be helpful for storing on github
    
---

Link to this html file:

- [https://rucla-ed.github.io/educ152/educ152_outline.html](https://rucla-ed.github.io/educ152/educ152_outline.html)

# Across sections of EDUC 152

## Constant across sections

- Course will focus on multivariate regression
- Course will have a final project that requires students to apply regression analysis to answer a research question

## Variation across sections

Course quality will benefit from faculty being able to tailor the course towards their disciplinary and methodological orientation. Instructor of record will have discretion over the following:

- Approach to introducing regression
  - some sections may introduce regression from the perspective of program evaluation/causal inference 
  - disciplinary orientation of the course may differ depending on instructor (e.g., psychology, economics)
- Requirements for the final project
- Required textbook and readings
- course website and communication
  - e.g., CCLE vs. different course management software

As a rough estimate, 70-80% of course content will be the same across sections

# Spring 2021 section, Jaquette

## Course description

This course introduces students to applied linear regression analysis with a focus on program evaluation.  Program evaluation is the main methodological strategy used to assess the impact of programs, policies, and interventions. The primary purpose of regression analysis in program evaluation research is to assess the causal effect of one intervention  (the independent variable of interest) on an educational outcome (the dependent variable) in observational settings where random assignment to the independent variable of interest is not possible. The course will focus on learning regression with a continuous dependent variable, one independent variable of interest, and control variables to evaluate the effect of some program, policy, and/or intervention. We will devote substantial time to interpreting and visualizing regression output, as well as cover measures of model fit, multicollinearity, and non-linear relationships. [ADD SENTENCE ABOUT FINAL PROJECT]

## Why emphasize causal inference?

I've taught introduction to regression many times, both as a graduate student TA and a primary instructor. I came to the conclusion that students become better researchers when they learn regression from a causal rather than a correlational perspective.

Holding aside prediction for the movement, researchers usually use regression to:

- Make causal statements about the relationship between $X$ and $Y$ *OR*
- Make statements about correlational relationships, that is conditional correlations between one or more $X$ variables and outcome, $Y$

Both applications of regression  -- causal and exploratory -- are important. Establishing causal relationships is usually more difficult, requiring careful consideration of assumptions and a modeling strategy entirely focused on estimating the causal relationship between one particular independent variable of intrest and the outcome. As experience researchers, we know when we are conducting causal vs. correlational analyses. However, students learing regression often view all relationships estimated in a regression model as causal ones.  Therefore, I believe that teaching students regression with an emphasis on the goal of causal inference prepares students to do high-quality causal research and exploratory research. This approach has the added benefit of preparing students for more advanced work in causal inference (e.g., experimental design, quasi-experimental methods)





The narrow focus of causal analyses (one X and one Y) improves the craft of scholarship in student final projects. Good empirical research tends to be focused rather than being substantively interested in the relationship between an outcome and two dozen other variables. During the course, we will do close reads of several high-quality empirical journal articles. For their final paper, students will write the introduction/framing, literature review, and the methodology all around this particular X-Y relationship. This level of analytic focus enables students to write high-quality, engaging sections that practice some of the strategies students learn from reading published pieces. Over the last decade, many student papers from my introduction to regression courses later became published in peer-reviewed journals.

## Course structure

How we will use our time:

- Lecture will focus on introducing statistics concepts and applying them in _R_
  - Application in _R_ will be intergrated throughout lecture rather than at the end or in a separate lab section
  - Students given html lectures, .Rmd files, _R_ code, data prior to lecture. So they can run code in _R_ as they work through lecture.
- Group work and (occasionally) solo work asking students to use course concepts/skills accomplish a practical research task
- Discussion (small group and class-wide) of empirical research we read

Online vs. face-to-face

- Assuming online instruction for Spring 2021 section, I will likely record brief video lectures discusing the most important/difficult concepts in the lecture html/.Rmd files
- Students will be asked to watch video and work through lecture prior to class
- Synchronous class time will be shortened. 
  - Will include Q&A discussion about course content and empirical research we read.
  - The majority of time will be spent on some practical challenge done in groups

## Assessments/homework

__Homework__

Course will have weekly homework assignments.

Homework will generally include three types of questions:

- Questions about theory, concepts
- Questions asking students to do stuff in R
- Questions asking students to make progress on ther final project
  
This is an applied regression course that also takes learning the theory/concepts seriously. Therefore, homework assignments will ask students to apply course concepts to real data using _R_, with an emphasis on developing competence in substantive tasks common in research analyst positions (e.g., conducting regression analyses, creating publication-ready tables, interpeting results)

__Other assessments__

Beyond weekly homework, the major course assessment is the final project, which they will develop throughout the quarter and will be due during finals week.

Given the final project, the course will not have a mid-term or final exam.

An alternative to a final project (e.g., in first iteration of course), would be 3-4 problem sets throughout the quarter. These problem sets would -- for the most part -- replace weekly houmework and would be the primay assessment throughout the course. Problem sets will differ from weekly problem sets in that they are designed to be challenging, more substantive, and a deeper dive into applying the analytic tools we are learning.

## Final project

Final project alternatives I considered

- Each group of 2-3 students chooses their own research question, working with instructor on developing the question and finding feasible data sources
- The entire class does the same broad research project, we identify dataset(s) to study this topic; students work in groups of 2-3 to choose their specific research question, and analyze the research question
- 3-4 substantive challenging problem sets over the course of the quarter instead of a final research project

Overview of final research project

- The entire class does the same broad research project, we identify dataset(s) to study this topic; students work in groups of 2-3 to choose their specific research question, and analyze the research question

- The entire class votes on which broad topic for the final research project (e.g., effect of bilingual education programs, effect of student race on school disciplinary punishments)
    - First, Students will list research topics they are interested in
    - Next, We will identify which research topics can be studied using publicly available data
    - Then we vote
- Then students complete project on this topic in groups of two or three
- Instructor will acquire relevant datasets; during lecture/activities, we will use these datasets
- final product
    - answers a causal question about effect of $X$ on $Y$
    - contains the following sections [minimum]
      - introduction
      - literature review
      - methods (including data, sample, variables)
      - preliminary results
    - considers construct validity, internal and external validity concerns
    - final project written as a .Rmd file
- In most weeks, part of their homework assignments will be related to final project
    - e.g., choose specific research question

Potential timeline for final project, by week

1. Introduce final project
    - homework assigned:
      - what topic do you want to study (examing a causal relationship)?
      - optional: any data sources you think are relevant    
1. Students form groups of 3 for final project
    - homework assigned:
1. Ozan introduce potential topics and data sources for final project
    - homework assigned:
      - student groups vote on final project topic (a couple days before next class)
1. Discuss chosen final project topic and data sources
    - discuss potential specific research questions groups may choose
    - introduce potential datasets (using R)
    - homework assigned:
      - come up w/ research questions
      - identify data sources and variables
1. Dveloping research questions, construct validity, internal and external validity concerns
    - homework assigned:
      - revise research question and data sources based on feedback from instructor
1. Choosing analysis sample
1. Choosing variables to represent concepts
1. ....      
      
      
Paper due during finals week


## Tentative course topics and schedule

Warnings: this is simultaneously over-detailed and a bit hap-hazardly organized. I was trying to make sure I didn't miss things but also not put too much in a single week.

Note: In most weeks, lecture/group work will include learning and applying new skills in $R$

1. Introduction
    - syllabus
    - Discussion of causal vs. correlational relationships
    - Introduce final project
      - same broad topic for entire class (class votes on broad topic)
      - do in groups of 3 (groups can decide on specific resarch question)
    - Doing stuff in R
      - introduce relevant programming concepts
1. Introduction to causal inference: Rubin's Causal Model and why experiments work
    - [*Note: I do causal inference in week 2 because learning these concepts early helps students develop better research questions for their final projects*]
    - counterfacturals and Rubin's Causal Model
    - cross sectional vs. longitudinal research designs
    - random assignment experiments as creating comparison group that represents the counterfactual
    - causal inference in the absence of experiments
      - quasi experimental designs (isolate exogenous variation in X)
      - correlational designs that have purpose of estimating correlational relationship
      - regressipon as an observational design to estimate causal relationship
    - Doing stuff in R
      - introduce relevant programming concepts
1. Fundamentals of inference I
    - Brief review of of goal in inferential statistics
      - e.g., population parameters vs. point estimates; correlational vs. causal relationships
    - standard deviation
    - distributions, properties of distributions
      - e.g., normal, skewed; standard normal distribution; "empirical rule" for normal distributions
    - sampling distribution
    - standard error
    - central limit theorem
    - Doing stuff in R
      - introduce relevant programming concepts
      - group activity applying theoretical concepts to data using R functions
1. Fundamentals of inference II    
    - Hypothesis testing
      - stating null and alternative hypotheses
      - one sided vs. two-sided
      - e.g., estimate population mean $\mu$
    - Practice all steps of hypothesis testing [group activity?]
    - Doing stuff in R
      - introduce relevant programming concepts
      - group activity applying theoretical concepts to data using R functions
1. Introduction to bivariate regression
    - Covariance
    - Correlation
      - Scatterplots
      - slope; best fit line
    - Population linear regression model
      - Population regression coefficient
      - Population intercept
      - error term, residuals
    - main things we do in regression analysis
      - estimation, prediction, hypothesis testing
    - Estimation
      - Ordinary least squares estimator
      - OLS prediction line
    - Doing stuff in R
      - introduce relevant programming concepts
      - group activity applying theoretical concepts to data using R functions
1. Prediction and measures of model fit
    - Prediction, based on OLS prediction line
    - Measures of model fit
      - e.g., total sum of squares; explained sum of squares, sum of squared residuals; $R^2$; standard error of the regression
1. Hypothesis testing and confidence intervals for $\beta_1$
    - Interpretation of $\hat{\beta}_1$
      - when $X$ is a continuous variable
    - Hypothesis testing
      - Review steps in hypothesis testing about population regression coefficient $\beta_1$
        - mirrors steps in hypothesis testing about population mean $\mu$
      - Standard error of $\hat{\beta}_1$
      - Sampling distribution of $\hat{\beta}_1$
      - t-test
    - Confidence intervals about $\beta_1$
    - Doing stuff in R
      - lecture/group activity to introduce and practice relevant programming skills    
1. Categorical X variables and introduction to multivariate regression
    - Modeling categorical X variables 
      - e.g., variable $X$ has $c$ categories, represented by $c-1$ dichotomous indicators in regression equation and one "base category" omitted from regression
    - Interpretation of $\hat{\beta}_1$ when $X$ is categorical (w/ respect to reference)
    - Multivariate regression
      - Population multivariate regression model
      - Interpretation of $\hat{\beta}_k$ in multivariate regression model
      - Hypothesis testing about $\beta_k$ (same as before)
    - Interpretation of regression results tables in journal articles
    - Doing stuff in R
      - lecture/group activity to introduce and practice relevant programming skills
1. OLS assumptions and omitted variable bias
    - Bias, efficiency
    - Importance of assumptions in statistical inference
    - OLS assumptions
      - OLS assumption 1, omitted variable bias (most attention)
      - heteroskedasticity, robust standard errors
    - Doing stuff in R      
      - e.g., creating publication-ready tables
1. Additional topics [likely won't have time to cover more than one of these]
    - creating descriptive results (tables and figures) for prior to regression results
    - linear probability model
    - non-linear regression models
      - polynomials (e.g., $X^2$)
      - interaction effects
        - categorical $X$ by categorical $Z$; continous $X$ by categorical $Z$; etc.
      - log models
        - linear-log; log-linear; log-log



