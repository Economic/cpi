#create objects ####
#bls codes
cpi_codes <- c("CUSR0000SA0",
               "CUUR0000SA0",
               "CUSR0000SA0L1E",
               "CUUR0000SA0L1E",
               "CUSR0000SAM",
               "CUUR0000SAM",
               "SUUR0000SA0")

#BLS API payloads
payload1 <- list('seriesid'=cpi_codes, 'startyear'='2020', 'endyear'=current_year,'registrationkey'=Sys.getenv("BLS_REG_KEY"),'annualaverage'=TRUE)
payload2 <- list('seriesid'=cpi_codes, 'startyear'='2000', 'endyear'='2019','registrationkey'=Sys.getenv("BLS_REG_KEY"),'annualaverage'=TRUE)
payload3 <- list('seriesid'=cpi_codes, 'startyear'='1980', 'endyear'='1999','registrationkey'=Sys.getenv("BLS_REG_KEY"),'annualaverage'=TRUE)
payload4 <- list('seriesid'=cpi_codes, 'startyear'='1960', 'endyear'='1979','registrationkey'=Sys.getenv("BLS_REG_KEY"),'annualaverage'=TRUE) 
payload5 <- list('seriesid'=cpi_codes, 'startyear'='1947', 'endyear'='1959','registrationkey'=Sys.getenv("BLS_REG_KEY"),'annualaverage'=TRUE) 

#Get bls data ####
df1 <- blsAPI(payload1, api_version = 2, return_data_frame = TRUE)
df2 <- blsAPI(payload2, api_version = 2, return_data_frame = TRUE)
df3 <- blsAPI(payload3, api_version = 2, return_data_frame = TRUE)
df4 <- blsAPI(payload4, api_version = 2, return_data_frame = TRUE)
df5 <- blsAPI(payload5, api_version = 2, return_data_frame = TRUE)

#append all 20 year periods together
api_output <- bind_rows(df1, df2, df3, df4, df5)

#download cpiurs excel file files
system(paste0("wget -N https://www.bls.gov/cpi/research-series/r-cpi-u-rs-allitems.xlsx -P", here("data/")))
system(paste0("wget -N https://www.bls.gov/cpi/research-series/r-cpi-u-rs-alllessfe.xlsx -P", here("data/")))


#Clean data for output ####
#create crosswalk for months
month_xwalk <- tibble(month = c(1,2,3,4,5,6,7,8,9,10,11,12, NA), 
                      period = c("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC","AVG"))

## Get CPI-U-RS data Seasonally adjusted and not seasonally adjusted and get into long format.
#note: BLS no longer provide SA data, seasonally adjust by hand
cpiurs_mon <- read.xlsx(here("data/r-cpi-u-rs-allitems.xlsx"), sheet = "Table 1", startRow = 6) %>% 
  # tranform to long format
  pivot_longer(cols = -YEAR, names_to = "period", values_to = "cpiurs_nsa") %>% 
  # filter out for monthly data
  filter(period != "AVG") %>% 
  # create month date index
  mutate(month_date = yearmonth(paste(YEAR, period))) %>% 
  # convert table to tsibble for adjustment
  as_tsibble(index = month_date) %>% 
  # perform seasonal adjustment
  model(X_13ARIMA_SEATS(cpiurs_nsa)) %>% components() %>% 
  # extract data into logical variable names
  transmute(month_date, cpiurs_nsa = cpiurs_nsa, cpiurs = season_adjust) %>% 
  # expand month date back out for easier handling
  mutate(year = str_sub(month_date, start = 1, end = 4), 
         period = toupper(str_sub(month_date, start = 6))) %>% 
  # join numeric month for easier handling 
  left_join(month_xwalk, by = "period") %>% 
  # convert back to data frame
  as.data.frame() %>% 
  # select relevant variables
  select(year, period, month, cpiurs, cpiurs_nsa)

# import CPIURS data
cpiurs_ann <- read.xlsx(here("data/r-cpi-u-rs-allitems.xlsx"), sheet = "Table 1", startRow = 6) %>% 
  # pivot to long format
  pivot_longer(cols = -YEAR, names_to = "period", values_to = "cpiurs_nsa") %>% 
  # extract annual data
  filter(period == "AVG") %>% rename(year = YEAR)

#CPI-U-RS less food and energy (core)
cpiurs_core_mon <- read.xlsx(here("data/r-cpi-u-rs-alllessfe.xlsx"), sheet = "Table 1", startRow = 6) %>% 
  # tranform to long format
  pivot_longer(cols = -YEAR, names_to = "period", values_to = "cpiurs_core_nsa") %>% 
  # filter out for monthly data
  filter(period != "AVG") %>% 
  # create month date index
  mutate(month_date = yearmonth(paste(YEAR, period))) %>% 
  # convert table to tsibble for adjustment
  as_tsibble(index = month_date) %>% 
  # perform seasonal adjustment
  model(X_13ARIMA_SEATS(cpiurs_core_nsa)) %>% components() %>% 
  # extract data into logical variable names
  transmute(month_date, cpiurs_core_nsa = cpiurs_core_nsa, cpiurs_core = season_adjust) %>% 
  # expand month date back out for easier handling
  mutate(year = str_sub(month_date, start = 1, end = 4), 
         period = toupper(str_sub(month_date, start = 6))) %>% 
  # join numeric month for easier handling 
  left_join(month_xwalk, by = "period") %>% 
  # convert back to data frame
  as.data.frame() %>% 
  # select relevant variables
  select(year, period, month, cpiurs_core, cpiurs_core_nsa)

# import CPIURS data
cpiurs_core_ann <- read.xlsx(here("data/r-cpi-u-rs-alllessfe.xlsx"), sheet = "Table 1", startRow = 6) %>% 
  # tranform to long format
  pivot_longer(cols = -YEAR, names_to = "period", values_to = "cpiurs_core_nsa") %>% 
  # extract annual data
  filter(period == "AVG") %>% rename(year = YEAR)

#monthly data
cpiurs_tot_mon <- cpiurs_mon %>% 
  left_join(cpiurs_core_mon, by = c("year", "period", "month")) %>%
  select(year, month, cpiurs, cpiurs_nsa, cpiurs_core, cpiurs_core_nsa) %>% 
  mutate(year = as.numeric(year))

#annual data: use not seasonally adjusted annual averages provided in BLS spreadsheets
cpiurs_tot_ann <- cpiurs_ann %>% 
  left_join(cpiurs_core_ann, by = c("year", "period")) %>%
  select(year, cpiurs_nsa, cpiurs_core_nsa) %>% 
  rename(cpiurs = cpiurs_nsa,
         cpiurs_core = cpiurs_core_nsa) %>% 
  mutate(year = as.numeric(year))

# assign average cpiurs for past year as value
cpiurs_val <- cpiurs_tot_mon %>% 
  group_by(year) %>% summarize(mean(cpiurs_nsa, na.rm = TRUE)) %>% 
  filter(year == current_year - 1) %>% pull()

# assign average cpiurs core for past year as value
cpiurs_core_val <- cpiurs_tot_mon %>% 
  group_by(year) %>% summarize(mean(cpiurs_core_nsa, na.rm = TRUE)) %>% 
  filter(year == current_year - 1) %>% pull()

#monthly cpi includes CPI U (SA, NSA) and CPI U CORE (SA, NSA)
#  calculate months that don't yet exist (only update once per year) apply change from CPI
cpi_monthly <- api_output %>% 
  filter(period != "M13") %>% 
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
         cpi_u_core_nsa = CUUR0000SA0L1E,
         cpi_u_medcare = CUSR0000SAM,
         cpi_u_medcare_nsa = CUUR0000SAM) %>% 
  left_join(cpiurs_tot_mon, by = c("year", "month")) %>% 
  arrange(year, month)

write_csv(cpi_monthly, here("output/cpi_monthly.csv"))

cpi_quarterly <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date),
         quarter = as.yearqtr(date)) %>% 
  group_by(quarter) %>% 
  summarise(cpi_u = round(mean(cpi_u), 1),
            cpi_u_nsa = round(mean(cpi_u_nsa), 1),
            cpi_u_core = round(mean(cpi_u_core), 1),
            cpi_u_core_nsa = round(mean(cpi_u_core_nsa), 1),
            cpiurs = round(mean(cpiurs), 1),
            cpiurs_nsa = round(mean(cpiurs_nsa), 1),
            cpiurs_core = round(mean(cpiurs_core), 1),
            cpiurs_core_nsa = round(mean(cpiurs_core_nsa), 1),
            cpi_u_medcare = round(mean(cpi_u_medcare), 1),
            cpi_u_medcare_nsa = round(mean(cpi_u_medcare_nsa), 1))

cpi_annual <- api_output %>% 
  filter(period == "M13") %>%
  select(seriesID, year, value) %>% 
  filter(year != current_year) %>% 
  mutate(year = as.numeric(year),
         value = as.numeric(value)) %>% 
  pivot_wider(id_cols = year, 
              names_from = seriesID,
              values_from = value) %>% 
  rename(cpi_u = CUUR0000SA0,
         cpi_u_core = CUUR0000SA0L1E,
         cpi_u_medcare = CUUR0000SAM) %>% 
  select(-SUUR0000SA0) %>% 
  left_join(cpiurs_tot_ann, by = "year") %>% 
  mutate(cpiurs = ifelse(year == current_year - 1, cpiurs_val, cpiurs),
         cpiurs_core = ifelse(year == current_year - 1, cpiurs_core_val, cpiurs_core))

write_csv(cpi_annual, here("output/cpi_annual.csv"))
