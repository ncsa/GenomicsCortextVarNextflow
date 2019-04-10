#!/bin/bash

######################################################################################################################################################################################
# Script make combination graph Cortex #
######################################################################################################################################################################################

#Assign variables to make index
prefix=colorlistFileToSubmit
colorListFile=${colorList}
fileIndex=\${colorListFile#*\${prefix}}

# Cortex command

${params.cortexDirMakeCombinationGraph} ${params.makeCombinationGraphCortexConfig} --dump_binary ${params.resultsDir}/makeCombinationGraphOutput/combinationGraph\${fileIndex}.ctx --colour_list ${colorList} > ${params.logDir}/combinationGraphLogs/makeCombinationGraph\${fileIndex}.log


