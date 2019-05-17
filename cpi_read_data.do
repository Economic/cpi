*cpi_read_data.do
*set working directory to root cpi directory

global output output/

*read in cpi data, monthly data
import delim ${output}cpi_monthly.csv, clear

lab var cpi_u "All items in U.S. city average (seasonally adjusted)"
lab var cpi_u_nsa "All items in U.S. city average (not seasonally adjusted)"
lab var cpi_u_core "All items less food and energy in U.S. city average (seasonally adjusted)"
lab var cpi_u_core_nsa "All items less food and energy in U.S. city average (not seasonally adjusted)"
lab var cpiurs "CPI-U-RS, All items (seasonally adjusted)"
lab var cpiurs_nsa "CPI-U-RS, All items (not seasonally adjusted)"
lab var cpiurs_core "CPI-U-RS, All items less food and energy (seasonally adjusted)"
lab var cpiurs_core_nsa "CPI-U-RS, All items less food and energy (not seasonally adjusted)"

save cpi_monthly.dta, replace

*read in cpi data, annual data
import delim ${output}cpi_annual.csv, clear

lab var cpi_u "All items in U.S. city average"
lab var cpi_u_core "All items less food and energy in U.S. city average"
lab var cpiurs "CPI-U-RS, All items"
lab var cpiurs_core "CPI-U-RS, All items less food and energy"

save cpi_annual.dta, replace
