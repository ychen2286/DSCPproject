#!/bin/bash

# Define input and output directories
input_dir="/home/wqian26/DSCPproject_git"
output_dir="/home/wqian26/DSCPproject_git/outputyears"
final_output="${output_dir}/combined_by_year.csv"

# Create output directory if it doesn't exist
mkdir -p "$output_dir"

# Start the final output file with an empty header
echo "" > "$final_output"

# Initialize a flag to track the first file (to preserve headers only from the first file)
first_file=true

# Process each CSV file
for file in ${input_dir}/*_means.csv; do
    year=$(basename "$file" "_means.csv")  # Assuming filename format is 'YYYY_mean.csv'
    
    if $first_file ; then
        # For the first file, keep the header and add 'Year' column
        awk -v year="$year" 'BEGIN {FS=","; OFS=","} NR == 1 {print $0, "Year"} NR > 1 {print $0, year}' "$file" > "$final_output"
        first_file=false
    else
        # For subsequent files, skip the header
        awk -v year="$year" 'BEGIN {FS=","; OFS=","} NR > 1 {print $0, year}' "$file" >> "$final_output"
    fi
done

echo "All files have been combined into $final_output."
