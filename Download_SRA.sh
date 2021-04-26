#!/bin/sh

##########################################################
###  	Title: z.Download_SRA.sh  						
### 	Author: Tonia Schwartz (Modified by Nick Bailey)
###		Date: January, 2021 (last modified on 4-26-21)
###		BIOL6950: Functional Genomics, Auburn University
###		Purpose: Learn to make scratch director, move files, and download data from NCBI SRA
##############################################################################################

source /opt/asn/etc/asn-bash-profiles-special/modules.sh
module load sra/2.9.2

### make variable for your ASC ID so the directories are automatically made in YOUR director

MyID=aubclsa0102

##### Define that directory a variable

DATADIR=/scratch/${MyID}/Arctoides

######  make the directories in SCRATCH for holding the raw data
mkdir -p ${DATADIR}

# change to your data directory, where you want to download your data

cd ${DATADIR}

##########  Download data files from NCBI: SRA using the Run IDs
### from SRA use the SRA tool kit - see NCBI
	# this downloads the SRA file and converts to fastq
	# -v 	Verbose, give as much detail as possible
	# -e 	Specify number of threads
	# -S 	Split reads if they are paired

fasterq-dump -v -e 4 -S SRR6322627
fasterq-dump -v -e 4 -S SRR2029580
fasterq-dump -v -e 4 -S SRR2029579
