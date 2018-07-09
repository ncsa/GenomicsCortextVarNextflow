#!/bin/bash

######################################################################################################################################################################################
# Script to run step 5 Cortex #
######################################################################################################################################################################################

# Cortex command

${cortexDirStep5and6} ${cortexConfig} --dump_binary ${resultsDir}/productsOfStep5/finalCombinationGraphWithRef.ctx --colour_list ${resultsDir}/samplesForStep5/colorlist_step5FileToSubmitToCortex


#/projects/bioinformatics/builds/CORTEX_release_v1.0.5.21_matt_k/bin/cortex_var_63_c4 --kmer_size 63 --mem_height 25 --mem_width 75 --colour_list /projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/testingStep1to6/results/samplesForStep5/colorlist_step5FileToSubmitToCortex --dump_binary  /projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/testingStep1to6/results/productsOfStep5/dumpingStep5.ctx






# Flag for control flow

echo ""  > runStep5CortexDone.flag


