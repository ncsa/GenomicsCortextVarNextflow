#!/usr/bin/env nextflow

//Products folder for Variant Calling
			
productsFolder = new File (params.resultsDir + "/variantCallingOutput")
productsFolder.mkdirs()

//Make log folder
variantCallingLogDir = params.logDir + "/variantCallingLogs"
variantCallingLogFolder = new File(variantCallingLogDir)
variantCallingLogFolder.mkdirs()

//-----------------------------------------------------------------------------------------------------------------------
//Channel Preparation for population variant calling
//-----------------------------------------------------------------------------------------------------------------------

combinationGraphChannelPop = Channel.fromPath(params.resultsDir + '/makeCombinationGraphOutput/combinationGraph*.ctx')
combinationGraphChannelInd = Channel.fromPath(params.resultsDir + '/makeCombinationGraphOutput/combinationGraph*.ctx')

makeCombinationGraphInputDir = params.resultsDir + '/makeCombinationGraphInput'
combinationGraphColorListChannelPop = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*')
combinationGraphColorListChannelInd = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*')

colorListAndComboGraphPop = combinationGraphColorListChannelPop.merge(combinationGraphChannelPop)
colorListAndComboGraphInd = combinationGraphColorListChannelInd.merge(combinationGraphChannelInd)

//Path Divergence Variant Calling : When selected, cortex will use path divergence caller algorithm to identify variants.

if (params.PD == "y") {

	//Makes PD Variant Calling logs
	PDLogDir = variantCallingLogDir + "/PDLogs"
	PDLogFolder = new File(PDLogDir)
	PDLogFolder.mkdirs()

	if (params.populationPD == "y") {	
		process PDVariantCallingPopulation {

			executor params.executor
			queue params.variantCallingQueue
			maxForks params.variantCallingMaxNodes
			time params.variantCallingWalltime
			cpus params.variantCallingCpusNeeded


			input:
				val colorListGraph from colorListAndComboGraphPop

			script:
				template 'PDVariantCallingPop.sh'	


		}	
	} 

	if (params.individualPD == "y") {

		//-----------------------------------------------------------------------------------------------------------------------
		//Channel Preparation for individual variant calling
		//-----------------------------------------------------------------------------------------------------------------------


		regularList = 1..(params.finalCombinationGraphMaxColor-1)


		sampleOnLastGraph = 1..(params.sampleList.size() % (params.finalCombinationGraphMaxColor-1))



		colorListAndComboGraphInd.toList().subscribe{ asList = it}

	
		finalList = []
		if (asList.size() > 1) {
			for (i = 0; i < asList.size(); i++) {
				temp = asList[i]
				if (i != (asList.size() - 1)) {
					for (j in regularList) {
						temp2 = temp.clone()
						temp2.add(j)
						finalList.add(temp2)

					}
				} else {

					for (j in sampleOnLastGraph) {
						temp2 = temp.clone()
						temp2.add(j)
						finalList.add(temp2)
					}
				}
			}

		} else {
			for (i = 0; i < asList.size(); i++) {
				temp = asList[i]
				for (j in regularList) {
					temp2 = temp.clone()
					temp2.add(j)
					finalList.add(temp2)
                                        }

			}

		}


		//Append finalList with sorted sample names 
		finalChannel = Channel.from(finalList)



		process PDVariantCallingIndividual {

			executor params.executor
			queue params.variantCallingQueue
			maxForks params.variantCallingMaxNodes
			time params.variantCallingWalltime
			cpus params.variantCallingCpusNeeded


	
			input:
				val color from finalChannel
			
			script:
				template 'PDVariantCallingInd.sh'				



		}


	}

}

