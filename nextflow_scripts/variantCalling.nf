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

combinationGraphFolderPath = params.resultsDir + '/makeCombinationGraphOutput'
combinationGraphFolderDirectory = new File(combinationGraphFolderPath)
combinationGraphList = []
combinationGraphFolderDirectory.eachFile() { file -> combinationGraphList.add(file) }



makeCombinationGraphInputDir = params.resultsDir + '/makeCombinationGraphInput'
combinationGraphColorListChannelInd = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*').toSortedList().subscribe{ colorListList = it}

mergedSortedList = combinationGraphList.sort()
for (i = 0; i < mergedSortedList.size(); i++) {
	mergedSortedList[i] = [mergedSortedList[i]]
	mergedSortedList[i].add(colorListList[i])

}



colorListAndComboGraphPop = Channel.from(mergedSortedList)
colorListAndComboGraphInd = Channel.from(mergedSortedList)

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
			errorStrategy params.variantCallingErrorStrategy

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

		if (params.sampleList.size() % (params.finalCombinationGraphMaxColor-1) > 0) {
			sampleOnLastGraph = 1..(params.sampleList.size() % (params.finalCombinationGraphMaxColor-1))
		} else {
			sampleOnLastGraph = 1..1
		}


		asList = combinationGraphList
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
			errorStrategy params.variantCallingErrorStrategy

	
			input:
				val color from finalChannel
			
			script:
				template 'PDVariantCallingInd.sh'				



		}


	}

}

