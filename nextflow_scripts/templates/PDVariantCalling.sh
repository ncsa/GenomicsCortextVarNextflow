#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 PATH DIVERGENCE Cortex #
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

${params.cortexDirVariantCalling} ${params.cortexConfig} --max_var_len 50000 --multicolour_bin \${comboGraph} --path_divergence_caller \${stringColorsForCaller}  --ref_colour 0 --list_ref_fasta ${params.pathToReferenceList} --path_divergence_caller_output ${params.resultsDir}/variantCallingOutput/\${baseName} --print_colour_coverages > ${params.logDir}/\${baseName}_PD.log
