#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 PATH DIVERGENCE Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirVariantCalling} ${params.cortexConfigVariantCalling} --max_var_len 50000 --multicolour_bin ${params.resultsDir}/makeCombinationGraphOutput/finalCombinationGraph.ctx --path_divergence_caller [1  --ref_colour 0 --list_ref_fasta ${params.sampleDir}/referenceSoybeanList --path_divergence_caller_output ${params.resultsDir}/variantCallingOutput/${combinationGraph} --print_colour_coverages > ${combinationGraph}_PD.log
