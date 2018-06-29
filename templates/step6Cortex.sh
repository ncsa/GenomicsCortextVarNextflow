#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 PATH DIVERGENCE Cortex #
######################################################################################################################################################################################

# Assigns FAN as variable for fileNameAndNumber, necessary for string manipulation in shell script for nextflow

FAN=${fileNameAndNumber}

# Cortex command

${cortexDirStep5and6} ${cortexConfig} --max_var_len 50000 --multicolour_bin ${resultsDir}/productsOfStep5/finalCombinationGraphWithRef.ctx --path_divergence_caller \${FAN#*+} --ref_colour 0 --list_ref_fasta ${sampleDir}/referenceSoybeanList --path_divergence_caller_output ${resultsDir}/productsOfStep6/step6_PathDivergence\${FAN%+*}.out --print_colour_coverages

# Flag for control flow

echo "" > runStep6CortexDone.flag
