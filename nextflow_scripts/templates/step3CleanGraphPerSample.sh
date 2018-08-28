#!/bin/bash


######################################################################################################################################################################################
# Script to run step 3 to clean graph per sample using Cortex_Var #
######################################################################################################################################################################################


# Cortex command

${params.cortexDirStep3} ${params.cortexConfigStep3} --multicolour_bin ${params.resultsDir}/productsOfStep2/step2PoolCleaned.ctx --colour_list ${params.resultsDir}/samplesForAndProductsOfStep3/colorlist_step3FileToSubmitToCortex${samplePairFileName} --load_colours_only_where_overlap_clean_colour 0 --successively_dump_cleaned_colours cleanedByComparisonToPool > step3CleanGraphPerSample_${samplePairFileName}.log
 
# Renames the produced file, makes it more intuitive

mv ${params.resultsDir}/samplesForAndProductsOfStep3/pathToStep1CtxFile${samplePairFileName}_cleanedByComparisonToPool.ctx ${params.resultsDir}/samplesForAndProductsOfStep3/${samplePairFileName}_cleanedByComparisonToPool.ctx

