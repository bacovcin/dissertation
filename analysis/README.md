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
In order to run this material you need access to *lemmatised* copies of the following corpora. In order to produce lemmatised corpora, use the scripts found in [this GitHub repository](https://github.com/bacovcin/lemmatised-parsed-corpora-historical-english). These downloads need to be placed (or symbolically linked) into the corpora sub-directory with the following structure:

PCEEC/*.psd
PCEEC/*.psd
PPCEME/*.psd
PPCMBE/*.psd
PPCME2/*.psd
ycoe/*.psd

