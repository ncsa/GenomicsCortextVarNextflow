#!/usr/bin/env nextflow



//Prepare for referenceDBGraph folder

productsFolder = new File(params.resultsDir + "/makeReferenceGraphOutput")
productsFolder.mkdirs()

// Makes log folder
refLogFolder = new File(params.logDir + "/makeReferenceGraphLogs")
refLogFolder.mkdris()

// Make reference de Bruijn Graph

process makeReferenceGraph {

	publishDir refLogFolder
	executor params.executor
	queue params.makeReferenceGraphQueue
	time params.makeReferenceGraphWalltime
	cpus params.makeReferenceGraphCpusNeeded

	output:
		file "makeReferenceGraph.log"

	script:
		template 'makeReferenceGraph.sh'
}




