#Update monthly CPI
library(tidyverse)
library(data.table)
library(blsAPI)
library(here)

cpi_codes <- c("CUSR0000SA0",
               "CUUR0000SA0",
               "CUSR0000SA0L1E",
               "CUUR0000SA0L1E")

payload1 <- list('seriesid'=cpi_codes, 
                 'startyear'='2000', 
                 'endyear'='2019',
                 'registrationkey'=Sys.getenv("BLS_REG_KEY"))
df1 <- blsAPI(payload1, api_version = 2, return_data_frame = TRUE)

cpi_monthly <- df1 %>% 
  mutate(month = as.numeric(substr(period,2,3)),
         value = as.numeric(value),
         year = as.numeric(year)) %>% 
  select(seriesID, year, month, value) %>% 
  pivot_wider(id_cols = c(year, month), 
              names_from = seriesID,
              values_from = value) %>% 
  rename(cpi_u = CUSR0000SA0,
         cpi_u_nsa = CUUR0000SA0,
         cpi_u_core = CUSR0000SA0L1E,
         cpi_u_core_nsa = CUUR0000SA0L1E)
  
  
  
  




#figure out how to parse CPI-U-RS data from https://www.bls.gov/cpi/research-series/home.htm

#may not be necessary to download all of the data. 
system(paste0('wget -N --progress=bar:force --header="Accept-Encoding: gzip" ',"https://download.bls.gov/pub/time.series/cu/cu.series", " -P data/"))
system(paste0('wget -N --progress=bar:force --header="Accept-Encoding: gzip" ',"https://download.bls.gov/pub/time.series/cu/cu.data.0.Current", " -P data/"))

cu_series <- fread("data/cu.series")
cu_data <- fread("data/cu.data.0.Current")
