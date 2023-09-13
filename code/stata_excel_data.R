### CPI-U-X1 DATA ####
#note: cpi-u-x1 was experimental data that preceded cpi-u-rs, used to backcast cpi-u-rs to 1947
# import monthly data
cpi_u_x1_monthly <- read_csv(here("data/cpi_u_x1_monthly.csv")) %>% 
  mutate(date = as.Date(date))

# import annual data
cpi_u_x1_ann <- read_csv(here("data/cpi_u_x1_annual.csv"))

### WORKBOOK MONTHLY DATA ####
# monthly backcast
df_monthly_backward <- cpi_monthly %>% 
  # transform cpi monthly date
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  # rearrange variables
  select(date, year, month, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  # merge in CPIUX1 data for backcasting
  left_join(cpi_u_x1_monthly, by = "date") %>% 
  arrange(date) %>% 
  # calculate monthly growth rate
  mutate(cpi_u_x1_monthly_gr = cpi_u_x1_monthly/lead(cpi_u_x1_monthly, 1)) %>% 
  # restrict date to prior 1978
  filter(date <= "1977-12-01") %>%
  # rearrange by date for proper implementation of accumulate function
  arrange(desc(date)) %>% 
  # backcast cpiurs data (nsa)
  mutate(cpiurs_nsa = accumulate(cpi_u_x1_monthly_gr[2:n()], function(x, y) x*y, .init = cpiurs_nsa[1]),
         cpiurs = cpiurs_nsa*cpi_u/cpi_u_nsa) %>% 
  select(-cpi_u_x1_monthly, -cpi_u_x1_monthly_gr) %>% 
  filter(date < "1977-12-01") %>% 
  arrange(date)


# monthly forward projection
#note: BLS only releases CPIURS/CPIURS core data once a year, 
#      use prior year data to interpolate monthly data
df_monthly_forward <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  # calculate CPIU and CPIU core growth rate
  mutate(cpi_u_nsa_gr = cpi_u_nsa/lag(cpi_u_nsa, 1),
         cpi_u_core_nsa_gr = cpi_u_core_nsa/lag(cpi_u_core_nsa, 1)) %>% 
  # filter out data prior current year
  filter(date >= paste0((current_year - 1),"-12-01")) %>% 
  # use december of prior year data to interpolate CPIURS/CPIURS core forward
  mutate(cpiurs_nsa = accumulate(cpi_u_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_nsa[1]),
         cpiurs_core_nsa = accumulate(cpi_u_core_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_core_nsa[1])) %>% 
  select(date, year, month, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  mutate(cpiurs = cpiurs_nsa*cpi_u/cpi_u_nsa,
         cpiurs_core = cpiurs_core_nsa*cpi_u_core/cpi_u_core_nsa)

# combine backfast, forward interpolation, and raw data together
df_monthly <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  select(date, year, month, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  # isolate data for years not backcast/forward interpolated
  filter(date < paste0((current_year - 2),"-12-01") & date >= "1977-12-01") %>% 
  # bind all dataframes together
  rbind(., df_monthly_backward, df_monthly_forward) %>%
  arrange(date) 

stata_cpi_monthly <- df_monthly %>% 
  select(-date, -cpi_u_medcare, -cpi_u_medcare_nsa)  %>% 
  mutate_at(vars(matches("cpi")), as.numeric) %>% 
  write_csv(here("output/cpi_monthly.csv"))

wb_df_monthly <- df_monthly %>% 
  select(-year, -month) %>% 
  arrange(date) %>% 
  # write .csv used in stata .do file
  write_csv(here("output/cpi_monthly.csv")) %>% 
  # calculate CPI-U and CPI-U core changes
  mutate(cpi_u_mom_sa_unit = cpi_u - lag(cpi_u, 1),
         cpi_u_mom_sa_percent = cpi_u_mom_sa_unit/lag(cpi_u, 1),
         cpi_u_yoy_nsa_unit = cpi_u_nsa - lag(cpi_u_nsa, 12),
         cpi_u_yoy_nsa_percent = cpi_u_yoy_nsa_unit/lag(cpi_u_nsa, 12),
         cpi_u_core_mom_sa_unit = cpi_u_core - lag(cpi_u_core, 1),
         cpi_u_core_mom_sa_percent = cpi_u_core_mom_sa_unit/lag(cpi_u_core, 1),
         cpi_u_core_yoy_nsa_unit = cpi_u_core_nsa - lag(cpi_u_core_nsa, 12),
         cpi_u_core_yoy_nsa_percent = cpi_u_core_yoy_nsa_unit/lag(cpi_u_core_nsa, 12)) %>% 
  # convert calculated changes to proper formatting
  mutate(cpi_u = round(cpi_u, 3),
         cpi_u_nsa = round(cpi_u_nsa, 3),
         cpi_u_core = round(cpi_u_core, 3),
         cpi_u_core_nsa = round(cpi_u_core_nsa, 3),
         cpiurs = round(cpiurs, 3),
         cpiurs_nsa = round(cpiurs_nsa, 3),
         cpiurs_core = round(cpiurs_core, 3),
         cpiurs_core_nsa = round(cpiurs_core_nsa, 3),
         cpi_u_medcare = round(cpi_u_medcare, 3),
         cpi_u_medcare_nsa = round(cpi_u_medcare_nsa, 3),
         cpi_u_mom_sa_unit = round(cpi_u_mom_sa_unit, 3),
         cpi_u_mom_sa_percent = round(cpi_u_mom_sa_percent, 3),
         cpi_u_yoy_nsa_unit = round(cpi_u_yoy_nsa_unit, 2),
         cpi_u_yoy_nsa_percent = round(cpi_u_yoy_nsa_percent, 3),
         cpi_u_core_mom_sa_unit = round(cpi_u_core_mom_sa_unit, 2),
         cpi_u_core_mom_sa_percent = round(cpi_u_core_mom_sa_percent, 3),
         cpi_u_core_yoy_nsa_unit = round(cpi_u_core_yoy_nsa_unit, 2),
         cpi_u_core_yoy_nsa_percent = round(cpi_u_core_yoy_nsa_percent, 3)) %>% 
  mutate_at(vars(matches("cpi")), as.numeric)
  

### WORKBOOK QUARTERLY DATA ####
# interpolate quarterly data forward
wb_df_quarterly_forward <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  # calculate CPIU and CPIU core growth rate
  mutate(cpi_u_nsa_gr = cpi_u_nsa/lag(cpi_u_nsa, 1),
         cpi_u_core_nsa_gr = cpi_u_core_nsa/lag(cpi_u_core_nsa, 1)) %>% 
  # filter out data prior current year
  filter(date >= paste0((current_year - 2),"-12-01")) %>% 
  # use december of prior year data to interpolate CPIURS/CPIURS core forward
  mutate(cpiurs_nsa = accumulate(cpi_u_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_nsa[1]),
         cpiurs_core_nsa = accumulate(cpi_u_core_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_core_nsa[1])) %>% 
  select(date, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  # adjust CPIURS and CPIURS core using interpolated data
  mutate(cpiurs = cpiurs_nsa*cpi_u/cpi_u_nsa,
         cpiurs_core = cpiurs_core_nsa*cpi_u_core/cpi_u_core_nsa) %>% 
  # define quarterly variable
  mutate(quarter = as.yearqtr(date)) %>% 
  # group by quarter
  group_by(quarter) %>%
  # calculate quarterly statistics
  summarise(cpi_u = round(mean(cpi_u), 3),
            cpi_u_nsa = round(mean(cpi_u_nsa), 3),
            cpi_u_core = round(mean(cpi_u_core), 3),
            cpi_u_core_nsa = round(mean(cpi_u_core_nsa), 3),
            cpiurs = round(mean(cpiurs), 3),
            cpiurs_nsa = round(mean(cpiurs_nsa), 3),
            cpiurs_core = round(mean(cpiurs_core), 3),
            cpiurs_core_nsa = round(mean(cpiurs_core_nsa), 3),
            cpi_u_medcare = round(mean(cpi_u_medcare), 3),
            cpi_u_medcare_nsa = round(mean(cpi_u_medcare_nsa), 3)) %>% 
  filter(quarter > paste((current_year - 1),"Q4"))

# combine forward interpolated and raw data
wb_df_quarterly <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date),
         quarter = as.yearqtr(date)) %>% 
  group_by(quarter) %>% 
  summarise(cpi_u = round(mean(cpi_u), 3),
            cpi_u_nsa = round(mean(cpi_u_nsa), 3),
            cpi_u_core = round(mean(cpi_u_core), 3),
            cpi_u_core_nsa = round(mean(cpi_u_core_nsa), 3),
            cpiurs = round(mean(cpiurs), 3),
            cpiurs_nsa = round(mean(cpiurs_nsa), 3),
            cpiurs_core = round(mean(cpiurs_core), 3),
            cpiurs_core_nsa = round(mean(cpiurs_core_nsa), 3),
            cpi_u_medcare = round(mean(cpi_u_medcare), 3),
            cpi_u_medcare_nsa = round(mean(cpi_u_medcare_nsa), 3)) %>% 
  filter(quarter <= paste((current_year - 2),"Q4")) %>% 
  bind_rows(., wb_df_quarterly_forward)

### WORKBOOK ANNUAL DATA ####
# backcast annual data
wb_df_annual_backward <- cpi_annual %>% 
  left_join(cpi_u_x1_ann, by = "year") %>% 
  arrange(year) %>% 
  # use cpiux1 data to calculate growth rate
  mutate(cpi_u_x1_ann_gr = cpi_u_x1_ann/lead(cpi_u_x1_ann, 1)) %>% 
  filter(year <= 1978) %>% 
  arrange(desc(year)) %>% 
  # apply growth rate backwards to 1947
  mutate(cpiurs = accumulate(cpi_u_x1_ann_gr[2:n()], function(x, y) x*y, .init = cpiurs[1])) %>% 
  select(-cpi_u_x1_ann, -cpi_u_x1_ann_gr) 

# combine backcast and raw annual data
wb_df_annual <- cpi_annual %>% 
  # isolate data after 1978
  filter(year > 1978) %>% 
  # row bind backcast data to raw data
  rbind(., wb_df_annual_backward)  %>%
  arrange(year) %>% 
  mutate(cpiurs = case_when(
    year == (current_year - 1) & is.na(cpiurs) ~ (lag(cpiurs, 1) * (cpi_u) / lag(cpi_u, 1)),
    TRUE ~ cpiurs),
    cpiurs_core = case_when(
      year == (current_year - 1) & is.na(cpiurs_core) ~ (lag(cpiurs_core, 1) * (cpi_u_core) / lag(cpi_u_core, 1)),
      TRUE ~ cpiurs_core)) %>% 
  arrange(year) %>%
  mutate(cpiurs = case_when(
            year == (current_year - 1) & is.na(cpiurs) ~ (lag(cpiurs, 1) * (cpi_u) / lag(cpi_u, 1)),
            TRUE ~ cpiurs),
         cpiurs_core = case_when(
           year == (current_year - 1) & is.na(cpiurs_core) ~ (lag(cpiurs_core, 1) * (cpi_u_core) / lag(cpi_u_core, 1)),
           TRUE ~ cpiurs_core)) %>% 
  select(year, cpi_u, cpi_u_core, cpiurs, cpiurs_core, cpi_u_medcare) 

write.csv(wb_df_annual, here("output/cpi_annual.csv"))

write_csv(wb_df_annual, here("output/cpi_annual.csv"))


### WORKBOOK ALT INDICES ####
# define BEA api function
get_bea_table <- function(tablename) {
  bea_specs <- list(
    'UserID' = Sys.getenv("BEA_REG_KEY"),
    'Method' = 'GetData',
    'datasetname' = 'NIPA',
    'TableName' = tablename,
    'Frequency' = 'A',
    'Year' = 'X',
    'ResultFormat' ='json'
  )
  beaGet(beaSpec = bea_specs, asWide = FALSE) %>%
    select(TableName, LineNumber, LineDescription, TimePeriod, DataValue) %>%
    rename(description = LineDescription,
           year = TimePeriod,
           value = DataValue,
           line = LineNumber,
           tablename_bea = TableName) %>%
    mutate(year = as.numeric(year),
           line = as.numeric(line),
           value = as.numeric(value))
};

# use get BEA function to import NIPA 2.3.4
bea_2.3.4 <- get_bea_table("T20304") %>% 
  # filter for PCE and market based PCE
  filter(line %in% c(1, 27)) %>% 
  filter(year >= 1947) %>%  
  select(year, line, value) %>% 
  pivot_wider(id_cols = year, names_from = "line", values_from = "value") %>% 
  rename(personal_consumption_exp = "1",
         market_based_personal_consumption_exp = "27") %>% 
  mutate(personal_consumption_exp = round(personal_consumption_exp, 1),
         market_based_personal_consumption_exp = round(market_based_personal_consumption_exp, 1)) %>% 
  arrange(year) 

# define month crosswalk to BEA data
month_xwalk_alt <- tibble(month = c(1,2,3,4,5,6,7,8,9,10,11,12), 
                          period = c("January","February","March","April","May","June","July","August","September","October","November","December"))

# combine all alt indices
wb_df_alt_indices <- api_output %>% 
  # select chained CPIU
  select(year, month, chained_cpi_u = SUUR0000SA0) %>% 
  filter(month != 13) %>% 
  group_by(year) %>% 
  mutate(chained_cpi_u = as.numeric(chained_cpi_u)) %>% 
  # summarize chained cpiu by year
  summarise(chained_cpi_u = round(mean(chained_cpi_u), 1)) %>% 
  mutate(year = as.numeric(year)) %>% 
  # merge in PCE and market based PCE pulled from BEA
  right_join(bea_2.3.4, by = "year") %>% 
  arrange(year)

# WordPress figure
wp_fig <- api_output %>% 
  filter(month != 13) %>% 
  mutate(date = as.POSIXct(paste(year,month,1, sep = "-")),
         date = as.Date(date)) %>%
  select(date, CES0500000003) %>%   
  left_join(wb_df_monthly, by = "date") %>% 
  mutate(real_wage = CES0500000003 * ((wb_df_monthly$cpiurs[wb_df_monthly$date == max(wb_df_monthly$date)]))/ cpiurs) %>% 
  transmute(date = date,
            "Nominal wage growth" = (CES0500000003 / lag(CES0500000003, 12))-1,
            "Real wage growth" = (real_wage / lag(real_wage, 12))-1,
            "Inflation" = cpi_u_yoy_nsa_percent)
