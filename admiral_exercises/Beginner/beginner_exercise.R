# -----------------------------------------------------------------------------------
# Hands-on Exercise: Beginner
# (Best for those with limited or no prior R or ADaM experience)
#
# See "ExerciseSheet_beginner.docx" for all exercise questions, and if you get stuck ask for help from one of our facilitators or consult "SolutionSheet_beginner.docx"
#
# This program is to be used as a starter template as you work through the exercises
# -----------------------------------------------------------------------------------

# Load all required packages
library(admiral)
library(dplyr)
library(lubridate)
library(stringr)
library(haven)

# Read in the input data from Github using haven
advs_temp <- read_xpt(url("https://github.com/pharmaverse/pharmaverse.workshop.phuseUS2022/raw/main/data/advs_temp.xpt"))

# Run the following code to create the required baseline variables

advs <- advs_temp %>%

  # Calculate ABLFL
  derive_var_extreme_flag(
    by_vars = vars(STUDYID, USUBJID, PARAMCD),
    order = vars(ADT),
    new_var = ABLFL,
    mode = "last",
    filter = (!is.na(AVAL) & ADT <= TRTSDT)
  ) %>%

  # Calculate BASE
  derive_var_base(
    by_vars = vars(STUDYID, USUBJID, PARAMCD)
  ) %>%

  # Calculate CHG
  derive_var_chg() %>%

  # Sort the data frame
  arrange(USUBJID, PARAMCD, ADT)
