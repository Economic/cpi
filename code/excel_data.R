cpi_u_x1_monthly <- read_csv(here("data/cpi_u_x1_monthly.csv")) %>% 
  mutate(date = as.Date(date))

cpi_u_x1_ann <- read_csv(here("data/cpi_u_x1_annual.csv"))

wb_df_monthly_backward <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  select(date, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  left_join(cpi_u_x1_monthly, by = "date") %>% 
  arrange(date) %>% 
  mutate(cpi_u_x1_monthly_gr = cpi_u_x1_monthly/lead(cpi_u_x1_monthly, 1)) %>% 
  filter(date <= "1977-12-01") %>%
  arrange(desc(date)) %>% 
  mutate(cpiurs_nsa = accumulate(cpi_u_x1_monthly_gr[2:n()], function(x, y) x*y, .init = cpiurs_nsa[1]),
         cpiurs = cpiurs_nsa*cpi_u/cpi_u_nsa) %>% 
  select(-cpi_u_x1_monthly, -cpi_u_x1_monthly_gr) %>% 
  filter(date < "1977-12-01") %>% 
  arrange(date)

wb_df_monthly_forward <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  mutate(cpi_u_nsa_gr = cpi_u_nsa/lag(cpi_u_nsa, 1),
         cpi_u_core_nsa_gr = cpi_u_core_nsa/lag(cpi_u_core_nsa, 1)) %>% 
  filter(date >= "2019-12-01") %>% 
  mutate(cpiurs_nsa = accumulate(cpi_u_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_nsa[1]),
         cpiurs_core_nsa = accumulate(cpi_u_core_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_core_nsa[1])) %>% 
  select(date, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  mutate(cpiurs = cpiurs_nsa*cpi_u/cpi_u_nsa,
         cpiurs_core = cpiurs_core_nsa*cpi_u_core/cpi_u_core_nsa)

wb_df_monthly <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  select(date, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  filter(date < "2019-12-01" & date >= "1977-12-01") %>% 
  rbind(., wb_df_monthly_backward, wb_df_monthly_forward) %>%
  arrange(date) %>% 
  mutate(cpi_u_mom_sa_unit = cpi_u - lag(cpi_u, 1),
         cpi_u_mom_sa_percent = cpi_u_mom_sa_unit/lag(cpi_u, 1),
         cpi_u_yoy_nsa_unit = cpi_u_nsa - lag(cpi_u_nsa, 12),
         cpi_u_yoy_nsa_percent = cpi_u_yoy_nsa_unit/lag(cpi_u_nsa, 12),
         cpi_u_core_mom_sa_unit = cpi_u_core - lag(cpi_u_core, 1),
         cpi_u_core_mom_sa_percent = cpi_u_core_mom_sa_unit/lag(cpi_u_core, 1),
         cpi_u_core_yoy_nsa_unit = cpi_u_core_nsa - lag(cpi_u_core_nsa, 12),
         cpi_u_core_yoy_nsa_percent = cpi_u_core_yoy_nsa_unit/lag(cpi_u_core_nsa, 12)) %>% 
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
         cpi_u_core_yoy_nsa_percent = round(cpi_u_core_yoy_nsa_percent, 3)) 

wb_df_quarterly_forward <- cpi_monthly %>% 
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  mutate(cpi_u_nsa_gr = cpi_u_nsa/lag(cpi_u_nsa, 1),
         cpi_u_core_nsa_gr = cpi_u_core_nsa/lag(cpi_u_core_nsa, 1)) %>% 
  filter(date >= "2019-12-01") %>% 
  mutate(cpiurs_nsa = accumulate(cpi_u_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_nsa[1]),
         cpiurs_core_nsa = accumulate(cpi_u_core_nsa_gr[2:n()], function(x, y) x*y, .init = cpiurs_core_nsa[1])) %>% 
  select(date, cpi_u, cpi_u_nsa, cpi_u_core, cpi_u_core_nsa, cpiurs, cpiurs_nsa, 
         cpiurs_core, cpiurs_core_nsa, cpi_u_medcare, cpi_u_medcare_nsa) %>% 
  mutate(cpiurs = cpiurs_nsa*cpi_u/cpi_u_nsa,
         cpiurs_core = cpiurs_core_nsa*cpi_u_core/cpi_u_core_nsa) %>% 
  mutate(quarter = as.yearqtr(date)) %>% 
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
  filter(quarter > "2019 Q4")

wb_df_quarterly <- wb_df_quarterly_forward <- cpi_monthly %>% 
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
  filter(quarter <= "2019 Q4") %>% 
  bind_rows(., wb_df_quarterly_forward)

wb_df_annual_backward <- api_output %>% 
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
  filter(year <= 1978) %>%
  left_join(cpiurs_ann, by = "year") %>% 
  left_join(cpi_u_x1_ann, by = "year") %>% 
  arrange(year) %>% 
  mutate(cpi_u_x1_ann_gr = cpi_u_x1_ann/lead(cpi_u_x1_ann, 1)) %>% 
  arrange(desc(year)) %>% 
  mutate(cpiurs = accumulate(cpi_u_x1_ann_gr[2:n()], function(x, y) x*y, .init = cpiurs[1])) %>% 
  select(-cpi_u_x1_ann, -cpi_u_x1_ann_gr) %>% 
  filter(year < 1978)

wb_df_annual <- api_output %>% 
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
  left_join(cpiurs_ann, by = "year") %>% 
  filter(year >= 1978) %>% 
  rbind(., wb_df_annual_backward) %>% 
  arrange(year) %>%
  select(year, cpi_u, cpi_u_core, cpiurs, cpiurs_core, cpi_u_medcare)

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

bea_2.3.4 <- get_bea_table("T20304") %>% 
  filter(line %in% c(1, 27)) %>% 
  filter(year >= 1947) %>%  
  select(year, line, value) %>% 
  pivot_wider(id_cols = year, names_from = "line", values_from = "value") %>% 
  rename(personal_consumption_exp = "1",
         market_based_personal_consumption_exp = "27") %>% 
  mutate(personal_consumption_exp = round(personal_consumption_exp, 1),
         market_based_personal_consumption_exp = round(market_based_personal_consumption_exp, 1)) %>% 
  arrange(year) 

month_xwalk_alt <- tibble(month = c(1,2,3,4,5,6,7,8,9,10,11,12), 
                          period = c("January","February","March","April","May","June","July","August","September","October","November","December"))

wb_df_alt_indices <- api_output %>% 
  filter(seriesID == "SUUR0000SA0") %>% 
  select(-period, -periodName, -seriesID, chained_cpi_u = value) %>% 
  group_by(year) %>% 
  mutate(chained_cpi_u = as.numeric(chained_cpi_u)) %>% 
  summarise(chained_cpi_u = round(mean(chained_cpi_u), 1)) %>% 
  mutate(year = as.numeric(year)) %>% 
  right_join(bea_2.3.4, by = "year") %>% 
  arrange(year)

  
  