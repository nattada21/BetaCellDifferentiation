argv=$1 ### argv can be QC Pre DNA RNA

### all fastq file should in name or symbol link of ${prefix}${id}_R1.fq.gz/${prefix}${id}_R2.fq.gz form
### e.g.
### CZ565_R1.fq.gz
### CZ565_R2.fq.gz
### in the $path path

path="01.rawdata"
#sample_id=`seq 91 106`
#sample_prefix=YX
#DNA_id=`seq 91 98`
#RNA_id=`seq 99 106`
sample_prefix=""
DNA_id=$2
RNA_id=$3
sample_id="${DNA_id} ${RNA_id}"


### set your own environment
alias reachtools=/gpfs/commons/groups/zhu_lab/nattada/Paired-Tag-master/reachtools/reachtools

## path to your hg38 bwt2 path
mm10_bwt2_ref=/gpfs/commons/groups/zhu_lab/czhu/genome_references/hg38/hg38

## path to your hg38 STAR path for RNA mapping
mm10_STAR_ref=/gpfs/commons/groups/zhu_lab/czhu/genome_references/STAR/hg38

#download from github: https://raw.githubusercontent.com/cxzhu/Paired-Tag/master/refereces/hg38.bin5k.txt
mm10_5k_bin_ref=/gpfs/commons/groups/zhu_lab/nattada/Paired-Tag-master/refereces/hg38.bin5k.txt

## download from github: https://raw.githubusercontent.com/cxzhu/Paired-Tag/master/refereces/hg38.RNA.txt
mm10_gene_matrix_ref=/gpfs/commons/groups/zhu_lab/nattada/Paired-Tag-master/refereces/hg38.RNA.txt

## download from github: https://raw.githubusercontent.com/cxzhu/Paired-Tag/master/refereces/cell_id_full_407.fa
## and build an index with bowtie (bowtie1)
cell_id_ref=/gpfs/commons/groups/zhu_lab/czhu/genome_references/cell_id_384/Paired_Tag3_384_ID_ref
### end of custom environment


if [[ $argv == "Pre_bz2" ]]
then
	today=`date +%Y_%m_%d`
#html_path=/projects/ps-renlab/chz272/public_html/2020/${today}/
	for q_path in 01.rawdata log
	do
		if [ ! -d "$q_path" ]
		then
			mkdir $q_path
		fi
	done
	for i in ${sample_id}
	do
		nohup sh scripts/bz2.sh $path $cell_id_ref ${sample_prefix}${i} 2>&1 > log/${sample_prefix}${i}_qc.log
	done
	sh per_run.sh RUN_mm $DNA_id $RNA_id
#mv 01.rawdata/*.html $html_path
elif [[ $argv == "Pre_gz" ]]
then
	today=`date +%Y_%m_%d`
#html_path=/projects/ps-renlab/chz272/public_html/2020/${today}/
	for q_path in 01.rawdata log
	do
		if [ ! -d "$q_path" ]
		then
			mkdir $q_path
		fi
	done
	for i in ${sample_id}
	do
		nohup sh scripts/gz.sh $path $cell_id_ref ${sample_prefix}${i} 2>&1 > log/${sample_prefix}${i}_qc.log
	done
	sh per_run.sh RUN_mm $DNA_id $RNA_id
#	mv 01.rawdata/*.html $html_path
elif [[ $argv == "RUN_mm" ]]
then
	for q_path in 02.trimmed 03.mm10_mapping 04.matrices
	do
		if [ ! -d "$q_path" ]
		then
			mkdir $q_path
		fi
	done

	cd 01.rawdata
	t=0
	for i in $DNA_id
	do
		sample=${sample_prefix}${i}
		t=t+1
		if [ t>8 ]
		then
			wait
			t=0
		fi
		trim_galore ${sample}_BC_cov.fq.gz &
	done
	wait
	for i in $DNA_id
	do
		sample=${sample_prefix}${i}
		mv ${sample}_BC_cov_trimmed.fq.gz ../02.trimmed/
	done
	t=0
	for i in $RNA_id
	do
		sample=${sample_prefix}${i}
		t=t+1
		if [ t>8 ]
		then
			wait
			t=0
		fi
		trim_galore ${sample}_BC_cov.fq.gz &
	done
	wait
	t=0
	for i in $RNA_id
	do
		sample=${sample_prefix}${i}
		t=t+1
		if [ t>8 ]
		then
			wait
			t=0
		fi
		trim_galore -a AAAAAAAAAAAAAAAACCTGCAGGNNNNNNNNNN ${sample}_BC_cov_trimmed.fq.gz &
	done
	wait
	for i in $RNA_id
	do
		sample=${sample_prefix}${i}
		mv ${sample}_BC_cov_trimmed.fq.gz ../02.trimmed/
		mv ${sample}_BC_cov_trimmed_trimmed.fq.gz ../02.trimmed/
	done
	for i in $DNA_id
	do
		cd ../02.trimmed/
		s=${sample_prefix}${i}
		bowtie2 -x $mm10_bwt2_ref -U ${s}_BC_cov_trimmed.fq.gz --no-unal -p 4 -S ${s}_mm10.sam
		mv ${s}_mm10.sam ../03.mm10_mapping/
		cd ../03.mm10_mapping/
		samtools sort ${s}_mm10.sam -o ${s}_mm10_sorted.bam
		reachtools rmdup2 ${s}_mm10_sorted.bam
		rm ${s}_mm10.sam
		reachtools bam2Mtx2 ${s}_mm10_sorted_rmdup.bam $mm10_5k_bin_ref
		mv ${s}*mtx2 ../04.matrices/
	done
	for i in $RNA_id
	do
		cd ../02.trimmed/
		s=${sample_prefix}${i}
		STAR  --runThreadN 4 --genomeDir $mm10_STAR_ref --readFilesIn ${s}_BC_cov_trimmed_trimmed.fq.gz --readFilesCommand zcat --outFileNamePrefix ${s}_mm10_ --outSAMtype BAM Unsorted
		mv ${s}_mm10_Aligned.out.bam ../03.mm10_mapping/
		cd ../03.mm10_mapping
		samtools view -h -F 256 ${s}_mm10_Aligned.out.bam -b > ${s}\_clean.bam
		samtools sort ${s}\_clean.bam -o ${s}_mm10_sorted.bam
		reachtools rmdup2 ${s}_mm10_sorted.bam
		reachtools bam2Mtx2 ${s}_mm10_sorted_rmdup.bam $mm10_gene_matrix_ref
		mv ${s}*mtx2 ../04.matrices/
	done
else
	echo "== Preprocessing pipeline for Paired-seq and Paired-Tag =="
	echo "	nohup sh run.sh [ARGV] & "
	echo "		ARGV:"
	echo "		Pre_bz2		Run pre_processing from bz2 file"
	echo "		Pre_gz		Run pre_processing from gz file"
	echo "		RUN_mm		Run DNA and RNA processing pipeline, mapping to mm10"
#	echo "		RUN_hs		Run DNA and RNA processing pipeline, mapping to hg19"
fi

