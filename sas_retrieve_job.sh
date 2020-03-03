#!/bin/bash

# This shell script is to retrieve finished jobs meanwhile to check status to confirm completion. 
# It uses the submission info to retrieve job list, log, info from the default work directory in server. 
# And, it moves the file from that directory to a user defined new folder under current directory. 

read -p "Please enter a name for the folder which will contain your job info:  " your_dir

if [ -d "$your_dir" ]; then
   read -p "The folder $your_dir already exists. Do you want to replace the existing folder (y/n)?  " user_ans
   if [ $user_ans = y ]; then
      rm -r $your_dir; mkdir $your_dir
   else
      read -p 'Please enter a different name for the folder to contain job info:  ' your_dir
      mkdir $your_dir
   fi
else
   mkdir $your_dir
fi

read -p "Please enter the name of the txt file which contains your job submission info:  " File

read -p "Please enter a name for the txt file which will contain the SAS job return code: " return_file

if [ -f "$return_file.txt" ]; then
   read -p "The file $return_file.txt already exists. Do you want to replace the existing file (y/n)? " user_ans
   if [ $user_ans=y ]; then
      rm $return_file.txt; touch "$return_file".txt
#both variable value extraction methods would work.
   else
      read -p 'Please enter a different name for the file which will contain job return code: ' return_file
   fi
else
   touch $return_file.txt
fi

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
      printout=$( printf 'Job info output to folder:    %s\n' "$dir";
        ( cd "$dir" && echo -e "    \nThe job return code is: " $(awk -F "Return code:" '{print$2}' job.info | tr -s '\n' ' ') )
      )
      echo -e $printout > ../$return_file.txt 
      echo -e $printout
   done
