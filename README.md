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
       - [Workflow Installation](#workflow-installation)
   - [User Guide](#user-guide)
     * [Data Preparation](#data-preparation)
       - [Sample Pair Reads](#sample-pair-reads)
       - [Reference Fasta Files](#reference-fasta-files)
     * [Cortex_Var Binary Preparation](#cortex_var-binary-preparation)
     * [Nextflow.config Parameters](#nextflow.config-parameters)
       - [Running Options](#running-options)
       - [Source, Config, and Destination Directory](#source,-config,-and-destination-directory)
       - [Sample-specific Parameters](#sample-specific-parameters)
       - [Cortex Directories and Variables](#cortex-directories-and-variables)
       - [Type of executor, queue names, etc.](#type-of-executor,-queue-names,-etc.)
     * [Resource Requirements](#resource-requirements)
     * [Executing nextflow application](#executing-nextflow-application)
     * [Logging functionality](#logging-functionality)
     * [Output Structure](#output-structure)
     * [Test Environment](#test-environment)
    
## Intended pipeline architecture and function
This workflow implements [Cortex-var workflow](http://cortexassembler.sourceforge.net/index_cortex_var.html) for structural variant calling in whole genome reads.

Cortex suggests to use high coverage reads, as suggested by section 9.2 of the cortex_var manual, using the principle of ("things which happen rarely are more likely to be errors than real")

The standard pipeline for cortex using high coverage is as such:
 1. Create de Bruijn graph for each sample (paired reads)
 2. Clean individual sample de Bruijn graph
 3. Create reference de Bruijn graph
 4. Create multi-color graph, consisting of reference de Bruijn graph and cleaned sample de Bruijn graphs
 5. Call variants by Bubble Caller and/or Path Divergence
 

However, cortex_var also supports a pipeline using many low coverage samples from the same population, also suggested by section 9.2 of the cortex_var manual

 1. Create de Bruijn graph for each sample
 2. **Create pooled de Bruijn graph**
 3. Clean individual sample de Bruijn graph based on pooled de Bruijn graph
 4. Create reference de Bruijn graph
 5. Create multi-color graph, consisting of reference de Bruijn graph and cleaned sample de Bruijn graphs
 6. Call variants by Bubble Caller and/or Path Divergence
 
 
 
 **Figure 1:** Overview of Workflow Design
 
 
 
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
- Reference fasta files
 
#### Sample Pair Reads
Sample pair reads are required to be placed in the same folder, and the path to this folder will later be the input for sampleDir parameter in nextflow.config.


**Figure 2:** sampleDir Recommended Structure

#### Reference Fasta Files

Cortex requires the user to input a list of path to the reference fasta files, separated by chromosomes to make reference de Bruijn graphs and Path Divergence variant calling. The reference fasta files of each chromosome should be listed as paths, separated by line break (\n) that will have its path specified in `pathToReferenceList` parameter in nextflow.config. Example of what the textfile should look like is as follows:


**Figure 3:** Example of Reference Fasta List Textfile

### Cortex_Var Binary Preparation
This workflow requires the user to have some prior knowledge about cortex_var, so this section will be brief. Cortex_var requires the user to have cortex_var binaries already made, specific to color and k-mer. To do this, the user can refer to the [**`INSTALL`**](https://github.com/iqbal-lab/cortex/blob/master/INSTALL) file in the [cortex_var repository](https://github.com/iqbal-lab/cortex).

For each step, here is the guide to how many colors is needed:
**Note:** n is the number of samples (1 sample requires 2 reads). So in the case of 2 samples there would be 4 reads, and the value of n is 2.

- makeSampleGraph: 1 color
- poolAndCleanErrors: 1 color
- cleanGraphPerSampleHighCoverage: 1 color
- makeReferenceGraph: 1 color
- makeCombinationGraph: n + 2 colors
- Step 6 without reference: n + 1 colors
- Step 6 with reference: n + 2 colors

### Nextflow.config Parameters

The workflow is controlled by modifying nextflow.config file.
**Note:** String parameters **always** need quotation marks ("") in the beginning and end of the string.

**`nextflowDir`**

Directory to nextflow executable should be specified here, for example: `path/to/nextflow/executable`

#### Running Options

**`PD`**

Specify if user would like to run path-divergence variant calling. Indicate using literal characters "n" or "y" (quotation marks needed). If something other than these two inputs are specificed, the workflow will not run.

**`BC`**

Specify if user would like to run bubble-caller variant calling. Indicate using literal characters "n" or "y" (quotation marks needed). If something other than these two inputs are specificed, the workflow will not run.

**`referenceReadsProvided`**

Specify if user has reference genome reads (like .fna fpecificed, the workflow will not run.

**NOTE:** Path divergence variant calling can only be diles). Indicate using literal characters "n" or "y" (quotation marks needed). If something other than these two inputs are sone when reference reads is available. So the workflow can only run when path divergence when reference reads are provided. However, Bubble caller variant calling method is idependent of the reference reads, so it is possible to conduct bubble caller variant calling without providing reference reads.

#### Source, Config, and Destination Directory

**`sampleDir`**

Path to where samples are located, as a string. Example: `"/PATH/TO/SAMPLE/DIRECTORY"`.

Refer to [Sample pair reads](#sample-pair-reads).

**`configDir`**

A String, path to the nextflow.config file, where these parameters will be filled and modified.

**`resultsDir`**

A String, path to where results of each step will be dumped. Example: `"/PATH/TO/RESULTS/DIRECTORY"`

**`pathToReferenceList`**

A String, path to where the file containing reference fasta files are (Refer to figure 3 above). Example: `"/PATH/TO/REFERENCELIST.TXT"`.

Refer to [Reference Fasta Files](#reference-fasta-files)

**`pathToRefCtx`**

If user chooses not to run step 4 in cortex (making the reference graph), path to reference binary (.ctx file) must be specified within this parameter.

Example: `"/PATH/TO/STEP4/BINARY/FILE.ctx"`

#### Sample-specific Parameters

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

A string, this variable should be filled with the extension of the sample
In example given, `sampleReadExtension` should be filled with ".fq"

#### Cortex Directories and Variables

**`cortexBinDir`**

A string, this should lead to the bin directory of cortex_var where all the executables for each step is located.

**`cortexDirStep#`**

For the step specific cortex directory parameter, as long as the color specific binary is made, there should be no need to change the variables. The default here is using 63 kmers, if there's variation, the user has the option to change the path to the desired executable.

**`cortexConfigStep#`**

Cortex_var requires flags `--kmer_size` `--mem_height` and `--mem_width` for each step. `kmer_size` indicates the length of each k-mer (nodes in the graph) and is required to be consistent with the cortex binary executables.

`mem_height` indicates the height of the hash table, and `mem_width` indicates the width of hash table. If the user needs help in determining the mem_height and mem_width, executing **`/usefulCalculators/findHeightAndWidth.py`** can be of assistance. This script is written in python3 and will take in the size of genome in number of bases and returns the optimum mem_height and mem_width, according to the [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf) page 8.

For example, soybean genome has about 1.15 gigabases:

```
#"Enter genome size in bases:" will be prompted when running the script.
Enter genome size in bases: 1150000000 
#Outputs below
mem_height = 27
mem_width = 18
```
If the `kmer_size` is 63 combined with the exmaple above, the input for `cortexConfigStep#` should be:
`"--kmer_size 63 --mem_height 27 --mem_width 18"`

**`quality_score_threshold`**

An integer, no quotation mark necessary. This parameter should be filled with the filter for quality score from the input file. Refer to [cortex_var manual](http://cortexassembler.sourceforge.net/cortex_var_user_manual.pdf) page 3.

#### Type of Executor, Queue Names, etc.

This category is filled with the system information and resource requirements for nextflow.

**`executor`**

A string, filled with the type of [executor](https://www.nextflow.io/docs/latest/executor.html). Examples include pbs, slurm, LSF, and so on.

Example: 
if pbs is the executor, the parameter should be filled with `"pbs"`

**`highRamQueue`**

A string, containing the name of the queue for the system.

**`walltime`**

A string, containing the walltime allocated for the run. Refer to the [executor documentation](https://www.nextflow.io/docs/latest/executor.html) for more the format. The walltime should be enclosed in quotation mark as well.
Example: `"10h"` for 10 hours walltime.

**`cpusNeeded`**

A string, containing the number of cpus needed per process. Refer to [executor documentation](https://www.nextflow.io/docs/latest/executor.html) for details.


### Resource Requirements

The main resources cortex_var needs is memory and time. The amount of memory cortex_var require depends on the size of hash table specified in `cortexConfigStep#` parameters, color number, and kmers. To compute the approximate ram required, the python3 script `usefulCalculators/findMemoryRequired.py`. The script will calculate how much memory is required for the most memory-demanding step. Then, the user can specify the queue that would fulfill the memory requirement in the `highRamQueue` variable in the nextflow.config file.

Example:
```
Enter height: 27
Enter width: 18
enter kmer size: 63
enter number of samples: 2
Most Memory Required in GB: 77.309411328
Most Memory Required in TB: 0.077309411328
```

In this case, the queue selected in `highRamQueue` parameter needs to have at least 77.3 GB for the workflow to run successfully.


### Executing Nextflow Application

The suggested practice to execute nextflow is to place the folder containing binary executable for nextflow in the PATH environment or to use full path to the nextflow executable file. Since nextflow will create a `work` folder, where all logs and temporary files are kept (refer to logging functionality), it is suggested (not mandatory) to avoid running `nextflow master_script.nf` in some other directory to keep the script directory clean.

### Logging Functionality

Nextflow creates `work` folder where the command `nextflow (script.nf)` is run. Within the `work` folder, there will be nested folders, containing the log of individual processes. In the stdout of running script, there will be lines that is similar to this:

`[73/a3f6d2] Submitted process > preflightCheck`

`preflightCheck` is the process name. `[73/a3f6d2]` indicates the folder name within work folder when the user can locate the log for the specific process. More accurately, within `/work/73/` there might be several folders, and `a3f6d2` is the first 6 characters of the nested folder within `/work/73/`. Inside the folder specific to the process, such as `/work/73/a3f6d2...`, there are several log files that can be used for debugging or troubleshooting.

The `work` folder for each specific process is located within the resultsDir specified in the `nextflow.config` parameter.

### Output Structure

This workflow dumps the output of each process described in [figure 1](#intended-pipeline-architecture-and-function) in the results directory specified in `resultsDir` parameter in nextflow.config file. In addition to output folders, there are also `sampleForStep#` folders that do not contain significant products/output for the user. Additionally there is `log` folder containing cortex stdout for each sample for each step. Finally, there is a `work` folder that is described by "Logging functionality" section above.

![](https://i.imgur.com/2LNhORR.png)
**Figure 4:** Complete output structure of resultsDir 


### Test Environment

- Executor : PBS
- Nextflow Version : 30.1.4844
- Genome source : Soybean
- Read Sizes : ~ 23 GB


