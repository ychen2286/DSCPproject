print("Script started")
library(dplyr)
library(readr)
library(stringr)
print("library done")

args <- commandArgs(trailingOnly = TRUE)
print(args)
if (length(args) == 0) {
  stop("No arguments supplied. Usage: Rscript your_script.R <filename>")
}
input_file <- args[1]
print("input done")

data <- read_csv(input_file)
print("csv read")

add_year_column <- function(data, filename) {
    print("Function add_year_column called")
    year_code <- str_extract(filename, "D\\d{2}")
    year <- as.integer(sub("D", "", year_code)) + 2000
    data$Year <- year
    print(paste("Year extracted and added:", year))
    return(data)
}

print(paste("Rows read:", nrow(data)))  # Check how many rows are read
if (nrow(data) == 0) {
    stop("No data in file, stopping execution.")
}

data <- add_year_column(data, input_file)
if (ncol(data) == ncol(read_csv(input_file))) {
    stop("Year column was not added.")
}

output_file <- sub(".csv", "_with_year.csv", input_file)
write_csv(data, output_file)
if (!file.exists(output_file)) {
    stop("Output file was not created.")
}
print(paste("Data processed and saved to:", output_file))
