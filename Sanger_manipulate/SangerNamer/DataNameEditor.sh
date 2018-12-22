#!/bin/bash
# working dir is "sanger" which contains a subfolder with 96 sequences and a .xlsx file.
# This script is used to edit file name of sequences from biotech center.
# After renameing these sequence files, we usually import them to Geneious.

mv *-*-* DNAsequence
dataDir=${1:-"DNAsequence"}

# conver .xlsx file to .csv
ssconvert -S *.xlsx primertable.csv
mv primertable.csv.0 primertable1.csv

# add key column to csv table
array=(01A 01B 01C 01D 01E 01F 01G 01H 02A 02B 02C 02D 02E 02F 02G 02H 03A 03B 03C 03D 03E 03F 03G 03H 04A 04B 04C 04D 04E 04F 04G 04H 05A 05B 05C 05D 05E 05F 05G 05H 06A 06B 06C 06D 06E 06F 06G 06H 07A 07B 07C 07D 07E 07F 07G 07H 08A 08B 08C 08D 08E 08F 08G 08H 09A 09B 09C 09D 09E 09F 09G 09H 010A 010B 010C 010D 010E 010F 010G 010H 011A 011B 011C 011D 011E 011F 011G 011H 012A 012B 012C 012D 012E 012F 012G 012H)
for item in ${array[*]}
do
printf "%s\n" $item >>wellkey.csv
done

# combine well key column to primertable.csv
paste -d ',' primertable1.csv wellkey.csv > primertable.csv
rm primertable1.csv wellkey.csv

# remove extra info for each file name
for file in "$dataDir"/*
do
newname=$(echo $file | cut -d '_' -f 2)
mv -- "$file" ""$dataDir"/$newname"
done

# match and extract filenames from primertable
for newfile in "$dataDir"/*
do
nopathname=$(echo $newfile | cut -d "/" -f 2)
key=$(cat primertable.csv | grep "$nopathname")
mv -- "$newfile" ""$dataDir"/$key"
done

# final polish filename
for filename in "$dataDir"/*
do
finalname=$(echo $filename | cut -d ',' -f 1,2 | sed s'/,/_/')
mv -- "$filename" "$finalname"
done