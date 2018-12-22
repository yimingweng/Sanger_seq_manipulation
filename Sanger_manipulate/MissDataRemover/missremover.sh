#!/bin/bash

for file in *.phy
do
cat $file | grep -v ' .\+[RYWSMKNBDVN?-]' >> nomiss.phy
done

sanoname1=$(wc -l nomiss.phy)
declare -i sano1 sano
sano1=$(echo $sanoname1 | cut -d ' ' -f 1)
sano=$sano1-1
cat nomiss.phy | sed "s/^[0-9]\+[[:space:]]\+/$sano /"  >> 'nomiss_'$file
rm -r nomiss.phy
