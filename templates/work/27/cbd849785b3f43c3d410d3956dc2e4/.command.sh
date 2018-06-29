#!/usr/bin/env nextflow

step6FileList = file("/projects/bioinformatics/DaveStuff/nextFlowUltimateFolder/testingStep1to6/results" + "/samplesForStep5/colorlist_step5FileToSubmitToCortex").readLines()

step6FileListReversed = []

for (int i = 0; i < step6FileList.size(); i++) {
	step6FileListReversed[step6FileList.size() - 1 - i] = step6FileList[i] - resultsDir + "+" + i - "/samplesForStep5/pathToCleaned"

}


step6FileListFiltered = []

for (int i = 0; i < 2; i++) {
	step6FileListFiltered[i] = step6FileListReversed[i]

}
