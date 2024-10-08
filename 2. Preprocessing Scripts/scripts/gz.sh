path=$1
ref=$2
sample=$3


echo ${sample}

ln -s ${path}/${sample}_R1.fq.gz ./01.rawdata/${sample}_R1.fq.gz
ln -s ${path}/${sample}_R2.fq.gz ./01.rawdata/${sample}_R2.fq.gz

cd 01.rawdata/
nohup fastqc ${sample}_R1.fq.gz 2>&1 > ../log/fastqc_log.log &
nohup fastqc ${sample}_R2.fq.gz 2>&1 > ../log/fastqc_log.log &
reachtools combine3 ${sample} 
zcat ${sample}_combined.fq.gz | bowtie $ref - --norc -m 1 -v 1 -p 1 -S ${sample}_BC.sam
ca232.count_Cell_ID_counts.pl ${sample}_BC.sam & ### optional script to count ID reads counts
reachtools convert2 ${sample}_BC.sam
rm ${sample}_BC.sam


