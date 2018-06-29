#!/usr/bin/env nextflow

sampleDir = "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads"

resultsDir = "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/testingStep1to6/results"

flagDir = resultsDir + "/flags"

rawSampleList = Channel.fromPath(sampleDir + "/*").toList()

println rawSampleList.getClass()

resultsDirFolder = new File(resultsDir)
resultsDirFolder.mkdirs()


flagDirFolder = new File(flagDir)
flagDirFolder.mkdirs()


processedListOfSamples = []
for (eachSample in rawSampleList) {
	sampleString = eachSample.toString()
	//println sampleString
	
	if (sampleString.contains("read1.fq")){
   	   sampleName = (sampleString - sampleDir - "_read1.fq" - "/" )
	   //println sampleName
	   processedListOfSamples.add(sampleName)
	}
	
}

/**
processedListOfSamples.sort()

println processedListOfSamples


//-------------------------------------------------------------------------------------------------------------
//Step 1 Folder and File Preparations--------------------------------------------------------------------------------------


	
step1SupplyFolder = new File(resultsDir + "/samplesForStep1/")
step1SupplyFolder.mkdirs()
step1ProductsFolder = new File(resultsDir + "/productsOfStep1/")
step1ProductsFolder.mkdirs()
		
for (sampleName in processedListOfSamples) {
	newFile = new File(resultsDir + "/samplesForStep1/" + sampleName)

	newFile.write (sampleDir + "/" + sampleName + "_read1.fq\n")
        newFile.append (sampleDir + "/" + sampleName + "_read2.fq\n")
}






//-------------------------------------------------------------------------------------------------------------
//Step 2 Folder and File Preparations ----------------------------------------------------------------------------------------	

step2SupplyFolder = new File(resultsDir + "/samplesForStep2/") 
step2SupplyFolder.mkdirs()
step2BinaryListFile = new File(resultsDir + "/samplesForStep2/" + "step2ColorListUncleanedBinaryList")
step2PathToBinaryListFile = new File (resultsDir + "/samplesForStep2/" + "step2PathToBinaryListFile")
step2ProductsFolder = new File(resultsDir +"/productsOfStep2/")
step2ProductsFolder.mkdirs()
	
for (sampleName in processedListOfSamples) {
	step2BinaryListFile.append(resultsDir + "/productsOfStep1/" + sampleName + ".ctx\n") 	

}
step2PathToBinaryListFile.write(resultsDir + "/samplesForStep2/" + "step2ColorListUncleanedBinaryList\n")
	
//REMEMBER THAT STEP2 ONLY APPENDS, SO EVERYTIME THIS IS RAN, THE FILE JUST KEEPS ADDING






	
//------------------------------------------------------------------------------------------------------------
//Step 3 Folder and File Preparations --------------------------------------------------------------------------------------

step3SupplyFolder = new File(resultsDir + "/samplesForAndProductsOfStep3/")
step3SupplyFolder.mkdirs()
step3PathToStep2PooledResultFile = new File(resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep2CtxFile")
step3PathToStep2PooledResultFile.write(resultsDir + "/productsOfStep2/" + "step2PoolCleaned.ctx\n")
		
	
for (sampleName in processedListOfSamples) {
 	step3PathToStep1CtxFile = new File(resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep1CtxFile" + sampleName)	
     	step3PathToStep1CtxFile.append(resultsDir + "/productsOfStep1/" + sampleName + ".ctx\n")
        step3FiletoSubmitToCortex = new File(resultsDir + "/samplesForAndProductsOfStep3/" + "colorlist_step3FileToSubmitToCortex" + sampleName)
	step3FiletoSubmitToCortex.write(resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep2CtxFile\n")
	step3FiletoSubmitToCortex.append(resultsDir + "/samplesForAndProductsOfStep3/" + "pathToStep1CtxFile" + sampleName + "\n")
}
	






//------------------------------------------------------------------------------------------------------------		
//Step 4 Folder and File Preparations ----------------------------------------------------------------------------------------
	
//Note: no supply folder is needed, since the file is from sampleDir, remember that step 4 is like step 1 but with reference,
//Consequently, step 4 can be run in parallel with step 1 - 3.
	
step4ProductsFolder = new File(resultsDir + "/productsOfStep4/")
step4ProductsFolder.mkdirs()







//------------------------------------------------------------------------------------------------------------
//Step 5 Folder and File Preparations ----------------------------------------------------------------------------------------
	
step5SupplyFolder = new File(resultsDir + "/samplesForStep5/")
step5SupplyFolder.mkdirs()
step5PathToReferenceUncleanedFile = new File(resultsDir + "/samplesForStep5/" + "pathToRefCtxFile")
step5PathToReferenceUncleanedFile.write(resultsDir + "/productsOfStep4/" + "ref.ctx\n")
	
step5PathToCleanedPoolFile = new File(resultsDir + "/samplesForStep5/" + "pathToCleanedPoolCtxFile")
step5PathToCleanedPoolFile.write(resultsDir + "/productsOfStep2/" + "step2PoolCleaned.ctx\n")
	
	
step5FileToSubmitToCortex = new File (resultsDir + "/samplesForStep5/" + "colorlist_step5FileToSubmitToCortex")
step5FileToSubmitToCortex.write(resultsDir + "/samplesForStep5/" + "pathToRefCtxFile\n")
step5FileToSubmitToCortex.append(resultsDir + "/samplesForStep5/" + "pathToCleanedPoolCtxFile\n")
	
for (sampleName in processedListOfSamples) {
		
	step5PathToSamples = new File(resultsDir + "/samplesForStep5/" + "pathToCleaned" + sampleName)
	step5PathToSamples.write(resultsDir + "/samplesForAndProductsOfStep3/" + sampleName + "_cleanedByComparisonToPool.ctx\n")
	step5FileToSubmitToCortex.append(resultsDir + "/samplesForStep5/" + "pathToCleaned" + sampleName + "\n")
}

step5ProductsFolder = new File(resultsDir + "/productsOfStep5/")
step5ProductsFolder.mkdirs()






//-----------------------------------------------------------------------------------------------------------------------
// Step 6 Products Folder Preparation (The actual file preparation is after step 5, this is only to make products folder-
//-----------------------------------------------------------------------------------------------------------------------
	
	step6ProductsFolder = new File (resultsDir + "/productsOfStep6/")
	step6ProductsFolder.mkdirs()
	
	dummyForStep6Prep = "dummy"	




//EXPLAIN WHY FOR EACH
*/
