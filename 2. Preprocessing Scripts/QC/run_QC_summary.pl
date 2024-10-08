#!/usr/bin/perl
use strict;
use warnings;


system("mkdir Paired-Tag_QC_reports");
open IN, "QC_library_list.xls" or die $!;
 my $first;
 my $last;
 my $i = 0;
 while(<IN>){
 	chomp;
 	$i++;
 	my @tmp = split/\s+/, $_;
 	my $dna = $tmp[0];
 	my $rna = $tmp[1];
 	$first=$dna if $i==1;
 	$last=$rna;
 	my $gen = $tmp[2];
 	my $output = "Per_lib_QC_".$dna."_".$rna.".html";
 	my $command = "Rscript -e \"rmarkdown::render(\'per_library_QC.Rmd\', params=list(dna.id=\'$dna\', rna.id=\'$rna\', genome=\'$gen\'), output_file=\'$output\')\"";
 	system($command);
}
close IN;

my $command = "Rscript -e \"rmarkdown::render(\'summary_QC.Rmd\', output_file=\'Paired-Tag_project_summary.html\')\"";
system($command);


system("mv *html Paired-Tag_QC_reports");
system("rm -rf *fastqc");

