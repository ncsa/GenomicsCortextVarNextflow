#!/bin/bash


######################################################################################################################################################################################
# Script to clean graph per sample using Cortex_Var #
######################################################################################################################################################################################

IFS=","


minPairBashString="${firstMinPair}"
removeFirstPar=\${minPairBashString#[}
removeLastPar=\${removeFirstPar/]/}

index=0
declare -a dataArray
for x in \${removeLastPar}
do
        dataArray[\$index]=\$x
        index=\$((\$index+1))
done

sampleName=\${dataArray[0]}
removeLowCovgInput=\${dataArray[1]}



# Cortex command
${params.cortexBinCleanGraphPerSampleHighCoverage} ${params.cortexConfig} --multicolour_bin ${params.resultsDir}/makeSampleGraphOutput/\${sampleName}.ctx --remove_low_coverage_supernodes \${removeLowCovgInput} --dump_binary ${params.resultsDir}/cleanGraphPerSampleFolder/\${sampleName}_cleanedIndividually.ctx --dump_covg_distribution ${params.resultsDir}/cleanGraphPerSampleFolder/\${sampleName}_cleanedIndividually.ctx.covg > ${cleanGraphLogDir}/\${sampleName}.log



