#!/bin/bash

######################################################################################################################################################################################
# Script to rename log file of step 6, which will later be needed if VCFs will be made #
######################################################################################################################################################################################

# Name of initial logfile
# Example = Sample_Magellan+2_PD.log

nameAndIndex=${logFile}


# Use regular expression to get substring from intial logfile, from index 0 to + (not including +)
sampleName=\${nameAndIndex%+*}


# Renames initial logfile name to samplename_PD.log
# Example: from Sample_Magellan+2_PD.log to SampleMagellan_PD.log
mv ${flagDir}/${logFile} ${flagDir}/\${sampleName}_PD.log




