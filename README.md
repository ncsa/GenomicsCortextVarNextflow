# Cortex_Var nextflow-based workflow


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


