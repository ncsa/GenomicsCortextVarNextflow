#!/bin/bash

######################################################################################################################################################################################
# Script to run step 5 make combination graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirStep5} ${params.cortexConfigStep5} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph.ctx --colour_list ${params.resultsDir}/makeCombinationGraphInput/colorlistFileToSubmit > makeCombinationGraph.log


