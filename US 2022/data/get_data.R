library(admiral)
library(stringr)
library(haven)

advs_admiral <- admiral::advs
adsl_admiral <- admiral::adsl
adae_admiral <- admiral::adae

# Read in previous advs_temp to be used for Admiral portion of workshop
wrefdata  <- "ADD PATH HERE"
advs_temp <- read_xpt(str_c(wrefdata, "advs_temp.xpt", sep="/"))

# Write out v8 transport files
# The .xpt files will be written in v8 format which is currently unreadable by SAS
# To bring into SAS the datasets must currently be written in v5 format
writedir  <- "ADD PATH HERE"
write_xpt(adsl_admiral, str_c(writedir, "adsl_admiral.xpt", sep="/"), version=8)
write_xpt(advs_admiral, str_c(writedir, "advs_admiral.xpt", sep="/"), version=8)
write_xpt(adae_admiral, str_c(writedir, "adae_admiral.xpt", sep="/"), version=8)
write_xpt(advs_temp, str_c(writedir, "advs_temp.xpt", sep="/"), version=8)

# Read back in to test .xpt files are readable by R
# readdir <- "c:/R_Projects/admiral.phuse.workshop/US 2022/data/"
readdir <- "ADD PATH HERE"
advs_temp1 <- read_xpt(str_c(readdir, "advs_temp.xpt", sep="/"))
advs_1 <- read_xpt(str_c(readdir, "advs_admiral.xpt", sep="/"))
adsl_1 <- read_xpt(str_c(readdir, "adsl_admiral.xpt", sep="/"))
adae_1 <- read_xpt(str_c(readdir, "adae_admiral.xpt", sep="/"))
