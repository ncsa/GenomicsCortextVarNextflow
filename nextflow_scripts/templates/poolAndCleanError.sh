#!/bin/bash

######################################################################################################################################################################################
# Script to pool and clean sequencing error #
######################################################################################################################################################################################



# Cortex command

${params.cortexBinPoolAndCleanError} ${params.cortexConfigPoolAndCleanError} --dump_binary ${params.resultsDir}/poolAndCleanErrorOutput/pooledAndCleanedGraph.ctx --dump_covg_distribution ${params.resultsDir}/poolAndCleanErrorOutput/pooledAndCleanedGraph.ctx.covg --colour_list ${params.resultsDir}/poolAndCleanErrorInput/pathToBinaryListFile --remove_low_coverage_supernodes 1 > poolAndCleanErrors.log