#!/usr/bin/env nextflow

//Products folder for Variant Calling
			
productsFolder = new File (params.resultsDir + "/variantCallingOutput/")
productsFolder.mkdirs()

//-----------------------------------------------------------------------------------------------------------------------


combinationGraphChannel = Channel.fromPath(params.resultsDir + '/makeCombinationGraphOutput/finalCombinationGraph*.ctx')
makeCombinationGraphInputDir = params.resultsDir + '/makeCombinationGraphInput'
combinationGraphColorListChannel = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*')
colorListAndComboGraph = combinationGraphColorListChannel.merge(combinationGraphChannel)

//Path Divergence Variant Calling : When selected, cortex will use path divergence caller algorithm to identify variants.


if (params.PD == "y") {

	process PDVariantCalling {

		publishDir params.logDir
		executor params.executor
		queue params.variantCallingQueue
		maxForks params.variantCallingMaxNodes
		time params.variantCallingWalltime
		cpus params.cpusNeeded


		input:
			val colorListGraph from colorListAndComboGraph

		script:
			template 'PDVariantCalling.sh'	


	}	

}

