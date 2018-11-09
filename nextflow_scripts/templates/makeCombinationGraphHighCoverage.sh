#!/bin/bash

######################################################################################################################################################################################
# Script make combination graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirMakeCombinationGraphHighCoverage} ${params.cortexConfigMakeCombinationGraph} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph.ctx --colour_list ${params.resultsDir}/makeCombinationGraphInput/colorlistFileToSubmit > makeCombinationGraph.log


