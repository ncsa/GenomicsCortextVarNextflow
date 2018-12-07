#!/usr/bin/env nextflow



//Prepare for referenceDBGraph folder

productsFolder = new File(params.resultsDir + "/makeReferenceGraphOutput")
productsFolder.mkdirs()


// Make reference de Bruijn Graph

process makeReferenceGraph {

	publishDir params.logDir
	executor params.executor
	queue params.makeReferenceGraphQueue
	time params.makeReferenceGraphWalltime
	cpus params.makeReferenceGraphCpusNeeded

	output:
		file "makeReferenceGraph.log"

	script:
		template 'makeReferenceGraph.sh'
}




