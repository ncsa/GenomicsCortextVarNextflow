#!/usr/bin/env nextflow

//Supply folder for conversion to VCF
inputFolderDir = params.resultsDir + "/conversionToVCFInput"
inputFolder = new File (inputFolderDir)
inputFolder.mkdirs()

//Products folder for conversion to VCF
productsFolder = new File (params.resultsDir + "/conversionToVCFOutput")
productsFolder.mkdirs()

//Make VCF log folder
conversionLogDir = params.logDir + "/conversionToVCFLogs"
conversionLogFolder = new File(conversionLogDir)
conversionLogFolder.mkdirs()

//Variant calling output folder
variantCallingOutputDir = params.resultsDir + "/variantCallingOutput"
variantCallingOutputFileChannel = Channel.fromPath(variantCallingOutputDir + "/*")

//Variant calling log folder
variantCallingLogDir = params.logDir + "/variantCallingLogs"

//Grab colorlist from combinationGraphInput and convert them to samplelist for vcf conversion
makeCombinationGraphInputDir = params.resultsDir + '/makeCombinationGraphInput'
combinationGraphColorListChannel = Channel.fromPath(makeCombinationGraphInputDir + '/colorlistFileToSubmit*')

sampleListsDir = inputFolderDir + "/sampleLists"
sampleListsFolder = new File(sampleListsDir)
sampleListsFolder.mkdirs()

process makeSampleList {

	input:
		file colorList from combinationGraphColorListChannel

	output:
		stdout into makeSampleListFlag
	script:
		template 'makeSampleList.sh'	


}

makeVCFStartFlag = makeSampleListFlag.first()

processCallsExecutable = params.cortexScriptDir + "/analyse_variants/process_calls.pl"

process makeVCF {
	
	executor params.executor
	queue params.runConversionToVCFQueue
	maxForks params.runConversionToVCFMaxNodes
	time params.runConversionToVCFWalltime
	cpus params.runConversionToVCFCpusNeeded

	input:
		val flag from makeVCFStartFlag
		file varOutFile from variantCallingOutputFileChannel

	output:
		stdout into stdoutChannel

	script:
		template 'makeVCF.sh'
	
}
stdoutChannel.subscribe{println it}


	



