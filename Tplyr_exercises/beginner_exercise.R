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

## Load all required packages ----

library(admiral)
library(dplyr)
library(haven)
library(Tplyr)

## Setup data for the exercise ----

# Read in the input data from Github using haven
advs <- admiral::advs

# create ADSL 
adsl <- admiral::adsl %>% 
  select(STUDYID, USUBJID, ARM)

# merge the ADSL vars to ADVS
advs <- left_join(advs, adsl) %>% 
  filter(VSTEST == "Temperature") %>% 
  ungroup() %>% 
  rename(VISITN = VISITNUM)

## Create the initial Tplyr table ----
t <- tplyr_table(advs, ARM)
t

# Add population information from ADSL
t <- t %>% 
  set_pop_data(adsl) %>% 
  set_pop_treat_var(ARM)
t

# Add in a layer to summarize descriptive statistics of AVAL by Visit - but follow defaults
t1 <- t %>% 
  add_layer(
    group_desc(AVAL, by = vars(VISIT, VSTEST))
  )
t1

# Calculate the results
t1 %>%
  build() %>% 
  arrange(ord_layer_1, ord_layer_2, ord_layer_3)

## Now, change the statistics we're presenting ----
# Create the initial Tplyr table
t <- tplyr_table(advs, ARM) %>% 
  set_pop_data(adsl) %>% 
  set_pop_treat_var(ARM) %>% 
  add_layer(
    group_desc(AVAL, by = vars(VISIT, VSTEST)) %>% 
      set_format_strings(
        'mean' = f_str('xx.x', mean, empty="NA")
      )
  )

dat <- t %>% 
  build() %>% 
  arrange(ord_layer_1, ord_layer_2, ord_layer_3)
dat

# Now let's add in column headers
dat %>% 
  select(starts_with('row'), starts_with('var1')) %>% 
  add_column_headers(paste0(
    "Visit | Test | | Placebo (N=**Placebo**) | Xanomeline High Dose (N=**Xanomeline High Dose**)",
    "| Xanomeline Low Dose (N=**Xanomeline Low Dose**)"
  ), header_n = header_n(t))

## Match the final rtables example ----
t <- tplyr_table(advs, ARM) %>% 
  set_pop_data(adsl) %>% 
  set_pop_treat_var(ARM) %>% 
  add_layer(
    group_desc(AVAL, by = vars(VISIT, VSTEST)) %>% 
      set_format_strings(
        'n' = f_str('xx', n, empty="NA"),
        'Mean (sd)' = f_str('xx.xx (x.xx)', mean, sd, empty="NA"),
        'IQR' = f_str('x.xx', iqr, empty="NA"),
        'min - max' = f_str('xx.xx - xx.xx', min, max, empty='NA')
      )
  )

dat <- t %>% 
  build() %>% 
  arrange(ord_layer_1, ord_layer_2, ord_layer_3) %>%  
  select(starts_with('row'), starts_with('var1')) %>% 
  add_column_headers(paste0(
    "Visit | Test | | Placebo (N=**Placebo**) | Xanomeline High Dose (N=**Xanomeline High Dose**)",
    "| Xanomeline Low Dose (N=**Xanomeline Low Dose**)"
  ), header_n = header_n(t))
dat