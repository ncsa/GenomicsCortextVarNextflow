#!/usr/bin/env nextflow

if (params.runStep4 == "y") {

	// Step 4: Make reference de Bruijn Graph

	process step4MakeReferenceDBGraph {

		publishDir params.logDir
		executor params.executor
		queue params.mediumRamQueue
		time params.wallTime
		cpus params.cpusNeeded

		output:
			file "step4MakeReferenceDBGraph.log"


		script:
			template 'step4MakeReferenceDBGraph.sh'
	}


	// Makes a log file of the standard out of step 4


} else {
	println "Step 4 was not run as requested by user"
	System.exit(0)
}
