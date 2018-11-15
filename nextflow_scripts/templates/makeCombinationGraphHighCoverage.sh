#!/bin/bash

######################################################################################################################################################################################
# Script make combination graph Cortex #
######################################################################################################################################################################################

#Assign variables to make index
filePath=${colorList}
fileIndex=\${filePath: -1}

# Cortex command

${params.cortexDirMakeCombinationGraphHighCoverage} ${params.cortexConfigMakeCombinationGraph} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph\${fileIndex}.ctx --colour_list ${colorList} > makeCombinationGraph\${fileIndex}.log


