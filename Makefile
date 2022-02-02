all: updatedata deploydata

.PHONY: all updatedata deploydata

updatedata:
	Rscript code/cpi_master.R
	stata -b do cpi_read_data.do &

deploydata:
	rsync -avh --chmod=0444 cpi_annual.dta /usr/local/ado/
	rsync -avh --chmod=0444 cpi_monthly.dta /usr/local/ado/
