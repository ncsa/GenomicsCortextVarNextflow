#!/bin/bash


######################################################################################################################################################################################
# Script to make DB graph for each sample using cortex_var #
######################################################################################################################################################################################



# Cortex command

${params.cortexDirStep1} ${params.cortexConfigStep1} --sample_id ${samplePairFileName} --dump_binary ${params.resultsDir}/makeSampleGraphOutput/${samplePairFileName}.ctx --dump_covg_distribution ${params.resultsDir}/makeSampleGraphOutput/${samplePairFileName}.ctx.covg --se_list ${params.resultsDir}/makeSampleGraphInput/${samplePairFileName} --quality_score_threshold ${params.quality_score_threshold} > makeSampleDeBruijnGraph_${samplePairFileName}.log







