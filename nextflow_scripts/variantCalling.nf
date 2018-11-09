#!/usr/bin/env nextflow

//Products folder for Variant Calling
			
productsFolder = new File (params.resultsDir + "/variantCallingOutput/")
productsFolder.mkdirs()

//-----------------------------------------------------------------------------------------------------------------------


//Step6 Preparation

//Prepare step 6, make channels that pair each sample with its index / order like in the supply for step 5 for consistent colour
//Example:
//	if sample name is magellan, and located at index 2 (first, since index 0 is reference de bruijn graph and 1 is combined de bruijn graph according
//	to step 5 colorlist_step5FileToSubmitToCortex)
//	it is processed as "magellan+2"

process prepareVariantCalling {

	executor 'local'

	output:
		val fileListFiltered into fileIndexFilteredChannel

	exec:	
		//Reads colorlist
		fileList = file(params.resultsDir + "/makeCombinationGraphInput/colorlistFileToSubmit").readLines()

		//Adds each sample in the reverse order in the step6FileListReversed Array
		fileListReversed = []

		for (int i = 0; i < fileList.size(); i++) {
			fileListReversed[fileList.size() - 1 - i] = fileList[i] - params.resultsDir + "+" + (i - 1) - "/makeCombinationGraphInput/pathToCleaned"
		}

	

		//Only takes in the samples, not the reference or combination graph
		fileListFiltered = []

		for (int i = 0; i < params.numberOfSamples; i++) {
			fileListFiltered[i] = fileListReversed[i]
			
		}


}




//Step 6 PD : When selected, cortex will use path divergence caller algorithm to identify variants.
//Step6 also includes a renaming script, since nextflow-bash interaction is untidy.

if (params.PD == "y") {

	process PDVariantCalling {

		publishDir params.logDir
		executor params.executor
		queue params.variantCallingQueue
		time params.wallTime
		cpus params.cpusNeeded


		input:
			each fileNameAndNumber from fileIndexFilteredChannel	


		output:
			file "${fileNameAndNumber}_PD.log" into PDLogFiles


		script:
			template 'PDVariantCalling.sh'	


	}	


	// This step renames the file from sampleName+index_PD.log to sampleName_PD.log

	process PDRenameLogFiles {
	
		input:
			file logFile from PDLogFiles
	
		script:
			template 'PDRenameLogFiles.sh'
		

	}	


}

//Step 6 BC: When selected, cortex will use bubble caller algorithm to identiy variants.

if (params.BC == "y") {

		process BCVariantCalling {
			publishDir params.logDir
			executor params.executor
			queue params.variantCallingQueue
			time params.wallTime
			cpus params.cpusNeeded


			input:
				each fileNameAndNumber from fileIndexFilteredChannel
			
			output:
				file "${fileNameAndNumber}_BC.log" into BCLogFiles	
		

			
			script:
				template 'BCVariantCallingWithRef.sh'

		}


	 


	// This step renames the file from sampleName+index_BC.log to sampleName_BC.log

        process BCRenameLogFiles {

        	input:
               		file logFile from BCLogFiles

                script:
                	template 'BCRenameLogFiles.sh'


        }
	



}

