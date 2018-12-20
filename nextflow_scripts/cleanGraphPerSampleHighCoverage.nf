#!/usr/env/bin nextflow

sampleListChannel = Channel.from(params.sampleList)


//Makes folder for cleaning samples (only 1 folder because of how cortex_var works)

cleanGraphPerSampleFolder = new File(params.resultsDir + "/cleanGraphPerSampleFolder/")
cleanGraphPerSampleFolder.mkdirs()

//Makes log folder
cleanGraphLogDir = params.logDir + "/cleanGraphLogs"
cleanGraphLogFolder = new File(cleanGraphLogDir)
cleanGraphLogFolder.mkdirs()


//Sample graph output dir
sampleGraphOutputDir = params.resultsDir + "/makeSampleGraphOutput"
coverageFileChannel = Channel.fromPath(sampleGraphOutputDir + '/*.covg')



// Get first minimum of kmer covg from coverage file in makeSampleGraph process

process getFirstMinimumCoverage {

	input:
		file coverageInfo from coverageFileChannel

	output:
		stdout into firstMinPairChannel 

	script:
		"""
		#!/usr/bin/env python
		sampleName = "$coverageInfo".replace(".ctx.covg","")

		fh = open("$coverageInfo", "r")
		
		pairsList = []
		
		for line in fh:
			line = line.strip()
			pairsList.append(line.split("\t"))
		fh.close()	

		
		firstMinPair = pairsList[2]
		for i in range(2,len(pairsList) - 2):
			if int(pairsList[i][1]) < int(pairsList[i+1][1]):
				firstMinPair = pairsList[i]
				break
		pairString = sampleName + "," + firstMinPair[0]
		print(pairString, end='')	
		"""
}





// Clean graph per sample individually

process cleanGraphPerSampleHighCoverage {
	/**
	publishDir cleanGraphLogDir
	executor params.executor
	queue params.cleanGraphPerSampleQueue
	maxForks params.cleanGraphPerSampleMaxNodes
	time params.cleanGraphPerSampleWalltime
	cpus params.cleanGraphPerSampleCpusNeeded
	*/
	input:
		val firstMinPair from firstMinPairChannel 		
	
	output:
	//	file "cleanGraphPerSample${samplePairFileName}.log"
		stdout into stdoutChannel
	script:
		template 'cleanGraphPerSampleHighCoverage.sh'	

}

