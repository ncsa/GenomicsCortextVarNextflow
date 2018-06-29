#!/usr/bin/env nextflow

sampleDir = "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads"

resultsDir = "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/testingStep1to6/results"

flagDir = resultsDir + "/flags"



//---------------------------------------------------------------------------------------------------------------------------------------
//CORTEX DIRECTORIES and VARIABLES

numberOfSamples = 2
totalColor = numberOfSamples + 2

cortexDirStep12and4 = "/projects/bioinformatics/builds/CORTEX_release_v1.0.5.21_matt_k/bin/cortex_var_63_c1"
cortexDirStep3 = "/projects/bioinformatics/builds/CORTEX_release_v1.0.5.21_matt_k/bin/cortex_var_63_c" + numberOfSamples
cortexDirStep5and6 = "/projects/bioinformatics/builds/CORTEX_release_v1.0.5.21_matt_k/bin/cortex_var_63_c" + (numberOfSamples + 2)
cortexDirForVCF = "/projects/bioinformatics/builds/CORTEX_release_v1.0.5.21/scripts/analyse_variants/process_calls.pl"

//Note To Fix = step 1,2,4 always 1 color (c1), step 3 color = number of samples, step 5 color = number of samples + 2
//Implement this when making the config file

cortexConfig = "--kmer_size 63 --mem_height 25 --mem_width 75"

quality_score_threshold = 5

//---------------------------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------------------------------------
//STAMPY DIRECTORIES AND VARIABLES

pathToRefDir = "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/smallerSamples/shortSamplesMagMavFqReads/stampyFolder/GCF_000004515.4_Glycine_max_v2.0_genomic.1.fna"

refFileName = "GCF_000004515.4_Glycine_max_v2.0_genomic.1.fna"

pathToStampy = "/projects/bioinformatics/builds/stampy-1.0.28/stampy.py"

vcfToolsDir = "/projects/bioinformatics/builds/vcftools-0.1.14/vcftools-0.1.14"

//---------------------------------------------------------------------------------------------------------------------------------------


samples = Channel.fromPath(sampleDir + "/*").toList()

// Step 0: make Files in the right format for Cortex step 1 and files for step 2

process prepareFolderAndFilesForCortexNEXTFLOW {
	
	publishDir flagDir
	executor 'local'	

	input:
	val rawSampleList from samples

	output:
	val processedListOfSamples into CortexSampleListChannel
	val dummyForStep6Prep into dummyFlagPrepFileFinish
	
	exec:
	resultsDirFolder = new File(resultsDir)
	resultsDirFolder.mkdirs()


	flagDirFolder = new File(flagDir)
	flagDirFolder.mkdirs()


	processedListOfSamples = []
	for (eachSample in rawSampleList) {
		sampleString = eachSample.toString()
		if (sampleString.contains("read1.fq")){
		   sampleName = (sampleString - sampleDir - "_read1.fq" - "/" )
		   processedListOfSamples.add(sampleName)
		}
	}
	processedListOfSamples.sort()




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
		
}


// Step 1: Run step 1 cortex, making de bruijn graphs


process runStep1Cortex {

	publishDir flagDir
	input:
	each samplePairFileName from CortexSampleListChannel

	output:
	file "runStep1CortexDone.flag" into flag1
	stdout into step1StdoutChannel	


	script:
	template 'step1Cortex.sh'


}

step1StdoutChannel.subscribe {
        step1LogFile = new File(resultsDir + "/productsOfStep1" + "/step1LogFile.log")
        step1LogFile.write(it)
}






// Step 1+ : Make Files for step 2, combined graph
// input must be flags to control flow, and sampleStringList to keep sample Names

flag1Mod = flag1.take(1)

// Step 2: Make pooled Graph


process runStep2Cortex {
	publishDir flagDir

	input:
	file flag from flag1Mod
	
	output:
	file "runStep2CortexDone.flag" into flag2
	stdout into step2StdoutChannel

	script:
	template 'step2Cortex.sh'	

	
}

step2StdoutChannel.subscribe {
        step2LogFile = new File(resultsDir + "/productsOfStep2" + "/step2LogFile.log")
        step2LogFile.write(it)
}




// Step 3: Clean Graph per Sample

process runStep3Cortex {
	publishDir flagDir	

	input:
	file flag from flag2
	each samplePairFileName from CortexSampleListChannel		
	
	output:
	file "runStep3CortexDone.flag" into flag3	
	stdout into step3StdoutChannel


	script:
	template 'step3Cortex.sh'	

}


flag3Mod = flag3.take(1)

step3StdoutChannel.subscribe {
	step3LogFile = new File(resultsDir + "/samplesForAndProductsOfStep3" + "/step3LogFile.log")
	step3LogFile.write(it)
}



// Step 4: Make reference de Bruijn Graph

process runStep4Cortex {
	publishDir flagDir
	
	input:
	val flag from dummyFlagPrepFileFinish
		
	output:
	file "runStep4CortexDone.flag" into flag4	
	stdout into step4StdoutChannel

	script:
	template 'step4Cortex.sh'
}

step4StdoutChannel.subscribe {
        step4LogFile = new File(resultsDir + "/productsOfStep4" + "/step4LogFile.log")
        step4LogFile.write(it)
}



// Step 5: Combine reference graph with sample graph and cleaned pool

process runStep5Cortex {
	
	publishDir flagDir

	input:
	file flag from flag3Mod
	file flagagain from flag4
	
	output:
	file "runStep5CortexDone.flag" into flag5
	stdout into step5StdoutChannel
	
	script:

	template 'step5Cortex.sh'



}

step5StdoutChannel.subscribe{
	step5LogFile = new File(resultsDir + "/productsOfStep5" + "/step5LogFile.log")
	step5LogFile.write(it)
}





//Step6 Preparation

//Prepare step 6, make channels that pair each sample with its index / order like in the supply for step 5 for consistent colour

process prepareStep6 {
	publishDir flagDir
	executor 'local'	

	input:	

	val flag from dummyFlagPrepFileFinish	

	output:
	val step6FileListFiltered into step6FileIndexFilteredChannel




	exec:
	step6FileList = file(resultsDir + "/samplesForStep5/colorlist_step5FileToSubmitToCortex").readLines()

	step6FileListReversed = []

	for (int i = 0; i < step6FileList.size(); i++) {
		step6FileListReversed[step6FileList.size() - 1 - i] = step6FileList[i] - resultsDir + "+" + i - "/samplesForStep5/pathToCleaned"

	}


	step6FileListFiltered = []

	for (int i = 0; i < numberOfSamples; i++) {
	step6FileListFiltered[i] = step6FileListReversed[i]

	}




}	







//Step 6: Path Divergence Caller

process step6Cortex{
	publishDir flagDir
	queue 'super_mem'
	time '10h'	

	input:
	each fileNameAndNumber from step6FileIndexFilteredChannel	
	val flagnumber5 from flag5	

	output:
	file "runStep6CortexDone.flag" into flag6	

	stdout into Step6StdoutChannel
	
	script:
	template 'step6Cortex.sh'	


}

Step6StdoutChannel.subscribe{
	step6LogFile = new File(resultsDir + "/productsOfStep6" + "/step6LogFile.log")
	step6LogFile.write(it)
}

/**
stdoutChannel.subscribe{println it}

//INPUT COMMANDS LEFT 14 JUNE 2018
//stdoutChannel.subscribe{println it}

//Step 6: Bubble Caller

process step6CortexBubbleCaller{
	input:
	each fileNameAndNumber from step6FileIndexFilteredChannel
	
	shell:
	"""
	FAN=${fileNameAndNumber}
	!{cortexDirStep5and6} --kmer_size 63 --mem_height 29 --mem_width 55 --multicolour_bin !{resultsDir}/productsOfStep5/finalCombinationGraphWithRef.ctx --detect_bubbles1 \${FAN#*+}/\${FAN#*+} --output_bubbles1 !{resultsDir}/productsOfStep6/step6_BubbleCaller\${FAN%+*}.out --print_colour_coverages 
	"""

}



//TRY RUNNING THIS AFTER PD CALLER DONE

//Step 7 : make hash of reference chromosome and convert into VCF for PATHDIVERGENCE

process step7Prep {

	publishDir flagDir	

	input:
	val listAsFlag from CortexSampleListChannel
	//each fileNameAndNumber from step6FileIndexFilteredChannel
	
	output:
	file "runStep7PrepCortexDone.flag" into flag7Prep 

	shell:
	"""
	module load python/2.7.9

	echo !{pathToRefDir}
	
	!{pathToStampy} -G !{resultsDir}/samplesForStep7/stampyRefFile !{pathToRefDir}
	!{pathToStampy} -g !{resultsDir}/samplesForStep7/stampyRefFile -H !{resultsDir}/samplesForStep7/stampyRefFile
		

	echo "" > runStep7PrepCortexDone.flag 
	"""


}

//flag7PrepTaken = flag7Prep.take(1)


process step7Exec{
	
	input:
	each fileNameAndNumber from step6FileIndexFilteredChannel
	val flag from flag7Prep


	shell:

	"""
	module load python/2.7.9
	
	FAN=${fileNameAndNumber}

	!{cortexDirForVCF} --callfile !{resultsDir}/productsOfStep6/step6_PathDivergence\${FAN%+*}.out_pd_calls --callfile_log !{resultsDir}/logs/S6_\${FAN%+*}_PD_Cortex.out --outvcf \${FAN%+*}VCF --outdir !{resultsDir}/productsOfStep7 --samplename_list !{resultsDir}/samplesForStep7/sampleListForStep7 --num_cols !{totalColor} --stampy_bin !{pathToStampy} --stampy_hash !{resultsDir}/samplesForStep7/stampyRefFile --vcftools_dir !{vcfToolsDir} --kmer 63 --refcol 0 --ploidy 2 --ref_fasta !{pathToRefDir} --caller PD 
	"""
	
}


//STEP 7 WORKS USING MATT'S LOG FILES!!!
*/

