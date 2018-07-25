#!/usr/bin/env nextflow

nextflowFolder = "/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/testingNestedNextflow/nextflow_scripts"


process preflightCheck {
	
	output:
		stdout into preflightStdout	

	script:	
		"""
		module load nextflow/nextflow-0.30.1.4844 
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/preflightCheck.nf		

		"""
}


process folderPrep {

	input:
		val preflightFlag from preflightStdout

	output:
		stdout into folderPrepStdout

	script:	
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/step0FileFolderPrep.nf
		"""	

}


process step1MakeSampleDBGraph {
	input:
		val folderPrepFlag from folderPrepStdout

	output:
		stdout into makeSampleDBGraphStdout

	script:
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/step1MakeSampleBinaryGraph.nf

		"""
}


process step2PoolAndCleanErrors {
	input:
		val step1Flag from makeSampleDBGraphStdout

	output:
		stdout into poolAndCleanErrorStdout
	
	script:	
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/step2PoolAndCleanErrors.nf
		"""

}

process step3CleanGraphPerSample {
	input:
		val step2Flag from poolAndCleanErrorStdout

	output:
		stdout into cleanGraphPerSampleStdout

	script:
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/step3CleanGraphPerSample.nf	
		"""

}

process step4MakeReferenceGraph {
	input:
		val step3Flag from cleanGraphPerSampleStdout

	output:
		stdout into makeReferenceGraphStdout

	script:
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/step4MakeReferenceDBGraph.nf
		"""

}

process step5MakeCombinationGraph {
	input:
		val step4Flag from makeReferenceGraphStdout
		
	output:
		stdout into makeCombinationGraph
	
	script:
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/step5MakeCombinationGraph.nf
		"""


}

process step6VariantCalling {
	input:
		val step5Flag from makeCombinationGraph

	script:
		"""
		module load nextflow/nextflow-0.30.1.4844
		cd ${params.resultsDir}
		nextflow run ${nextflowFolder}/step6VariantCalling.nf
		"""

}











*/


