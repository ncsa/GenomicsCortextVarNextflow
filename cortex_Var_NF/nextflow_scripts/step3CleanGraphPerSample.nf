#!/usr/env/bin nextflow

sampleListChannel = Channel.from(params.sampleList)

// Step 3: Clean graph per sample using combined graph made in step 2

process step3CleanGraphPerSample {

	publishDir params.logDir	
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded


	input:
		each samplePairFileName from sampleListChannel		
	
	output:
		file "step3CleanGraphPerSample_${samplePairFileName}.log"



	script:
		template 'step3CleanGraphPerSample.sh'	

}
