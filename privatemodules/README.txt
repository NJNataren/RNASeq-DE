++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Private modules for loading miniconda packages on Gadi
++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# These private modules were written to load packages that have been downloaded using miniconda3.
# Given that they are conda packages it is necessary to export the path to miniconda3 
# in the PBS script that is using the module.
# For example, if we want to use the HTSeq/2.0.5 module in the 'htseq-count_run_parallel.pbs' script,
# we export the miniconda3 path by 'export PATH=$HOME/miniconda3/bin:$PATH'
# and then activate the conda environment which has htseq installed.
# For example below, we activate the conda environment 'rnaseq-de' by calling
# 'source activate rnaseq-de'
# Then we can call the module as follows:
# 'module load HTSeq/2.0.5'
