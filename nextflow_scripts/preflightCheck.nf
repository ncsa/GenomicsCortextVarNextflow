#!/usr/bin/env nextflow

process preflightCheck {


	exec:
	//------------------------------------------------------------------------------------------------------------------------------------------------------
	//PREFLIGHT CHECKS -------------------------------------------------------------------------------------------------------------------------------------
	//------------------------------------------------------------------------------------------------------------------------------------------------------
	
	//Checks for Nextflow Directory and Cortex Bin Directory
	nextflowExec = new File(parans.nextflowDir)
	cortexBinDirFile = new File(params.cortexBinDir)

	if (!nextflowExec.exists()) {
		println ("Nextflow executable cannot be found at specified nextflowDir path")
		System.exit(1)
	}

	if (!cortexBinDirFile.exists()) {
		println ("Cortex bin directory does not exist in specified cortexBinDir path")
		System.exit(1)
	}

	//Check for user input for each run(PROCESSNAME) parameter

	if (params.runMakeSampleGraph != "y" && params.runMakeSampleGraph != "n") {
		println ("runMakeSampleGraph must be 'y' or 'n'")
		System.exit(1)
	}

	if (params.runMakePoolAndCleanError != "y" && params.runMakePoolAndCleanError != "n") {
		println ("runMakePoolAndCleanError must be 'y' or 'n'")
		System.exit(1)
	}

	if (params.runCleanSampleGraph != "y" && params.runCleanSampleGraph != "n") {
		println ("runCleanSampleGraph must be 'y' or 'n'")
		System.exit(1)
	}

	if (params.runMakeReferenceGraph != "y" && params.runMakeReferenceGraph != "n") {
		println ("runMakeReferenceGraph must be 'y' or 'n'")
		System.exit(1)
	}

	if (params.runMakeCombinationGraph != "y" && params.runMakeCombinationGraph != "n") {
		println ("runMakeCombinationGraph must be 'y' or 'n'")
		System.exit(1)
	}

	if (params.runVariantCalling != "y" && params.runVariantCalling != "n") {
		println ("runVariantCalling must be 'y' or 'n'")
		System.exit(1)
	}	
	//Cheks if there are read files provided in the sampleDir according to sample list needed by make sample graph

	if (params.runMakeSampleGraph == "y") {
		for (eachSample in params.sampleList) {
			sampleRead1 = new File(params.sampleDir + "/" + eachSample + params.sampleReadPattern + "1" + params.sampleReadExtension)
			sampleRead2 = new File(params.sampleDir + "/" + eachSample + params.sampleReadPattern + "2" + params.sampleReadExtension)
			if (!sampleRead1.exists()) {
				println ("File " + params.sampleDir + "/" + eachSample + params.sampleReadPattern + "1" + params.sampleReadExtension + " does not exist!")
				System.exit(1)	
			} else {
				println ("File " + params.sampleDir + "/" + eachSample + params.sampleReadPattern + "1" + params.sampleReadExtension + " exists!")

			}		
		
			if (!sampleRead2.exists()) {    
					println ("File " + params.sampleDir + "/" + eachSample + params.sampleReadPattern + "2" + params.sampleReadExtension + " does not exist!")
					System.exit(1)
			} else {
					println ("File " + params.sampleDir + "/" + eachSample + params.sampleReadPattern + "2" + params.sampleReadExtension + " exists!")

			}

		}
	}

	// Check for Reference fasta list if make reference graph is called or Path divergence is called

	if (params.runMakeReferenceGraph == "y" || params.PD == "y") {
		referenceListFile = new File(params.pathToReferenceList)
		if (!referenceListFile.exists()) {
			println ("pathToReferenceList provided is not valid!")
			System.exit(1)
		}
	}
		
	
}

