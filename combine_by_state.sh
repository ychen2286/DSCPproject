#!/bin/bash
directory="."

mkdir -p "$directory/temp"
echo "Temporary directory created."

for file in "$directory"/*.csv; do
    state_code=$(echo "$(basename "$file")" | grep -oP '\d{4}_\K[A-Z]{2}(?=\.csv)')
    echo "$state_code" >> "$directory/temp/state_codes.txt"
done

sort "$directory/temp/state_codes.txt" | uniq > "$directory/temp/unique_state_codes.txt"


echo "Combining files by state code..."
while read state; do
    echo "Processing files for state: $state"

    combined_file="$directory/${state}_combined.csv"
  
    first=true
    for file in "$directory"/*"${state}".csv; do
        year=$(basename "$file" | grep -oP '^\d{4}')
        if [ "$first" = true ]; then
            echo "Processing first file for state $state: $(basename "$file")"
            awk -v year="$year" 'BEGIN {FS=OFS=","} NR==1 {print $0 ",Year"} NR>1 {print $0 "," year}' "$file" > "$combined_file"
            first=false
        else
            awk -v year="$year" 'BEGIN {FS=OFS=","} NR>1 {print $0 "," year}' "$file" >> "$combined_file"
        fi
    done

    echo "Combined files for state $state into $combined_file"
done < "$directory/temp/unique_state_codes.txt"

echo "Cleaning up temporary files..."
rm -r "$directory/temp"

echo "Process completed successfully."
