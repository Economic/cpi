#Update monthly CPI
library(tidyverse)
library(data.table)
library(blsAPI)
library(here)

cpi_codes <- c("CUSR0000SA0",
               "CUUR0000SA0",
               "CUSR0000SA0L1E",
               "CUUR0000SA0L1E")
current_year <- 2019

payload1 <- list('seriesid'=cpi_codes, 
                 'startyear'='2000', 
                 'endyear'='2019',
                 'registrationkey'=Sys.getenv("BLS_REG_KEY"))
df1 <- blsAPI(payload1, api_version = 2, return_data_frame = TRUE)

#monthly cpi includes CPI U (SA, NSA) and CPI U CORE (SA, NSA)

#add cpiurs from bls excel file. 
#  calculate months that don't yet exist (only update once per year) apply change from CPI
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

write_csv(cpi_monthly, here("output/cpi_monthly.csv"))

cpi_annual <- cpi_monthly %>% 
  filter(year != current_year) %>% 
  group_by(year) %>% 
  summarise(cpi_u = mean(cpi_u_nsa),
            cpi_u_core = mean(cpi_u_core_nsa))

  
