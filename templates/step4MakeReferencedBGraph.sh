#!/bin/bash

######################################################################################################################################################################################
# Script to run step 4 Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirStep12and4} ${params.cortexConfigStep4} --sample_id referenceSoybean --se_list ${params.sampleDir}/referenceSoybeanList --dump_binary ${params.resultsDir}/productsOfStep4/ref.ctx > LogStep4.log

# Flag for control flow

echo "" > runStep4CortexDone.flag


