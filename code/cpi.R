#Update monthly CPI
library(tidyverse)
library(readxl)
library(data.table)
library(blsAPI)
library(here)

#create objects ####
#codes
cpi_codes <- c("CUSR0000SA0",
               "CUUR0000SA0",
               "CUSR0000SA0L1E",
               "CUUR0000SA0L1E")
#year
current_year <- 2019

#BLS API payloads
payload1 <- list('seriesid'=cpi_codes, 'startyear'='2000', 'endyear'='2019','registrationkey'=Sys.getenv("BLS_REG_KEY"))
payload2 <- list('seriesid'=cpi_codes, 'startyear'='1980', 'endyear'='1999','registrationkey'=Sys.getenv("BLS_REG_KEY"))
payload3 <- list('seriesid'=cpi_codes, 'startyear'='1960', 'endyear'='1979','registrationkey'=Sys.getenv("BLS_REG_KEY")) 
payload4 <- list('seriesid'=cpi_codes, 'startyear'='1947', 'endyear'='1959','registrationkey'=Sys.getenv("BLS_REG_KEY")) 

#Get bls data ####
df1 <- blsAPI(payload1, api_version = 2, return_data_frame = TRUE)
df2 <- blsAPI(payload2, api_version = 2, return_data_frame = TRUE)
df3 <- blsAPI(payload3, api_version = 2, return_data_frame = TRUE)
df4 <- blsAPI(payload4, api_version = 2, return_data_frame = TRUE)

#append all 20 year periods together
api_output <- bind_rows(df1, df2, df3, df4)

#download cpiurs excel file files
download.file("https://www.bls.gov/cpi/research-series/allitems.xlsx", here("data/allitems.xlsx"))
download.file("https://www.bls.gov/cpi/research-series/alllessfe.xlsx", here("data/alllessfe.xlsx"))


#Clean data for output ####
#create crosswalk for months
month_xwalk <- tibble(month = c(1,2,3,4,5,6,7,8,9,10,11,12, NA), 
                          period = c("JAN","FEB","MAR","APR","MAY","JUNE","JULY","AUG","SEP","OCT","NOV","DEC","AVG"))

#Get CPI-U-RS data Seasonally adjusted and not seasonally adjusted and get into long format.
cpiurs_nsa <- read_excel(here("data/allitems.xlsx"), sheet = "All Items_NSA", skip = 6) %>% 
  pivot_longer(cols = -YEAR, 
               names_to = "period", 
               values_to = "cpiurs_nsa")

cpiurs <- read_excel(here("data/allitems.xlsx"), sheet = "All Items_SA", skip = 6) %>% 
  pivot_longer(cols = -YEAR, 
               names_to = "period", 
               values_to = "cpiurs") %>% 
  left_join(month_xwalk, by = "period") %>% 
  left_join(cpiurs_nsa, by = c("YEAR", "period")) %>% 
  rename(year = YEAR)


#CPI-U-RS less food and energy (core)
cpiurs_core_nsa <- read_excel(here("data/alllessfe.xlsx"), sheet = "All Items Less_NSA", skip = 6) %>% 
  pivot_longer(cols = -YEAR, 
               names_to = "period", 
               values_to = "cpiurs_core_nsa")

cpiurs_core <- read_excel(here("data/alllessfe.xlsx"), sheet = "All Items Less_SA", skip = 6) %>% 
  pivot_longer(cols = -YEAR, 
               names_to = "period", 
               values_to = "cpiurs_core") %>% 
  left_join(month_xwalk, by = "period") %>% 
  left_join(cpiurs_core_nsa, by = c("YEAR", "period")) %>% 
  rename(year = YEAR)


#monthly data
cpiurs_mon <- cpiurs %>% 
  left_join(cpiurs_core, by = c("year", "period", "month")) %>%
  filter(period != "AVG",
         !is.na(cpiurs)) %>% 
  select(year, month ,cpiurs, cpiurs_nsa, cpiurs_core, cpiurs_core_nsa)

#annual data: use not seasonally adjusted annual averages provided in BLS spreadsheets
cpiurs_ann <- cpiurs %>% 
  left_join(cpiurs_core, by = c("year", "period", "month")) %>%
  filter(period == "AVG", 
         !is.na(cpiurs)) %>% 
  select(year, cpiurs_nsa, cpiurs_core_nsa) %>% 
  rename(cpiurs = cpiurs_nsa,
         cpiurs_core = cpiurs_core_nsa)



#monthly cpi includes CPI U (SA, NSA) and CPI U CORE (SA, NSA)
#  calculate months that don't yet exist (only update once per year) apply change from CPI
cpi_monthly <- api_output %>% 
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
         cpi_u_core_nsa = CUUR0000SA0L1E) %>% 
  left_join(cpiurs_mon, by = c("year", "month")) %>% 
  arrange(year, month)

write_csv(cpi_monthly, here("output/cpi_monthly.csv"))

cpi_annual <- cpi_monthly %>% 
  filter(year != current_year) %>% 
  group_by(year) %>% 
  summarise(cpi_u = round(mean(cpi_u_nsa),1),
            cpi_u_core = round(mean(cpi_u_core_nsa),1)) %>% 
  left_join(cpiurs_ann, by = "year")

write_csv(cpi_annual, here("output/cpi_annual.csv"))



