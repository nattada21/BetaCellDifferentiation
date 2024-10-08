prefix_dna = DNA01 ### prefix for DNA fastq file, in ${prefix_dna}_R1.fq.gz and ${prefix_dna}_R2.fq.gz format
prefix_rna = RNA01 ### prefix for RNA fastq file, in ${prefix_rna}_R1.fq.gz and ${prefix_rna}_R2.fq.gz format

sh per_run.sh Pre_gz $prefix_dna $prefix_rna  ### preprocessing step