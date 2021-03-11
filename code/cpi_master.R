#Update monthly CPI
library(tidyverse)
library(openxlsx)
library(data.table)
library(blsAPI)
library(bea.R)
library(here)
library(zoo)

#year
current_year <- c(2021)

# run script to pull in CPI
source("code/cpi.R", echo = TRUE)

# run script to format data for excel
source("code/excel_data.R", echo = TRUE)

# map data to excel, to be saved on R drive
source("code/write_excel.R", echo = TRUE)