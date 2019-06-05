#bin/bash

# Name: bootstraptreemix.sh 
# Author: YiMing Weng
# Date: 05 June 2019 (last updated)
# Software requirements:
# treemix (https://code.google.com/p/treemix/)
# sumtrees package in dendropy (http://pythonhosted.org/DendroPy/scripts/sumtrees.html)

# Usage: bash bootstraptreemix.sh inputfile outgroup bootstrap block_size output_directory
# imputfile: zipped treemix format (.tmix.gz), you can convert from vcf with vcf2treemix.py then gzip it
# outgroup (optional): defined outgroup for the maximum likelhood tree
# bootstraps: number of bootstrap to run the ML tree, default: 1000
# block_size: the size of resampling blocks, default: 1
# output: name of the output directory

infile=${1:-"*.tmix.gz"}
outgroup=${2}
bootstraps=${3:-"1000"}
blocksize=${4:-"1"}
output=${5:-"treemixout"}

# Create output folder and run treemix original tree
# If outgroup is present, then run treemix with outgroup
# If no outgroup is assigned, no outgroup for treemix
mkdir $output
if [[ $outgroup ]]; then 
    treemix -i $infile -root $outgroup -o originaltree
else
    treemix -i $infile -o originaltree
fi
gunzip -k originaltree.treeout.gz
mv originaltree* $output

# To run treemix with bootstrap replicates
# If outgroup is present, then run treemix with outgroup
# If no outgroup is assigned, no outgroup for treemix
if [[ $outgroup ]]; then 
    for ((bt=1;bt<=$bootstraps;bt++)); 
    do 
    treemix -i $infile -root $outgroup -bootstrap -k $blocksize -o btreplicate$bt
    done

else
    for ((bt=1;bt<=$bootstraps;bt++)); 
    do 
    treemix -i $infile -bootstrap -k $blocksize -o btreplicate$bt
    done
fi

# move all bootstrap replicates into output file
mkdir bootstrap_replicates
mv *btreplicate* bootstrap_replicates

# concatenate the bootstrap replicates into cattree file
# first to unzip the bt replicates
for gztreefile in bootstrap_replicates/btreplicate*.treeout.gz
    do
    gunzip -k $gztreefile
done

# Then write trees into single cattree file
touch $output/cattree
for treefile in bootstrap_replicates/btreplicate*.treeout
    do
    cat $treefile >> $output/cattree
    rm -r $treefile
done

# use sumtree.py to add bootstrap values to the branches of original tree
cd $output
sumtrees.py --target-tree-filepath=originaltree.treeout cattree -o finaltree
cd ..
mv bootstrap_replicates $output/