#!/usr/env/bin nextflow

sampleListChannel = Channel.from(params.sampleList)


//Makes folder for cleaning samples (only 1 folder because of how cortex_var works)

cleanGraphPerSampleFolder = new File(params.resultsDir + "/cleanGraphPerSampleFolder/")
cleanGraphPerSampleFolder.mkdirs()

//Makes log folder
cleanGraphLogDir = params.logDir + "/cleanGraphLogs"
cleanGraphLogFolder = new File(cleanGraphLogDir)
cleanGraphLogFolder.mkdirs()


//Sample graph output dir
sampleGraphOutputDir = params.resultsDir + "/makeSampleGraphOutput"
coverageFileChannel = Channel.fromPath(sampleGraphOutputDir + '/*.covg')



// Get first minimum of kmer covg from coverage file in makeSampleGraph process

process getFirstMinimumCoverage {

	input:
		file coverageInfo from coverageFileChannel

	output:
		stdout into firstMinPairChannel 

	script:
		template 'getFirstMinimumCoverage.py'
}


// Clean graph per sample individually

process cleanGraphPerSampleHighCoverage {
	
	publishDir cleanGraphLogDir
	executor params.executor
	queue params.cleanGraphPerSampleQueue
	maxForks params.cleanGraphPerSampleMaxNodes
	time params.cleanGraphPerSampleWalltime
	cpus params.cleanGraphPerSampleCpusNeeded
	errorStrategy params.cleanGraphPerSampleErrorStrategy	
	
	input:
		val firstMinPair from firstMinPairChannel 		

	output:
		stdout into stdoutChannel	
	script:
		template 'cleanGraphPerSampleHighCoverage.sh'	

}


