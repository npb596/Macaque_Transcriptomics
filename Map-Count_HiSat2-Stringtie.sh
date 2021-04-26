#!/bin/sh
 
############################################################################################
###   Title: z.MapCount_HiSat2Stringtie.sh             
###   Author: Tonia Schwartz (Modified by Nick Bailey)
###   Date: Feb, 2021 (Last modified on 4-26-21)
###   BIOL6950: Functional Genomics, Auburn University
###   Purpose: Gain Experience on how to use map data to a reference genome
###            Gain Experience reading program manuals.
##############################################################################################

module load hisat2/2.0.5
module load stringtie/1.3.3
module load python/2.7.1
module load gcc/9.3.0
module load samtools/1.11
#module load bcftools/1.2
module load gffread/
module load gffcompare/

  # Define DATADIR to be where the input files are
DATADIR=/scratch/aubclsa0102/Arctoides   #   *** This is where the cleaned paired files are located
REFDIR=/scratch/aubclsa0102/Arctoides/Reference_files                        # this directory contains the indexed reference genome for the pig-tail macaque
OUTDIR=/scratch/aubclsa0102/Arctoides
COUNTSDIR=/scratch/aubclsa0102/Arctoides/counts
RESULTSDIR=/home/aubclsa0102/Arctoides

REF=GCF_000956065.1_Mnem_1.0_genomic ## This is what the "easy name" will be for the genome

##################  Prepare the Reference Index for mapping with HiSat2   #############################
 
######  Move to $REFDIR
cd $REFDIR

###  Identify exons and splice sites
gffread $REF.gff -T -o $REF.gtf
extract_splice_sites.py $REF.gtf > $REF.ss
extract_exons.py $REF.gtf > $REF.exon

#### Create a HISAT2 index
hisat2-build --ss ${REFDIR}/${REF}.ss --exon ${REFDIR}/${REF}.exon ${REFDIR}/${REF}.fna ${REFDIR}/${REF}_index

########################  Map and Count the Data using HiSAT2 and StringTie  ########################

# Move to the data directory
cd $DATADIR   #### This is where our clean paired reads are located.

## Create list of fastq files to map    Example file format: SRR629651_1_paired.fastq
# grab all fastq files, cut on the underscore, use only the first of the cuts, sort, use unique put in list
ls | grep ".fastq" |cut -d "_" -f 1| sort | uniq > list    #should list Example: SRR629651

while read i;
do

  ## HiSat2 is the mapping program
  #  -p indicates number ofprocessors, --dta reports alignments for StringTie --rf is the read orientation
  hisat2 -p 6 --dta --phred33       \
    -x ${REFDIR}/${REF}_index       \
    -1 ${i}_1_paired.fastq  -2 ${i}_2_paired.fastq      \
    -S ${i}.sam

    ### view: convert the SAM file into a BAM file  -bS: BAM is the binary format corresponding to the SAM text format.
    ### sort: convert the BAM file to a sorted BAM file.

samtools view -@ 6 -b ${i}.sam > ${i}.bam  ### This works on ASC

samtools sort -@ 6 ${i}.bam > sorted.${i}.bam

# Index the BAM and get stats
#samtools flagstat -@ 6 sorted.${i}.bam > ${i}_Stats.txt

  ### Stringtie is the program that counts the reads that are mapped to each gene, exon, transcript model. 
  ### Original: This will make transcripts using the reference geneome as a guide for each sorted.bam
  # eAB options: This will run stringtie once and  ONLY use the Ref annotation for counting readsto genes and exons 

mkdir -p ${COUNTSDIR}/${i}

stringtie -p 6 -e -B -G ${REFDIR}/${REF}.gtf -o ${i}.gtf -l ${i} sorted.${i}.bam

mv ${i}.gtf ${COUNTSDIR}/${i}/
mv *ctab ${COUNTSDIR}/${i}/

done<list

#####################  Copy Results to home Directory.  These will be the files you want to bring back to your computer.
### these are your stats files from Samtools
#cp *.txt $RESULTSDIR
### The PrepDE.py is a python script that converts the files in your ballgown folder to a count matrix
 python /home/aubtss/class_shared/scripts/PrepDE.py /scratch/aubtss/GarterSnakeProject/ballgown. 
#cd ..
python /home/aubclsa0102/class_shared/scripts/PrepDE.py $COUNTSDIR
#cp *.csv $RESULTSDIR
