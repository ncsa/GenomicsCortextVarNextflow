#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 Bubble Caller Cortex, these variants are called against pool, not reference, but combination graph has ref in it #
######################################################################################################################################################################################

# Assigns FAN as variable for fileNameAndNumber, necessary for string manipulation in shell script for nextflow

FAN=${fileNameAndNumber}

SAMPLENAME=\${FAN%+*}
SAMPLENUMBER=\${FAN#*+}

# Cortex command

${params.cortexDirStep6WithRef} ${params.cortexConfigStep6} --max_var_len 50000 --multicolour_bin ${params.resultsDir}/productsOfStep5/finalCombinationGraph.ctx --detect_bubbles1 0/\${SAMPLENUMBER} --output_bubbles ${params.resultsDir}/productsOfStep6/step6_BubbleCaller\${SAMPLENAME}.out --print_colour_coverages > step6_${fileNameAndNumber}_BC.log 





