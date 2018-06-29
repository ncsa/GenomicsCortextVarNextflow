#!/bin/bash


######################################################################################################################################################################################
# Script to run step 3 Cortex #
######################################################################################################################################################################################


# Cortex command

${cortexDirStep3} ${cortexConfig} --multicolour_bin ${resultsDir}/productsOfStep2/step2PoolCleaned.ctx --colour_list ${resultsDir}/samplesForAndProductsOfStep3/colorlist_step3FileToSubmitToCortex${samplePairFileName} --load_colours_only_where_overlap_clean_colour 0 --successively_dump_cleaned_colours cleanedByComparisonToPool
 
# Renames the produced file, makes it more intuitive

mv ${resultsDir}/samplesForAndProductsOfStep3/pathToStep1CtxFile${samplePairFileName}_cleanedByComparisonToPool.ctx ${resultsDir}/samplesForAndProductsOfStep3/${samplePairFileName}_cleanedByComparisonToPool.ctx
        
# Flag for control flow

echo "" > runStep3CortexDone.flag
