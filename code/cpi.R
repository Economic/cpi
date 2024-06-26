#create objects ####
#bls codes
cpi_codes <- c("CUSR0000SA0",
               "CUUR0000SA0",
               "CUSR0000SA0L1E",
               "CUUR0000SA0L1E",
               "CUSR0000SAM",
               "CUUR0000SAM",
               "SUUR0000SA0",
               "CES0500000003")

#BLS API payloads
api_output <- get_n_series_table(series_ids = cpi_codes, start_year = 1947, end_year = current_year, api_key = bls_key, tidy = TRUE, annualaverage = TRUE)


#download cpiurs excel file files
system(paste0('wget -N -U "" https://www.bls.gov/cpi/research-series/r-cpi-u-rs-allitems.xlsx -P', here("data")))
system(paste0('wget -N -U "" https://www.bls.gov/cpi/research-series/r-cpi-u-rs-alllessfe.xlsx -P', here("data")))

#Clean data for output ####
#create crosswalk for months
month_xwalk <- tibble(month = c(1,2,3,4,5,6,7,8,9,10,11,12, NA), 
                      period = c("JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC","AVG"))

## Get CPI-U-RS data Seasonally adjusted and not seasonally adjusted and get into long format.
#note: BLS no longer provide SA data, seasonally adjust by hand
cpiurs_mon <- read.xlsx(here("data/r-cpi-u-rs-allitems.xlsx"), sheet = "All items", startRow = 6) %>% 
  # transform to long format
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
cpiurs_ann <- read.xlsx(here("data/r-cpi-u-rs-allitems.xlsx"), sheet = "All items", startRow = 6) %>% 
  # pivot to long format
  pivot_longer(cols = -YEAR, names_to = "period", values_to = "cpiurs_nsa") %>% 
  # extract annual data
  filter(period == "AVG") %>% rename(year = YEAR)

#CPI-U-RS less food and energy (core)
cpiurs_core_mon <- read.xlsx(here("data/r-cpi-u-rs-alllessfe.xlsx"), sheet = "All items less food and energy", startRow = 6) %>% 
  # transform to long format
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
cpiurs_core_ann <- read.xlsx(here("data/r-cpi-u-rs-alllessfe.xlsx"), sheet = "All items less food and energy", startRow = 6) %>% 
  # transform to long format
  pivot_longer(cols = -YEAR, names_to = "period", values_to = "cpiurs_core_nsa") %>% 
  # extract annual data
  filter(period == "AVG") %>% rename(year = YEAR)

#monthly data
cpiurs_tot_mon <- cpiurs_mon %>% 
  left_join(cpiurs_core_mon, by = c("year", "period", "month")) %>%
  mutate(year = as.numeric(year)) %>% 
  select(year, month, cpiurs, cpiurs_nsa, cpiurs_core, cpiurs_core_nsa)

#annual data: use not seasonally adjusted annual averages provided in BLS spreadsheets
cpiurs_tot_ann <- cpiurs_ann %>% 
  left_join(cpiurs_core_ann, by = c("year", "period")) %>%
  mutate(year = as.numeric(year)) %>% 
  select(year, cpiurs_nsa, cpiurs_core_nsa) %>% 
  rename(cpiurs = cpiurs_nsa,
         cpiurs_core = cpiurs_core_nsa)

#monthly cpi includes CPI U (SA, NSA) and CPI U CORE (SA, NSA)
#  calculate months that don't yet exist (only update once per year) apply change from CPI
cpi_monthly <- api_output %>% 
  # filter out annual data
  filter(month != 13) %>% 
  # merge in 
  left_join(cpiurs_tot_mon, by = c("year", "month")) %>% 
  rename(cpi_u = CUSR0000SA0,
         cpi_u_nsa = CUUR0000SA0,
         cpi_u_core = CUSR0000SA0L1E,
         cpi_u_core_nsa = CUUR0000SA0L1E,
         cpi_u_medcare = CUSR0000SAM,
         cpi_u_medcare_nsa = CUUR0000SAM) %>% 
  arrange(year, month)

# quarterly CPI
#note: quarterly aggregation of CPI monthly
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

# Annual CPI
#note: officially published BLS annual average + EPI estimate for current year
cpi_annual <- api_output %>% 
  filter(month == 13) %>%
  rename(cpi_u = CUUR0000SA0,
         cpi_u_core = CUUR0000SA0L1E,
         cpi_u_medcare = CUUR0000SAM) %>% 
  select(-SUUR0000SA0) %>% 
  left_join(cpiurs_tot_ann, by = "year") %>% 
  # assign annual average as CPIURS/CPIURS core values in latest year
  mutate(cpiurs = case_when(is.na(cpiurs) & year == (current_year - 1) ~ (cpi_u/lag(cpi_u, 1) * lag(cpiurs, 1)),
                            TRUE ~ cpiurs),
         cpiurs_core = case_when(is.na(cpiurs_core) & year == (current_year - 1) ~ (cpi_u_core/lag(cpi_u_core) * lag(cpiurs_core, 1)),
                                 TRUE ~ cpiurs_core)) %>% 
  select((c(year, starts_with("cpi"))))