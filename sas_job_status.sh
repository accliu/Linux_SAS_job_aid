#!/bin/bash

# This bash script is used to detect the status of a sas job

read -p "Please enter the name of the txt file that contains the job submission info (no .txt please):  " File

echo -e "\nThe following is the job status info you want:\n"

all_jobs=($(awk -F "Job ID:" '{print$2}' $File.txt | tr -s '\n' ' '))

for i in "${all_jobs[@]}" 
   do 
      echo -e "\nStatus of Job ID: $i \n"
      job_id=$(printf "%-.6s" $i)
      echo -e "***---------------------------------***"
      sasgsub -gridgetstatus $job_id
      echo -e "***---------------------------------***\n\n" 
   done

# Job id must be string. The format in printf is to remove unwanted newline, space, tab. - left adjust the string. 
# .6 describes the precision. Suppose 6 is enough to capture the id string. Can change it to larger numbers. 
