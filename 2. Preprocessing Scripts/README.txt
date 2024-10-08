### README
### Paired-Tag V2 processing pipeline


1. download references and code from: https://github.com/cxzhu/Paired-Tag
2. compile the "reachtools" as in the README of github.
3. build cell barcode reference as in the README of github.
4. modify the environment variables in per_run.sh, line 20-38.

5. soft link DNA and RNA fastq files in "./01.rawdata/" folder, in the format of "DNA01_R1.fq.gz", "DNA01_R2.fq.gz", "RNA01_R1.fq.gz", and "RNA01_R2.fq.gz"
6. "run01.step1.sh" is the script for running a single sub-library. Modify it to adopt the task management system in your own computing platform for processing multiple sub-libraries.

This will give the invidual bam files and matrices files (in Matrix Market file format). You can optionally use the scripts as in github to perform merging of matrices or use your preferred tools.


[optional] generating QC report
7. in "./QC/QC_library_list.xls", change them with the paired DNA-RNA sub-libraries prefixes. You don't need to change the 3rd and 4th column (in the 3rd column, it must be "mm10", and in 4th column, could be any information).
8. Once step 6 finished, "run02.step2.sh" can generate the QC report. Several R packages are needed for this optional report, including: rmarkdown, knitr, varhandle, png, Matrix