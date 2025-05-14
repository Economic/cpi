# create workbook object
wb <- createWorkbook()

### MONTHLY DATA ####
addWorksheet(wb, sheetName = "Monthly")

setColWidths(wb, sheet = "Monthly", cols = 1:19, widths = 15.71)

writeData(wb, x = "C-CPI-U-Extended", sheet = "Monthly", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 2)
writeData(wb, x = "Dec 1999 = 100", sheet = "Monthly", startRow = 3, startCol = 2)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 3)
writeData(wb, x = "Dec 1999 = 100", sheet = "Monthly", startRow = 3, startCol = 3)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 2:3)

writeData(wb, x = "CPI-U", sheet = "Monthly", startRow = 1, startCol = 4)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 4)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 4)
writeData(wb, x = "1982-84=100", sheet = "Monthly", startRow = 3, startCol = 4)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 5)
writeData(wb, x = "1982-84=100", sheet = "Monthly", startRow = 3, startCol = 5)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 4:5)

writeData(wb, x = "C-CPI-U-Extended Changes", sheet = "Monthly", startRow = 1, startCol = 6)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 6)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 6)
writeData(wb, x = "MoM", sheet = "Monthly", startRow = 3, startCol = 6)
writeData(wb, x = "MoM %", sheet = "Monthly", startRow = 3, startCol = 7)

writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 8)
writeData(wb, x = "YoY", sheet = "Monthly", startRow = 3, startCol = 8)
writeData(wb, x = "YoY %", sheet = "Monthly", startRow = 3, startCol = 9)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 6:9)


writeData(wb, x = "CPI-U Changes", sheet = "Monthly", startRow = 1, startCol = 10)
addStyle(wb, sheet = "Monthly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 10)

writeData(wb, x = "SA", sheet = "Monthly", startRow = 2, startCol = 10)
writeData(wb, x = "MoM", sheet = "Monthly", startRow = 3, startCol = 10)
writeData(wb, x = "MoM %", sheet = "Monthly", startRow = 3, startCol = 11)


writeData(wb, x = "NSA", sheet = "Monthly", startRow = 2, startCol = 12)
writeData(wb, x = "YoY", sheet = "Monthly", startRow = 3, startCol = 12)
writeData(wb, x = "YoY %", sheet = "Monthly", startRow = 3, startCol = 13)

mergeCells(wb, sheet = "Monthly", rows = 1, cols = 10:13)

freezePane(wb, sheet = "Monthly", firstActiveRow = 4, firstActiveCol = 2)

writeData(wb, wb_df_monthly, sheet = "Monthly", startRow = 4, startCol = 1, colNames = FALSE)

percent_fun <- function(x) {
  addStyle(wb, sheet = "Monthly", style = createStyle(numFmt = "PERCENTAGE"), rows = 1:nrow(wb_df_monthly)+1, cols = x)
}

walk(c(7, 9, 11, 13), percent_fun)

addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1:nrow(wb_df_monthly)+4, cols = 6)
addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1, cols = 6)
addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 2, cols = 6)

addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1:nrow(wb_df_monthly)+4, cols = 10)
addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 1, cols = 10)
addStyle(wb, sheet = "Monthly", style = createStyle(border = "left", borderColour = getOption("openxlsx.borderColour", "black"),  
                                                    borderStyle = (getOption("openxlsx.borderStyle", "dashed"))), rows = 2, cols = 10)

### QUARTERLY DATA ####
addWorksheet(wb, sheetName = "Quarterly")

setColWidths(wb, sheet = "Quarterly", cols = 1:19, widths = 15.71)
writeData(wb, x = "C-CPI-U-Extended", sheet = "Quarterly", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Quarterly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "SA", sheet = "Quarterly", startRow = 2, startCol = 2)
writeData(wb, x = "Dec 1999 = 100", sheet = "Quarterly", startRow = 3, startCol = 2)

writeData(wb, x = "NSA", sheet = "Quarterly", startRow = 2, startCol = 3)
writeData(wb, x = "Dec 1999 = 100", sheet = "Quarterly", startRow = 3, startCol = 3)

mergeCells(wb, sheet = "Quarterly", rows = 1, cols = 2:3)

writeData(wb, x = "CPI-U", sheet = "Quarterly", startRow = 1, startCol = 4)
addStyle(wb, sheet = "Quarterly", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 4)

writeData(wb, x = "SA", sheet = "Quarterly", startRow = 2, startCol = 4)
writeData(wb, x = "1982-84=100", sheet = "Quarterly", startRow = 3, startCol = 4)

writeData(wb, x = "NSA", sheet = "Quarterly", startRow = 2, startCol = 5)
writeData(wb, x = "1982-84=100", sheet = "Quarterly", startRow = 3, startCol = 5)

mergeCells(wb, sheet = "Quarterly", rows = 1, cols = 4:5)
freezePane(wb, sheet = "Quarterly", firstActiveRow = 4, firstActiveCol = 2)

writeData(wb, wb_df_quarterly, sheet = "Quarterly", startRow = 4, startCol = 1, colNames = FALSE)

### ANNUAL DATA ####
addWorksheet(wb, sheetName = "Annual")

setColWidths(wb, sheet = "Annual", cols = 1:19, widths = 15.71)

writeData(wb, x = "C-CPI-U-Extended", sheet = "Annual", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Annual", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "NSA", sheet = "Annual", startRow = 2, startCol = 2)
writeData(wb, x = "Dec 1999 = 100", sheet = "Annual", startRow = 3, startCol = 2)

writeData(wb, x = "CPI-U", sheet = "Annual", startRow = 1, startCol = 3)
addStyle(wb, sheet = "Annual", style = createStyle(halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 3)

writeData(wb, x = "NSA", sheet = "Annual", startRow = 2, startCol = 3)
writeData(wb, x = "1982-1984=100", sheet = "Annual", startRow = 3, startCol = 3)

freezePane(wb, sheet = "Annual", firstActiveRow = 4, firstActiveCol = 2)

writeData(wb, wb_df_annual, sheet = "Annual", startRow = 4, startCol = 1, colNames = FALSE)

### ALT INDICES ####
addWorksheet(wb, sheetName = "Alt Indices")

writeData(wb, x = "Personal Consumption Expenditure", sheet = "Alt Indices", startRow = 1, startCol = 2)
addStyle(wb, sheet = "Alt Indices", style = createStyle(wrapText = TRUE, halign = "center", valign = "center", textDecoration = "bold"), rows = 1, cols = 2)

writeData(wb, x = "2012=100", sheet = "Alt Indices", startRow = 2, startCol = 2)
writeData(wb, x = "NIPA 2.3.4 (line 1)", sheet = "Alt Indices", startRow = 3, startCol = 2)

freezePane(wb, sheet = "Alt Indices", firstActiveRow = 4, firstActiveCol = 2)

writeData(wb, wb_df_alt_indices, sheet = "Alt Indices", startRow = 4, startCol = 1, colNames = FALSE)

### WORDPRESS FIGURE ####
addWorksheet(wb, sheetName = "WP Figure")

writeData(wb, x = wp_fig, sheet = "WP Figure", startRow = 1, startCol = 1)

percent_fun <- function(x) {
  addStyle(wb, sheet = "WP Figure", style = createStyle(numFmt = '0.0%'), rows = 1:nrow(wp_fig)+1, cols = x)
}

walk(c(2:4), percent_fun)
saveWorkbook(wb, here("output/price_indices.xlsx"), overwrite = TRUE)
  