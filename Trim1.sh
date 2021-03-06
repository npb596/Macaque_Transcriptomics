#!/bin/sh

############################################################################################
###  	Title: z.Trim1.sh 						
### 	Author: Tonia Schwartz (Modified by Nick Bailey)
###		Date: January, 2021 (Last modified 4-26-21)
###		BIOL6950: Functional Genomics, Auburn University
###		Purpose: Demonstrate how to use Trimmomatic to clean NGS data - on one file. 
###              Demonstrate how to concatenate data if it had been broken up in multiple files, or multiple runs. 
### 			 Demonstrate another use of variables
##############################################################################################

### Load the modules you need to use
source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load fastqc/0.10.1
module load trimmomatic/0.38

### Define variable for directories and define array for samples from csv file.
DATADIR=/scratch/aubclsa0102/Arctoides
WORKDIR=/scratch/aubclsa0102/Arctoides
OUTDIR=/scratch/aubclsa0102/Arctoides

samples=(`awk -F, '{print $1}' ~/Transcriptomes_RunInfo.csv`)
 
### Go to the working directoru, copy an adapter file here and loop through the samples

cd $WORKDIR

cp /home/aubclsa0102/class_shared/AdaptersToTrim_All.fa .

for x in ${samples[@]}; do

############  Trim read for quality when quality drops below Q30 and remove sequences shorter than 25 bp
## PE for paired end phred-score-type  R1-Infile   R2-Infile  R1-Paired-outfile R1-unpaired-outfile R-Paired-outfile R2-unpaired-outfile  Trimming paramenter
## MINLEN:<length> #length: Specifies the minimum length of reads to be kept.
## SLIDINGWINDOW:<windowSize>:<requiredQuality>  #windowSize: specifies the number of bases to average across  
## requiredQuality: specifies the average quality required.

java -jar /mnt/beegfs/home/aubmxa/.conda/envs/BioInfo_Tools/share/trimmomatic-0.39-1/trimmomatic.jar PE -threads 6 -phred33 \
	${x}_1.fastq ${x}_2.fastq \
	${x}_1_paired.fastq ${x}_1_unpaired.fastq 	\
	${x}_2_paired.fastq ${x}_2_unpaired.fastq 	\
	ILLUMINACLIP:AdaptersToTrim_All.fa:1:35:20 LEADING:20 TRAILING:20 SLIDINGWINDOW:5:30 MINLEN:25

done

### Run fastqc on the cleaned paired files

fastqc -t 6 *paired.fastq
