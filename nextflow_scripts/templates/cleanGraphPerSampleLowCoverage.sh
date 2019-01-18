#!/bin/bash


######################################################################################################################################################################################
# Script to run clean graph per sample using Cortex_Var #
######################################################################################################################################################################################


# Cortex command

${params.cortexBinCleanGraphPerSampleLowCoverage} ${params.cleanGraphPerSampleCortexConfig} --multicolour_bin ${params.resultsDir}/poolAndCleanErrorOutput/pooledAndCleanedGraph.ctx --colour_list ${params.resultsDir}/cleanGraphPerSampleFolder/colorlistFileToSubmit${samplePairFileName} --load_colours_only_where_overlap_clean_colour 0 --successively_dump_cleaned_colours cleanedByComparisonToPool > cleanGraphPerSample${samplePairFileName}.log
 
# Renames the produced file, makes it more intuitive

mv ${params.resultsDir}/cleanGraphPerSampleFolder/pathToSampleBinaryCtxFile${samplePairFileName}_cleanedByComparisonToPool.ctx ${params.resultsDir}/cleanGraphPerSampleFolder/${samplePairFileName}_cleanedByComparisonToPool.ctx

