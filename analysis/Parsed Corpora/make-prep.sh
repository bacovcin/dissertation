#!/bin/bash
#Steps to run in folder with parsed corpora

# 0) Copy all corpus files into single file in directory
echo "Creating a single corpus file"
cat corpus/PPCEME-RELEASE-3/corpus/psd/*/*.psd corpus/PPCMBE2-RELEASE-1/corpus/psd/*.psd corpus/PCEEC/corpus/psd/*ref corpus/YCOE/psd/*.psd corpus/PPCME2-RELEASE-4/corpus/psd/*.psd > queries/corpus.txt

# 1) add-cp.q (from corpus-tools repository) on all the corpora
echo "Adding new cp layer to corpus"
CS_COMMAND="java -classpath ./queries/CS_2.003.04.jar csearch/CorpusSearch"
$CS_COMMAND ./corpus-tools/add-cp.q ./queries/corpus.txt # Adds CPs to every clause in corpus...yeesh
	# Outputs to: ./queries/corpus.txt.out 

#2) remove-dup-cp.q on output
echo "Filtering cp layer"
$CS_COMMAND ./corpus-tools/remove-dup-cp.q ./queries/corpus.txt.out # Removes duplicate CPs add in the previous step...yeesh
	# Outputs to:  ./queries/corpus.txt.out.out

#3) run dummy.q to prepare corpus for RemoveDup.py
echo "Preparing corpus for duplicate removal"
$CS_COMMAND ./corpus-tools/dummy.q ./queries/corpus.txt.out.out
mv ./corpus-tools/dummy.out ./queries/dummy.out
	# Outputs to: ./queries/dummy.out

#4) run RemoveDup.py on the output from dummy.q (Removes tokens with identical text; deals with corpus overlap issues)
echo "Removing duplicate tokens from corpus"
python ./corpus-tools/RemoveDup.py ./queries/dummy.out
	# Outputs to: ./queries/dummy.psd
