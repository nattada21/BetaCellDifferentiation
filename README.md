# BetaCellDifferentiation

1. Data Collection
   - Used Paired-Tag Protocol
   - Antibodies Used: H3K27me3 & H3K27ac
   - Original Protocol: ​​https://protocolexchange.researchsquare.com/article/pex-1301/v1 
3. Pre-Processing
   - Original Preprocessing Pipeline: https://github.com/cxzhu/Paired-Tag/?tab=readme-ov-file
     1. QC
        - [ ] Create working directory
        - [ ] Create directory named “01.rawdata” in working directory and add raw fasta files
        - [ ] Have Paired Tag Pre-processing scripts in the working directory
        - [ ] You will have to edit the scripts to include the path to your references and DNA/RNA pairs
        - [ ] First run fastqc in the "01.rawdata" directory
        - [ ] Then run step1 script on each DNA/RNA pair
     3. Merged Matrix
5. Seurat
   - Run Seurat script using the matrix file to create the Seurat object
   - Adjust script as needed
   - Save seurat object as .RDS after
   - Link to Seurat Manual: https://satijalab.org/seurat/articles/pbmc3k_tutorial
   - Installation: https://satijalab.org/seurat/articles/install_v5 
6. Cell Type Annotation
7. NMF
8. Homer
9. GREAT Go Term Enrichment Analysis
10. ChromHMM
