#!/bin/bash                                                                     
input=$1
pattern=$(echo "$input" | grep -o 'D[0-9]\+')
output="${pattern}_cleaned.csv"

awk 'BEGIN {FS=OFS=","}                                                         
{                                                                               
    for (i = 1; i <= NF; i++) {                                                 
        if ($i == "") $i = "NA";                                                
    }                                                                           
    print;                                                                      
}' $input | awk -v FPAT='[^,]*|"[^"]*"' '{                                      
    for (i = 1; i <= NF; i++) {                                                 
        gsub(/,/, "", $i);                                                      
    }                                                                           
    $1=$1;     
    print $0;                                                                                  
}' OFS=',' > $output
echo "Null values filled and commas removed. Processed file saved as $output"
