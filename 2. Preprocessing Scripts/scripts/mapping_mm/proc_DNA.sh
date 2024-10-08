s=$1
cd 01.rawdata
trim_galore ${s}_BC_cov.fq.gz
mv ${s}_BC_cov_trimmed.fq.gz ../02.trimmed
cd ../02.trimmed
bowtie2 -x /projects/ps-renlab/chz272/genome_ref/mm10/mm10 -U ${s}_BC_cov_trimmed.fq.gz --no-unal -p 8 -S ${s}_mm10.sam
mv ${s}_mm10.sam ../03.mm10_mapping
cd ../03.mm10_mapping
samtools sort ${s}_mm10.sam -o ${s}_mm10_sorted.bam
reachtools rmdup2 ${s}_mm10_sorted.bam
rm ${s}_mm10.sam
reachtools bam2Mtx2 ${s}_mm10_sorted_rmdup.bam mm10_5k
mv ${s}*mtx2 ../04.matrices
