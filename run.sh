###############################################################################
################################ SCRIPT BELOW: ################################
###############################################################################

# DIRECTORIES REQUIRED BEFORE RUNNING THE SCRIPT:
# files (Containing gzip'd fastq read files) [example below]:
# 	349-2_S8_R1_001.fastq.gz  NG-2_S9_R1_001.fastq.gz
# input_files (Containing FASTA and GFF3 reference sequences and annotations, respectively) [all files below]:
# 	349.fasta  349.gff3  373.fasta  373.gff3  451.fasta  451.gff3  980.fasta  980.gff3  EA.fasta  EA.gff3  NG.fasta  NG.gff3  pACYC.fasta  pACYC.gff3

# NEW DIRECTORIES
mkdir trimout
mkdir trimsummaries
mkdir references
mkdir samout
mkdir counts

# TRIM READS
cd files

for i in *.gz; do
        name=`basename $i | cut -d "." -f1`	
        trimmomatic SE -threads 10 -phred33 -summary ../trimsummaries/${name}-summary.txt ${i} ../trimout/${name}-reads.fastq.gz LEADING:10 TRAILING:10
done ;

cd ../trimout/
for i in *.gz; do
     gunzip ${i}

done ;

cd ..


# CREATE REFERENCES FOR MAPPING
hisat2-build ./input_files/349.fasta ./references/349
hisat2-build ./input_files/373.fasta ./references/373
hisat2-build ./input_files/451.fasta ./references/451
hisat2-build ./input_files/980.fasta ./references/980
hisat2-build ./input_files/NG.fasta ./references/NG

# MAP READS
cd trimout

for i in *.fastq; do
        ref=`basename $i | cut -d "-" -f1`
        name=`basename $i | cut -d "." -f1`
        echo ${ref}
        echo ${name}
        echo ${i}
        hisat2 -p 20 -x ../references/${ref} -U ${name}.fastq -S ../samout/${name}.sam -p 44 --no-unal
done ;

cd ..

# COUNT READS
cd trimout
for i in *.fastq; do

        ref=`basename $i | cut -d "-" -f1`

        name=`basename $i | cut -d "." -f1`

        echo ${ref}

        echo ${name}

        echo ${i}

        htseq-count ../samout/${name}.sam ../input_files/${ref}.gff3 > ../counts/${name}.txt --idattr ID --stranded no --type gene

done ;

cd ..
