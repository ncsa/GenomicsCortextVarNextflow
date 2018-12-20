#!/bin/bash

module load python-2.7.9

sample="/projects/bioinformatics/DaveStuff/development_and_testing_individual_variant_calling/test_results/variantCallingOutput/Sample_Magellan_pd_calls"
processCalls="/projects/bioinformatics/builds/CORTEX_release_v1.0.5.21/scripts/analyse_variants/process_calls.pl"
logFile="/projects/bioinformatics/DaveStuff/development_and_testing_individual_variant_calling/test_results/logs/variantCallingLogs/PDLogs/Sample_Magellan_PD.log"
outDir="/projects/bioinformatics/DaveStuff/development_and_testing_individual_variant_calling/makeVCF"
colorNumber="3"
stampyExecutable="/projects/bioinformatics/builds/stampy-1.0.32/stampy.py"
stampyHashProducts="/projects/bioinformatics/DaveStuff/Cortex_workflow_development/makeVCFs/stampyFiles/ref"
VCFToolsDir="/projects/bioinformatics/builds/vcftools_0.1.8a"
variantCallerMethod="PD" #PD for Path Divergence or BC for bubble caller
kmerSizeUsed=63
referenceColor=0
referenceFastaFile="/projects/bioinformatics/HudsonSoybeanProject/SoybeanAssemblyOnCortex/Workflow_auto/stampy_hash/Glycine_max/GCF_000004515.4_Glycine_max_v2.0.AllChromo.fa"
ploidy=2

$processCalls --callFile $sample --callfile_log $logFile --outvcf Sample_Magellan_pd_calls --outdir $outDir/Sample_Magellan --samplename_list /projects/bioinformatics/DaveStuff/development_and_testing_individual_variant_calling/makeVCF/sample_list_file.txt --num_cols $colorNumber --stampy_bin $stampyExecutable --stampy_hash $stampyHashProducts --vcftools_dir $VCFToolsDir --caller $variantCallerMethod --kmer $kmerSizeUsed --refcol $referenceColor --ploidy $ploidy --ref_fasta $referenceFastaFile


