#!/bin/bash

mkdir -p states
for file in *_combined.csv; do
  if [[ $file =~ ^[A-Z]{2}_combined\.csv$ ]]; then
    mv "$file" states/
  fi
done

echo "Files of states  have been moved to folder"
