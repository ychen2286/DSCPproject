#!/bin/bash

# Create directories for logging errors and output if they do not exist
mkdir -p log error output 

# Submit a Condor job to get data from url.txt and wait for completion
condor_submit getData.sub && echo "Data retrieval job submitted."

sleep 180
# Wait for the getData job to complete
while condor_q | grep -q "getData.sub"; do sleep 70; done
echo "Data retrieval completed."

# Make scripts executable and execute them
chmod u+x splitnamestxt.sh 
./splitnamestxt.sh && echo "Filename splitting completed."

# Submit a Condor job to add a year column to each CSV
condor_submit year.sub && echo "Year addition job submitted."

sleep 180
# Wait for the year job to complete
while condor_q | grep -q "year.sub"; do sleep 120; done
echo "Year addition completed."

# Tidy up the names
chmod u+x postname.sh
./postname.sh && echo "Name tidying completed."

# Get txt of filenames for the year CSV
chmod u+x yearname.sh
./yearname.sh && 
echo "Year filenames retrieval completed."

sleep 20
# Submit a Condor job to summarize numerical values for each year CSV
condor_submit yearmean.sub && echo "Year mean calculation job submitted."
sleep 300
# Wait for the yearmean job to complete
while condor_q | grep -q "yearmean.sub"; do sleep 100; done
echo "Year mean calculation completed."

# Combine these summarizing information about year together
chmod u+x combine_by_year.sh
./combine_by_year.sh &&
sleep 30 
echo "Yearly data combined."

rm -r *_means.csv
# Submit final split job
condor_submit split.sub && echo "Split job submitted."
sleep 180
# Wait for the split job to complete
while condor_q | grep -q "split.sub"; do sleep 70; done
echo "Split job completed."

# Remove specified CSV files
#rm -r MUP*.csv
#rm -r 2021.csv 2020.csv 2019.csv 2018.csv  2017.csv  2016.csv 2015.csv 2014.csv 2013.csv

chmod u+x combine_by_state.sh
./combine_by_state.sh
# Removing intermediate combined files if exist
rm -f _combined.csv

chmod u+x statemeans.sh
./statemeans.sh && echo "State means calculation completed."

rm -r 20*_*.csv
rm -r *_combined.csv
