#!/bin/bash

######################################################################################################################################################################################
# Script to make reference Graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirMakeReferenceGraph} ${params.cortexConfig} --sample_id reference --se_list ${params.pathToReferenceList} --dump_binary ${params.resultsDir}/makeReferenceGraphOutput/ref.ctx > makeReferenceGraph.log






