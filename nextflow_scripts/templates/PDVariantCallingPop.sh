#!/bin/bash

######################################################################################################################################################################################
# Script to run PATH DIVERGENCE Cortex #
######################################################################################################################################################################################

colorListBash="${colorListGraph}"
temp1=\${colorListBash#[}
colorListFile=\${temp1%,*}
temp2=\${colorListBash%]}
comboGraph=\${temp2#*,}
colorLength=\$(cat \$colorListFile | wc -l 2>%1)
stringColorsForCaller=''
for i in \$(seq 1 \$((colorLength-1)))
do
	stringColorsForCaller="\$stringColorsForCaller[\$i"
done 

baseNameTemp=\${comboGraph##*/}
baseName=\${baseNameTemp%.*}


# Cortex command

${params.cortexDirVariantCalling} ${params.variantCallingCortexConfig} --max_var_len ${params.maxVarLength} --multicolour_bin \${comboGraph} --path_divergence_caller \${stringColorsForCaller}  --ref_colour 0 --list_ref_fasta ${params.pathToReferenceList} --path_divergence_caller_output ${params.resultsDir}/variantCallingOutput/\${baseName} --print_colour_coverages > ${PDLogDir}/\${baseName}_PD.log
