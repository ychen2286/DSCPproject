library(dplyr)
library(readr)
library(stringr)

args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 2){
  input_file <- args[1]
  group_by_var <- args[2]
} else {
  cat('usage: Rscript split.R <filename> <group by variable>', file=stderr())
  stop()
}

percentage <- function(df, tot_col) {
  cols <- grep("Bene_Race_.*_Cnt", names(df), value = TRUE)
  for (col in cols) {
    pct_col <- sub("Cnt", "Pct", col)
    df[[pct_col]] <- df[[col]] / df[[tot_col]]
  }
  return(df)
}

data <- read_csv(input_file)
#data <- percentage(data, "Tot_Bene")

grouped_data <- data %>%
  group_by(!!sym(group_by_var)) %>%
  summarise(across(matches("^(Rndrng_NPI|Rndrng_Prvdr_State|Tot_|Bene_)"), mean, na.rm = TRUE))

grouped_data %>%
  split(.[[group_by_var]]) %>%
  lapply(function(x) {
    year <- str_extract(input_file, "^\\d{4}")
    group_name <- unique(x[[group_by_var]])
    output_file <- paste0(year, "_", group_name, ".csv")
    write_csv(x, file = output_file)
  })