#!/usr/bin/env nextflow

// Takes in sample names
sampleListChannel = Channel.from(params.sampleList)

// Step 1: Run step 1 cortex, making de bruijn graphs


process Step1CreateSampleBinaryGraph {

	publishDir params.logDir
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded



	input:
		each samplePairFileName from sampleListChannel


	output:
		file "step1CreateSampleBinaryGraph_${samplePairFileName}.log"



	script:
		template 'step1CreateSampleBinaryGraph.sh'


}




