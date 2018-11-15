#!/bin/bash

######################################################################################################################################################################################
# Script make combination graph Cortex #
######################################################################################################################################################################################

# Cortex command

echo ${colorList}

${params.cortexDirMakeCombinationGraphHighCoverage} ${params.cortexConfigMakeCombinationGraph} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph\${index}.ctx --colour_list ${colorList} > makeCombinationGraph.log


