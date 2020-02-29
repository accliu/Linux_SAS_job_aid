#!/bin/bash

# This shell script is used to submit a sas program located in the current directory on grid server.
# It produces a txt file to contain the submission info for later use. 
# To invoke it, use: ./sas_submit_jog.sh your_sas_code1 your_sas_code2 (no .sas plealse)
# Suppose 'sasgsub' is already present under one of your current environment's search paths
# Otherwise, use something like: /sas/software/.../SASGridManagerClientUtility/9.4/sasgsub
# Suppose you want to save submission info to grid_submit_info.txt. And, this becomes handy when small jobs are in question.
# This is because the running time is instantaneous. If you check back later or much later with bjobs or bhist, the job ID will be gone. 

read -p 'Please enter a name for the txt file which will contain submission info: ' File

if test -f $File.txt; then
   read -p "$File.txt already exists. Do you want to replace the existing file (y/n)?  " user_ans
   if [ $usesr_ans=y ]; then
      rm $File.txt; touch $File.txt
   else
      read -p 'Please enter a different name for the txt file to contain submission info: ' File
      touch $File.txt
   fi
else
   touch $File.txt
fi

echo -e "\nYou have submitted: $* \n"

for i in $@
do 
   sasgsub -gridsubmitpgm $i.sas >> $File.txt
done

# The next block helps you find the sas job IDs in the submission info. 
# The array all_jobs searches $File.txt for pattern and get them into this array. 

all_jobs=($(awk -F "Job ID:" '{print$2}' $File.txt | tr -s '\n' ' '))

# Check whether the array is empty. 

if [ ${#all_jobs[@]} -eq 0 ]; then
   echo -e "Sorry but you didn't submit a job. Enter the sas file names next to the shell invocation command. \n"
   exit 1
else
   echo -e "\nYou have submitted jobs with IDs: ${all_jobs[@]} \n"
   echo -e "The submission info is stored in $File.txt \n"
   echo "To check job status, use: sas_job_status.sh"
fi


