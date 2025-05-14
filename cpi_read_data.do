*cpi_read_data.do
*set working directory to root cpi directory

global output output/
global data data/

*read in cpi data, monthly data
import delim ${output}cpi_monthly.csv, clear
*make NA's missing and destring

tostring c*, force replace

replace c_cpi_u_extended_mom_sa_unit = "." if c_cpi_u_extended_mom_sa_unit == "NA"
replace c_cpi_u_extended_mom_sa_percent = "." if c_cpi_u_extended_mom_sa_percent == "NA"
replace cpi_u_mom_sa_unit = "." if cpi_u_mom_sa_unit == "NA"
replace cpi_u_mom_sa_percent = "." if cpi_u_mom_sa_percent == "NA"

destring c*, replace

replace cpi_u = round(cpi_u, 0.1)
replace cpi_u_nsa = round(cpi_u_nsa, 0.1)
replace c_cpi_u_extended = round(c_cpi_u_extended, 0.1)
replace c_cpi_u_extended_nsa = round(c_cpi_u_extended_nsa, 0.1)


*label all variables
lab var cpi_u "All items in U.S. city average (seasonally adjusted)"
lab var cpi_u_nsa "All items in U.S. city average (not seasonally adjusted)"
lab var c_cpi_u_extended "All items in U.S. city average (seasonally adjusted)"
lab var c_cpi_u_extended_nsa "All items in U.S. city average (not seasonally adjusted)"
saveold cpi_monthly.dta, version(13) replace

*read in cpi data, annual data
import delim ${output}cpi_annual.csv, clear

/*
tostring c*, force replace

replace cpi_u_core = "." if cpi_u_core == "NA"
replace cpiurs = "." if cpiurs == "NA"
replace cpiurs_core = "." if cpiurs_core == "NA"
replace cpi_u_medcare = "." if cpi_u_medcare == "NA"

destring cpi*, replace
*/

replace cpi_u = round(cpi_u, 0.1)
replace c_cpi_u_extended = round(c_cpi_u_extended, 0.1)

lab var cpi_u "All items in U.S. city average"
lab var c_cpi_u_extended "All items in U.S. city average"

*replace cpiurs = "." if cpiurs == "NA"
*replace cpiurs_core = "." if cpiurs_core == "NA"

tempfile cpi_ann
save `cpi_ann'

saveold cpi_annual.dta, version(13) replace
