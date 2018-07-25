#!/usr/bin/env nextflow

//Step6 Preparation

//Prepare step 6, make channels that pair each sample with its index / order like in the supply for step 5 for consistent colour
//Example:
//	if sample name is magellan, and located at index 2 (first, since index 0 is reference de bruijn graph and 1 is combined de bruijn graph according
//	to step 5 colorlist_step5FileToSubmitToCortex)
//	it is processed as "magellan+2"

process prepareStep6VariantCalling {
	executor 'local'

	output:
		val step6FileListFiltered into step6FileIndexFilteredChannel




	exec:	
		//Reads colorlist
		step6FileList = file(params.resultsDir + "/samplesForStep5/colorlist_step5FileToSubmitToCortex").readLines()


		//Adds each sample in the reverse order in the step6FileListReversed Array
		if (params.referenceReadsProvided == "y") {
			step6FileListReversed = []

                	for (int i = 0; i < step6FileList.size(); i++) {
                        step6FileListReversed[step6FileList.size() - 1 - i] = step6FileList[i] - params.resultsDir + "+" + (i-1) - "/samplesForStep5/pathToCleaned"
                	}

		} else {
			step6FileListReversed = []
			
			for (int i = 0; i < step6FileList.size(); i++) {
				step6FileListReversed[step6FileList.size() - 1 - i] = step6FileList[i] - params.resultsDir + "+" + i - "/samplesForStep5/pathToCleaned"

			}
		}



		//Only takes in the samples, not the reference or combination graph
		step6FileListFiltered = []

		for (int i = 0; i < params.numberOfSamples; i++) {
		step6FileListFiltered[i] = step6FileListReversed[i]

		}




}




//Step 6 PD : When selected, cortex will use path divergence caller algorithm to identify variants.
//Step6 also includes a renaming script, since nextflow-bash interaction is untidy.

if (params.PD == "y") {
	process step6PDVariantCalling {

		publishDir params.logDir
		executor params.executor
		queue params.highRamQueue
		time params.wallTime
		cpus params.cpusNeeded


		input:
			each fileNameAndNumber from step6FileIndexFilteredChannel	


		output:
			file "step6_${fileNameAndNumber}_PD.log" into PDLogFiles


		script:
			template 'step6PDVariantCalling.sh'	


	}	


	// This step renames the file from sampleName+index_PD.log to sampleName_PD.log

	process step6PDRenameLogFiles {
	
		input:
			file logFile from PDLogFiles
	
		script:
			template 'step6PDRenameLogFiles.sh'
		

	}	


}

//Step 6 BC: When selected, cortex will use bubble caller algorithm to identiy variants.

if (params.BC == "y") {
	if (params.referenceReadsProvided == "y") {

		process step6BCVariantCallingWithRef {
			publishDir params.logDir
			executor params.executor
			queue params.highRamQueue
			time params.wallTime
			cpus params.cpusNeeded


			input:
				each fileNameAndNumber from step6FileIndexFilteredChannel
			
			output:
				file "step6_${fileNameAndNumber}_BC.log" into BCLogFiles	
		

			
			script:
				template 'step6BCVariantCallingWithRef.sh'

		}


	} else {

                process step6bBCVariantCallingWithoutRef {
                        publishDir params.logDir
                        executor params.executor
                        queue params.highRamQueue
                        time params.wallTime
                        cpus params.cpusNeeded


                        input:
                                each fileNameAndNumber from step6FileIndexFilteredChannel

                 
                        output:
                                file "step6_${fileNameAndNumber}_BC.log" into BCLogFiles
         
                        script:
                                template 'step6BCVariantCallingWithoutRef.sh'

                }

                
	}
	
	// This step renames the file from sampleName+index_BC.log to sampleName_BC.log

        process step6BCRenameLogFiles {

        	input:
               		file logFile from BCLogFiles

                script:
                	template 'step6BCRenameLogFiles.sh'


        }
	



}

