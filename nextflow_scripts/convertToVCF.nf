#!/usr/bin/env nextflow

//Supply folder for conversion to VCF
inputFolderDir = params.resultsDir + "/conversionToVCFInput"
inputFolder = new File (inputFolderDir)
inputFolder.mkdirs()

//Products folder for conversion to VCF
productsFolder = new File (params.resultsDir + "/conversionToVCFOutput")
productsFolder.mkdirs()

//Make log folder
conversionLogDir = params.logDir + "/conversionToVCFLogs"
conversionLogFolder = new File(conversionLogDir)
conversionLogFolder.mkdirs()



//Grab colorlist from combinationGraphInput and convert them to samplelist for vcf conversion
makeCombinationGraphInputDir = params.resultsDir + '/makeCombinationGraphInput'
combinationGraphColorListChannel = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*')

sampleListsDir = inputFolderDir + "/sampleLists"
sampleListsFolder = new File(sampleListsDir)
sampleListsFolder.mkdirs()

process makeSampleList {

	input:
		file colorList from combinationGraphColorListChannel

	stdout:
		stdout into makeSampleListFlag
	script:
		"""
		prefix=colorlistFileToSubmit
		colorListFile=${colorList}
		fileIndex=\${colorListFile#*\${prefix}}
	
		sampleListFile=${sampleListsDir}/sampleList\${fileIndex}
		touch \$sampleListFile

		declare -a sampleArray
		prefix="pathToCleaned"
		index=0
		while read pathToSample
		do
			if ((\$index==0))
			then
				echo "REF" >> \$sampleListFile	
			else
				echo \${pathToSample#*\$prefix} >> \$sampleListFile
			fi

			index=\$((\$index+1))
		done < ${colorList}

		"""

}



processCallsExecutable = params.cortexScriptDir + "/process_calls.pl"





	



