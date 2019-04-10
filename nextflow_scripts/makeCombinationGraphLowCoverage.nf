#!/usr/bin/env nextflow


//Makes input and output folder for making combination graph
	
makeCombinationInputFolder = new File(params.resultsDir + "/makeCombinationGraphInput/")
makeCombinationInputFolder.mkdirs()
makeCombinationOutputFolder = new File(params.resultsDir + "/makeCombinationGraphOutput/")
makeCombinationOutputFolder.mkdirs()

//Makes combination graph log directory in log folder
makeCombinationLogFolder = new File(params.logDir + "/combinationGraphLogs")
makeCombinationLogFolder.mkdirs()

// Make a file that contains the path to reference graph

pathToReferenceGraph = new File(params.resultsDir + "/makeCombinationGraphInput/" + "pathToRefCtxFile")

//If empty use reference graph created in the process, else use given path in config file parameter pathToRefCtx
if (params.pathToRefCtx.size() == 0) {
	pathToRefGraph = params.resultsDir + "/makeReferenceGraphOutput/ref.ctx"
} else {
	pathToRefGraph = params.pathToRefCtx
}
pathToReferenceGraph.write(pathToRefGraph)

// Make a file containing path to cleaned graphs
for (sampleName in params.sampleList) {
		
	//Makes a file that contains the path to the cleaned sample binaries
	pathToSamples = new File(params.resultsDir + "/makeCombinationGraphInput/" + "pathToCleaned" + sampleName)
	pathToSamples.write(params.resultsDir + "/cleanGraphPerSampleFolder/" + sampleName + "_cleanedByComparisonToPool.ctx\n")
}

collatedList = params.sampleList.collate(params.finalCombinationGraphMaxColor - 1)

for (index in 0..(collatedList.size() - 1)) {

	//Makes a file that will be submitted to Cortex_var, containing the path to the two files created above
	fileToSubmitToCortex = new File (params.resultsDir + "/makeCombinationGraphInput/" + "colorlistFileToSubmit" + index)

	//Writes path to ref ctx file
	fileToSubmitToCortex.write(params.resultsDir + "/makeCombinationGraphInput/" + "pathToRefCtxFile\n")

	for (sampleName in collatedList[index]) {
		//Adds the path to the file containing the path to the cleaned sample binaries (path to file created right above this)
		//into the file that will be submitted by cortex (fileToSubmitToCortex variable)
		fileToSubmitToCortex.append(params.resultsDir + "/makeCombinationGraphInput/" + "pathToCleaned" + sampleName + "\n")
	}

}
//-------------------------------------------------------------------------------------------------------------------------------

//Combine reference graph with sample graph 
makeCombinationGraphInputDir = params.resultsDir + '/makeCombinationGraphInput'
inputListChannel = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*')

process makeCombinationGraph {
	
	executor params.executor
	queue params.makeCombinationGraphQueue
	maxForks params.makeCombinationGraphMaxNodes
	time params.makeCombinationGraphWalltime
	cpus params.makeCombinationGraphCpusNeeded
	errorStrategy params.makeCombinationGraphErrorStrategy

	input:
		each colorList from inputListChannel

	script:
		template 'makeCombinationGraph.sh'

}
