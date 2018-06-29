#!/bin/bash


######################################################################################################################################################################################
# Script to run step 1 Cortex #
######################################################################################################################################################################################



# Cortex command

${cortexDirStep12and4} ${cortexConfig} --sample_id ${samplePairFileName} --dump_binary ${resultsDir}/productsOfStep1/${samplePairFileName}.ctx --dump_covg_distribution ${resultsDir}/productsOfStep1/${samplePairFileName}.ctx.covg --se_list ${resultsDir}/samplesForStep1/${samplePairFileName} --quality_score_threshold ${quality_score_threshold}


# Flag for control flow

echo "" > runStep1CortexDone.flag


