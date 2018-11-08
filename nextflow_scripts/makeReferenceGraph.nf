#!/usr/bin/env nextflow

if (params.makeRefGraph == "y") {

	//Prepare for referenceDBGraph folder

	productsFolder = new File(params.resultsDir + "/referenceGraphOutput")
	productsFolder.mkdirs()


	// Make reference de Bruijn Graph

	process makeReferenceGraph {

		publishDir params.logDir
		executor params.executor
		queue params.makeReferenceGraphQueue
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
