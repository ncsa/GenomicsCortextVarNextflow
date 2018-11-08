#!/bin/bash

######################################################################################################################################################################################
# Script to make reference Graph Cortex #
######################################################################################################################################################################################

# Cortex command

${params.cortexDirStep4} ${params.cortexConfigMakeReferenceGraph} --sample_id reference --se_list ${params.pathToReferenceList} --dump_binary ${params.resultsDir}/referenceGraphOutput/ref.ctx > makeReferenceGraph.log






