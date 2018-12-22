read.vcf.genotypes <- function(filename) {
    
  get_counts <- function(x,GT.pos) {
    if (length(grep(":",x,fixed=TRUE))>0) {
      y <- strsplit(x,split=":",fixed=TRUE)[[1]][GT.pos]
      z <- strsplit(y,split="/",fixed=TRUE)[[1]]
      return(as.numeric(z))
    } else {
      return(c(0,0))
    }
  }
  
  con <- file(filename,"r") #open file for reading
  temp <- readLines(con,1)  #read one line
  comment.line <- 0
  while(substr(temp,1,2)=="##") {  #skip comment lines
    temp <- readLines(con,1)
    comment.line <- comment.line+1
  }
  header <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
  format.pos <- grep("FORMAT",header)
  # Get sample names
  n.sample <- length(header) - format.pos
  sample.names <- apply(array(header[-c(1:format.pos)]),1,function(x){y=strsplit(x,split=":",fixed=TRUE)[[1]][1];return(y)})
  
  # Get GT position
  temp <- readLines(con,1)
  temp2 <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
  temp3 <- strsplit(temp2[format.pos],split=":",fixed=TRUE)[[1]]
  GT.pos <- match("GT",temp3)

  # Get number of marker lines
  print("Retrieving marker lines...")
  temp <- readLines(con)
  n.markers <- length(temp)+1 #need to add back the line previously read to get GT position

  close(con)
  
  print("Extracting genotypes:")
  
  genotypes1 <- matrix(NA,n.markers,n.sample)
  genotypes2 <- matrix(NA,n.markers,n.sample)
  genotypes <- matrix(NA,n.markers,n.sample)
  colnames(genotypes1) <- sample.names
  colnames(genotypes2) <- sample.names
  colnames(genotypes) <- sample.names
  marker.names <- array(rep("",n.markers))
  
  con <- file(filename,"r")
  temp <- readLines(con,comment.line+1)
  m <- 0
  
  while ((m < n.markers) & (length(temp)>0)) {
    temp <- readLines(con,1)
    if (length(temp) > 0) {
      temp2 <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
      temp3 <- strsplit(temp2[1],split="d",fixed=TRUE)[[1]] #splitting by "d" because the scaffold number is preceded by "scaffold"
#      if ((length(grep(",",temp2[5],fixed=TRUE))==0)&(temp2[5]!="-")&(temp2[4]!="-")&(length(grep(",",temp2[4],fixed=TRUE))==0)) {  #only process bi-allelic SNPs (remove tri-allelic and indels)
        
         counts <- apply(array(temp2[-c(1:format.pos)]),1,get_counts,GT.pos)
         m <- m + 1
         genotypes1[m,] <- counts[1,]
         genotypes2[m,] <- counts[2,]
         marker.names[m] <- paste(temp2[1],temp2[2],sep="_")
#      }
    }
    print(paste(m,"of",n.markers,sep=" "))
  }
  close(con) 
  
  i <- seq(1,n.sample,by=1)
  j <- seq(1,n.markers,by=1)
  for (i in 1:n.sample){
    for (j in 1:n.markers){
      genotypes[j,i] <- sum(genotypes1[j,i],genotypes2[j,i])
    }
  }
  rownames(genotypes) <- marker.names

  # Write vcf table
#  filename2 <- sub('.vcf','.table',filename)
#  write.table(genotypes,filename2,sep="\t")

  # Return vcf table as object in R working environment
  return(genotypes)
  
}  #end read.vcf



# For reading beagle v4 imputed vcf files
read.beagle.vcf.genotypes <- function(filename) {
    
  get_counts <- function(x,GT.pos) {
     z <- strsplit(x,split="|",fixed=TRUE)[[1]]
     return(as.numeric(z))
  }
  
  con <- file(filename,"r") #open file for reading
  temp <- readLines(con,1)  #read one line
  comment.line <- 0
  while(substr(temp,1,2)=="##") {  #skip comment lines
    temp <- readLines(con,1)
    comment.line <- comment.line+1
  }
  header <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
  
  # Get sample names
  n.sample <- length(header) - 9
  sample.names <- apply(array(header[-c(1:9)]),1,function(x){y=strsplit(x,split=":",fixed=TRUE)[[1]][1];return(y)})
  
  # Get GT position
  temp <- readLines(con,1)
  temp2 <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
  temp3 <- strsplit(temp2[9],split=":",fixed=TRUE)[[1]]
  GT.pos <- match("GT",temp3)

  # Get number of marker lines
  print("Retrieving marker lines...")
  temp <- readLines(con)
  n.markers <- length(temp)+1 #need to add back the line previously read to get GT position

  close(con)
  
  print("Extracting genotypes:")
  
  genotypes1 <- matrix(NA,n.markers,n.sample)
  genotypes2 <- matrix(NA,n.markers,n.sample)
  genotypes <- matrix(NA,n.markers,n.sample)
  colnames(genotypes1) <- sample.names
  colnames(genotypes2) <- sample.names
  colnames(genotypes) <- sample.names
  marker.names <- array(rep("",n.markers))
  
  con <- file(filename,"r")
  temp <- readLines(con,comment.line+1)
  m <- 0
  
  while ((m < n.markers) & (length(temp)>0)) {
    temp <- readLines(con,1)
    if (length(temp) > 0) {
      temp2 <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
      temp3 <- strsplit(temp2[1],split="d",fixed=TRUE)[[1]] #splitting by "d" because the scaffold number is preceded by "scaffold"
#      if ((length(grep(",",temp2[5],fixed=TRUE))==0)&(temp2[5]!="-")&(temp2[4]!="-")&(length(grep(",",temp2[4],fixed=TRUE))==0)) {
        
        #only process bi-allelic SNPs (remove tri-allelic and indels)
          counts <- apply(array(temp2[-c(1:9)]),1,get_counts,GT.pos)
          m <- m + 1
          genotypes1[m,] <- counts[1,]
          genotypes2[m,] <- counts[2,]
          marker.names[m] <- paste(temp2[1],temp2[2],sep="_")
#      }
    }
    print(paste(m,"of",n.markers,sep=" "))
  }
  close(con) 
  
  i <- seq(1,n.sample,by=1)
  j <- seq(1,n.markers,by=1)
  for (i in 1:n.sample){
    for (j in 1:n.markers){
      genotypes[j,i] <- sum(genotypes1[j,i],genotypes2[j,i])
    }
  }
  rownames(genotypes) <- marker.names

  # Write vcf table
  filename2 <- sub('.vcf','.table',filename)
  write.table(genotypes,filename2,sep="\t")

  # Return vcf table as object in R working environment
  return(genotypes)
  
}  #end read.vcf




# For a VCF file that has "." for missing genotypes, as opposed to "./."

# NOTE #
# Need to revise so it is not dependent on max.marker

read.vcf.genotypes2 <- function(filename,max.marker) {
  
  get_counts <- function(x,GT.pos) {
    if (length(grep(":",x,fixed=TRUE))>0) {
      y <- strsplit(x,split=":",fixed=TRUE)[[1]][GT.pos]
      if (length(grep("/",y,fixed=TRUE))>0){
        z <- strsplit(y,split="/",fixed=TRUE)[[1]]
        return(as.numeric(z))
      } else {
        return(c(NA,NA))
      }
    } else {
      return(c(0,0))
    }
  }
  
  con <- file(filename,"r") #open file for reading
  temp <- readLines(con,1)  #read one line
  comment.line <- 0
  while(substr(temp,1,2)=="##") {  #skip comment lines
    temp <- readLines(con,1)
    comment.line <- comment.line+1
  }
  header <- strsplit(temp,split="\t",fixed=TRUE)[[1]] #contains attribute headings and sample names
  
  n.sample <- length(header) - 9 #first 9 entries are vcf format headings
  
  sample.names <- apply(array(header[-c(1:9)]),1,function(x){y=strsplit(x,split=":",fixed=TRUE)[[1]][1];return(y)})
  
  temp <- readLines(con,1) #read first line of data
  temp2 <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
  temp3 <- strsplit(temp2[9],split=":",fixed=TRUE)[[1]] #isolate the format headings
  GT.pos <- match("GT",temp3) #keep position of genotype (GT) entries
  close(con)
  
  print("Got genotype positions")
  
  genotypes1 <- matrix(NA,max.marker,n.sample)
  genotypes2 <- matrix(NA,max.marker,n.sample)
  genotypes <- matrix(NA,max.marker,n.sample)
  colnames(genotypes1) <- sample.names
  colnames(genotypes2) <- sample.names
  colnames(genotypes) <- sample.names
  marker.names <- array(rep("",max.marker))
  
  con <- file(filename,"r")
  temp <- readLines(con,comment.line+1) #skip header lines
  m <- 0
  
  while ((m < max.marker) & (length(temp)>0)) {
    temp <- readLines(con,1)
    if (length(temp) > 0) {
      temp2 <- strsplit(temp,split="\t",fixed=TRUE)[[1]]
      temp3 <- strsplit(temp2[1],split="d",fixed=TRUE)[[1]]
      if ((length(grep(",",temp2[5],fixed=TRUE))==0)&(temp2[5]!="-")&(temp2[4]!="-")&(length(grep(",",temp2[4],fixed=TRUE))==0)) { #if there are no "," or "-" in the allele columns
        
        #only process bi-allelic SNPs (remove tri-allelic and indels)
        counts <- apply(array(temp2[-c(1:9)]),1,get_counts,GT.pos)
        m <- m + 1
        genotypes1[m,] <- counts[1,]
        genotypes2[m,] <- counts[2,]
        marker.names[m] <- paste(temp3[2],temp2[2],temp2[3],sep=".")
      }
    }
    print(paste("Marker",m,"done",sep=" "))
  }
  close(con) 
  
  i <- seq(1,n.sample,by=1)
  j <- seq(1,max.marker,by=1)
  for (i in 1:n.sample){
    for (j in 1:max.marker){
      genotypes[j,i] <- sum(genotypes1[j,i],genotypes2[j,i])
    }
  }
  genotypes[1:m,]
  rownames(genotypes) <- marker.names
  
  return(genotypes)
  
}  #end read.vcf
