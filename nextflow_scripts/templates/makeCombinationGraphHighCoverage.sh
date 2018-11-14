#!/bin/bash

######################################################################################################################################################################################
# Script make combination graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirMakeCombinationGraphHighCoverage} ${params.cortexConfigMakeCombinationGraph} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph${index}.ctx --colour_list ${params.resultsDir}/makeCombinationGraphInput/colorlistFileToSubmit${index} > makeCombinationGraph.log


