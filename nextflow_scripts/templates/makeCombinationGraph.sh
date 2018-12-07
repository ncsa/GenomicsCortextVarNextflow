#!/bin/bash

######################################################################################################################################################################################
# Script make combination graph Cortex #
######################################################################################################################################################################################

#Assign variables to make index
prefix=colorlistFileToSubmit
colorListFile=${colorList}
fileIndex=\${colorListFile#*\${prefix}}

# Cortex command

${params.cortexDirMakeCombinationGraph} ${params.cortexConfigMakeCombinationGraph} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph\${fileIndex}.ctx --colour_list ${colorList} > ${params.logDir}/makeCombinationGraph\${fileIndex}.log


