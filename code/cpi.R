
# IMPORT MONTHLY DATA FROM REALTALK #
cpi_monthly <- c_cpi_u_extended_monthly_nsa %>%
  left_join(c_cpi_u_extended_monthly_sa, by = c("year", "month")) %>%
  left_join(cpi_u_monthly_sa, by = c("year", "month")) %>%
  left_join(cpi_u_monthly_nsa, by = c("year", "month")) %>% 
  rename( 
    c_cpi_u_extended = c_cpi_u_extended.y ,
    c_cpi_u_extended_nsa =c_cpi_u_extended.x ,
    cpi_u = cpi_u.x,
    cpi_u_nsa = cpi_u.y) %>% 
  # correct order of variables 
  select(year, month, c_cpi_u_extended, c_cpi_u_extended_nsa, everything())

# IMPORT QUARTERLY DATA FROM REALTALK #
cpi_quarterly <- c_cpi_u_extended_quarterly_sa %>%
  left_join(c_cpi_u_extended_quarterly_nsa, by = c("year", "quarter")) %>%
  left_join(cpi_u_quarterly_sa, by = c("year", "quarter")) %>%
  left_join(cpi_u_quarterly_nsa, by = c("year", "quarter")) %>% 
  rename( 
    c_cpi_u_extended = c_cpi_u_extended.x ,
    c_cpi_u_extended_nsa =c_cpi_u_extended.y ,
    cpi_u = cpi_u.x,
    cpi_u_nsa = cpi_u.y)

# IMPORT ANNUAL DATA FROM REALTALK #
cpi_annual <- c_cpi_u_extended_annual %>%
  left_join(cpi_u_annual, by = c("year"))




