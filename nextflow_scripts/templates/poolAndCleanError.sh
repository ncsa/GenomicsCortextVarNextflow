#!/bin/bash

######################################################################################################################################################################################
# Script to pool and clean sequencing error #
######################################################################################################################################################################################



# Cortex command

${params.cortexDirStep2} ${params.cortexConfigStep2} --dump_binary ${params.resultsDir}/poolAndCleanErrorOutputs/pooledAndCleanedGraph.ctx --dump_covg_distribution ${params.resultsDir}/poolAndCleanErrorOutputs/pooledAndCleanedGraph.ctx.covg --colour_list ${params.resultsDir}/poolAndCleanErrorInputs/pathToBinaryListFile --remove_low_coverage_supernodes 1 > poolAndCleanErrors.log