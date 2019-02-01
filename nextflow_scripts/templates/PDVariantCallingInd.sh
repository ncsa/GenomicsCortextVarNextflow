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

combinationGraph=\${dataArray[0]}
colorList=\${dataArray[1]}
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

echo "using \${combinationGraph} as combination graph" > ${PDLogDir}/\${sampleName}_PD.log
echo "using \${colorList} as color list" >> ${PDLogDir}/\${sampleName}_PD.log
echo "using \${sampleIndex}" >> ${PDLogDir}/\${sampleName}_PD.log
echo "Now running PD variant calling on \${sampleName}" >> ${PDLogDir}/\${sampleName}_PD.log

# Cortex command
${params.cortexDirVariantCalling} ${params.variantCallingCortexConfig} --max_var_len ${params.maxVarLength} --multicolour_bin \${combinationGraph} --path_divergence_caller \${sampleIndex}  --ref_colour 0 --list_ref_fasta ${params.pathToReferenceList} --path_divergence_caller_output ${params.resultsDir}/variantCallingOutput/\${sampleName} --print_colour_coverages >> ${PDLogDir}/\${sampleName}_PD.log


