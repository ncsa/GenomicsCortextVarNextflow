#!/usr/bin/env nextflow

if (params.runStep4 == "y") {

		//Prepare for referenceDBGraph folder

		step4ProductsFolder = new File(params.resultsDir + "/referenceGraphOutput/")
		step4ProductsFolder.mkdirs()


	// Step 4: Make reference de Bruijn Graph

	process makeReferenceGraph {

		publishDir params.logDir
		executor params.executor
		queue params.mediumRamQueue
		time params.wallTime
		cpus params.cpusNeeded

		output:
			file "makeReferenceGraph.log"


		script:
			template 'makeReferenceGraph.sh'
	}


	// Makes a log file of the standard out of step 4


} else {
	println "Make reference graph was not run as requested by user"
	System.exit(0)
}
