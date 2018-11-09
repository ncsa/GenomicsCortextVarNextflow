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
*/


/**
process makeSampleDBGraph {
	//input:
		//val folderPrepFlag from folderPrepStdout

	output:
		stdout into makeSampleDBGraphStdout

	script:
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/makeSampleGraph.nf

		"""
}



process poolAndCleanErrors {
	//input:
	//	val step1Flag from makeSampleDBGraphStdout

	output:
		stdout into poolAndCleanErrorStdout
	
	script:	
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/poolAndCleanErrors.nf
		"""

}


process cleanGraphPerSample {
	//input:
	//	val step2Flag from poolAndCleanErrorStdout

	output:
		stdout into cleanGraphPerSampleStdout

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/cleanGraphPerSample.nf	
		"""

}


process makeReferenceGraph {
	//input:
	//	val step3Flag from cleanGraphPerSampleStdout

	output:
		stdout into makeReferenceGraphStdout

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/makeReferenceGraph.nf
		"""

}
*/
/**
process makeCombinationGraph {
	//input:
	//	val step4Flag from makeReferenceGraphStdout
		
	output:
		stdout into makeCombinationGraph
	
	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/makeCombinationGraph.nf
		"""

}
*/

process variantCalling {
	//input:
	//	val step5Flag from makeCombinationGraph

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/variantCalling.nf
		"""

}













