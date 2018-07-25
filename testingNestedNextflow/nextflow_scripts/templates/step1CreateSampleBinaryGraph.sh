#!/bin/bash


######################################################################################################################################################################################
# Script to run step 1 to make DB graph for each sample using cortex_var #
######################################################################################################################################################################################



# Cortex command

${params.cortexDirStep1} ${params.cortexConfigStep1} --sample_id ${samplePairFileName} --dump_binary ${params.resultsDir}/productsOfStep1/${samplePairFileName}.ctx --dump_covg_distribution ${params.resultsDir}/productsOfStep1/${samplePairFileName}.ctx.covg --se_list ${params.resultsDir}/samplesForStep1/${samplePairFileName} --quality_score_threshold ${params.quality_score_threshold} > step1CreateSampleBinaryGraph_${samplePairFileName}.log







