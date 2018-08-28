#!/bin/bash

######################################################################################################################################################################################
# Script to run step 5 make combination graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirStep5} ${params.cortexConfigStep5} --dump_binary ${params.resultsDir}/productsOfStep5/finalCombinationGraph.ctx --colour_list ${params.resultsDir}/samplesForStep5/colorlist_step5FileToSubmitToCortex > step5MakeCombinationGraph.log


