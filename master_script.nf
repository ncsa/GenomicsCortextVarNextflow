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



process makeSampleDBGraph {
	input:
		val folderPrepFlag from folderPrepStdout

	output:
		stdout into makeSampleDBGraphStdout

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/step1MakeSampleBinaryGraph.nf

		"""
}

/**
process step2PoolAndCleanErrors {
	input:
		val step1Flag from makeSampleDBGraphStdout

	output:
		stdout into poolAndCleanErrorStdout
	
	script:	
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/step2PoolAndCleanErrors.nf
		"""

}

process step3CleanGraphPerSample {
	input:
		val step2Flag from poolAndCleanErrorStdout

	output:
		stdout into cleanGraphPerSampleStdout

	script:
		"""
		cd ${params.resultsDir}
		${params.nextflowDir} run ${nextflowFolder}/step3CleanGraphPerSample.nf	
		"""

}

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












