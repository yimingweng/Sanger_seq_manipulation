#!/bin/bash
# usage: bash snpunique.sh "input vcf file"
# Inputs Arguments, must be .vcf file
inputvcf=${1:-"example.vcf"}


echo "start running snpunique..."

# record to start time
timeStart="$(date +"%s")"

# separate the header and matrix
echo "seperating header and matrix..."
cat $inputvcf | grep -v \# > vcfmatrix.tmpl
cat $inputvcf | grep \# > vcfheader.tmpl

# seperate matrix based on reads
echo "generating sub-matrixes..."
reads=$(cat $inputvcf | grep -o [[:space:]][0-9]\\+_[0-9]\\+ | cut -d "_" -f 1 | uniq)
IFS=$'\n'       # make newlines the only separator
for line in $(cat vcfmatrix.tmpl)
do 
    read=$(echo $line | grep -o [[:space:]][0-9]\\+_[0-9]\\+ | cut -d "_" -f 1 | grep -o [0-9]\\+)
    echo $line >>$read.tmp
done
unset IFS

# count miss data amount for snps in same reads
# for each read, remove all snps but those snps have least missing data
echo "trimming snp..."
for file in *.tmp
do
    IFS=$'\n'
    arrayname=$(echo $file | cut -d "." -f 1)
    array=()
        for line in $(cat $file)
        do 
            misscount=$(echo $line | grep [[:space:]][0-9]\\+_ | grep -o \\./\\. | wc -l)
            array+=("$misscount")
        done
    sortedmiss=($(sort -n  <<<"${array[*]}"))
    minmiss=$(echo "${sortedmiss[@]}" | grep -o  ^[0-9]\\+)
    unset array
        for line in $(cat $file)
        do
            misscount=$(echo $line | grep [[:space:]][0-9]\\+_ | grep -o \\./\\. | wc -l)
            if [[ $minmiss -eq $misscount ]]
            then
            echo $line >> subset$file
            fi
        done
    rm -r $file
done
unset IFS

# reduse each subset file to one line (keep only last line (last snp))
for subsetfile in subset*.tmp
do
    tail -n 1 $subsetfile >> final$subsetfile
    rm -r $subsetfile
done

echo "assembling final vcf file..."
# assemble output vcf file
for finalsubset in finalsubset*.tmp
do
    cat $finalsubset >> finalmatrix.tmp
    rm -r $finalsubset
done
sort -k2 -n finalmatrix.tmp >> sortedmatrix.tmp
cat sortedmatrix.tmp >> vcfheader.tmpl
rm -r vcfmatrix.tmpl finalmatrix.tmp sortedmatrix.tmp
mv vcfheader.tmpl readtrim_$inputvcf

#claculate computing time
timeEnd="$(date +"%s")"
sec="$((timeEnd - timeStart))"
h=$(( $sec / 3600 ))
m=$(( $(($sec - $h * 3600)) / 60 ))
s=$(($sec - $h * 3600 - $m * 60))
if [ $h -le 9 ];then h=0$h;fi
if [ $m -le 9 ];then m=0$m;fi
if [ $s -le 9 ];then s=0$s;fi
totaltime="$(echo $h:$m:$s)"
echo "Finish running"
echo "Total time to generate new vcf file is: $totaltime"



