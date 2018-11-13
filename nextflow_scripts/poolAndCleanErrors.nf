#!/usr/env/bin nextflow

// Make pooled de Bruijn Graph for low coverage samples

//Makes supply and product folder for pooled graph

supplyFolder = new File(params.resultsDir + "/poolAndCleanErrorInput/") 
supplyFolder.mkdirs()
productsFolder = new File(params.resultsDir +"/poolAndCleanErrorOutput/")
productsFolder.mkdirs()


//Makes 2 files:
//	1) File containing the list of path to the binary files outputted by step 1 Cortex
//	2) File containing the path to file 1)

binaryListFile = new File(params.resultsDir + "/poolAndCleanErrorInput/" + "colorListUncleanedBinaryList")
pathToBinaryListFile = new File (params.resultsDir + "/poolAndCleanErrorInput/" + "pathToBinaryListFile")

// File containing the list of path to the binary files outputted by step 1 Cortex
for (sampleName in params.sampleList) {
	binaryListFile.append(params.resultsDir + "/makeSampleGraphOutput/" + sampleName + ".ctx\n") 	

}

// File containing path to file 1)
pathToBinaryListFile.write(params.resultsDir + "/poolAndCleanErrorInput/" + "colorListUncleanedBinaryList\n")
	
//STEP2 ONLY APPENDS, SO EVERYTIME THIS IS RAN WITHOUT DELETING, THE FILE JUST KEEPS ADDING


process poolAndCleanErrors {

	publishDir params.logDir
	executor params.executor
	maxForks params.poolAndCleanErrorMaxNodes
	queue params.poolAndCleanErrorQueue
	time params.wallTime
	cpus params.cpusNeeded


	output:
		file "poolAndCleanErrors.log"


	script:
		template 'poolAndCleanError.sh'	


}

