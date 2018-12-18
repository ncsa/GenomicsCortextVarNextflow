#!/usr/env/bin nextflow

// Make pooled de Bruijn Graph for low coverage samples

//Makes supply and product folder for pooled graph

supplyFolder = new File(params.resultsDir + "/poolAndCleanErrorInput/") 
supplyFolder.mkdirs()
productsFolder = new File(params.resultsDir +"/poolAndCleanErrorOutput/")
productsFolder.mkdirs()

//Make log folder
poolCleanErrorLogDir = params.logDir + "/poolAndCleanErrorLogs"
poolCleanErrorLogFolder = new File(poolCleanErrorLogDir)
poolCleanErrorLogFolder.mkdirs()


//Makes 2 files:
//	1) File containing the list of path to de Bruijn Graphs
//	2) File containing the path to file 1)

binaryListFile = new File(params.resultsDir + "/poolAndCleanErrorInput/" + "colorListUncleanedBinaryList")
pathToBinaryListFile = new File (params.resultsDir + "/poolAndCleanErrorInput/" + "pathToBinaryListFile")

// File containing the list of path to uncleaned de Bruijn Graphs
for (sampleName in params.sampleList) {
	binaryListFile.append(params.resultsDir + "/makeSampleGraphOutput/" + sampleName + ".ctx\n") 	

}

// File containing path to file 1)
pathToBinaryListFile.write(params.resultsDir + "/poolAndCleanErrorInput/" + "colorListUncleanedBinaryList\n")



process poolAndCleanErrors {

	publishDir poolCleanErrorLogDir
	executor params.executor
	queue params.poolAndCleanErrorQueue
	maxForks params.poolAndCleanErrorMaxNodes
	time params.wallTime
	cpus params.cpusNeeded


	output:
		file "poolAndCleanErrors.log"


	script:
		template 'poolAndCleanError.sh'	


}

