#!/bin/bash


######################################################################################################################################################################################
# Script to run step 1 Cortex #
######################################################################################################################################################################################



# Cortex command

${params.cortexDirStep12and4} ${params.cortexConfigStep1} --sample_id ${samplePairFileName} --dump_binary ${params.resultsDir}/productsOfStep1/${samplePairFileName}.ctx --dump_covg_distribution ${params.resultsDir}/productsOfStep1/${samplePairFileName}.ctx.covg --se_list ${params.resultsDir}/samplesForStep1/${samplePairFileName} --quality_score_threshold ${params.quality_score_threshold} > LogStep1_${samplePairFileName}.log


# Flag for control flow

echo "" > runStep1CortexDone.flag


