#!/usr/env/bin nextflow

// Step 2: Make pooled de Bruijn Graph


process Step2PoolAndCleanErrors {

	publishDir params.logDir
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded



	output:
		file "step2PoolAndCleanErrors.log"


		script:
		template 'step2CortexPoolAndCleanError.sh'	

	
}

