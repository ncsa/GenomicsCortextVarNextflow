#!/usr/bin/env nextflow

// Takes in sample names
sampleListChannel = Channel.from(params.sampleList)

// Prepare folder for sampleGraphs

// Makes supply and product folder
supplyFolder = new File(params.resultsDir + "/makeSampleGraphInput/")
supplyFolder.mkdirs()
productsFolder = new File(params.resultsDir + "/makeSampleGraphOutput/")
productsFolder.mkdirs()

// Makes a file in supply folder called the sample name (e.g. Sample_Magellan) and writes the path to sample reads
// e.g "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/Sample_Magellan_read1.fq"
// and "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/Sample_Magellan_read2.fq"
// is written to the file "Sample_Magellan" inside supply folder

for (sampleName in params.sampleList) {
	newFile = new File(params.resultsDir + "/makeSampleGraphInput/" + sampleName)

	// Writes directory to each fastq files
	newFile.write(params.sampleDir + "/" + sampleName + params.sampleReadPattern + "1" + params.sampleReadExtension + "\n")
	newFile.append(params.sampleDir + "/" + sampleName + params.sampleReadPattern + "2" + params.sampleReadExtension + "\n")
}

//Partition handling
sampleListCollated = (params.sampleList).collate(params.makeSampleGraphPartition)

for (batch in sampleListCollated) {

	batchSampleList = Channel.from(batch)
	// Construct de Bruijn graphs
	process makeSampleDeBruijnGraph {

		publishDir params.logDir
		executor params.executor
		queue params.makeGraphQueue
		time params.wallTime
		cpus params.cpusNeeded


		input:
			each samplePairFileName from batchSampleList


		output:
			file "makeSampleDeBruijnGraph_${samplePairFileName}.log"


		script:
			template 'makeSampleGraph.sh'

	}
}
