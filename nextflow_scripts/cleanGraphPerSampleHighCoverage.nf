#!/usr/env/bin nextflow

sampleListChannel = Channel.from(params.sampleList)


//Makes folder for cleaning samples (only 1 folder because of how cortex_var works)

cleanGraphPerSampleFolder = new File(params.resultsDir + "/cleanGraphPerSampleFolder/")
cleanGraphPerSampleFolder.mkdirs()


// Clean graph per sample using pooled graph

process cleanGraphPerSampleHighCoverage {

	publishDir params.logDir	
	executor params.executor
	queue params.cleanGraphPerSampleQueue
	maxForks params.cleanGraphPerSampleMaxNodes
	time params.cleanGraphPerSampleWalltime
	cpus params.cleanGraphPerSampleCpusNeeded

	input:
		each samplePairFileName from sampleListChannel		
	
	output:
		file "cleanGraphPerSample${samplePairFileName}.log"

	script:
		template 'cleanGraphPerSampleHighCoverage.sh'	

}