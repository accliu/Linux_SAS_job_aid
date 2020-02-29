#!/bin/bash

# Use this script to kill the grid job contained in the submission info

read -p "Please enter the txt file name which contains submission info:  " File

all_jobs=($(awk -F "Job ID:" '{print$2}' $File.txt | tr -s '\n' ' '))

for i in "${all_jobs[@]}"
   do
      echo -e "\n  Killing Job ID:  $i \n"
      job_id=$(printf "%-.6s" $i)
      sasgsub -gridkilljob $job_id
   done
