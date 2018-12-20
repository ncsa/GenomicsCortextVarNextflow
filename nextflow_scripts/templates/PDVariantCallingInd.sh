#!/bin/bash

######################################################################################################################################################################################
# Script to run step 6 PATH DIVERGENCE Cortex #
######################################################################################################################################################################################

IFS=", "

colorBashString="${color}"
removeFirstPar=\${colorBashString#[}
removeLastPar=\${removeFirstPar/]/}

index=0
declare -a dataArray
for x in \${removeLastPar}
do
	dataArray[\$index]=\$x
	index=\$((\$index+1))
done

colorList=\${dataArray[0]}
combinationGraph=\${dataArray[1]}
sampleIndex=\${dataArray[2]}


declare -a colorNames

while IFS= read line
do
	colorNames+=(\$line)
done <"\$colorList"

sampleNameRaw=\${colorNames[\$sampleIndex]}
sampleNameMedium=\${sampleNameRaw##*/}
prefix="pathToCleaned"
sampleName=\${sampleNameMedium#*\$prefix}

# Cortex command

${params.cortexDirVariantCalling} ${params.cortexConfig} --max_var_len 50000 --multicolour_bin \${combinationGraph} --path_divergence_caller \${sampleIndex}  --ref_colour 0 --list_ref_fasta ${params.pathToReferenceList} --path_divergence_caller_output ${params.resultsDir}/variantCallingOutput/\${sampleName} --print_colour_coverages > ${PDLogDir}/\${sampleName}_PD.log

