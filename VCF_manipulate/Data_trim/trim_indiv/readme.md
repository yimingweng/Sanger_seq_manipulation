# Trim individual from VCF

## Description
The program is used to trim individuals from VCF files. The trimming criteria are porpotion of missing data, or other customized criteria (in working).

## Input
* VCF files

## Step1: convert VCF to matrix
* script name: read.vcf.genotypes.R
* usage:  
`source('path/to/read.vcf.genotypes.R')`  
`dat = read.vcf.genotypes('path/to/file.vcf')`

## Step2: drop the individual with bad quality
* script name: Indiv_Trim.r
* usage: run the code in scrpt

## Output
* list of individuals with bad quality
