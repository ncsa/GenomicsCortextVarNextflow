#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 PATH DIVERGENCE Cortex #
######################################################################################################################################################################################

# Assigns FAN as variable for fileNameAndNumber, necessary for string manipulation in shell script for nextflow

FAN=${fileNameAndNumber}

SAMPLENAME=\${FAN%+*}
SAMPLENUMBER=\${FAN#*+}

# Cortex command

${params.cortexDirStep6WithRef} ${params.cortexConfigStep6} --max_var_len 50000 --multicolour_bin ${params.resultsDir}/productsOfStep5/finalCombinationGraph.ctx --path_divergence_caller \${SAMPLENUMBER} --ref_colour 0 --list_ref_fasta ${params.sampleDir}/referenceSoybeanList --path_divergence_caller_output ${params.resultsDir}/productsOfStep6/step6_PathDivergence\${SAMPLENAME}.out --print_colour_coverages > step6_${fileNameAndNumber}_PD.log

