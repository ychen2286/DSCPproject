#!/bin/bash
files=$(ls MUP*Prov_with_year.csv 2> /dev/null)
for src_file in $files; do
  year=$(echo "$src_file" | grep -oP 'D\K\d{2}' | head -n 1)
  if [ ! -z "$year" ]; then
    year="20$year"
    
    target_file="${year}.csv"
    
    if [ ! -f "$target_file" ]; then
      mv "$src_file" "$target_file"
      echo "Renamed $src_file to $target_file"
    else
      echo "Target file $target_file already exists. Skipping."
    fi
  else
    echo "No year found in $src_file"
  fi
done
