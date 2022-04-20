# -----------------------------------------------------------------------------------
# Hands-on Exercise: Beginner 
# (Best for those with limited or no prior R or TLG experience)
#  
# See "ExerciseSheet_beginner.docx" for all exercise questions, 
# and if you get stuck ask for help from one of our facilitators 
# or consult "SolutionSheet_beginner.docx"
# 
# This program is to be used as a starter template as you work through the exercises
# -----------------------------------------------------------------------------------

# Load all required packages

library(admiral)
library(dplyr)
library(lubridate)
library(stringr)
library(haven)
library(rtables)

# Read in the input data from Github using haven

advs_temp <- read_xpt(url("https://github.com/Roche-GSK/admiral.phuse.workshop/raw/main/Hands_on_Exercises/advs_temp.xpt"))

# create ADSL 
adsl <- advs %>% 
  select(STUDYID, USUBJID) %>% 
  group_by(STUDYID, USUBJID) %>% 
  slice(1) %>%
  mutate(ARM = factor(sample(c("ARM A","ARM B"), 1, rep = TRUE)))

# merge the ADSL vars to ADVS
advs <- left_join(advs, adsl) %>% 
  filter(VSTEST == "Temperature")


# create table layout
lyt <- basic_table()
lyt

# Add the column split
lyt <- basic_table() %>%
  split_cols_by("ARM")
lyt

# Add rows split
lyt <- basic_table() %>%
  split_cols_by("ARM") %>%
  split_rows_by("VSTEST") %>%
  split_rows_by("VISIT")

# Add analyses function
lyt <- basic_table() %>%
  split_cols_by("ARM") %>%
  split_rows_by("VSTEST") %>%
  split_rows_by("VISIT") %>%
  analyze(vars = "AVAL", afun = mean, format = "xx.x")
  
# Build the result output table
result <- build_table(lyt = lyt, df = advs)
result


#create the same results output by changing the source of the denominator
# and adding the column counts
lyt <- basic_table() %>%
  split_cols_by("ARM") %>%
  add_colcounts() %>%
  split_rows_by("VSTEST") %>%
  split_rows_by("VISIT") %>%
  analyze(vars = "AVAL", afun = mean, format = "xx.x")

result <- build_table(lyt = lyt, df = advs, alt_count_df = adsl)
result


#creates basic statistics s_function summary
s_summary <- function(x) {
  if (is.numeric(x)) {
    in_rows(
      "n" = rcell(sum(!is.na(x)), format = "xx"),
      "Mean (sd)" = rcell(c(mean(x, na.rm = TRUE), sd(x, na.rm = TRUE)), format = "xx.xx (xx.xx)"),
      "IQR" = rcell(IQR(x, na.rm = TRUE), format = "xx.xx"),
      "min - max" = rcell(range(x, na.rm = TRUE), format = "xx.xx - xx.xx")
    )
  } else if (is.factor(x)) {
    
    vs <- as.list(table(x))
    do.call(in_rows, lapply(vs, rcell, format = "xx"))
    
  } else (
    stop("type not supported")
  )
}

#use the above function in analyses

lyt <- basic_table() %>%
  split_cols_by("ARM") %>%
  add_colcounts() %>%
  split_rows_by("VSTEST") %>%
  split_rows_by("VISIT") %>%
  analyze(vars = "AVAL", afun = s_summary, format = "xx.x")

result <- build_table(lyt = lyt, df = advs, alf_count_df = adsl)
result
