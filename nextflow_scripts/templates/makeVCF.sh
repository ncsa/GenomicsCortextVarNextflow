#!/bin/bash

module load python-2.7.9

varOutFileBash=$varOutFile
sampleNameVarCallMethod=\${varOutFileBash%_*}
sampleName=\${sampleNameVarCallMethod%_*}
varCallMethodLower=\${sampleNameVarCallMethod: -2}

if [ \$varCallMethodLower = "pd" ]; then
	varCallMethodUpper="PD"
fi

callFile=$varOutFile
callFileLog=${variantCallingLogDir}/\${varCallMethodUpper}Logs/\${sampleName}_\${varCallMethodUpper}.log
outVCF=\$varOutFileBash
outDir=$productsFolder
sampleListFile=""
echo \$sampleName
if [[ "\$sampleName" == "combinationGraph"* ]]; then
	combinationGraphIndex=\${sampleName#"combinationGraph"}
	sampleListFile=${sampleListsDir}/sampleList\${combinationGraphIndex}
else
	for sampleList in ${sampleListsDir}/*;
	do
		while read sample;
		do
			if [ \$sample = \$sampleName ]; then
				sampleListFile=\$sampleList

				break
			fi
		done < \$sampleList
	done
fi

numcols=$params.finalCombinationGraphMaxColor
stampyExecutable=$params.stampyBin
stampyHashProducts=$params.stampyHashProducts
VCFToolsDir=$params.VCFToolsDir
caller=\$varCallMethodUpper
kmerSize=$params.kmerSize
refCol=0
ploidy=$params.samplePloidy
refFastaFile=$params.referenceFasta

${processCallsExecutable} --callfile \${callFile} --callfile_log \${callFileLog} --outvcf \${outVCF} --outDir \${outDir}/\${sampleName} --samplename_list \${sampleListFile} --num_cols \${numcols} --stampy_bin \${stampyExecutable} --stampy_hash \${stampyHashProducts} --vcftools_dir \${VCFToolsDir} --caller \${caller} --kmer \${kmerSize} --refcol \${refCol} --ploidy \${ploidy} --ref_fasta \${refFastaFile} > ${conversionLogDir}/\${sampleName}VCFConversion.log
