#' Read raw Aligent array files
#'
#' @param input path for raw Aligent scan files
#' @param output output path, default current directory(.)
#' @param annotation_file ID map between array ID and gene names
#' @param source_ID row name of input files
#' @param target_ID row name of output data frame
#' @param ERR The cut-off for coefficient of variation allowed when multiple probes map to a single identifier. ERR must lie between 0 and 1. If ERR=0, any difference between such probes will result in the identifier being omitted from the final list. If ERR=1, all identifiers are retained. The default is 0.2, allowing a maximum coefficient of variation between multiple probes mapping to a single identifier of 20%.
#' @param B Number of files in input path
#' @param NORM "LOG" or "FALSE"
#' @param template_file sample information
#' @param LOG "TRUE" or "FALSE"
#' @return A data frame of input files named dataout, which columns correspond to samples, rows correspond to gene_id
#' @author Yangming si
#' @export
ReadAligentFile <- function(input, output= ".", annotation_file, source_ID = "NAME", target_ID="GENE_SYMBOL",ERR=1, B,NORM="LOG", template_file="",LOG="TRUE"){
  if(!dir.exists(output)){
    dir.create(output)
  }
  outputdirs = file.path(output,
                         c("AAProcess",
                           "IDswop",
                           "Equaliser",
                           "AALoess"))
  lapply(outputdirs, dir.create)
  agilp::AAProcess(input = input, output = paste0(output,"/AAProcess/"), s = 9)
  agilp::IDswop(input = paste0(output,"/AAProcess/"), output = paste0(output,"/IDswop/"), annotation = annotation_file, source_ID = source_ID, target_ID=target_ID, ERR=ERR)
  agilp::Equaliser(input = paste0(output,"/IDswop/"), output = paste0(output,"/Equaliser/"))
  samples <- data.frame(raw_files = dir(input),
                        AAProcess = dir(paste0(output,"/AAProcess/")),
                        IDswop = dir(paste0(output,"/IDswop/")),
                        Equaliser = dir(paste0(output,"/Equaliser/")))
  write.table(samples,file = file.path(output,"samples.txt"),sep="\t",col.names=TRUE,row.names=TRUE)

  agilp::Baseline(NORM=NORM,allfiles="TRUE",r="Equaliser",A=2,B=B+1,input=paste0(output,"/Equaliser/"), baseout=file.path(output,"baseline.txt"), t = file.path(output,"samples.txt"))
  agilp::AALoess(input=paste0(output,"/Equaliser/"),
                 output=paste0(output,"/AALoess/"),
                 baseline = file.path(output,"baseline.txt"), LOG="TRUE")
  samples <- data.frame(raw_files = dir(input),
                        AAProcess = dir(paste0(output,"/AAProcess/")),
                        IDswop = dir(paste0(output,"/IDswop/")),
                        AALoess = dir(paste0(output,"/AALoess/"), pattern = "ns_"))
  write.table(samples,file = file.path(output,"samples.txt"),sep="\t",col.names=FALSE,row.names=TRUE, quote = FALSE)
  agilp::Loader(input=paste0(output,"/AALoess/"),output=output,t=file.path(output,"samples.txt"),f="FALSE",r=5,A=1,B=B)
  unlink(file.path(output), recursive = TRUE)
}

