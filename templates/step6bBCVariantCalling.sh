#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 Bubble Caller Cortex #
######################################################################################################################################################################################

# Assigns FAN as variable for fileNameAndNumber, necessary for string manipulation in shell script for nextflow

FAN=${fileNameAndNumber}

# Cortex command

${params.cortexDirStep5and6} ${params.cortexConfigStep6} --max_var_len 50000 --multicolour_bin ${params.resultsDir}/productsOfStep5/finalCombinationGraphWithRef.ctx --detect_bubbles 0/\${FAN#*+} --output_bubbles ${params.resultsDir}/productsOfStep6/step6_BubbleCaller\${FAN%+*}.out --print_colour_coverages > ${fileNameAndNumber}_BC.log 

# Flag for control flow

echo "" > runStep6BCCortexDone.flag

