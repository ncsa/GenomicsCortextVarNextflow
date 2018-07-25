#!/bin/bash

######################################################################################################################################################################################
# Script to rename log file of step 6, which will later be needed if VCFs will be made #
######################################################################################################################################################################################

# Name of initial logfile
# Example = step6_Sample_Magellan+2_BC.log
nameAndIndex=${logFile}

# Use regular expression to get substring from intial logfile, from index 0 to + (not including +)

sampleName=\${nameAndIndex%+*}


# Renames initial logfile name to samplename_BC.log
# Example: from Sample_Magellan+2_BC.log to SampleMagellan_BC.log

mv ${params.flagAndLogDir}/${logFile} ${params.flagAndLogDir}/\${sampleName}_BC.log




