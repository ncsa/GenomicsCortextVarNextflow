#!/bin/bash

######################################################################################################################################################################################
# Script to run step 2 Cortex #
######################################################################################################################################################################################



# Cortex command

${params.cortexDirStep12and4} ${params.cortexConfigStep2} --dump_binary ${params.resultsDir}/productsOfStep2/step2PoolCleaned.ctx --dump_covg_distribution ${params.resultsDir}/productsOfStep2/step2PoolCleaned.ctx.covg --colour_list ${params.resultsDir}/samplesForStep2/step2PathToBinaryListFile --remove_low_coverage_supernodes 1 > LogStep2.log

# Flag for control flow

echo "" > runStep2CortexDone.flag

