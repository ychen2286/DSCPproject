#!/bin/bash

# Directory containing state CSV files
input_dir=$(pwd)
output_dir="${input_dir}/outputstates"

# Create an output directory if it doesn't exist
mkdir -p $output_dir
echo "Output directory is set to: $output_dir"
# Process each CSV file
for file in $input_dir/*_combined.csv; do
  state=$(basename "$file" "_combined.csv")
  echo "State extracted from filename: $state"
  # Use awk to calculate the mean of each column, include column names, and add the state column
  awk -F, -v state="$state" 'BEGIN { OFS="," }
    NR==1 {
        # Print headers with an additional 'state' column
        for (i=1; i<=NF; i++) {
            header[i]=$i;
        }
        print $0, "state";
        next
    }
    {
        for (i=1; i<=NF; i++) {
            sum[i]+=$i;
            count[i]++;
        }
    }
    END {
        # Output the means followed by the state code
        for (i=1; i<=NF; i++) {
            printf (i>1 ? OFS : "") sum[i]/count[i];
        }
        printf OFS state "\n";
    }' "$file" > "$output_dir/${state}_mean.csv"
  echo "Mean values calculated and saved to: ${output_dir}/${state}_mean.csv"
done

# Combine all mean CSV files into one, including headers from the first file only
awk 'FNR == 1 && NR == 1 { print } FNR > 1 { print }' $output_dir/*_mean.csv > "$input_dir/combine_all_means_with_state.csv"
