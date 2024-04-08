#!/bin/bash

row = ${SLURM_ARRAY_TASK_ID}

module load R/R-3.6.1 

df = read.csv("url.csv")

wget df[row,1]
