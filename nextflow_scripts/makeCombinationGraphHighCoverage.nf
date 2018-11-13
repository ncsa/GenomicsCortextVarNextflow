#!/usr/bin/env nextflow


//Makes supply and product folder for step 5
	
makeCombinationInputFolder = new File(params.resultsDir + "/makeCombinationGraphInput/")
makeCombinationInputFolder.mkdirs()
makeCombinationOutputFolder = new File(params.resultsDir + "/makeCombinationGraphOutput/")
makeCombinationOutputFolder.mkdirs()



// Make a file that contains the path to reference graph from step 4

pathToReferenceGraph = new File(params.resultsDir + "/makeCombinationGraphInput/" + "pathToRefCtxFile")

//If empty use reference graph created in the process, else use given path in config file parameter pathToRefCtx
if (params.pathToRefCtx.size() == 0) {
	pathToRefGraph = params.resultsDir + "/makeReferenceGraphOutput/ref.ctx"
} else {
	pathToRefGraph = params.pathToRefCtx
}
pathToReferenceGraph.write(pathToRefGraph)

collatedList = sampleList.collate(params.numberOfSamples/(variantCallingMaxNodes*5))
for (index in 1..collatedList.size()) {

	//Makes a file that will be submitted to Cortex, containing the path to the two files created above
	fileToSubmitToCortex = new File (params.resultsDir + "/makeCombinationGraphInput/" + "colorlistFileToSubmit" + index)

	//Writes path to ref ctx file
	fileToSubmitToCortex.write(params.resultsDir + "/makeCombinationGraphInput/" + "pathToRefCtxFile\n")

	//Goes through the sample list
	for (sampleName in collatedList[index]) {
			
		//Makes a file that contains the path to the cleaned sample binaries
		pathToSamples = new File(params.resultsDir + "/makeCombinationGraphInput/" + "pathToCleaned" + sampleName)
		pathToSamples.write(params.resultsDir + "/cleanGraphPerSampleFolder/" + sampleName + "_cleanedIndividually.ctx\n")
		
		//Adds the path to the file containing the path to the cleaned sample binaries (path to file created right above this)
		//into the file that will be submitted by cortex (fileToSubmitToCortex variable)
		fileToSubmitToCortex.append(params.resultsDir + "/makeCombinationGraphInput/" + "pathToCleaned" + sampleName + "\n")

	}
}
//-------------------------------------------------------------------------------------------------------------------------------

// Step 5: Combine reference graph with sample graph and cleaned pool

process makeCombinationGraph {
	
	publishDir params.logDir
	executor params.executor
	queue params.makeCombinationGraphQueue
	time params.wallTime
	cpus params.cpusNeeded

	output:
		file "makeCombinationGraph.log"

	
	script:
		template 'makeCombinationGraphHighCoverage.sh'



}

