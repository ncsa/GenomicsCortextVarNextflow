#!/usr/bin/env nextflow


//Prepare for referenceDBGraph folder
productsFolderPath = params.resultsDir + "/makeReferenceGraphOutput"
productsFolder = new File(productsFolderPath)
productsFolder.mkdirs()

// Makes log folder
refLogFolderPath = params.logDir + "/makeReferenceGraphLogs"
refLogFolder = new File(refLogFolderPath)
refLogFolder.mkdirs()

// Make reference de Bruijn Graph

process makeReferenceGraph {

	publishDir refLogFolderPath
	executor params.executor
	queue params.makeReferenceGraphQueue
	time params.makeReferenceGraphWalltime
	cpus params.makeReferenceGraphCpusNeeded

	output:
		file "makeReferenceGraph.log"

	script:
		template 'makeReferenceGraph.sh'
}




