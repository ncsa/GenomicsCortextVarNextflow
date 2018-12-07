#!/usr/bin/env nextflow

// Takes in sample names
sampleListChannel = Channel.from(params.sampleList)

// Prepare folder for sampleGraphs

// Makes input and product folder
inputFolder = new File(params.resultsDir + "/makeSampleGraphInput/")
inputFolder.mkdirs()
productsFolder = new File(params.resultsDir + "/makeSampleGraphOutput/")
productsFolder.mkdirs()

// Makes a file in input folder called the sample name (e.g. Sample_Magellan) and writes the path to sample reads
// e.g "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/Sample_Magellan_read1.fq"
// and "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/Sample_Magellan_read2.fq"
// is written to the file "Sample_Magellan" inside input folder

for (sampleName in params.sampleList) {
	newFile = new File(params.resultsDir + "/makeSampleGraphInput/" + sampleName)

	// Writes directory to each fastq files
	newFile.write(params.sampleDir + "/" + sampleName + params.sampleReadPattern + "1" + params.sampleReadExtension + "\n")
	newFile.append(params.sampleDir + "/" + sampleName + params.sampleReadPattern + "2" + params.sampleReadExtension + "\n")
}


process makeSampleDeBruijnGraph {

	publishDir params.logDir
	executor params.executor
	queue params.makeGraphQueue
	maxForks params.makeGraphMaxNodes
	time params.makeGraphWallTime
	cpus params.makeGraphCpusNeeded



	input:
		each samplePairFileName from batchSampleList


	output:
		file "makeSampleGraph_${samplePairFileName}.log"


	script:
		emplate 'makeSampleGraph.sh'

}

