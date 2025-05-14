### WORKBOOK MONTHLY DATA ####
wb_df_monthly <- cpi_monthly %>%
  mutate(date = as.POSIXct(paste(year, month, 1, sep = "-")),
         date = as.Date(date)) %>% 
  select(date, everything(), -year, -month) %>% 
  arrange(date) %>% 
  # calculate CPI-U and CPI-U core changes
  mutate(cpi_u_mom_sa_unit = cpi_u - lag(cpi_u, 1),
         cpi_u_mom_sa_percent = cpi_u_mom_sa_unit/lag(cpi_u, 1),
         cpi_u_yoy_nsa_unit = cpi_u_nsa - lag(cpi_u_nsa, 12),
         cpi_u_yoy_nsa_percent = cpi_u_yoy_nsa_unit/lag(cpi_u_nsa, 12),
         c_cpi_u_extended_mom_sa_unit = c_cpi_u_extended - lag(c_cpi_u_extended, 1),
         c_cpi_u_extended_mom_sa_percent = c_cpi_u_extended_mom_sa_unit/lag(c_cpi_u_extended, 1),
         c_cpi_u_extended_yoy_nsa_unit = c_cpi_u_extended_nsa - lag(c_cpi_u_extended_nsa, 12),
         c_cpi_u_extended_yoy_nsa_percent = c_cpi_u_extended_yoy_nsa_unit/lag(c_cpi_u_extended_nsa, 12)) %>% 
  # convert calculated changes to proper formatting
  mutate(cpi_u = round(cpi_u, 3),
         cpi_u_nsa = round(cpi_u_nsa, 3),
         c_cpi_u_extended = round(c_cpi_u_extended, 3),
         c_cpi_u_extended_nsa = round(c_cpi_u_extended_nsa, 3),
         c_cpi_u_extended_mom_sa_unit = round(c_cpi_u_extended_mom_sa_unit, 2),
         c_cpi_u_extended_mom_sa_percent = round(c_cpi_u_extended_mom_sa_percent, 3),
         c_cpi_u_extended_yoy_nsa_unit = round(c_cpi_u_extended_yoy_nsa_unit, 2),
         c_cpi_u_extended_yoy_nsa_percent = round(c_cpi_u_extended_yoy_nsa_percent, 3),
         cpi_u_mom_sa_unit = round(cpi_u_mom_sa_unit, 3),
         cpi_u_mom_sa_percent = round(cpi_u_mom_sa_percent, 3),
         cpi_u_yoy_nsa_unit = round(cpi_u_yoy_nsa_unit, 2),
         cpi_u_yoy_nsa_percent = round(cpi_u_yoy_nsa_percent, 3)) %>% 
  mutate_at(vars(matches("cpi")), as.numeric) %>% 
  # filter for starting in Jan 1947
  filter(date >= "1947-01-01") %>% 
  # write .csv used in stata .do file
  write_csv(here("output/cpi_monthly.csv"))


### WORKBOOK QUARTERLY DATA ####
wb_df_quarterly <- cpi_quarterly %>% 
  mutate(date = paste(year, " Q", quarter, sep = "")) %>% 
  select(date, everything(), -year, -quarter) %>% 
  mutate(cpi_u = round(cpi_u, 3),
         cpi_u_nsa = round(cpi_u_nsa, 3),
         c_cpi_u_extended = round(c_cpi_u_extended, 3),
         c_cpi_u_extended_nsa = round(c_cpi_u_extended_nsa, 3)) 


### WORKBOOK ANNUAL DATA ####
wb_df_annual <- cpi_annual %>% 
  arrange(year) %>% 
  mutate(cpi_u = round(cpi_u, 3),
         c_cpi_u_extended = round(c_cpi_u_extended, 3)) %>%  
  write_csv(here("output/cpi_annual.csv"))


### WORKBOOK ALT INDICES ####
wb_df_alt_indices <- pce_annual %>% 
  filter(year>=1947) 

#create objects ####
#bls codes
cpi_codes <- c("CES0500000003")

#BLS API payloads
api_output <- get_n_series_table(series_ids = cpi_codes, start_year = 1947, end_year = current_year, api_key = bls_key, tidy = TRUE, annualaverage = TRUE)

# WordPress figure
wp_fig <- api_output %>% 
  filter(month != 13) %>% 
  mutate(date = as.POSIXct(paste(year,month,1, sep = "-")),
         date = as.Date(date)) %>%
  select(date, CES0500000003) %>%   
  left_join(wb_df_monthly, by = "date") %>% 
  mutate(real_wage = CES0500000003 * ((wb_df_monthly$cpi_u[wb_df_monthly$date == max(wb_df_monthly$date)]))/ cpi_u) %>% 
  transmute(date = date,
            "Nominal wage growth" = (CES0500000003 / lag(CES0500000003, 12))-1,
            "Real wage growth" = (real_wage / lag(real_wage, 12))-1,
            "Inflation" = cpi_u_yoy_nsa_percent) %>% 
  filter(date >= "2019-01-01")