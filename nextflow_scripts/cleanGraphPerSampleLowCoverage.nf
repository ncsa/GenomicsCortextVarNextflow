#!/usr/env/bin nextflow

sampleListChannel = Channel.from(params.sampleList)


//Makes supply and product folder for clean graph per sample

cleanGraphPerSampleFolder = new File(params.resultsDir + "/cleanGraphPerSampleFolder/")
cleanGraphPerSampleFolder.mkdirs()

//Makes a file that contains the path to results of pooled de Bruijn Graph file

pathToPooledResultFile = new File(params.resultsDir + "/cleanGraphPerSampleFolder/" + "pathToPooledGraph")
pathToPooledResultFile.write(params.resultsDir + "/poolAndCleanErrorOutput/" + "pooledAndCleanedGraph.ctx\n")
		


for (sampleName in params.sampleList) {

//Makes a file for each sample that contains the path to results of sample de Bruijn Graph file

	pathToSampleCtxFile = new File(params.resultsDir + "/cleanGraphPerSampleFolder/" + "pathToSampleBinaryCtxFile" + sampleName)	
	pathToSampleCtxFile.append(params.resultsDir + "/makeSampleGraphOutput/" + sampleName + ".ctx\n")

//Makes a file that contains:
// 	Line 1: The path to the file that contains to the path of pooled de Bruijn Graph file
// 	Line 2: The path to the file that contains the path to results of sample de Bruijn Graph file
//Cortex requires nested file paths like what's being created here

	filetoSubmitToCortex = new File(params.resultsDir + "/cleanGraphPerSampleFolder/" + "colorlistFileToSubmit" + sampleName)
	filetoSubmitToCortex.write(params.resultsDir + "/cleanGraphPerSampleFolder/" + "pathToPooledGraph\n")
	filetoSubmitToCortex.append(params.resultsDir + "/cleanGraphPerSampleFolder/" + "pathToSampleBinaryCtxFile" + sampleName + "\n")
}
	
//-------------------------------------------------------------------------------------------------------------------------------





// Clean graph per sample using pooled graph

process cleanGraphPerSampleLowCoverage {

	publishDir params.logDir	
	executor params.executor
	queue params.cleanGraphPerErrorQueue
	maxForks params.cleanGraphPerErrorMaxNodes
	time params.wallTime
	cpus params.cpusNeeded

	input:
		each samplePairFileName from sampleListChannel		
	
	output:
		file "cleanGraphPerSample${samplePairFileName}.log"

	script:
		template 'cleanGraphPerSampleLowCoverage.sh'	

}