#!/bin/bash

mkdir -p log error output 

condor_submit getData.sub && echo "Data retrieval job submitted."

sleep 180
while condor_q | grep -q "getData.sub"; do sleep 70; done
echo "Data retrieval completed."

chmod u+x splitnamestxt.sh 
./splitnamestxt.sh && echo "Filename splitting completed."

condor_submit year.sub && echo "Year addition job submitted."

sleep 180
while condor_q | grep -q "year.sub"; do sleep 120; done
echo "Year addition completed."

chmod u+x postname.sh
./postname.sh && echo "Name tidying completed."

# Get txt of filenames for the year CSV
chmod u+x yearname.sh
./yearname.sh && 
echo "Year filenames completed."

sleep 30
condor_submit yearmean.sub && echo "Year mean calculation job submitted."
sleep 300
while condor_q | grep -q "yearmean.sub"; do sleep 100; done
echo "Year mean calculation completed."

chmod u+x combine_by_year.sh
./combine_by_year.sh &&
sleep 30 
echo "Yearly data combined."

rm -r *_means.csv

condor_submit split.sub && echo "Split job submitted."
sleep 180
while condor_q | grep -q "split.sub"; do sleep 70; done
echo "Split job completed."

rm -r MUP*.csv
#rm -r 2021.csv 2020.csv 2019.csv 2018.csv  2017.csv  2016.csv 2015.csv 2014.csv 2013.csv
sleep 20

chmod u+x combine_by_state.sh
./combine_by_state.sh
rm -f _combined.csv

sleep 15
chmod u+x statemeans.sh
./statemeans.sh && echo "State means calculation completed."


cp $(pwd)/outputstates/combine_all_means_with_state.csv .

mkdir -p results
cp combine_all_means_with_state.csv combined_by_year.csv results/

#rm -r 20*_*.csv
#rm -r *_combined.csv
