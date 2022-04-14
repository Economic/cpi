*cpi_read_data.do
*set working directory to root cpi directory

global output output/
global data data/

*read in cpi data, monthly data
import delim ${output}cpi_monthly.csv, clear
*make NA's missing and destring

tostring cpi*, force replace

replace cpi_u_core = "." if cpi_u_core == "NA"
replace cpi_u_core_nsa = "." if cpi_u_core_nsa == "NA"
replace cpiurs = "." if cpiurs == "NA"
replace cpiurs_nsa = "." if cpiurs_nsa == "NA"
replace cpiurs_core = "." if cpiurs_core == "NA"
replace cpiurs_core_nsa = "." if cpiurs_core_nsa == "NA"

destring cpi*, replace

replace cpi_u_core = round(cpi_u_core, 0.1)
replace cpi_u_core_nsa = round(cpi_u_core_nsa, 0.1)
replace cpiurs = round(cpiurs, 0.1)
replace cpiurs_nsa = round(cpiurs_nsa, 0.1)
replace cpiurs_core = round(cpiurs_core, 0.1)
replace cpiurs_core_nsa = round(cpiurs_core_nsa, 0.1)


*creat timeseries for lags and leads
gen yearmonth = ym(year, month)
tsset yearmonth

*label all variables
lab var cpi_u "All items in U.S. city average (seasonally adjusted)"
lab var cpi_u_nsa "All items in U.S. city average (not seasonally adjusted)"
lab var cpi_u_core "All items less food and energy in U.S. city average (seasonally adjusted)"
lab var cpi_u_core_nsa "All items less food and energy in U.S. city average (not seasonally adjusted)"
lab var cpiurs "CPI-U-RS, All items (seasonally adjusted)"
lab var cpiurs_nsa "CPI-U-RS, All items (not seasonally adjusted)"
lab var cpiurs_core "CPI-U-RS, All items less food and energy (seasonally adjusted)"
lab var cpiurs_core_nsa "CPI-U-RS, All items less food and energy (not seasonally adjusted)"
drop yearmonth
saveold cpi_monthly.dta, version(13) replace

*read in cpi data, annual data
import delim ${output}cpi_annual.csv, clear
tsset year

replace cpi_u_core = "." if cpi_u_core == "NA"

destring cpi*, replace

replace cpi_u = round(cpi_u, 0.1)
replace cpi_u_core = round(cpi_u_core, 0.1)
replace cpiurs = round(cpiurs, 0.1)
replace cpiurs_core = round(cpiurs_core, 0.1)
replace cpi_u_medcare = round(cpi_u_medcare, 0.1)


lab var cpi_u "All items in U.S. city average"
lab var cpi_u_core "All items less food and energy in U.S. city average"
lab var cpiurs "CPI-U-RS, All items"
lab var cpiurs_core "CPI-U-RS, All items less food and energy"


*replace cpiurs = "." if cpiurs == "NA"
*replace cpiurs_core = "." if cpiurs_core == "NA"

tempfile cpi_ann
save `cpi_ann'

saveold cpi_annual.dta, version(13) replace
