# Metabolically-targeted-dCas9-expression-in-bacteria-

Reads were downloaded from Illumina Basespace.  The reads in FASTQ format were trimmed using the program Trimmomatic with the following command:

`trimmomatic SE -threads 10 -phred33 -summary ../trimsummaries/${name}-summary.txt ${i} ../trimout/trimmed-${name}.fastq.gz LEADING:10 TRAILING:10`

This command generates trimmed output FASTQ files, and summary text files.

To generate reference genomes to map the reads to, the program Hisat2 was used, with the following command:

`hisat2-build ./plasmids/Greg_Pellegrino_Plasmids/${samplename}—genomeandplasmid.fasta ./references/${samplename}-genomeandplasmid-ref`

This command, Hisat2-build, takes in a FASTA format file containing both the E. coli genome, and a plasmid. Following this, reads from each sample were mapped to their respective reference genome with Hisat2, using the command:

`hisat2 -p 20 -x ./references/${samplename}-genomeandplasmid-ref -U ./trimout/merged-${samplename}.fastq -S ./gandp-samout/merged-${samplename}.sam -p 44 --no-unal`

This command, Hisat2, takes in the reference genome and FASTQ file, and outputs a SAM file of the mapped reads for each sample.

Following this, the annotation files for the E. coli genome and respective plasmid, all in GFF3 format, were concatenated into single files for use in identifying where the reads map to on the genome and plasmid. To count the number of reads mapping to each annotation in the genome and sample, the program Htseq-count was used with the command:

`htseq-count ./gandp-samout/merged-${samplename}.sam ./plasmids/Greg_Pellegrino_Plasmids/${referencename}-genomeandplasmid.gff3 > ./gandp-samout/merged-${samplename}.txt --idattr ID --stranded no --type gene`

This program takes in the mapped reads (SAM format), the annotation file (GFF3 format), and outputs a text file with information about the number of reads mapping to each feature for each sample.
