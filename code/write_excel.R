# create workbook object
wb <- createWorkbook()

### MONTHLY DATA ####
addWorksheet(wb, sheetName = "Monthly")

setColWidths(wb, sheet = "Monthly", cols = 1:19, widths = 15.71)

writeData(wb, x = "CPI-U", sheet = "Monthly", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 2)
writeData(wb, x = "1982-84=100", sheet = "Monthly", startRow = 3, startCol = 2)
writeData(wb, x = "CUSR0000SA0", sheet = "Monthly", startRow = 4, startCol = 2)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 3)
writeData(wb, x = "1982-84=100", sheet = "Monthly", startRow = 3, startCol = 3)
writeData(wb, x = "CUUR0000SA0", sheet = "Monthly", startRow = 4, startCol = 3)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 2:3)

writeData(wb, x = "CPI-U-Core", sheet = "Monthly", startRow = 1, startCol = 4)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 4)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 4)
writeData(wb, x = "1982-84=100", sheet = "Monthly", startRow = 3, startCol = 4)
writeData(wb, x = "CUSR0000SA0L1E", sheet = "Monthly", startRow = 4, startCol = 4)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 5)
writeData(wb, x = "1982-84=100", sheet = "Monthly", startRow = 3, startCol = 5)
writeData(wb, x = "CUUR0000SA0L1E", sheet = "Monthly", startRow = 4, startCol = 5)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 4:5)

writeData(wb, x = "CPI-U-RS", sheet = "Monthly", startRow = 1, startCol = 6)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 6)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 6)
writeData(wb, x = "Dec. 1977=100", sheet = "Monthly", startRow = 3, startCol = 6)
writeData(wb, x = "N/A", sheet = "Monthly", startRow = 4, startCol = 6)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 7)
writeData(wb, x = "Dec. 1977=100", sheet = "Monthly", startRow = 3, startCol = 7)
writeData(wb, x = "N/A", sheet = "Monthly", startRow = 4, startCol = 7)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 6:7)

writeData(wb, x = "CPI-U-RS Core", sheet = "Monthly", startRow = 1, startCol = 8)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 8)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 8)
writeData(wb, x = "Dec. 1977=100", sheet = "Monthly", startRow = 3, startCol = 8)
writeData(wb, x = "N/A", sheet = "Monthly", startRow = 4, startCol = 8)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 9)
writeData(wb, x = "Dec. 1977=100", sheet = "Monthly", startRow = 3, startCol = 9)
writeData(wb, x = "N/A", sheet = "Monthly", startRow = 4, startCol = 9)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 8:9)

writeData(wb, x = "CPI-U Med care", sheet = "Monthly", startRow = 1, startCol = 10)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 10)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 10)
writeData(wb, x = "1982-84=100", sheet = "Monthly", startRow = 3, startCol = 10)
writeData(wb, x = "CUSR0000SA0L1E", sheet = "Monthly", startRow = 4, startCol = 10)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 11)
writeData(wb, x = "Dec. 1977=100", sheet = "Monthly", startRow = 3, startCol = 11)
writeData(wb, x = "CUUR0000SA0L1E", sheet = "Monthly", startRow = 4, startCol = 11)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 10:11)

writeData(wb, x = "CPI-U Changes", sheet = "Monthly", startRow = 2, startCol = 12)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 2, cols = 12)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 3, startCol = 12)
writeData(wb, x = "MoM", sheet = "Monthly", startRow = 4, startCol = 12)
writeData(wb, x = "MoM %", sheet = "Monthly", startRow = 4, startCol = 13)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 3, startCol = 14)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 3, startCol = 14)
writeData(wb, x = "YoY", sheet = "Monthly", startRow = 4, startCol = 14)
writeData(wb, x = "YoY %", sheet = "Monthly", startRow = 4, startCol = 15)

mergeCells(wb, sheet = "Monthly", rows = 2, cols = 12:15)


writeData(wb, x = "CPI-U-Core Changes", sheet = "Monthly", startRow = 2, startCol = 16)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 2, cols = 16)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 3, startCol = 16)
writeData(wb, x = "MoM", sheet = "Monthly", startRow = 4, startCol = 16)
writeData(wb, x = "MoM %", sheet = "Monthly", startRow = 4, startCol = 17)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 3, startCol = 18)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 3, startCol = 18)
writeData(wb, x = "YoY", sheet = "Monthly", startRow = 4, startCol = 18)
writeData(wb, x = "YoY %", sheet = "Monthly", startRow = 4, startCol = 19)

mergeCells(wb, sheet = "Monthly", rows = 2, cols = 16:19)

freezePane(wb, sheet = "Monthly", firstActiveRow = 5, firstActiveCol = 2)

writeData(wb, wb_df_monthly, sheet = "Monthly", startRow = 5, startCol = 1, colNames = FALSE)

percent_fun <- function(x) {
  addStyle(wb, sheet = "Monthly", style = createStyle(numFmt = "PERCENTAGE"), rows = 1:nrow(wb_df)+1, cols = x)
}

walk(c(13, 15, 17, 19), percent_fun)

addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1:nrow(wb_df)+4, cols = 12)
addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1, cols = 12)
addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 2, cols = 12)

addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1:nrow(wb_df)+4, cols = 16)
addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1, cols = 16)
addStyle(wb, sheet = "Monthly", 
         style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), 
         rows = 2, cols = 16)


addWorksheet(wb, sheetName = "Quarterly")

setColWidths(wb, sheet = "Quarterly", cols = 1:19, widths = 15.71)

writeData(wb, x = "CPI-U", sheet = "Quarterly", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Quarterly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "SA", sheet = "Quarterly", startRow = 2, startCol = 2)
writeData(wb, x = "1982-84=100", sheet = "Quarterly", startRow = 3, startCol = 2)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 2)

writeData(wb, x = "NSA", sheet = "Quarterly", startRow = 2, startCol = 3)
writeData(wb, x = "1982-84=100", sheet = "Quarterly", startRow = 3, startCol = 3)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 3)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 2:3)

writeData(wb, x = "CPI-U-Core", sheet = "Quarterly", startRow = 1, startCol = 4)
addStyle(wb, sheet = "Quarterly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 4)

writeData(wb, x = "SA", sheet = "Quarterly", startRow = 2, startCol = 4)
writeData(wb, x = "1982-84=100", sheet = "Quarterly", startRow = 3, startCol = 4)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 4)

writeData(wb, x = "NSA", sheet = "Quarterly", startRow = 2, startCol = 5)
writeData(wb, x = "1982-84=100", sheet = "Quarterly", startRow = 3, startCol = 5)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 5)

mergeCells(wb, sheet = "Quarterly", rows = 1, cols = 4:5)

writeData(wb, x = "CPI-U-RS", sheet = "Quarterly", startRow = 1, startCol = 6)
addStyle(wb, sheet = "Quarterly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 6)

writeData(wb, x = "SA", sheet = "Quarterly", startRow = 2, startCol = 6)
writeData(wb, x = "Dec. 1977=100", sheet = "Quarterly", startRow = 3, startCol = 6)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 6)

writeData(wb, x = "NSA", sheet = "Quarterly", startRow = 2, startCol = 7)
writeData(wb, x = "Dec. 1977=100", sheet = "Quarterly", startRow = 3, startCol = 7)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 7)

mergeCells(wb, sheet = "Quarterly", rows = 1, cols = 6:7)

writeData(wb, x = "CPI-U-RS Core", sheet = "Quarterly", startRow = 1, startCol = 8)
addStyle(wb, sheet = "Quarterly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 8)

writeData(wb, x = "SA", sheet = "Quarterly", startRow = 2, startCol = 8)
writeData(wb, x = "Dec. 1977=100", sheet = "Quarterly", startRow = 3, startCol = 8)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 8)

writeData(wb, x = "NSA", sheet = "Quarterly", startRow = 2, startCol = 9)
writeData(wb, x = "Dec. 1977=100", sheet = "Quarterly", startRow = 3, startCol = 9)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 9)

mergeCells(wb, sheet = "Quarterly", rows = 1, cols = 8:9)

writeData(wb, x = "CPI-U Med care", sheet = "Quarterly", startRow = 1, startCol = 10)
addStyle(wb, sheet = "Quarterly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 10)

writeData(wb, x = "SA", sheet = "Quarterly", startRow = 2, startCol = 10)
writeData(wb, x = "1982-84=100", sheet = "Quarterly", startRow = 3, startCol = 10)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 10)

writeData(wb, x = "NSA", sheet = "Quarterly", startRow = 2, startCol = 11)
writeData(wb, x = "Dec. 1977=100", sheet = "Quarterly", startRow = 3, startCol = 11)
writeData(wb, x = "Calculated from monthly", sheet = "Quarterly", startRow = 4, startCol = 11)

mergeCells(wb, sheet = "Quarterly", rows = 1, cols = 10:11)

freezePane(wb, sheet = "Quarterly", firstActiveRow = 5, firstActiveCol = 2)

writeData(wb, wb_df_quarterly, sheet = "Quarterly", startRow = 5, startCol = 1, colNames = FALSE)

### ANNUAL DATA ####
addWorksheet(wb, sheetName = "Annual")

setColWidths(wb, sheet = "Annual", cols = 1:19, widths = 15.71)

writeData(wb, x = "CPI-U", sheet = "Annual", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Annual", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "NSA", sheet = "Annual", startRow = 2, startCol = 2)
writeData(wb, x = "1982-1984=100", sheet = "Annual", startRow = 3, startCol = 2)
writeData(wb, x = "CUUR0000SA0", sheet = "Annual", startRow = 4, startCol = 2)

writeData(wb, x = "CPI-U-Core", sheet = "Annual", startRow = 1, startCol = 3)
addStyle(wb, sheet = "Annual", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 3)

writeData(wb, x = "NSA", sheet = "Annual", startRow = 2, startCol = 3)
writeData(wb, x = "1982-1984=100", sheet = "Annual", startRow = 3, startCol = 3)
writeData(wb, x = "CUUR0000SA0L1E", sheet = "Annual", startRow = 4, startCol = 3)

writeData(wb, x = "CPI-U-RS", sheet = "Annual", startRow = 1, startCol = 4)
addStyle(wb, sheet = "Annual", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 4)

writeData(wb, x = "NSA", sheet = "Annual", startRow = 2, startCol = 4)
writeData(wb, x = "Dec. 1977=100", sheet = "Annual", startRow = 3, startCol = 4)
writeData(wb, x = "N/A", sheet = "Annual", startRow = 4, startCol = 4)

writeData(wb, x = "CPI-U-RS Core", sheet = "Annual", startRow = 1, startCol = 5)
addStyle(wb, sheet = "Annual", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 5)

writeData(wb, x = "NSA", sheet = "Annual", startRow = 2, startCol = 5)
writeData(wb, x = "Dec. 1977=100", sheet = "Annual", startRow = 3, startCol = 5)
writeData(wb, x = "N/A", sheet = "Annual", startRow = 4, startCol = 5)

writeData(wb, x = "CPI-U-Med care", sheet = "Annual", startRow = 1, startCol = 6)
addStyle(wb, sheet = "Annual", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 6)

writeData(wb, x = "NSA", sheet = "Annual", startRow = 2, startCol = 6)
writeData(wb, x = "982-1984=100", sheet = "Annual", startRow = 3, startCol = 6)
writeData(wb, x = "CUUR0000SAM", sheet = "Annual", startRow = 4, startCol = 6)

freezePane(wb, sheet = "Annual", firstActiveRow = 5, firstActiveCol = 2)

writeData(wb, wb_df_annual, sheet = "Annual", startRow = 5, startCol = 1, colNames = FALSE)

### ALT INDICES ####
addWorksheet(wb, sheetName = "Alt Indices")

writeData(wb, x = "Chained CPI-U", sheet = "Alt Indices", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Alt Indices", style = createStyle(wrapText = TRUE, halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "Dec. 1999=100", sheet = "Alt Indices", startRow = 2, startCol = 2)
writeData(wb, x = "SUUR0000SA0", sheet = "Alt Indices", startRow = 3, startCol = 2)


writeData(wb, x = "Personal Consumption Expenditure", sheet = "Alt Indices", startRow = 1, startCol = 3)
addStyle(wb, sheet = "Alt Indices", style = createStyle(wrapText = TRUE, halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 3)

writeData(wb, x = "2012=100", sheet = "Alt Indices", startRow = 2, startCol = 3)
writeData(wb, x = "NIPA 2.3.4 (line 1)", sheet = "Alt Indices", startRow = 3, startCol = 3)

writeData(wb, x = "Marekt-Based Personal Consumption Expenditure", sheet = "Alt Indices", startRow = 1, startCol = 4)
addStyle(wb, sheet = "Alt Indices", style = createStyle(wrapText = TRUE, halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 4)

writeData(wb, x = "2009=100", sheet = "Alt Indices", startRow = 2, startCol = 4)
writeData(wb, x = "NIPA 2.3.4 (line 27)", sheet = "Alt Indices", startRow = 3, startCol = 4)

freezePane(wb, sheet = "Alt Indices", firstActiveRow = 4, firstActiveCol = 2)

writeData(wb, wb_df_alt_indices, sheet = "Alt Indices", startRow = 4, startCol = 1, colNames = FALSE)

saveWorkbook(wb, here("output/test_wb.xlsx"), overwrite = TRUE)
  