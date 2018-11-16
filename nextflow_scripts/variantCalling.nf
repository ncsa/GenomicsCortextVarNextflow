#!/usr/bin/env nextflow

//Products folder for Variant Calling
			
productsFolder = new File (params.resultsDir + "/variantCallingOutput/")
productsFolder.mkdirs()

//-----------------------------------------------------------------------------------------------------------------------


combinationGraphChannel = Channel.fromPath(params.resultsDir + '/makeCombinationGraphOutput/finalCombinationGraph*.ctx')


//Step 6 PD : When selected, cortex will use path divergence caller algorithm to identify variants.
//Step6 also includes a renaming script, since nextflow-bash interaction is untidy.

if (params.PD == "y") {

	process PDVariantCalling {

		publishDir params.logDir
		executor params.executor
		queue params.variantCallingQueue
		maxForks params.variantCallingMaxNodes
		time params.wallTime
		cpus params.cpusNeeded


		input:
			each combinationGraph from combinationGraphChannel

		script:
			template 'PDVariantCalling.sh'	


	}	

}

//Step 6 BC: When selected, cortex will use bubble caller algorithm to identiy variants.

if (params.BC == "y") {

		process BCVariantCalling {
			publishDir params.logDir
			executor params.executor
			queue params.variantCallingQueue
			maxForks params.variantCallingMaxNodes
			time params.variantCallingWalltime
			cpus params.cpusNeeded


			input:
				each fileNameAndNumber from fileIndexFilteredChannel
			
			output:
				file "${fileNameAndNumber}_BC.log" into BCLogFiles	
		

			
			script:
				template 'BCVariantCalling.sh'

		}


	 


	// This step renames the file from sampleName+index_BC.log to sampleName_BC.log

        process BCRenameLogFiles {

        	input:
               		file logFile from BCLogFiles

                script:
                	template 'BCRenameLogFiles.sh'


        }
	



}

