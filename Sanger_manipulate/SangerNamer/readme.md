# Sanger sequence renaming program 
#### The script "DataNameEditor.sh" is used to rename the sequence files from sanger sequencing center. The new names are made mainly for better operation after importing to Geneious.

## Input
1. Download sanger sequence data (96 well plate) from [UW-Biotech Center](https://www.biotech.wisc.edu/services/dnaseq)
2. Extract file to "SangerNamer" directory (the sequence folder name sould be named as "mm-dd-yyyy")
3. Move the correspond .xlxs file which was uploaded to [UW-Biotech Center](https://www.biotech.wisc.edu/services/dnaseq) during submitting
4. So there should be three files in "SangerNamer" directory: readme.md, DataNameEditor.sh, and .xlxs plus one directory contains sequence files (mm-dd-yyyy).
## Usage
1. Open terminal and direct to /SangerNamer
2. type: </br>`bash DataNameEditor.sh`
## Output
1. Two outputs will be created:
  primertable.csv and DNAsequence folder
2. The sequence file should be renamed in DNAsequence folder
## Notes
- The program "Gnumeric" will be used in the script
- To install Gnumeric: </br>`sudo apt-get install gnumeric`
- Type password to authorize the installation
- To import renamed files to Geneious, select "Chromatogram" to load the sequences