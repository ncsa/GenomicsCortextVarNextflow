#!/bin/bash

######################################################################################################################################################################################
# Script to run step 2 Cortex #
######################################################################################################################################################################################



# Cortex command

${cortexDirStep12and4} ${cortexConfig} --dump_binary ${resultsDir}/productsOfStep2/step2PoolCleaned.ctx --dump_covg_distribution ${resultsDir}/productsOfStep2/step2PoolCleaned.ctx.covg --colour_list ${resultsDir}/samplesForStep2/step2PathToBinaryListFile --remove_low_coverage_supernodes 1

# Flag for control flow

echo "" > runStep2CortexDone.flag

