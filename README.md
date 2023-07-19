# Consumer Price Index stata package
Stata package with monthly and annual data for various CPI series

## Installation
```stata
net install cpi, from("https://github.com/Economic/cpi")
```

## Basic Use
This package allows users to access monthly and annual CPI data files without having to place them in their working directory.


Example:
```stata
/* cpi tempfile */
sysuse cpi_annual, clear
keep year cpiurs

tempfile cpiurs
save `cpiurs'


*load org data
load_epiextracts, begin(1979m1) end(2022m12) sample(org) version(production)
gen org = 1
gen wgt = orgwgt

tempfile org
save `org'

*age and selfemp restrictions
drop if age < 16
drop if selfemp == 1
drop if selfinc == 1

tempfile wage_master
save `wage_master'

use `wage_master', clear
gcollapse (mean) wage [pw=wgt], by(year) fast

/* merge CPI */
merge m:1 year using `cpiurs'
drop if _merge == 2


/*use 2021 as base */
sum cpiurs if year == 2022
local cpi_base = `r(mean)'

gen realwage = wage * `cpi_base'/cpiurs

export delimited real_wage.csv, replace 

