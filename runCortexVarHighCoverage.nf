#!/usr/bin/env nextflow

nextflowFolder = params.configDir - "nextflow.config" + "nextflow_scripts"

/**
process preflightCheck {	
	output:
		stdout into preflightStdout	

	script:	
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/preflightCheck.nf		

		"""
}


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

process cleanGraphPerSample {
	//input:
	//	val makeSampleDBGraphFlag from makeSampleDBGraphStdout

	output:
		stdout into cleanGraphPerSampleStdout

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/cleanGraphPerSampleHighCoverage.nf
		"""

}


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
*/

process makeCombinationGraph {
	//input:
	//	val cleanGraphPerSampleFlag from cleanGraphPerSampleStdout
	//	val makeRefGraphFlag from makeReferenceGraphStdout
		
	output:
		stdout into makeCombinationGraphStdout
	
	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/makeCombinationGraphHighCoverage.nf
		"""

}
/*

process variantCalling {
	input:
		val makeCombinationGraphFlag from makeCombinationGraphStdout

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/variantCalling.nf
		"""

}










*/


