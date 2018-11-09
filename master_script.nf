#!/usr/bin/env nextflow

nextflowFolder = params.configDir - "nextflow.config" + "nextflow_scripts"


process preflightCheck {	
	output:
		stdout into preflightStdout	

	script:	
		"""
		echo "preflight"
		#cd ${params.resultsDir}
		#${params.nextflowDir} run ${nextflowFolder}/preflightCheck.nf		

		"""
}


process makeSampleDBGraph {
	input:
		val preflightFlag from preflightStdout

	output:
		stdout into makeSampleDBGraphStdout

	script:
		"""
		echo "makeDbGraph"
		#cd ${params.resultsDir}
		#${params.nextflowDir} run ${nextflowFolder}/makeSampleGraph.nf

		"""
}


process poolAndCleanErrors {
	input:
		val makeSampleDBGraphFlag from makeSampleDBGraphStdout

	output:
		stdout into poolAndCleanErrorStdout
	
	script:	
		"""
		echo "pool and clean"
		#cd ${params.resultsDir}
		#${params.nextflowDir} run ${nextflowFolder}/poolAndCleanErrors.nf
		"""

}


process cleanGraphPerSample {
	input:
		val poolCleanStdout from poolAndCleanErrorStdout

	output:
		stdout into cleanGraphPerSampleStdout

	script:
		"""
		echo "clean graph"
		#cd ${params.resultsDir}
		#${params.nextflowDir} run ${nextflowFolder}/cleanGraphPerSample.nf	
		"""

}


process makeReferenceGraph {
	input:
		val preflightFlag from preflightStdout

	output:
		stdout into makeReferenceGraphStdout

	script:
		"""
		echo "make ref graph"
		#cd ${params.resultsDir}
		#${params.nextflowDir} run ${nextflowFolder}/makeReferenceGraph.nf
		"""

}


process makeCombinationGraph {
	input:
		val cleanGraphPerSampleFlag from cleanGraphPerSampleStdout
		val makeRefGraphFlag from makeReferenceGraphStdout
		
	output:
		stdout into makeCombinationGraphStdout
	
	script:
		"""
		echo "make combo graph"
		#cd ${params.resultsDir}
		#${params.nextflowDir} run ${nextflowFolder}/makeCombinationGraph.nf
		"""

}


process variantCalling {
	input:
		val makeCombinationGraphFlag from makeCombinationGraphStdout

	script:
		"""
		echo "variant calling"
		#cd ${params.resultsDir}
		#${params.nextflowDir} run ${nextflowFolder}/variantCalling.nf
		"""

}













