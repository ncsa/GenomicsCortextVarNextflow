#!/bin/bash

######################################################################################################################################################################################
# Script make combination graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirMakeCombinationGraphLowCoverage} ${params.cortexConfigMakeCombinationGraph} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph.ctx --colour_list ${params.resultsDir}/makeCombinationGraphInput/colorlistFileToSubmit > makeCombinationGraph.log


