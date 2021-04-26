# Abstract
Hybridization between populations can have a variety of effects on their evolutionary trajectory. In this study I examine one possible outcome of hybridization, the evolution of a trait in a putative hybrid species due to a combination of genetic material from the putative parental species. I do this by examining blood transcriptomes from three species of macaques, the putative hybrid and parentals. Here I compare expression profiles of genital development genes between different species comparisons and in reference to random sets of other annotated genes. I find that the genital genes do have significantly different expression between the putative parental species and that one genital development gene, SOX13, exhibits a distinct expression profile in the putative hybrid species.


# Transcriptome Processing
The shell scripts in this repository are used for downloading, quality checking, and mapping a set of macaque transcriptomes. The scripts have comments contained within signifying what they do so I will only briefly point out here that they should be run in this order: Download_SRA.sh, Trim1.sh and Map-Count_HiSat2-Stringtie.sh. Some commands in this scripts can be run individually on a command-line with little memory or processing power.

# Stat Analysis
The sole R script provided should be able to replicate all stat analyses and figures presented in my final paper for the class (alongside some extra steps taken in bash that are stated in the comments to this script).