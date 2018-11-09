#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 Bubble Caller Cortex, these variants are called against pool, not reference, but combination graph has ref in it #
######################################################################################################################################################################################

# Assigns FAN as variable for fileNameAndNumber, necessary for string manipulation in shell script for nextflow

FAN=${fileNameAndNumber}

SAMPLENAME=\${FAN%+*}
SAMPLENUMBER=\${FAN#*+}

# Cortex command

${params.cortexDirVariantCalling} ${params.cortexConfigVariantCalling} --max_var_len 50000 --multicolour_bin ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph.ctx --detect_bubbles1 0/\${SAMPLENUMBER} --output_bubbles ${params.resultsDir}/variantCallingOutput/bubbleCaller\${SAMPLENAME}.out --print_colour_coverages > ${fileNameAndNumber}_BC.log 





