# readme for snpunique.sh

## working enviornment
Ubuntu 18.04.1 LTS  
GNU bash, version 4.4.19(1)

## input file
**vcf file**, with second column representing reads and snps by the following format: <span style="color:red"> read_snp </span> for example: <span style="color:red">132658_48</span>  
*note: the snp number suppose to be less than 100*

## usage
`bash snpunique.sh "imput.vcf"`

## output
also **vcf file**, with "readtrim_" added before the imput file name, in example, the output is "readtrim_example.vcf"