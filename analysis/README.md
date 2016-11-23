# Analysis folder
This folder contains all of the material necessary to go from the raw corpus files to the completed analyses.

The reproducible structure of this folder is based on the blog post sequence that starts [here](http://www.jonzelner.net/statistics/make/docker/reproducibility/2016/05/31/reproducibility-pt-1/).

# General Structure
Because of the limitations of corpus licenses, the raw corpus files and the intermediary steps cannot be saved in this repository. Instead, the tab-separated output of corpus search queries, as well as the relevant queries have been stored. 

The analysis is divided into two steps: collection and analysis. The collection stage generates tab-separated files with relevant linguistic annotation out of the raw corpus files. For the parsed corpora, this has been done automatically using a combination of CorpusSearch and python scripts and should be completely reproducible. For COHA quries, this was mostly accomplished with hand annotation. The resulting annotated files have been directly added to the /data folder.

The data generation and analysis can be accomplished using two make files. make-data takes the raw parsed corpora and regenerates the tab-seperated value files in the /data directory. make-analysis uses the files in the /data directory and generates output, which is stores in the /dissertation/output directory.

This creates the following structure:
- /corpora (raw corpus files, see below for structure)
  /data (linguistically annotated output from raw corpus files)
  /src-collection (scripts for generating files in data)
  /src-analysis (scripts for analysing the data files)

# Required Input
In order to run this material you need access to downloaded copies of the following corpora. These downloads need to be placed (or symbolically linked) into the corpora sub-directory with the following structure:

PCEEC/corpus/psd-cs1/*.psd
PCEEC/corpus/psd-cs2/*.psd
PPCEME/psd/helsinki/*.psd
PPCEME/psd/penn1/*.psd
PPCEME/psd/penn2/*.psd
PPCMBE/psd/*.psd
PPCME2/psd/*.psd
ycoe/psd/*.psd

