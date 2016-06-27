#!/bin/bash
#Steps to run in folder with parsed corpora
CS_COMMAND="java -classpath ./queries/CS_2.003.04.jar csearch/CorpusSearch"

#0) run the Full.q query on dummy.psd
echo "Extracting ditransitive verbs"
$CS_COMMAND ./queries/Ditransitives/Full.q ./queries/dummy.psd
	# Outputs to: ./queries/Ditransitives/Full.out

#1) run the Verbs.c query on Full.out
echo "Coding Verbs"
$CS_COMMAND ./queries/Ditransitives/Verbs.c ./queries/Ditransitives/Full.out
	# Outputs to: ./queries/Ditransitives/Verbs.cod

#2) run the clausetype.c query on Verbs.cod
echo "Coding clausetype"
$CS_COMMAND ./queries/Ditransitives/clausetype.c ./queries/Ditransitives/Verbs.cod
	# Outputs to: ./queries/Ditransitives/clausetype.cod

#3) run the PP.c query on clausetype.cod
echo "Coding PP"
$CS_COMMAND ./queries/Ditransitives/PP.c ./queries/Ditransitives/clausetype.cod
	# Outputs to: ./queries/Ditransitives/PP.cod

#4) run the NomType.c query on PP.cod
echo "Coding NomType"
$CS_COMMAND ./queries/Ditransitives/NomType.c ./queries/Ditransitives/PP.cod
	# Outputs to: ./queries/Ditransitives/NomType.cod

#5) run the DatType.c query on NomType.cod
echo "Coding DatType"
$CS_COMMAND ./queries/Ditransitives/DatType.c ./queries/Ditransitives/NomType.cod
	# Outputs to: ./queries/Ditransitives/DatType.cod

#6) run the AccType.c query on DatType.cod
echo "Coding AccType"
$CS_COMMAND ./queries/Ditransitives/AccType.c ./queries/Ditransitives/DatType.cod
	# Outputs to: ./queries/Ditransitives/AccType.cod

#7) run the NomVerbOrd.c query on AccType.cod
echo "Coding NomVerbOrder"
$CS_COMMAND ./queries/Ditransitives/NomVerbOrd.c ./queries/Ditransitives/AccType.cod
	# Outputs to: ./queries/Ditransitives/NomVerbOrd.cod

#8) run the DatVerbOrd.c query on NomVerbOrd.cod
echo "Coding DatVerbOrd"
$CS_COMMAND ./queries/Ditransitives/DatVerbOrd.c ./queries/Ditransitives/NomVerbOrd.cod
	# Outputs to: ./queries/Ditransitives/DatVerbOrd.cod

#9) run the AccVerbOrd.c query on DatVerbOrd.cod
echo "Coding NomType"
$CS_COMMAND ./queries/Ditransitives/AccVerbOrd.c ./queries/Ditransitives/DatVerbOrd.cod
	# Outputs to: ./queries/Ditransitives/AccVerbOrd.cod

#10) run the NomDatOrd.c query on AccVerbOrd.cod
echo "Coding NomDatOrd"
$CS_COMMAND ./queries/Ditransitives/NomDatOrd.c ./queries/Ditransitives/AccVerbOrd.cod
	# Outputs to: ./queries/Ditransitives/NomDatOrd.cod

#11) run the NomAccOrd.c query on NomDatOrd.cod
echo "Coding NomAccOrd"
$CS_COMMAND ./queries/Ditransitives/NomAccOrd.c ./queries/Ditransitives/NomDatOrd.cod
	# Outputs to: ./queries/Ditransitives/NomAccOrd.cod

#12) run the AccDatOrd.c query on NomAccOrd.cod
echo "Coding AccDatOrd"
$CS_COMMAND ./queries/Ditransitives/AccDatOrd.c ./queries/Ditransitives/NomAccOrd.cod
	# Outputs to: ./queries/Ditransitives/AccDatOrd.cod

#13) run the pas.c query on AccDatOrd.cod
echo "Coding pas"
$CS_COMMAND ./queries/Ditransitives/pas.c ./queries/Ditransitives/AccDatOrd.cod
	# Outputs to: ./queries/Ditransitives/pas.cod

#14) run the hascp.c query on pas.cod
echo "Coding hascp"
$CS_COMMAND ./queries/Ditransitives/hascp.c ./queries/Ditransitives/pas.cod
	# Outputs to: ./queries/Ditransitives/hascp.cod

#15) run the adj.c query on hascp.cod
echo "Coding adj"
$CS_COMMAND ./queries/Ditransitives/adj.c ./queries/Ditransitives/hascp.cod
	# Outputs to: ./queries/Ditransitives/hascp.cod


#6) Run the only-coding.q query (from corpus-tools repository)
#echo "Extracting codes"
#$CS_COMMAND ./corpus-tools/only-coding.q ./queries/do-support.cod
	# Outputs to: /queries/do-support.cod.ooo

#7) Run add_metadata.py to create the final tab-separated file
#echo "Adding metadata and creating final file"
#mkdir data
#python ./parsedenglish_database/add_metadata.py ./parsedenglish_database/English_database.txt ./queries/do-support.cod.ooo ./data/do-support.txt "token.num" "do.supp" "clause" "negation"
	# Outputs to: ./data/do-support.txt

# 8) Clean up intermediate files that duplicate the corpus
#echo "Cleaning up intermediate duplicate files"
#./queries/clean.sh
