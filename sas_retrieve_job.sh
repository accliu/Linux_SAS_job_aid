#!/bin/bash

read -p "Please enter a folder name which will contain your job info:  " your_dir

if [ -d "your_dir" ]; then 
   read -p "The folder $your_dir already exists. Do you want to replace the existing folder (y/n)?  " user_ans
   if [ $user_ans = y ]; then
      rm -r $your_dir; mkdir $your_dir
   else
      read -p 'Please enter a different name for the folder to contain job info:  ' $your_dir
      mkdir $your_dir
   fi
else
   mkdir $your_dir
fi

read -p "Please enter the txt file name which contains your job submission info:  " File

all_jobs=($(awk -F "Job ID:" '{print$2}' $File.txt | tr -s '\n' ' '))

for i in "${all_jobs[@]}"
   do
      echo -e "\n   Status of Job ID: $i \n"
      job_id=$(printf "%-.6s" $i)

      echo '***--------------------------***'
      sasgsub -gridgetstatus $job_id
      echo '***--------------------------***'

      sasgsub -gridgetresults $job_id -resultsdir ./$your_dir
      echo '***--------------------------***'
   done

cd ./$your_dir

for dir in */
   do
      { printf 'In folder:    %s\n' "$dir"
        ( cd "$dir" && echo -e "    \nThe job return code is: " $(awk -F "Return code:" '{print$2}' job.info | tr -s '\n' ' ')
      }
   done
