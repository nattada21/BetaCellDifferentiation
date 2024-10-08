s=$1
cd 01.rawdata
trim_galore ${s}_BC_cov.fq.gz
trim_galore -a AAAAAAAAAAAAAAAACCTGCAGGNNNNNNNNNN ${s}_BC_cov_trimmed.fq.gz
mv ${s}_BC_cov_trimmed.fq.gz ../02.trimmed
mv ${s}_BC_cov_trimmed_trimmed.fq.gz ../02.trimmed
cd ../02.trimmed
STAR  --runThreadN 8 --genomeDir /projects/ps-renlab/chz272/genome_ref/refdata-cellranger-mm10-3.0.0/star/ --readFilesIn ${s}_BC_cov_trimmed_trimmed.fq.gz --readFilesCommand zcat --outFileNamePrefix ${s}_mm10_ --outSAMtype BAM Unsorted
mv ${s}_mm10_Aligned.out.bam ../03.mm10_mapping
cd ../03.mm10_mapping
samtools view -h -F 256 ${s}_mm10_Aligned.out.bam -b > ${s}\_clean.bam
samtools sort ${s}\_clean.bam -o ${s}_mm10_sorted.bam
reachtools rmdup2 ${s}_mm10_sorted.bam
reachtools bam2Mtx2 ${s}_mm10_sorted_rmdup.bam mm10
mv ${s}*mtx2 ../04.matrices
