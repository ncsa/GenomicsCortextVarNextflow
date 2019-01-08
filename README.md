# Structural Variant Calling with Cortex-Var on Nextflow

This repo is a variant calling pipeline that uses [cortex_var](http://cortexassembler.sourceforge.net/index_cortex_var.html) written in [Nextflow](https://www.nextflow.io/), for use in detecting de-novo structural variance in whole-genome reads.

Many information mentioned in this readme are referred from the [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)

You may use this README file to understand how the scripts are organized and how the codes are structured. Additionally, this README file also provides a brief explanation about how cortex-var behaves.

Files in this repo are organized as follows:

| Folder / Files | Contents |
| --- | --- |
| runCortexVarHighCoverage | Nextflow script to be run by user |
| runCortexVarLowCoverage | Nextflow script to be run by user |
| nextflow.config | Configuration file to be edited by user |
| nextflow_scripts | Individual nextflow scripts for each step in cortex-var |
| usefulCalculators | Tools to help finding some parameters in the config file |

**Table of Contents**
 - [Structural Variant Calling with Cortex-Var on Nextflow](#structural-variant-calling-with-cortex-var-on-nextflow)
   - [Intended pipeline architecture and function](#intended-pipeline-architecture-and-function)
     * [Installation](#installation)
       - [Dependencies](#dependencies)
       - [Cortex_var Installation](#Cortex_var-installation)
       - [Workflow Installation](#workflow-installation)
   - [User Guide](#user-guide)
     * [Data Preparation](#data-preparation)
       - [Sample Pair Reads](#sample-pair-reads)
       - [Reference Fasta Files](#reference-fasta-files)
     * [Cortex_Var Executable Preparation](#cortex_var-Executable-Preparation)
     * [Nextflow config Parameters](#nextflow-config-Parameters)
       - [Executables](#executables)
       - [Sample, Result, and Config Directory](#sample-result-and-config-directory)
       - [Sample Management](#Sample-Management)
       - [Executor](#executor)
       - [Cortex_var Individual Process Parameters](#Cortex_var-Individual-Process-Parameters)
         * [Generic process parameters](#Generic-process-parameters)
         * [Specific process parameters](#Specific-process-parameters)
     * [Resource Requirements](#resource-requirements)
     * [Executing nextflow application](#executing-nextflow-application)
     * [Logging functionality](#logging-functionality)
     * [Output Structure](#output-structure)
     * [Test Environment](#test-environment)
    
## Intended pipeline architecture and function
This workflow implements [Cortex-var workflow](http://cortexassembler.sourceforge.net/index_cortex_var.html) for structural variant calling in whole genome reads.

Cortex suggests to use high coverage reads, as suggested by section 9.2 of the [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf), using the principle of ("things which happen rarely are more likely to be errors than real"), and according section 6.2 of the [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf), the threshold considered as "high" or "low" coverage samples is about above or below 20x coverage for diploid and 10x for above or below 10x for haploid.

The standard pipeline for cortex using high coverage is as such:
 1. Create de Bruijn graph for each sample (paired reads)
 2. Clean individual sample de Bruijn graph
 3. Create reference de Bruijn graph
 4. Create multi-color graph, consisting of reference de Bruijn graph and cleaned sample de Bruijn graphs
 5. Call variants by Bubble Caller and/or Path Divergence
 6. Convert cortex calls to VCF

**Figure 1:** Cortex_var High-Coverage Pipeline Overview

<p align="center">
  <img src="/images/Figure1.png" width="40%">
</p>


Additionally, cortex_var also supports a pipeline using many low coverage samples from the same population, also suggested by section 9.2 of the [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf).

 1. Create de Bruijn graph for each sample
 2. **Create pooled de Bruijn graph**
 3. Clean individual sample de Bruijn graph based on pooled de Bruijn graph
 4. Create reference de Bruijn graph
 5. Create multi-color graph, consisting of reference de Bruijn graph and cleaned sample de Bruijn graphs
 6. Call variants by Bubble Caller and/or Path Divergence
 7. Convert cortex calls to VCF
 
**Figure 2:** Cortex_var Low-Coverage Pipeline Overview

<p align="center">
  <img src="/images/Figure2.png" width="40%">
</p>
 
**IMPORTANT NOTE:** Cortex var works chronologically. Which means to conduct one process, the previous processes must be done first. Although it is possible to do each step separately, the output of previous steps must still be present as an input for the next step. For a clear visual which process requires which process input, please refer to diagrams below. An arrow from process a to process b indicates that process b requires all files related to process a (both input and output) to still be present for process b to run successfully.
 

## Installation

### Dependencies

- [cortex_var](http://cortexassembler.sourceforge.net/index_cortex_var.html)
- [Nextflow](https://www.nextflow.io/) 0.30.1.4844 or newer is recommeded

### Cortex_var installation

Refer to [cortex_var github page](https://github.com/iqbal-lab/cortex)

### Workflow Installation

Clone this repository

## User Guide

### Data Preparation
Cortex_var requires two types of data input:
- Sample pair reads
- Reference fasta files, separated by chromosome
 
#### Sample Pair Reads
Sample pair reads are required to be placed in the same folder, and the path to this folder will later be the input for sampleDir parameter in nextflow.config.


**Figure 3:** sampleDir Example

<p align="center">
  <img src="/images/Figure3.png" width="40%">
</p>

#### Reference Fasta Files

Cortex requires the user to input a list of path to the reference fasta files, separated by chromosomes to make reference de Bruijn graphs and Path Divergence variant calling. The reference fasta files of each chromosome should be listed as paths, separated by line break (\n) that will have its path specified in `pathToReferenceList` parameter in nextflow.config. Example of what the textfile should look like is as follows:


**Figure 4:** Example of Reference Fasta List Textfile
<p align="center">
  <img src="/images/Figure4.png" width="40%">
</p>

### Cortex_Var Executable Preparation
This workflow requires the user to have some prior knowledge about cortex_var, so this section will be brief. Cortex_var requires the user to have cortex_var executable already made, specific to color and k-mer. To do this, the user can refer to the [**`INSTALL`**](https://github.com/iqbal-lab/cortex/blob/master/INSTALL) file in the [cortex_var repository](https://github.com/iqbal-lab/cortex).

"Color" in cortex simply means how many de Bruijn Graph files (.ctx extensions) will be loaded to the cortex executable. A simple way of thinking about "color" is how many genomes are loaded in the executable to be processed.

For each step, here is the guide to how many colors is needed:
**Note:** n is the number of samples (1 sample requires 2 reads). For example: if there are 2 samples there would be 4 reads, and the value of n is 2.

For standard, high coverage samples:

- makeSampleGraph: 1 color
- cleanGraphPerSampleHighCoverage: 1 color
- makeReferenceGraph: 1 color
- makeCombinationGraph: finalCombinationGraphMaxColor
- variantCalling: finalCombinationGraphMaxColor

For low coverage, pooled base pipeline:

- makeSampleGraph: 1 color
- poolAndCleanErrors: 1 color
- cleanGraphPerSampleLowCoverage: 2 colors
- makeReferenceGraph: 1 color
- makeCombinationGraph: finalCombinationGraphMaxColor
- variantCalling: finalCombinationGraphMaxColor

"Kmer size" in cortex dictates the number of bases to be used to construct the node in the de Bruijn graph made. The Kmer size is required to be consistent throughout the process.

Cortex_var also requires a specific kmer size to be specified by user. To choose the appropriate kmer size, refer to section 8 of the [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf).

After choosing the kmer and color for each cortex executable each of them much be made and compiled in the cortex bin directory specified, refer to section 4 of [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf).

For example, if color chosen is 1 and kmer size chosen is 63:

 1. cd to installed cortex_var directory (bash install.sh has already been run)
 2. make NUM_COLS=1 MAXK=63 cortex_var

After running the "make" commands, within the cortexDir/bin directory, the executable cortex_var_63_c1 will be made, "63" being the kmer size, and "c1" indicates the number of colors.

finalCombinationGraphMaxColor is a parameter to be filled by the user, this indicates the color required by makeCombinationGraph and variantCalling step. Further explanation on how to fill this parameter will be provided in the Nextflow.config Parameters section below.

### Nextflow config Parameters

The workflow is controlled by modifying nextflow.config file.
**Note:** String parameters **always** need quotation marks ("") in the beginning and end of the string.

#### Executables

**`nextflowDir`**

**STRING** 

Path to nextflow executable

**`cortexBinDir`**

**STRING**

Path to bin directory of cortex, where executables for each process is located.

#### Sample, Result, and Config Directory

**`sampleDir`**

**STRING**

Path to directory where samples are located.

**`resultsDir`**

**STRING**

Path to directory where results of each process will be dumped.

**`logDir`**

**STRING**

Path to directory where logs of each process will be dumped, default is inside the resultsDir

**`cloneDir`**

**STRING**

Path to where this repository is cloned (path/to/GenomicsCortexVarNextflow)

#### Sample Management

All samples are organized as referred to figure 2, the fastq filenames should be organized as: "(sampleName)(sampleReadPattern)(readNumber)(sampleReadExtension)"

For instance, for the following samples:
sampleDir/sample1_read1.fq.gz
sampleDir/sample1_read2.fq.gz
sampleDir/sample2_read1.fq.gz
sampleDir/sample2_read2.fq.gz

sampleName is sample1 and sample2
sampleReadPattern is \_read
readNumber is 1 and 2 for each sample
sampleReadExtension is .fq.gz

**`sampleList`**

**ARRAYLIST OF STRING**

ArrayList containing the sample names enclosed within quotation marks and separated by comma, all enclosed within `[]`

With examples given, the `sampleList` should be filled with: `["Sample_1", "Sample_2"]`

**Note:** Quotation marks are required to indicate that the element is a string.

**`sampleReadPattern`**

**STRING**

The string after the sample name, but before the read number.

With examples given, the `sampleReadPattern` should be filled with: "\_read"


**`sampleReadExtension`**

**STRING**

The string after the read number, cortex supports both raw .fq and gzipped .fq.gz

In example given, `sampleReadExtension` should be filled with ".fq.gz"


**`pathToReferenceList`**

**STRING**

Path to where the file containing reference fasta files paths.
Example: `"/PATH/TO/REFERENCELIST.TXT"`.

Refer to [Reference Fasta Files](#reference-fasta-files)

#### Executor

**`executor`**

**STRING**

The type of executor that will be used by user. refer to nextflow executors [documentation](https://www.nextflow.io/docs/latest/executor.html)

#### Cortex_var Individual Process Parameters

##### Generic process parameters (excluding conversion to VCF)

**`kmerSize`**

**STRING**

kmerSize chosen for the whole cortex_var process, refer to [Cortex_Var Executable Preparation](#Cortex_Var Executable Preparation)

**`cortexConfig`**

**STRING**

Cortex_var requires flags `--kmer_size` `--mem_height` and `--mem_width` for each step. `kmer_size` indicates the length of each k-mer (nodes in the graph) and is required to be consistent with the cortex binary executables.

By default, the kmer size will be derived from kmerSize parameter above, but the memory height and width should be specified here.

`mem_height` indicates the height of the hash table, and `mem_width` indicates the width of hash table. If the user needs help in determining the mem_height and mem_width, executing `/usefulCalculators/findHeightAndWidth.py` can be of assistance. This script is written in python3 and will take in the size of genome in number of bases and returns the optimum mem_height and mem_width, according to the [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf) page 8.

For example, soybean genome has about 1.15 gigabases:

```
#"Enter genome size in bases:" will be prompted when running the script.
Enter genome size in bases: 1150000000 
#Outputs below
mem_height = 27
mem_width = 18
```
If the `kmer_size` is 63 combined with the example above, the input for `cortexConfig(PROCESSNAME)` should be:
`"--kmer_size " + kmerSize + " --mem_height 27 --mem_width 18"`

**`run(PROCESSNAME)`**

**STRING**

Indicate if user is willing to run that specific process. ("y"/"n")

**`cortexBin(PROCESSNAME)`**

**STRING**

Executable to where the executable will be used for the process. Default is in the bin directory specificied by `cortexBinDir`

**`(PROCESSNAME)Queue`**

**STRING**

Queue name in the cluster, refer to nextflow executor [documentation](https://www.nextflow.io/docs/latest/executor.html)


**`(PROCESSNAME)MaxNodes`**

**INT**

Maximum number of nodes to be used in parallel, refer to nextflow maxForks [documentation]('https://www.nextflow.io/docs/latest/process.html?highlight=maxforks#maxforks')


**`(PROCESSNAME)Walltime`**

**STRING**

Walltime for individual process runs, refer to nextflow walltime [documentation](https://www.nextflow.io/docs/latest/process.html#process-time)


**`(PROCESSNAME)CpusNeeded`**

**STRING**

Number of cores per node for each process, refer to nextflow cpus [documentation](https://www.nextflow.io/docs/latest/process.html#cpus)


##### Specific process parameters

###### Make sample de Bruijn graph specific parameters

**`quality_score_threshold`**

**INT**

Initial quality filter for making de Bruijn graph, refer to section 6.2 and page 3 of [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)


###### Make combination graph specific parameters

**`pathToRefCtx`**

**STRING**

Path to reference de Bruijn graph, usually having .ctx extension (default is path to where it would be made by makeReferenceGraph)

**`finalCombinationGraphMaxColor`**

**INT**

The largest number of colors of graph to run the node can handle, given kmer size, memory height and memory width.

This process creates multi-colored deBruijn graph, stacking reference de Bruijn graph with one or more cleaned sample de Bruijn graph(s). Thus, the number ranges from 2 to N+1 (total number of samples), depending on the memory capability of the node. 

To identify how much memory the process needs, the user can refer to [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf) page 8. However, this repository also provides a script to calculate memory required, `/usefulCalculators/findMemoryRequired.py`. For more information, refer to Resource Requirement section [below](#Resource Requirement)

If the finalCombinationGraphMaxColor is not N+1, then this pipeline will automatically parition the graphs, and make the total of N %(modulo) (`finalCombinationGraphMaxColor` - 1) combination graphs.


###### Variant Calling specific parameters
 
**`PD`**

**STRING**

Indicate if user wants to run Path Divergence variant calling method ("y"/"n")

For more information regarding Path Divergence variant calling method, refer to Section 11 of [cortex_var manual] (http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)


**Parameters used only if PD is selected**

**`populationPD`**

**STRING**

Indicate if user wants to run combined Path Divergence variant calling in the same combination graph consecutively ("y"/"n")

After the vcf conversion process, variant calls of every sample in the same combination graph will be available in a single VCF file, one per combination graph.

For more information, refer to page 12, or section 11.2 of [cortex_var manual] (http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)

**`individualPD`**

**STRING**

Indicate if user wants to run path divergence on one of one sample for each process ("y"/"n")

After the vcf conversion process, variant calls of each individual sample will be available in individual vcf files.

For more information refer to page 12, or section 11.1 of [cortex_var manual] (http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)


###### Variant Calling specific parameters

**`stampyBin`**

**STRING**

Full path to stampy.py.

For more information refer to page 15 of [cortex_var manual] (http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)

**`stampyHashProducts`**

**STRING**

For more information refer to page 15 of [cortex_var manual] (http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)

**`VCFToolsDir`**

**STRING**

For more information refer to page 15 of [cortex_var manual] (http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)

**`samplePloidy`**

**INT**

Ploidy of sample.

Example: if sample is diploid, samplePloidy should be 2

**`referenceFasta`**

Path to reference fasta file. Note: this is different from `pathToReferenceList`.

For more information refer to page 15 of [cortex_var manual] (http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf)


### Resource Requirements

The main resources cortex_var needs are memory and time. The amount of memory cortex_var require depends on the size of hash table specified in `cortexConfig(PROCESSNAME)` parameters, color number, and kmer size. To compute the approximate ram required, the python3 script `usefulCalculators/findMemoryRequired.py` is available.

Example:
```
enter kmer size: 63
Enter height: 27
Enter width: 18
enter number of colors: 2
Memory Required in GB: 77.309411328
Memory Required in TB: 0.077309411328
FOR IFORGE USERS ONLY: Use big_mem
```

With this example, this means that the user should fill `(PROCESSNAME)Queue` with a queue that have at least 77.3 GB of RAM (more is recommended).


### Executing Nextflow Application

The suggested practice to execute nextflow is to place the folder containing binary executable for nextflow in the PATH environment or to use full path to the nextflow executable file.

There are two master scripts available: `runCortexVarHighCoverage.nf` and `runCortexVarLowCoverage.nf`, as its respective names suggest, if the sample read coverage is high, running the standard pipeline `nextflow run runCortexVarHighCoverage` will be appropriate. Respectively, with low sample read coverage, but coming from similar population, running low-coverage pipeline `nextflow run runCortexVarLowCoverage.nf` will be more appropriate. To determine what is a 'high' or 'low' coverage samples, the user can refer to section 6.2 of [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf) .

Nextflow will create a `work` folder, where all logs and temporary files are kept (refer to [logging functionality](# Logging Functionality), therefore it is suggested (not mandatory) to avoid running the master control scripts `runCortexVarHighCoverage.nf` and/or `runCortexVarLowCoverage.nf` in some other directory, like the resultsDir, to keep the script directory clean.

### Logging Functionality

Nextflow creates `work` folder where the command `nextflow (script.nf)` is run. Within the `work` folder, there will be nested folders, containing the log of individual processes. In the stdout of running script, there will be lines that is similar to this:

`[73/a3f6d2] Submitted process > test`

`test` is the process name. `[73/a3f6d2]` indicates the folder name within work folder when the user can locate the log for the specific process. More accurately, within `/work/73/` there might be several folders, and `a3f6d2` is the first 6 characters of the nested folder within `/work/73/`. Inside the folder specific to the process, such as `/work/73/a3f6d2...`, there are several log files that can be used for debugging or troubleshooting.

The `work` folder for each specific process is located within the resultsDir specified in the `nextflow.config` parameter.

### Output Structure

This workflow places the output of each process described in figure 1 and figure 2 in the results directory specified in `resultsDir` parameter in nextflow.config file. Each process will have a folder, named as `(PROCESSNAME)Output` to host the output files of the specific process.

### Test Environment

- Executor : PBS
- Nextflow Version : 30.1.4844
- Genome source : Soybean
- Read Sizes : 90bp - 100bp
- Read Coverage: ~17x


