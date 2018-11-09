#!/bin/bash


######################################################################################################################################################################################
# Script to run step 3 to clean graph per sample using Cortex_Var #
######################################################################################################################################################################################


# Cortex command

${params.cortexBinCleanGraphPerSampleHighCoverage} ${params.cortexConfigCleanGraphPerSample} --multicolour_bin ${params.resultsDir}/makeSampleGraphOutput/${samplePairFileName}.ctx --remove_low_coverage_supernodes 1 --dump_binary ${params.resultsDir}/cleanGraphPerSampleFolder/${samplePairFileName}_cleanedIndividually.ctx --dump_covg_distribution ${params.resultsDir}/cleanGraphPerSampleFolder/${samplePairFileName}_cleanedIndividually.ctx.covg > cleanGraphPerSample${samplePairFileName}.log
 

