#Update monthly CPI
library(tidyverse)
library(openxlsx)
library(data.table)
library(blsR)
library(bea.R)
library(here)
library(zoo)
library(tsibble)
library(feasts)
library(seasonal)
library(stringr)
library(realtalk)

#BLS registration key needed for api version 2. register here: https://data.bls.gov/registrationEngine/
bls_key <- Sys.getenv("BLS_REG_KEY")

# set year object
current_year <- c(2025)

# run script to pull in CPI
#note: IF BLS HAS RELEASED CPI DATA FOR PAST YEAR, RUN THIS SCRIPT
source("code/cpi.R", echo = TRUE)

# run script to format data for excel
source("code/stata_excel_data.R", echo = TRUE)

# map data to excel, to be saved on R drive
source("code/write_excel.R", echo = TRUE)

