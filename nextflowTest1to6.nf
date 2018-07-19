#!/usr/bin/env nextflow

//------------------------------------------------------------------------------------------------------------------------------------------------------
//PREFLIGHT CHECKS -------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------

//Checks if at least one of Path Divergence or Bubble Caller is selected, if neither is selected, this script is terminated

if ( params.PD == "n" && params.BC == "n" ) {
	println "At least one of PD or BC have to be selected"
	System.exit(0);
}

if (params.PD == "y") {
	println "Path divergence variant calling method is selected"
} else {
	println "Path divergence variant calling method is not selected"
}

if (params.BC == "y") {
	println "Bubble caller variant calling method is selected"
} else {
	println "Bubble caller variant calling method is not selected"
}











//---------Checks for Paths------------


//Checks if sampleDir path exists, if not the script stops

sampleDirPathCheck = new File(params.sampleDir)
if (sampleDirPathCheck.exists()) {
	println "Sample directory exists!"
}
  else {

	println "Sample directory does not exist..."
	println "Terminating script..."
	System.exit(0);

}















//Assigns path to reference genome de Bruijn graph, depending on whether or not step 4 is selected

if (params.runStep4 == "y") {

	pathToRefBinary = params.resultsDir + "/productsOfStep4/" + "ref.ctx\n"

} else if (params.runStep4 == "n") {
	

	//Checks if params.pathToRefCtx given by user exists
	
	givenPathToRefCtxCheck = new File(params.pathToRefCtx)
	if (givenPathToRefCtxCheck.exists()) {

		println "Path to reference binary file given exists!"
		pathToRefBinary = params.pathToRefCtx

	} else {

		println "Path to reference binary file given does not exist!"
		System.exit(0)

	}
	

} else {

	println "runStep4 parameter in nextflow.config needs to be either \"y\" or \"n\""
	println "Terminating script..."
	System.exit(0);

}














//------------------------------------------------------------------------------------------------------------------------------------------------------
//VARIABLES NOT LOCATED IN CONFIG, BUT DERIVED FROM NEXTFLOW.CONFIG FILE--------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------------------

//Note: if there a variable has param. prefix, it is located at nextflow.config file

//Where flags and logs are located

flagDir = params.resultsDir + "/flagsAndLogs"

//Number of samples

numberOfSamples = params.numberOfSamples

//Number of color, this constitutes of number of samples, combined graph, and reference (that is why it is number of samples + 2)

totalColor = numberOfSamples + 2


//------------------------------------------------------------------------------------------------------------------------------------------------------












//Samples takes in all files in the sample directory, places it into array and into a channel called "samples"

samples = Channel.fromPath(params.sampleDir + "/*").toList()





// Step 0: make Files in the right format for Cortex step 1 and files for step 2

process prepareFolderAndFilesForCortexNEXTFLOW {
	
	// This directive can be hard coded, because this will be the sam everytime		

	executor 'local'	

	input:
		// Takes in the list of unprocessed sample list from samples Channel
		val rawSampleList from samples

	output:
		val processedListOfSamples into CortexSampleListChannel
		val preparingStepFinished into dummyFlagPrepFileFinish
	
	exec:
		//---------------------------------------------
		// Makes the out directory and flag directory
		//---------------------------------------------

		resultsDirFolder = new File(params.resultsDir)
		resultsDirFolder.mkdirs()


		flagDirFolder = new File(flagDir)
		flagDirFolder.mkdirs()
		
		// --------------------------------------------





		//----------------------------------------------------------------------------------------------------------------------------------------	
		// Creates a new List and fills it with each sample name and sorts them
		// e.g: from "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/Sample_Magellan_read1.fq"
		// to "Sample_Magellan"
		//----------------------------------------------------------------------------------------------------------------------------------------


		processedListOfSamples = []
		for (eachSample in rawSampleList) {
			sampleString = eachSample.toString()
			if (sampleString.contains("read1.fq")){
			   sampleName = (sampleString - params.sampleDir - "_read1.fq" - "/" )
			   processedListOfSamples.add(sampleName)
			}
		}
		processedListOfSamples.sort()

		//----------------------------------------------------------------------------------------------------------------------------------------








		//-------------------------------------------------------------------------------------------------------------------------
		//Step 1 Folder and File Preparations--------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------------------------------------------------------

		// Makes the supply and product folder for/from step 1
			
		step1SupplyFolder = new File(params.resultsDir + "/samplesForStep1/")
		step1SupplyFolder.mkdirs()
		step1ProductsFolder = new File(params.resultsDir + "/productsOfStep1/")
		step1ProductsFolder.mkdirs()
				
		// Makes a file in supply folder called the sample name (e.g. Sample_Magellan) and writes the path to sample reads
		// e.g "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/Sample_Magellan_read1.fq"
		// and "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/Sample_Magellan_read2.fq"
		// is written to the file "Sample_Magellan" inside supply folder

		for (sampleName in processedListOfSamples) {
			newFile = new File(params.resultsDir + "/samplesForStep1/" + sampleName)

			newFile.write (params.sampleDir + "/" + sampleName + "_read1.fq\n")
			newFile.append (params.sampleDir + "/" + sampleName + "_read2.fq\n")
		}








		//-------------------------------------------------------------------------------------------------------------
		//Step 2 Folder and File Preparations -------------------------------------------------------------------------	
		//-------------------------------------------------------------------------------------------------------------
		
		//Makes supply and product folder for step 2	

		step2SupplyFolder = new File(params.resultsDir + "/samplesForStep2/") 
		step2SupplyFolder.mkdirs()
		step2ProductsFolder = new File(params.resultsDir +"/productsOfStep2/")
		step2ProductsFolder.mkdirs()
		

		//Makes 2 files:
		//	1) File containing the list of path to the binary files outputted by step 1 Cortex
		//	2) File containing the path to file 1)

		step2BinaryListFile = new File(params.resultsDir + "/samplesForStep2/" + "step2ColorListUncleanedBinaryList")
		step2PathToBinaryListFile = new File (params.resultsDir + "/samplesForStep2/" + "step2PathToBinaryListFile")
			
		for (sampleName in processedListOfSamples) {
			step2BinaryListFile.append(params.resultsDir + "/productsOfStep1/" + sampleName + ".ctx\n") 	

		}
		step2PathToBinaryListFile.write(params.resultsDir + "/samplesForStep2/" + "step2ColorListUncleanedBinaryList\n")
			
		//STEP2 ONLY APPENDS, SO EVERYTIME THIS IS RAN WITHOUT DELETING, THE FILE JUST KEEPS ADDING







			
		//------------------------------------------------------------------------------------------------------------
		//Step 3 Folder and File Preparations --------------------------------------------------------------------------------------
		//-------------------------------------------------------------------------------------------------------------

		//Makes supply and product folder for step 3, in step3, cortex dumps the binary files into the same folder, so only 1 folder is created

		step3SupplyAndProductsFolder = new File(params.resultsDir + "/samplesForAndProductsOfStep3/")
		step3SupplyAndProductsFolder.mkdirs()

		//Makes a file that contains the path to results of step 2 binary file

		step3PathToStep2PooledResultFile = new File(params.resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep2CtxFile")
		step3PathToStep2PooledResultFile.write(params.resultsDir + "/productsOfStep2/" + "step2PoolCleaned.ctx\n")
				
		

		for (sampleName in processedListOfSamples) {
		
		//Makes a file for each sample that contains the path to results of step 1 binary file

			step3PathToStep1CtxFile = new File(params.resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep1CtxFile" + sampleName)	
			step3PathToStep1CtxFile.append(params.resultsDir + "/productsOfStep1/" + sampleName + ".ctx\n")
		
		//Makes a file that contains:
		// 	Line 1: The path to the file that contains to the path of step 2 binary file
		// 	Line 2: The path to the file that contains the path to results of step 1 binary file (step3PathToStep1CtxFile)	
		//Cortex requires nested file paths like what's being created here

			step3FiletoSubmitToCortex = new File(params.resultsDir + "/samplesForAndProductsOfStep3/" + "colorlist_step3FileToSubmitToCortex" + sampleName)
			step3FiletoSubmitToCortex.write(params.resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep2CtxFile\n")
			step3FiletoSubmitToCortex.append(params.resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep1CtxFile" + sampleName + "\n")
		}
			
		//-------------------------------------------------------------------------------------------------------------------------------









		//----------------------------------------------------------------------------------------------------------------------------
		//Step 4 Folder and File Preparations ----------------------------------------------------------------------------------------
		//----------------------------------------------------------------------------------------------------------------------------		

		//Note: no supply folder is needed, since the file is from sampleDir, remember that step 4 is like step 1 but with reference,
		//Consequently, step 4 can be run in parallel with step 1 - 3.
			
		step4ProductsFolder = new File(params.resultsDir + "/productsOfStep4/")
		step4ProductsFolder.mkdirs()

		//-------------------------------------------------------------------------------------------------------------------------------









		//----------------------------------------------------------------------------------------------------------------------------
		//Step 5 Folder and File Preparations ----------------------------------------------------------------------------------------
		//----------------------------------------------------------------------------------------------------------------------------
		//Makes supply and product folder for step 5
			
		step5SupplyFolder = new File(params.resultsDir + "/samplesForStep5/")
		step5SupplyFolder.mkdirs()
		step5ProductsFolder = new File(params.resultsDir + "/productsOfStep5/")
		step5ProductsFolder.mkdirs()


		// Make a file that contains the path to product (binary file output) of step 4
		
		step5PathToReferenceUncleanedFile = new File(params.resultsDir + "/samplesForStep5/" + "pathToRefCtxFile")
		step5PathToReferenceUncleanedFile.write(pathToRefBinary)


		//Makes a file that contains the path to product (the binary file output) of step 2		
		step5PathToCleanedPoolFile = new File(params.resultsDir + "/samplesForStep5/" + "pathToCleanedPoolCtxFile")
		step5PathToCleanedPoolFile.write(params.resultsDir + "/productsOfStep2/" + "step2PoolCleaned.ctx\n")
			
		//Makes a file that will be submitted to Cortex, containing the path to the two files created above
		step5FileToSubmitToCortex = new File (params.resultsDir + "/samplesForStep5/" + "colorlist_step5FileToSubmitToCortex")
		step5FileToSubmitToCortex.write(params.resultsDir + "/samplesForStep5/" + "pathToRefCtxFile\n")
		step5FileToSubmitToCortex.append(params.resultsDir + "/samplesForStep5/" + "pathToCleanedPoolCtxFile\n")
		
		//Goes through the sample list
		for (sampleName in processedListOfSamples) {
				
			//Makes a file that contains the path to the cleaned sample binaries (output of step 3)
			step5PathToSamples = new File(params.resultsDir + "/samplesForStep5/" + "pathToCleaned" + sampleName)
			step5PathToSamples.write(params.resultsDir + "/samplesForAndProductsOfStep3/" + sampleName + "_cleanedByComparisonToPool.ctx\n")
			
			//Adds the path to the file containing the path to the cleaned sample binaries (path to file created right above this)
			//into the file that will be submitted by cortex (step5FileToSubmitToCortex variable)
			step5FileToSubmitToCortex.append(params.resultsDir + "/samplesForStep5/" + "pathToCleaned" + sampleName + "\n")
		}

		//-------------------------------------------------------------------------------------------------------------------------------







		//-----------------------------------------------------------------------------------------------------------------------
		// Step 6 Products Folder Preparation (The actual file preparation is after step 5, this is only to make products folder-
		//-----------------------------------------------------------------------------------------------------------------------
			
		//Products folder for step 6
					
		step6ProductsFolder = new File (params.resultsDir + "/productsOfStep6/")
		step6ProductsFolder.mkdirs()

		//-----------------------------------------------------------------------------------------------------------------------
		








		//-------------------------------------------------------------------------------------------------------------------------------

		//Makes a dummy variable to indicate this process ends, useful for control flow
		
		preparingStepFinished = "dummy"

		//-------------------------------------------------------------------------------------------------------------------------------



	}


// Step 1: Run step 1 cortex, making de bruijn graphs


process step1CreateSampleBinaryGraph {

	publishDir flagDir
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded



	input:
	each samplePairFileName from CortexSampleListChannel

	output:
	file "runStep1CortexDone.flag" into flag1
	file "LogStep1_${samplePairFileName}.log"



	script:
	template 'step1CreateSampleBinaryGraph.sh'


}










// flag1Mod is used to take only 1 value of flag, to make the process only run once

flag1Mod = flag1.take(1)








// Step 2: Make pooled de Bruijn Graph


process Step2PoolAndCleanErrors {

	publishDir flagDir
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded


	input:
	file flag from flag1Mod
	
	output:
	file "runStep2CortexDone.flag" into flag2
	file "LogStep2.log"


	script:
	template 'step2CortexPoolAndCleanError.sh'	

	
}









// Step 3: Clean graph per sample using combined graph made in step 2

process step3CleanGraphPerSample {

	publishDir flagDir	
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded


	input:
	file flag from flag2
	each samplePairFileName from CortexSampleListChannel		
	
	output:
	file "runStep3CortexDone.flag" into flag3	
	file "LogStep3_${samplePairFileName}.log"



	script:
	template 'step3CleanGraphPerSample.sh'	

}

// This is used to make flag3 has only 1 value, so the next step will only be done once

flag3Mod = flag3.take(1)






// Optional: step 4 is only run when user asks for it

if (params.runStep4 == "y") {

	// Step 4: Make reference de Bruijn Graph

	process step4MakeReferencedBGraph {

		publishDir flagDir
		executor params.executor
		queue params.mediumRamQueue
		time params.wallTime
		cpus params.cpusNeeded


		input:
		val flag from dummyFlagPrepFileFinish
			
		output:
		file "runStep4CortexDone.flag" into flag4	
		file "LogStep4.log"


		script:
		template 'step4MakeReferencedBGraph.sh'
	}


	// Makes a log file of the standard out of step 4


} else {
	// Replacement for step 4 if it is not selected
	process dummyProcessToReplaceStep4IfNotSelected {
	
	input:
        val flag from dummyFlagPrepFileFinish	
	
	output:
	val dummyValue into flag4 
	
	exec:
	dummyValue = "dummy"
	
	}

}










// Step 5: Combine reference graph with sample graph and cleaned pool

process step5MakeCombinationGraph {
	
	publishDir flagDir
	executor params.executor
	queue params.mediumRamQueue
	time params.wallTime
	cpus params.cpusNeeded


	input:
	file flag from flag3Mod
	val flagagain from flag4
	
	output:
	file "runStep5CortexDone.flag" into flag5forPD
	file "runStep5CortexDone.flag" into flag5forBC
	file "LogStep5.log"

	
	script:

	template 'step5MakeCombinationGraph.sh'



}











//Step6 Preparation

//Prepare step 6, make channels that pair each sample with its index / order like in the supply for step 5 for consistent colour
//Example:
//	if sample name is magellan, and located at index 2 (first, since index 0 is reference de bruijn graph and 1 is combined de bruijn graph according
//	to step 5 colorlist_step5FileToSubmitToCortex)
//	it is processed as "magellan+2"

process prepareStep6VariantCalling {

	publishDir flagDir
	executor 'local'	

	input:	

	val flag from dummyFlagPrepFileFinish	

	output:
	val step6FileListFiltered into step6FileIndexFilteredChannel




	exec:
	
	//Reads colorlist

	step6FileList = file(params.resultsDir + "/samplesForStep5/colorlist_step5FileToSubmitToCortex").readLines()

	
	step6FileListReversed = []

	//Adds each sample in the reverse order in the step6FileListReversed Array

	for (int i = 0; i < step6FileList.size(); i++) {
		step6FileListReversed[step6FileList.size() - 1 - i] = step6FileList[i] - params.resultsDir + "+" + i - "/samplesForStep5/pathToCleaned"

	}


	step6FileListFiltered = []

	//Only takes in the samples, not the reference or combination graph

	for (int i = 0; i < numberOfSamples; i++) {
	step6FileListFiltered[i] = step6FileListReversed[i]

	}




}	












//Step 6 PD : When selected, cortex will use path divergence caller algorithm to identify variants.
//Step6 also includes a renaming script, since nextflow-bash interaction is untidy.

if (params.PD == "y") {
	process step6aPDVariantCalling {

		publishDir flagDir
		executor params.executor
		queue params.highRamQueue
		time params.wallTime
		cpus params.cpusNeeded


		input:
		each fileNameAndNumber from step6FileIndexFilteredChannel	
		val flagnumber5 from flag5forPD	

		output:
		file "runStep6PDCortexDone.flag" into flag6PD	
		file "${fileNameAndNumber}_PD.log" into PDLogFiles


		
		script:
		template 'step6aPDVariantCalling.sh'	


	}	


	// This step renames the file from (sampleName)+(index)_PD.log to sampleName_PD.log

	process step6PDRenameLogFiles {
	
		input:
		file logFile from PDLogFiles
	
		script:
		template 'step6PDRenameLogFiles.sh'
		

	}	


}




//Step 6 BC: When selected, cortex will use bubble caller algorithm to identiy variants.

if (params.BC == "y") {

	process step6bBCVariantCalling {
		publishDir flagDir
		executor params.executor
		queue params.highRamQueue
		time params.wallTime
		cpus params.cpusNeeded


		input:
		each fileNameAndNumber from step6FileIndexFilteredChannel
		val flagnumber5 from flag5forBC
		
		output:
		file "runStep6BCCortexDone.flag" into flag6BC
		file "${fileNameAndNumber}_BC.log" into BCLogFiles	
	

		
		script:
		template 'step6bBCVariantCalling.sh'

	}

	// This step renames the file from (sampleName)+(index)_PD.log to sampleName_BC.log

	process step6BCRenameLogFiles {

		input:
		file logFile from BCLogFiles

		script:
		template 'step6BCRenameLogFiles.sh'


        }


}



