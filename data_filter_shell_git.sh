#!/bin/bash

# This shell script selects user specified columns from a dilimited file and filter the observations based
# on user specified conditions. The use of the script (can also be in servers) will save the pain of loading/parsing/formating large
# datasets into statistical softwares like R, Python, or SAS. Shell parses and filters the text file and thus
# results in a smaller dataset before the statistical softwares take the job over. The statistical softwares then
# can parse and format a smaller dataset. Also note Shell can do more than basic filtering.
# With modification, can be invoked by Python, for example, to run. 

# The script takes in a parent dataset (as positional argument) to perform filtering
# Use as ./data_filter_by_unix.sh nba.txt


## Select columns wanted here
## The indices/order will be used later in filtering
## Change the indices accordingly to perform filtering
col_wanted=(game_id _iscopy date_game team_id fran_id pts forecast)

position=()
col_name=$(head -n 1 $1 | sed 's/|/\t/g')

cnt=0
for i in ${col_wanted[@]}
  do
    up_to_col=(${col_name%%$i*})
    position[$cnt]=$((${#up_to_col[*]}+1))
    ((cnt++))
  done

## Choose a file name to store the subset
read -p 'Please enter a name for the txt file which will contain the filtered set: ' File

if test -f ${File}; then
   read -p "${File} already exists. Do you want to replace the existing file (y/n)?  " user_ans
   if [ $usesr_ans=y ]; then
      rm ${File}; touch ${File}
   else
      read -p 'Please enter a different name for the txt file which will contain the filtered data: ' File
      touch ${File}
   fi
else
   touch ${File}
fi

start_time=$(($(date +%s%N)/1000000))

## Select needed columns and filter the data by conditions
## Save subset to a txt/csv file
cut -d '|' -f $(printf ",%s" "${position[@]}" | sed 's/,//') $1 | awk -F "|"  'NR==1 || (($5 ~ /Lakers/ || /Kings/ || /Jazz/ || /Heat/ || /Clippers/) && $2==0)' > $File
#cut -d '|' -f $(printf ",%s" "${position[@]}" | sed 's/,//') $1 | awk -F "|" 'NR==1 || ($5 == "Heat" && $2 == 0)' > $File
#cut -d '|' -f $(printf ",%s" "${position[@]}" | sed 's/,//') $1 > $File

echo Check observation counts:
wc -l $File

echo -e "\n"

## End time
end_time=$(($(date +%s%N)/1000000)) 
echo "The program takes" $((end_time-start_time)) "milliseconds to run."
