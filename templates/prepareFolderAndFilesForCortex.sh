#!/bin/bash


# Step 1 folder and file preparation

mkdir ${resultsDir}/samplesForStep1

for sampleName in "$processedListOfSamples";
do
	echo ${sampleDir}/"$sampleName"_read1.fq\n > ${resultsDir}/samplesForStep1/"$sampleName"
	echo ${sampleDir}/"$sampleName"_read2.fq\n >> ${resultsDir}/samplesForStep1/"$sampleName"
done

mkdir ${resultsDir}/productsOfStep1


# Step 2 folder and file preparation


mkdir ${resultsDir}/samplesForStep2

for sampleName in "$processedListOfSamples";
do
	echo ${resultsDir}/productsOfStep1/"$sampleName".ctx\n >> ${resultsDir}/samplesForStep2/step2ColorListUncleanedBinarylist
done

echo ${resultsDir}/samplesForStep2/step2ColorListUncleanedBinaryList\n > ${resultsDir}/samplesForStep2/step2PathToBinaryListFile

mkdir ${resultsDir}/productsOfStep2

# Step 3 folder and file preparation

mkdir ${resultsDir}/samplesForAndProductsOfStep3

echo ${resultsDir}/productsOfStep2/step2PoolCleaned.ctx\n > ${resultsDir}/samplesForAndProductsOfStep3/pathToStep2CtxFile

for sampleName in "$processedListOfSamples";
do
	
	echo ${resultsDir}/productsOfStep1/"$sampleName".ctx\n >> ${resultsDir}/samplesForAndProductsOfStep3/pathToStep1CtxFile/"$sampleName"
	
	echo ${resultsDir}/samplesForAndProductsOfStep3/pathToStep2CtxFile\n > ${resultsDir}/samplesForAndProductsOfStep3/colorlist_step3FileToSubmitToCortex"$sampleName"
	echo ${resultsDir}/samplesForAndProductsOfStep3/pathToStep1CtxFile"$sampleName"\n >> ${resultsDir}/samplesForAndProductsOfStep3/colorlist_step3FileToSubmitToCortex"$sampleName"	


done


# Step 4 folder and file preparation

mkdir ${resultsDir}/productsOfStep4


# Step 5 folder and file preparation

mkdir ${resultsDir}/samplesForStep5

echo ${resultsDir}/productsOfStep4/ref.ctx\n > ${resultsDir}/samplesForStep5/pathToRefCtxFile

echo ${resultsDir}/productsOfStep2/step2PoolCleaned.ctx\n > ${resultsDir}/samplesForStep5/pathToCleanedPoolCtxFile

echo ${resultsDir}/samplesForStep5/pathToRefCtxFile\n > ${resultsDir}/samplesForStep5/colorlist_step5FileToSubmitToCortex
echo ${resultsDir}/samplesForStep5/pathToCleanedPoolCtxFile\n >> ${resultsDir}/samplesForStep5/colorlist_step5FileToSubmitToCortex

for sampleName in "$processedListOfSamples";
do
	

	echo ${resultsDir}/samplesForAndProductsOfStep3/"$sampleName"_cleanedByComparisonToPool.ctx\n > ${resultsDir}/samplesForStep5/pathToCleaned/"$sampleName"
	
	echo ${resultsDir}/samplesForStep5/pathToCleaned/"$sampleName"\n >> ${resultsDir}/samplesForStep5/colorlist_step5FileToSubmitToCortex

done

mkdir ${resultsDir}/productsOfStep5

# Step 6 folder and file preparation

mkdir ${resultsDir}/productsOfStep6

dummyForStep6Prep="dummy"



















