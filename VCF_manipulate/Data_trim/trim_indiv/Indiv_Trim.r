source('/home/yiming/Desktop/test/read.vcf.genotypes.R')
dat = read.vcf.genotypes('/home/yiming/Desktop/test/file.vcf')
prop.miss=apply(dat, 2, function(x){length(which(is.na(x)))/length(x)})
dat2=colnames(dat)[which(prop.miss>0.7)]
write.table(dat2, "/home/yiming/Desktop/test/badlist.txt")