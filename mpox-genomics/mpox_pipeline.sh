#!/bin/bash

echo "Starting Mpox pipeline..."

# Quality Control
fastqc *.fastq.gz

# Trimming
fastp -i input_R1.fastq.gz -I input_R2.fastq.gz -o trimmed_R1.fastq.gz -O trimmed_R2.fastq.gz

# Mapping
bwa mem ref.fasta trimmed_R1.fastq.gz trimmed_R2.fastq.gz | samtools sort -o output.bam

# Index BAM
samtools index output.bam

# Variant Calling
freebayes -f ref.fasta output.bam > variants.vcf

# Consensus sequence
bcftools consensus -f ref.fasta variants.vcf > consensus.fasta

echo "Pipeline completed"
