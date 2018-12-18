#!/usr/bin/env nextflow

//Products folder for Variant Calling
			
productsFolder = new File (params.resultsDir + "/variantCallingOutput")
productsFolder.mkdirs()

//Make log folder
variantCallingLogDir = params.logDir + "/variantCallingLogs"
variantCallingLogFolder = new File(variantCallingLogDir)
variantCallingLogFolder.mkdirs()

//-----------------------------------------------------------------------------------------------------------------------


combinationGraphChannel = Channel.fromPath(params.resultsDir + '/makeCombinationGraphOutput/finalCombinationGraph*.ctx')
makeCombinationGraphInputDir = params.resultsDir + '/makeCombinationGraphInput'
combinationGraphColorListChannel = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*')
colorListAndComboGraph = combinationGraphColorListChannel.merge(combinationGraphChannel)

//Path Divergence Variant Calling : When selected, cortex will use path divergence caller algorithm to identify variants.


if (params.PD == "y") {

	//Makes PD Variant Calling logs
	PDLogFolder = new File(variantCallingLogDir + "/PDLogs")
	
	process PDVariantCalling {

		publishDir PDLogFolder
		executor params.executor
		queue params.variantCallingQueue
		maxForks params.variantCallingMaxNodes
		time params.variantCallingWalltime
		cpus params.variatnCallingCpusNeeded


		input:
			val colorListGraph from colorListAndComboGraph

		script:
			template 'PDVariantCalling.sh'	


	}	

}

