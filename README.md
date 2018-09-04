# Structural Variant Calling with Cortex-Var on Nextflow

This repo is a variant calling pipeline that uses [cortex_var](http://cortexassembler.sourceforge.net/index_cortex_var.html) written in [Nextflow](https://www.nextflow.io/), for use in detecting de-novo structural variance in whole-genome reads.

You may use this README file to understand how the scripts are organized and how the codes are structured. Additionally, this README file also provides a brief explanation about how cortex-var behaves.

Files in this repo are organized as follows:

| Folder / Files | Contents |
| --- | --- |
| master_script.nf | Nextflow script to be run by user |
| nextflow.config | Configuration file to be edited by user |
| nextflow_scripts | Individual nextflow scripts for each step in cortex-var |
| usefulCalculators | Tools to identify parameters for config file |
## Intended pipeline architecture and function
This workflow implements [Cortex-var workflow](http://cortexassembler.sourceforge.net/index_cortex_var.html) for structural variant calling in whole genome reads.

The cortex-var workflow consists of the following steps:
 1. Create binary graphs for each sample (paired reads)
 2. Create pooled binary graph and clean sequencing errors
 3. Clean the errors in individual samples according to the pooled graph
 4. Create reference binary graph (optional step, can be done beforehand)
 5. Combine reference graph with sample graphs and cleaned pool
 6. Call variants by Bubble Caller and/or Path Divergence
 
 
 
 

## Installation

### Dependencies

- [cortex_var](http://cortexassembler.sourceforge.net/index_cortex_var.html)
- [Nextflow](https://www.nextflow.io/) 0.30.1.4844 or newer is recommeded

### Workflow Installation

Clone this repository

## User Guide

The workflow is controlled by modifying nextflow.config file.

### Nextflow.config parameters

**`nextflowDir`**

Directory to nextflow executable should be specified here, for example: `path/to/nextflow/executable`

#### Running Options

**`PD`**

Specify if user would like to run path-divergence variant calling. Indicate using literal characters "n" or "y" (quotation marks needed). If something other than these two inputs are specificed, the workflow will not run.

**`BC`**

Specify if user would like to run bubble-caller variant calling. Indicate using literal characters "n" or "y" (quotation marks needed). If something other than these two inputs are specificed, the workflow will not run.

**`referenceReadsProvided`**

Specify if user has reference genome reads (like .fna files). Indicate using literal characters "n" or "y" (quotation marks needed). If something other than these two inputs are specificed, the workflow will not run.

**NOTE:** Path divergence variant calling can only be done when reference reads is available. So the workflow can only run when path divergence when reference reads are provided. However, Bubble caller variant calling method is idependent of the reference reads, so it is possible to conduct bubble caller variant calling without providing reference reads.

#### Source, Config, and Destination Directory

**`sampleDir`**

Path to where samples are located, as a string. Example: `"/PATH/TO/SAMPLE/DIRECTORY"`

**`configDir`**

A String, path to the nextflow.config file, where these parameters will be filled and modified.

**`resultsDir`**

A String, path to where results of each step will be dumped. Example: `"/PATH/TO/RESULTS/DIRECTORY"`

**`pathToReferenceList`**

(FILL THIS TOMORROW)

**`pathToRefCtx`**
If user chooses not to run step 4 in cortex (making the reference graph), path to reference binary (.ctx file) must be specified within this parameter.

Example: `"/PATH/TO/STEP4/BINARY/FILE.ctx"`

#### Sample_specific parameters

This section will be a little tedious, as it involves strict formats for each sample reads.
Given 2 sample pairs Sample_Maverick.read1.fq, Sample_Maverick.read2.fq, Sample_Magellan.read1.fq, Sample_Magellan.read2.fq, here are how the parameters should be filled.
**`sampleList`**

An array, with the sample names enclosed within quotation marks and separated by comma, all enclosed within `[]`

Example: With examples given, the `sampleList` should be filled with: `["Sample_Maverick", "Sample_Magellan"]`

**`sampleReadPattern`**

A string, with how sample name is followed by the reads.
Example: 
- With example given, the `sampleReadPattern` should be filled with "\.read"
- If the sample names are formatted as: Sample_name_read1.fq and Sample_name_read2.fq, `sampleReadPattern` should be filled with "\_read"

**`sampleReadExtension`**

A String, this variable should be filled with the extension of the sample
In example given, `sampleReadExtension` should be filled with ".fq"




















## Quick Start

### Introduction
This nexflow-adapted workflow uses the tool [cortex_var](http://cortexassembler.sourceforge.net/index_cortex_var.html) based on [cortex_var paper](https://www.nature.com/articles/ng.1028). The variant calls are reference free, but reference is needed to locate these variant in known genome.

### Dependencies

 - [Nextflow (recommended 30.1.4844 or newer)](https://www.nextflow.io/)
 - [Cortex_var tool](http://cortexassembler.sourceforge.net/index_cortex_var.html)

### How to install

```
cd {desired directory}

git clone https://github.com/ncsa/GenomicsCortextVarNextflow.git
```

### How to use

After cloning the repository, go to cortex_Var_NF/nextflow.config. Follow the instructions within the file and provide necessary directories.

If there are difficulties in setting height and width for each step in cortex in nextflow.config (such as the cortexConfigStep1), go to cortex_Var_NF/usefulCalculators and run findHeightAndWidth.py

If there are difficulties in setting the params.queue in nextflow.config, go to cortex_Var_NF/usefulCalculators and run findHeightAndWidth.py 



**Important note: the k-mer and color specific cortex have to be made before running this script. This script DOES NOT make the specific binary cortex files**


When the nextflow.config parameters have been completed, please run cortex_Var_NF/master_Cortex_Var_NF_Script.nf



### Test environment

- Executor : PBS
- Nextflow Version : 30.1.4844
- Genome source : Soybean
- Read Sizes : ~ 23 GB


