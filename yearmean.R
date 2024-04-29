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

# Generate the output filename by replacing ".csv" with "_means.csv"
output_file <- sub("\\.csv$", "_means.csv", input_file)

# Load data
data <- read.csv(input_file, stringsAsFactors = FALSE)

# Select columns starting with "Tot", "Avg", or "Bene"
selected_columns <- grep("^(Tot|Avg|Bene)", names(data), value = TRUE)
selected_data <- data[, selected_columns, drop = FALSE]

# Calculate means for each column
mean_values <- colMeans(selected_data, na.rm = TRUE)

# Prepare the output dataframe with original column names
means_df <- as.data.frame(t(mean_values))
colnames(means_df) <- selected_columns

# Save the output
write.csv(means_df, output_file, quote = FALSE, row.names = FALSE)
