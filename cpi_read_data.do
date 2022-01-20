*cpi_read_data.do
*set working directory to root cpi directory

global output output/
global data data/

*read in cpi data, monthly data
import delim ${output}cpi_monthly.csv, clear
*make NA's missing and destring
replace cpi_u_core = "." if cpi_u_core == "NA"
replace cpi_u_core_nsa = "." if cpi_u_core_nsa == "NA"
replace cpiurs = "." if cpiurs == "NA"
replace cpiurs = "." if cpiurs == "NA"
replace cpiurs_nsa = "." if cpiurs_nsa == "NA"
replace cpiurs_core = "." if cpiurs_core == "NA"
replace cpiurs_core_nsa = "." if cpiurs_core_nsa == "NA"

destring cpi*, replace

*creat timeseries for lags and leads
gen yearmonth = ym(year, month)
tsset yearmonth

*extend cpiurs forward to 2019 since it's not released on a monthly basis
*2019 is currently hardcoded, fix this to be based on missing values later
replace cpiurs_nsa = l1.cpiurs_nsa * cpi_u_nsa / l1.cpi_u_nsa if year == 2020
replace cpiurs = cpiurs_nsa * cpi_u / cpi_u_nsa if year == 2020

*label all variables
lab var cpi_u "All items in U.S. city average (seasonally adjusted)"
lab var cpi_u_nsa "All items in U.S. city average (not seasonally adjusted)"
lab var cpi_u_core "All items less food and energy in U.S. city average (seasonally adjusted)"
lab var cpi_u_core_nsa "All items less food and energy in U.S. city average (not seasonally adjusted)"
lab var cpiurs "CPI-U-RS, All items (seasonally adjusted)"
lab var cpiurs_nsa "CPI-U-RS, All items (not seasonally adjusted)"
lab var cpiurs_core "CPI-U-RS, All items less food and energy (seasonally adjusted)"
lab var cpiurs_core_nsa "CPI-U-RS, All items less food and energy (not seasonally adjusted)"

saveold cpi_monthly.dta, version(13) replace

*read in cpi data, annual data
import delim ${output}cpi_annual.csv, clear

lab var cpi_u "All items in U.S. city average"
lab var cpi_u_core "All items less food and energy in U.S. city average"
lab var cpiurs "CPI-U-RS, All items"
lab var cpiurs_core "CPI-U-RS, All items less food and energy"

replace cpi_u_core = "." if cpi_u_core == "NA"
replace cpiurs = "." if cpiurs == "NA"
replace cpiurs_core = "." if cpiurs_core == "NA"

destring cpi*, replace

tempfile cpi_ann
save `cpi_ann'

*apply changes from CPI-U-X1 to CPI-U-RS to extend back from 1978 to 1947
import delim ${data}cpi_u_x1_annual.csv, clear
merge 1:1 year using `cpi_ann'
drop if _merge == 1
drop _merge

tsset year
while cpiurs == . & year == 1947{
    replace cpiurs = f1.cpiurs * (cpi_u_x1 / f1.cpi_u_x1) if year <= 1977
}

replace cpiurs = round(cpiurs, .1)
drop cpi_u_x1

saveold cpi_annual.dta, version(13) replace
