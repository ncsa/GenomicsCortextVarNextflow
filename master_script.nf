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

*/
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
/**
process step4MakeReferenceGraph {
	input:
		val step3Flag from cleanGraphPerSampleStdout

	output:
		stdout into makeReferenceGraphStdout

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/step4MakeReferenceDBGraph.nf
		"""

}

process step5MakeCombinationGraph {
	input:
		val step4Flag from makeReferenceGraphStdout
		
	output:
		stdout into makeCombinationGraph
	
	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/step5MakeCombinationGraph.nf
		"""


}

process step6VariantCalling {
	input:
		val step5Flag from makeCombinationGraph

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/step6VariantCalling.nf
		"""

}
*/












