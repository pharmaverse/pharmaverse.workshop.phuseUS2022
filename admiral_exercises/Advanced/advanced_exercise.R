# -----------------------------------------------------------------------------------
# Hands-on Exercise: Advanced
# (Best for those with basic R knowledge and ADaM experience)
#
# See "ExerciseSheet_advanced.docx" for all exercise questions, and if you get stuck ask for help from one of our facilitators or consult "SolutionSheet_advanced.docx"
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

# Use admiral functions to create the required baseline variables
