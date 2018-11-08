#!/usr/bin/env nextflow

process preflightCheck {


	exec:
	//------------------------------------------------------------------------------------------------------------------------------------------------------
	//PREFLIGHT CHECKS -------------------------------------------------------------------------------------------------------------------------------------
	//------------------------------------------------------------------------------------------------------------------------------------------------------

	//Checks if at least one of Path Divergence or Bubble Caller is selected, if neither is selected, this script is terminated

	if (params.PD == "n" && params.BC == "n" ) {
		println "At least one of PD or BC have to be selected"
		System.exit(1)
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
	
	//Checks if referenceReadsProvided, if it is not provided and user tries to run PD, script will exit

	if (params.referenceReadsProvided == "y") {
		println "Reference reads provided!"
		
		//Then checks existence of reference read directory
		checkRefGivenExists = new File(params.pathToReferenceList)
		if (checkRefGivenExists.exists()) {
			println "Path to reference given exists!"
			
		} else {
			println "Path to reference reads given does not exist!"
			System.exit(1)
		}
	} else {
		println "Reference reads not provided!"

		if (params.PD == "y") {
			println "Path Divergence cannot be called without reference reads!"
			System.exit(1)
		} else if (params.runStep4 == "y") {
			println "Running step 4 cannot be done without reference reads!"
			System.exit(1)
		}
	}
	

	
	//Assigns path to reference genome de Bruijn graph, depending on whether or not step 4 is selected

	if (params.runStep4 == "y") {

		pathToRefBinary = params.resultsDir + "/productsOfStep4/" + "ref.ctx\n"

	} else if (params.runStep4 == "n") {


		//Checks if params.pathToRefCtx given by user exists

		givenPathToRefCtxCheck = new File(params.pathToRefCtx)
		if (givenPathToRefCtxCheck.exists()) {

			println "Path to reference binary file given exists!"


		} else {

			println "Path to reference binary file given does not exist!"
			System.exit(1)

		}


	} else {

		println "runStep4 parameter in nextflow.config needs to be either \"y\" or \"n\""
		println "Terminating script..."
		System.exit(1);

	}

	//Cheks if there are read files provided in the sampleDir according to sample list

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

