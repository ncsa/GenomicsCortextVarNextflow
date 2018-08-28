#!/usr/bin/env nextflow

// Step 0: make Files in the right format for Cortex step 1 and files for step 2

process prepareFolderAndFilesForCortexNEXTFLOW {
	
	// This directive can be hard coded, because this will be the same everytime		

	executor 'local'	

	exec:
		//Assigns path to reference genome de Bruijn graph, depending on whether or not step 4 is selected
		
		//Checks for step4 is also performed here because step 5 needs path to reference .ctx file, for modularity purposes

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
				System.exit(1)

			}


		} else {

			println "runStep4 parameter in nextflow.config needs to be either \"y\" or \"n\""
			println "Terminating script..."
			System.exit(1);

		}


		//---------------------------------------------
		// Makes the out directory and flag directory
		//---------------------------------------------

		resultsDirFolder = new File(params.resultsDir)
		resultsDirFolder.mkdirs()


		flagDirFolder = new File(params.logDir)
		flagDirFolder.mkdirs()
		
		// --------------------------------------------






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

		for (sampleName in params.sampleList) {
			newFile = new File(params.resultsDir + "/samplesForStep1/" + sampleName)

			newFile.write (params.sampleDir + "/" + sampleName + params.sampleReadPattern + "1" + params.sampleReadExtension + "\n")
			newFile.append (params.sampleDir + "/" + sampleName + params.sampleReadPattern + "2" + params.sampleReadExtension + "\n")
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
			
		for (sampleName in params.sampleList) {
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
				
		

		for (sampleName in params.sampleList) {
		
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



		// Make a file that contains the path to reference graph from step 4
		
		step5PathToReferenceUncleanedFile = new File(params.resultsDir + "/samplesForStep5/" + "pathToRefCtxFile")
		step5PathToReferenceUncleanedFile.write(pathToRefBinary)


		//Makes a file that contains the path to product (the binary file output) of step 2		
		step5PathToCleanedPoolFile = new File(params.resultsDir + "/samplesForStep5/" + "pathToCleanedPoolCtxFile")
		step5PathToCleanedPoolFile.write(params.resultsDir + "/productsOfStep2/" + "step2PoolCleaned.ctx\n")
			
		//Makes a file that will be submitted to Cortex, containing the path to the two files created above
		step5FileToSubmitToCortex = new File (params.resultsDir + "/samplesForStep5/" + "colorlist_step5FileToSubmitToCortex")
		
		//Only writes pathToRefCtxFile if reference reads are provided, otherwise it is not written.

		if (params.referenceReadsProvided == "y") {

			step5FileToSubmitToCortex.write(params.resultsDir + "/samplesForStep5/" + "pathToRefCtxFile\n")
			step5FileToSubmitToCortex.append(params.resultsDir + "/samplesForStep5/" + "pathToCleanedPoolCtxFile\n")
		
		} else {
			step5FileToSubmitToCortex.write(params.resultsDir + "/samplesForStep5/" + "pathToCleanedPoolCtxFile\n")
		}
		//Goes through the sample list
		for (sampleName in params.sampleList) {
				
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
		



}

