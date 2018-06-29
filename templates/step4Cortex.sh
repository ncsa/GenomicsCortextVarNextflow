#!/bin/bash

######################################################################################################################################################################################
# Script to run step 4 Cortex #
######################################################################################################################################################################################

# Cortex command

${cortexDirStep12and4} ${cortexConfig} --sample_id referenceSoybean --se_list ${sampleDir}/referenceSoybeanList --dump_binary ${resultsDir}/productsOfStep4/ref.ctx

# Flag for control flow

echo "" > runStep4CortexDone.flag


