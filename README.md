# ReadAligentFiles

## install agilp

[Bioconductor - agilp](http://bioconductor.org/packages/release/bioc/html/agilp.html)

[Bioconductor - AgiMicroRna](http://bioconductor.org/packages/release/bioc/html/AgiMicroRna.html)

```R
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("agilp")
```

## Download GEO Files

GSE40289: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE40289

annotation file: https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GPL13912

## Rsead Aligent Files

```R
source("ReadRawArrayFiles.R")
ReadAligentFile(input = "GSE40289/GSE40289_RAW/",
                output = "GSE40289/AligentFile/",
                annotation_file = "GSE40289/GPL13912-20417.txt",B = 24)


colnames(dataout) <- gsub(".*(GSM.*?)_.*","\\1",colnames(dataout))
write.csv(cbind(gene = rownames(dataout),
                dataout), file = "GSE40289/GSE40289.csv", row.names = FALSE)
```

