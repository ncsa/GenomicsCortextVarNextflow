#!/usr/bin/env nextflow

// Step 5: Combine reference graph with sample graph and cleaned pool

process step5MakeCombinationGraph {
	
	publishDir params.logDir
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded

	output:
		file "step5MakeCombinationGraph.log"

	
	script:
		template 'step5MakeCombinationGraph.sh'



}

