#!/usr/bin/env nextflow

nextflowFolder = params.cloneDir + "/nextflow_scripts"

process preflightCheck {	
	output:
		stdout into preflightStdout	

	script:	
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/preflightCheck.nf		

		"""
}

if (params.runMakeSampleGraph == "y") {

	process makeSampleDBGraph {
		input:
			val preflightFlag from preflightStdout

		output:
			stdout into makeSampleDBGraphStdout

		script:
			"""
			cd ${params.resultsDir}
			${params.nextflowDir} run ${nextflowFolder}/makeSampleGraph.nf

			"""
	}

} else {

	makeSampleDBGraphStdout = Channel.from('DummyFlag')

}


if (params.runCleanSampleGraph == "y") {

	process cleanGraphPerSample {
		input:
			val preflightFlag from preflightStdout
			val makeSampleDBGraphFlag from makeSampleDBGraphStdout

		output:
			stdout into cleanGraphPerSampleStdout

		script:
			"""
			cd ${params.resultsDir}
			${params.nextflowDir} run ${nextflowFolder}/cleanGraphPerSampleHighCoverage.nf
			"""

	}

} else {

	cleanGraphPerSampleStdout = Channel.from('DummyFlag')

}

if (params.runMakeReferenceGraph == "y") {

	process makeReferenceGraph {
		input:
			val preflightFlag from preflightStdout

		output:
			stdout into makeReferenceGraphStdout

		script:
			"""
			cd ${params.resultsDir}
			${params.nextflowDir} run ${nextflowFolder}/makeReferenceGraph.nf
			"""

	}

} else {

	makeReferenceGraphStdout = Channel.from('DummyFlag')

}

if (params.runMakeCombinationGraph == "y") {

	process makeCombinationGraph {
		input:
			val preflightFlag from preflightStdout
			val cleanGraphPerSampleFlag from cleanGraphPerSampleStdout
			val makeRefGraphFlag from makeReferenceGraphStdout
			
		output:
			stdout into makeCombinationGraphStdout
		
		script:
			"""
			cd ${params.resultsDir}
			${params.nextflowDir} run ${nextflowFolder}/makeCombinationGraphHighCoverage.nf
			"""

	}

} else {

	makeCombinationGraphStdout = Channel.from('DummyFlag')

}

if (params.runVariantCalling == "y") {

	process variantCalling {
		input:
			val preflightFlag from preflightStdout
			val makeCombinationGraphFlag from makeCombinationGraphStdout
		output:
			stdout into runVariantCallingStdout
		script:
			"""
			cd ${params.resultsDir}
			${params.nextflowDir} run ${nextflowFolder}/variantCalling.nf
			"""

	}

} else {

	runVariantCallingStdout = Channel.from('DummyFlag')

}

if (params.runConversionToVCF == "y") {
	
	process convertToVCF {
		input:
			val preflightFlag from preflightStdout
			val variantCallingFlag from runVariantCallingStdout
		script:
			"""
			cd ${params.resultsDir}
			${params.nextflowDir} run ${nextflowFolder}/convertToVCF.nf
			""" 
	}

} else {
	
	runConversionToVCFStdout = Channel.from('DummyFlag')	

}
