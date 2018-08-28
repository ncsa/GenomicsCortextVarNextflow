#!/bin/bash

######################################################################################################################################################################################
# Script to run step 4 to make reference Graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirStep4} ${params.cortexConfigStep4} --sample_id referenceSoybean --se_list ${params.pathToReferenceList} --dump_binary ${params.resultsDir}/productsOfStep4/ref.ctx > step4MakeReferenceDBGraph.log






