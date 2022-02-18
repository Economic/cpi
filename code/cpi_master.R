#Update monthly CPI
library(tidyverse)
library(openxlsx)
library(data.table)
library(blsAPI)
library(bea.R)
library(here)
library(zoo)
library(tsibble)
library(feasts)
library(seasonal)
library(stringr)

#year
current_year <- c(2022)

# run script to pull in CPI
#note: IF BLS HAS NOT RELEASE CPI DATA FOR THE PAST YEAR, RUN THIS SCRIPT
source("code/cpi_alt.R", echo = TRUE)

# run script to pull in CPI
#note: IF BLS HAS RELEASED CPI DATA FOR PAST YEAR, RUN THIS SCRIPT
#("code/cpi.R", echo = TRUE)

# run script to format data for excel
source("code/excel_data.R", echo = TRUE)

# map data to excel, to be saved on R drive
source("code/write_excel.R", echo = TRUE)
