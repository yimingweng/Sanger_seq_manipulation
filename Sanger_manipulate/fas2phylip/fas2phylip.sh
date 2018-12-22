#!/bin/bash

if [ $# != 1 ]; then
    echo "USAGE: bash fas2phylip.sh <fasta-file>"
    exit
fi
# replace dash with underscore in the species names
cat $1 | sed 's/>\(.*\)-\(.*\)/>\1_\2/' | sponge $1
numSpec=$(grep -c  ">" $1)
tmp=$(cat $1 | sed "s/>[ ]*\(\w*\).*/;\1</"  | tr -d "\n" | tr -d ' '  | sed 's/^;//' | tr "<" " " )
length=$(($(echo $tmp | sed 's/[^ ]* \([^;]*\);.*/\1/'   | wc -m ) - 1))


echo "$numSpec $length" >> $1.phy
echo  $tmp | tr ";" "\n" >>  $1.phy

for file in *.fas*.phy; do
    mv "$file" "${file/.fas/}"
done