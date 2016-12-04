collection = false

ifeq ($(collection),true)
	####
	## Preperation for CorpusSearch queries
	####
	corpora = $(wildcard analysis/corpora/PCEEC/*.psd) $(wildcard analysis/corpora/PPCEME/*.psd) $(wildcard analysis/corpora/PPCMBE/*.psd) $(wildcard analysis/corpora/PPCME/*.psd) $(wildcard(analysis/corpora/YCOE/*.psd)
	CS_COMMAND=java -classpath analysis/src-collection/CS_2.003.04.jar csearch/CorpusSearch
	col-tmp = analysis/collection-tmp
	col-src = analysis/src-collection
	dit-tmp = analysis/collection-tmp/Ditransitives
	dit-src = analysis/src-collection/Ditransitives
	## Create a combined corpus file
$(col-tmp)/corpus.txt : $(corpora) 
	@echo --- Creating a single corpus file  ---
	@mkdir -p $(@D)
	cat $(corpora) > $@
	
	## Add extra cp layer to all of the corpus files
$(col-tmp)/corpus.txt.out : $(col-tmp)/corpus.txt $(col-src)/corpus-tools/add-cp.q
	@echo --- Adding new cp layer to corpus ---
	$(CS_COMMAND) $(word 2,$^) $<

	## remove-dup-cp.q on output
$(col-tmp)/corpus.txt.out.out : $(col-tmp)/corpus.txt.out $(col-src)/corpus-tools/remove-dup-cp.q
	@echo --- Filtering cp layer ---
	$(CS_COMMAND) $(word 2,$^) $<

	## run dummy.q to prepare corpus for RemoveDup.py
$(col-tmp)/dummy.out : $(col-tmp)/corpus.txt.out.out $(col-src)/corpus-tools/dummy.q
	@echo --- Preparing corpus for duplicate removal ---
	$(CS_COMMAND) $(word 2,$^) $<
	mv analysis/src-collection/corpus-tools/dummy.out $@

	## run RemoveDup.py on the output from dummy.q (Removes tokens with identical text; deals with corpus overlap issues)
$(col-tmp)/dummy.psd : $(col-tmp)/dummy.out $(col-src)/corpus-tools/RemoveDup.py
	@echo --- Removing duplicate tokens from corpus ---
	python $(word 2,$^) $<

	####
	## Ditransitive coding queries
	####

	## run the Full.q query on dummy.psd
$(col-tmp)/Ditransitives/Full.out : $(col-tmp)/dummy.psd $(dit-src)/Full.q
	@echo --- Extracting ditransitive verbs ---
	@mkdir -p $(@D)
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/Full.out $(col-tmp)/Ditransitives/Full.out

	## run the Verbs.c query on Full.out
$(dit-tmp)/Verbs.cod : $(dit-tmp)/Full.out $(dit-src)/Verbs.c
	@echo ---Coding Verbs---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/Verbs.cod $(col-tmp)/Ditransitives/Verbs.cod

	## run the clausetype.c query on Verbs.cod
$(dit-tmp)/clausetype.cod : $(dit-tmp)/Verbs.cod $(dit-src)/clausetype.c
	@echo ---Coding clausetype---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/clausetype.cod $(col-tmp)/Ditransitives/clausetype.cod

	## run the PP.c query on clausetype.cod
$(dit-tmp)/PP.cod : $(dit-tmp)/clausetype.cod $(dit-src)/PP.c
	@echo ---Coding PP---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/PP.cod $(col-tmp)/Ditransitives/PP.cod

	## run the NomType.c query on PP.cod
$(dit-tmp)/NomType.cod : $(dit-tmp)/PP.cod $(dit-src)/NomType.c
	@echo ---Coding NomType---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/NomType.cod $(col-tmp)/Ditransitives/NomType.cod

	## run the DatType.c query on NomType.cod
$(dit-tmp)/DatType.cod : $(dit-tmp)/NomType.cod $(dit-src)/DatType.c
	@echo ---Coding DatType---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/DatType.cod $(col-tmp)/Ditransitives/DatType.cod

	## run the AccType.c query on DatType.cod
$(dit-tmp)/AccType.cod : $(dit-tmp)/DatType.cod $(dit-src)/AccType.c
	@echo ---Coding AccType---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/AccType.cod $(col-tmp)/Ditransitives/AccType.cod

	## run the NomVerbOrd.c query on AccType.cod
$(dit-tmp)/NomVerbOrd.cod : $(dit-tmp)/AccType.cod $(dit-src)/NomVerbOrd.c
	@echo ---Coding NomVerbOrder---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/NomVerbOrd.cod $(col-tmp)/Ditransitives/NomVerbOrd.cod

	## run the DatVerbOrd.c query on NomVerbOrd.cod
$(dit-tmp)/DatVerbOrd.cod : $(dit-tmp)/NomVerbOrd.cod $(dit-src)/DatVerbOrd.c
	@echo ---Coding DatVerbOrd---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/DatVerbOrd.cod $(col-tmp)/Ditransitives/DatVerbOrd.cod

	## run the AccVerbOrd.c query on DatVerbOrd.cod
$(dit-tmp)/AccVerbOrd.cod : $(dit-tmp)/DatVerbOrd.cod $(dit-src)/AccVerbOrd.c
	@echo ---Coding NomType---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/AccVerbOrd.cod $(col-tmp)/Ditransitives/AccVerbOrd.cod

	## run the NomDatOrd.c query on AccVerbOrd.cod
$(dit-tmp)/NomDatOrd.cod : $(dit-tmp)/AccVerbOrd.cod $(dit-src)/NomDatOrd.c
	@echo ---Coding NomDatOrd---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/NomDatOrd.cod $(col-tmp)/Ditransitives/NomDatOrd.cod

	## run the NomAccOrd.c query on NomDatOrd.cod
$(dit-tmp)/NomAccOrd.cod : $(dit-tmp)/NomDatOrd.cod $(dit-src)/NomAccOrd.c
	@echo ---Coding NomAccOrd---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/NomAccOrd.cod $(col-tmp)/Ditransitives/NomAccOrd.cod

	## run the AccDatOrd.c query on NomAccOrd.cod
$(dit-tmp)/AccDatOrd.cod : $(dit-tmp)/NomDatOrd.cod $(dit-src)/AccDatOrd.c
	@echo ---Coding AccDatOrd---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/AccDatOrd.cod $(col-tmp)/Ditransitives/AccDatOrd.cod

	## run the pas.c query on AccDatOrd.cod
$(dit-tmp)/pas.cod : $(dit-tmp)/AccDatOrd.cod $(dit-src)/pas.c
	@echo ---Coding pas---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/pas.cod $(col-tmp)/Ditransitives/pas.cod

	## run the hascp.c query on pas.cod
$(dit-tmp)/hascp.cod : $(dit-tmp)/pas.cod $(dit-src)/hascp.c
	@echo ---Coding hascp---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/hascp.cod $(col-tmp)/Ditransitives/hascp.cod

	## run the adj.c query on hascp.cod
$(dit-tmp)/adj.cod : $(dit-tmp)/hascp.cod $(dit-src)/adj.c
	@echo ---Coding adj---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/adj.cod $(col-tmp)/Ditransitives/adj.cod

	## run the NomPartOrd.c query on adj.cod
$(dit-tmp)/NomPartOrd.cod : $(dit-tmp)/adj.cod $(dit-src)/NomPartOrd.c
	@echo ---Coding NomPartOrd---
	$(CS_COMMAND) analysis/src-collection/Ditransitives/NomPartOrd.c $<
	mv $(dit-src)/NomPartOrd.cod $(col-tmp)/Ditransitives/NomPartOrd.cod

	## run the DatPartOrd.c query on NomPartOrd.cod
$(dit-tmp)/DatPartOrd.cod : $(dit-tmp)/NomPartOrd.cod $(dit-src)/DatPartOrd.c
	@echo ---Coding DatPartOrd---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/DatPartOrd.cod $(col-tmp)/Ditransitives/DatPartOrd.cod

	## run the AccPartOrd.c query on DatPartOrd.cod
$(dit-tmp)/AccPartOrd.cod : $(dit-tmp)/DatPartOrd.cod $(dit-src)/AccPartOrd.c
	@echo ---Coding AccPartOrd---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(dit-src)/AccPartOrd.cod $(col-tmp)/Ditransitives/AccPartOrd.cod

	## count the subjects
$(dit-tmp)/adj-sbj.cod : $(dit-tmp)/AccPartOrd.cod $(col-src)/corpus-tools/count-words-deep.py
	@echo ---Counting subject words---
	python $(word 2,$^) NP-SBJ:NP-NOM 18 $<
	mv $(dit-tmp)/AccPartOrd_NP-SBJ_NP-NOM.cod $(dit-tmp)/adj-sbj.cod

	## count the indirect objects
$(dit-tmp)/adj-io.cod : $(dit-tmp)/adj-sbj.cod $(col-src)/corpus-tools/count-words-deep.py
	@echo ---Counting IO words---
	python $(word 2,$^) NP-DAT:NP-DTV:NP-OB2:PP-DAT 19 $<
	mv $(dit-tmp)/adj-sbj_NP-DAT_NP-DTV_NP-OB2_PP-DAT.cod $(dit-tmp)/adj-io.cod

	## count the direct objects
$(dit-tmp)/adj-do.cod : $(dit-tmp)/adj-io.cod $(col-src)/corpus-tools/count-words-deep.py
	@echo ---Counting DO words---
	python $(word 2,$^) NP-OB1:NP-ACC 20 $<
	mv $(dit-tmp)/adj-io_NP-OB1_NP-ACC.cod $(dit-tmp)/adj-do.cod

	## Run the only-coding.q query (from corpus-tools repository)
$(dit-tmp)/adj-do.cod.ooo : $(dit-tmp)/adj-do.cod $(col-src)/corpus-tools/only-coding.q
	@echo ---Extracting codes---
	$(CS_COMMAND) $(word 2,$^) $<

	## Run add_metadata.py to create the final tab-separated file
analysis/data/dit.dat : $(dit-tmp)/adj-do.cod.ooo $(col-src)/parsedenglish_database/add_metadata.py $(col-src)/parsedenglish_database/English_database.txt
	@echo ---Adding metadata and creating final file---
	@mkdir -p $(@D)
	python $(word 2,$^) $(word 3,$^) $< $@ "Blank" "Verb" "Clause" "PP" "Nom" "Dat" "Acc" "NomVerb" "DatVerb" "AccVerb" "NomDat" "NomAcc" "DatAcc" "Pas" "NomCP" "DatCP" "AccCP" "NomSize" "DatSize" "AccSize" "Adj" "NomPart" "DatPart" "AccPart"
	

	####
	## Heavy NP Shift
	####

	## run the Heavy Full.q query on dummy.psd
$(col-tmp)/Heavy/Full.out : $(col-tmp)/dummy.psd $(col-src)/Heavy/Full.q
	@echo --- Extracting potential cases of Heavy NP Shift ---
	@mkdir -p $(@D)
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(col-src)/Heavy/Full.out $(col-tmp)/Heavy/Full.out

	## run the Heavy Shifted.c query on Heavy Full.out
$(col-tmp)/Heavy/Shifted.cod : $(col-tmp)/Heavy/Full.out $(col-src)/Heavy/Shifted.c
	@echo --- Coding for Heavy NP Shift---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(col-src)/Heavy/Shifted.cod $(col-tmp)/Heavy/Shifted.cod
	
	## run the Heavy ObjType.c query on Shifted.cod
$(col-tmp)/Heavy/ObjType.cod : $(col-tmp)/Heavy/Shifted.cod $(col-src)/Heavy/ObjType.c
	@echo --- Coding for Heavy NP Shift Object Type---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(col-src)/Heavy/ObjType.cod $(col-tmp)/Heavy/ObjType.cod

	## Run the only-coding.q query (from corpus-tools repository)
$(col-tmp)/Heavy/ObjType.cod.ooo : $(col-tmp)/Heavy/ObjType.cod $(col-src)/corpus-tools/only-coding.q
	@echo ---Extracting Heavy NP Shift codes---
	$(CS_COMMAND) $(word 2,$^) $<

	## Run add_metadata.py to create the final tab-separated file
analysis/data/Heavy.dat : $(col-tmp)/Heavy/ObjType.cod.ooo $(col-src)/parsedenglish_database/add_metadata.py $(col-src)/parsedenglish_database/English_database.txt
	@echo ---Adding metadata and creating final file---
	@mkdir -p $(@D)
	python $(word 2,$^) $(word 3,$^) $< $@ "Shifted" "ObjType"


	####
	## Pseudopassives
	####

	## run the Pseudopassives Full.q query on dummy.psd
$(col-tmp)/Pseudopassives/Full.out : $(col-tmp)/dummy.psd $(col-src)/Pseudopassives/Full.q
	@echo --- Extracting potential cases of Heavy NP Shift ---
	@mkdir -p $(@D)
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(col-src)/Pseudopassives/Full.out $(col-tmp)/Pseudopassives/Full.out

	## run the Pseudopassives Pseudo.c query on Pseudopassives Full.out
$(col-tmp)/Pseudopassives/Verbs.cod : $(col-tmp)/Pseudopassives/Full.out $(col-src)/Pseudopassives/Verbs.c
	@echo --- Coding for Pseudopassives ---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(col-src)/Pseudopassives/Verbs.cod $(col-tmp)/Pseudopassives/Verbs.cod

	## run the Pseudopassives Pseudo.c query on Pseudopassives Verbs.cod
$(col-tmp)/Pseudopassives/Pseudo.cod : $(col-tmp)/Pseudopassives/Verbs.cod $(col-src)/Pseudopassives/Pseudo.c
	@echo --- Coding for Pseudopassives ---
	$(CS_COMMAND) $(word 2,$^) $<
	mv $(col-src)/Pseudopassives/Pseudo.cod $(col-tmp)/Pseudopassives/Pseudo.cod
	
	## Run the only-coding.q query (from corpus-tools repository)
$(col-tmp)/Pseudopassives/Pseudo.cod.ooo : $(col-tmp)/Pseudopassives/Pseudo.cod $(col-src)/corpus-tools/only-coding.q
	@echo ---Extracting Heavy NP Shift codes---
	$(CS_COMMAND) $(word 2,$^) $<

	## Run add_metadata.py to create the final tab-separated file
analysis/data/pseudopassives.dat : $(col-tmp)/Pseudopassives/Pseudo.cod.ooo $(col-src)/parsedenglish_database/add_metadata.py $(col-src)/parsedenglish_database/English_database.txt
	@echo ---Adding metadata and creating final file---
	@mkdir -p $(@D)
	python $(word 2,$^) $(word 3,$^) $< $@ "Verb" "Passive"

.PHONY : collection
collection : analysis/data/pseudopassives.dat analysis/data/dit.dat analysis/data/Heavy.dat
endif

.PHONY : dissertation
dissertation : tex/book/Bacovcin-Dissertation.pdf 

## Create intermediate Rdata files by post-processing the raw data
analysis/rdata-tmp/britdat.RData analysis/rdata-tmp/amdat.RData analysis/rdata-tmp/monotrans.RData: analysis/src-analysis/Dit-Processing.R analysis/data/offer_act_coded_final.dat analysis/data/give_old_coded_final.dat analysis/data/give_act_coded_final.dat analysis/data/offer_pas_coded_final.dat analysis/data/dit.dat
	@echo --- Post-processing Raw Data ---
	@mkdir -p $(@D)
	./$<

## Run To-Rates stan model
: analysis/rdata-tmp/britdat.RData analysis/src-analysis/Dit-Processing.R analysis/src-analysis/stan-models/ToReanalysis.stan

chactive : tex/book/chactive.tex output/tables/To-Prop.tex output/images/shifting.pdf output/tables/heavy-mcmc.tex output/tables/weight-mcmc.tex

## Heavy Data for Active Chapter
output/tables/To-Prop.tex : analysis/src-analysis/Dit-Table.R analysis/rdata-tmp/britdat.RData
	@mkdir -p $(@D)
	./$<

output/images/shifting.pdf : analysis/src-analysis/Dit-Heavy-Graph.R analysis/rdata-tmp/britdat.RData analysis/data/Heavy.dat
	@mkdir -p $(@D)
	./$<

analysis/mcmc-runs/heavy.RDS : analysis/src-analysis/Dit-Heavy-MCMC.R analysis/rdata-tmp/britdat.RData analysis/data/Heavy.dat
	@mkdir -p $(@D)
	./$<

output/tables/heavy-mcmc.tex : analysis/src-analysis/Dit-Heavy-Table.R analysis/mcmc-runs/heavy.RDS
	@mkdir -p $(@D)
	./$<


analysis/mcmc-runs/weight.RDS : analysis/src-analysis/Dit-Weight-MCMC.R analysis/rdata-tmp/britdat.RData
	@mkdir -p $(@D)
	./$<

output/tables/weight-mcmc.tex : analysis/src-analysis/Dit-Weight-Table.R analysis/mcmc-runs/weight.RDS
	@mkdir -p $(@D)
	./$<

chpassive : tex/book/chpassive.tex output/images/recpro-to-am.pdf

output/images/recpro-to-am.pdf : analysis/src-analysis/Am-RecPro-Graph.R analysis/rdata-tmp/amdat.RData
	@mkdir -p $(@D)
	./$<

chhist : tex/book/chhist.tex output/images/kroch-graph.png output/images/to-use.pdf output/tables/to-mcmc.tex

output/images/to-use.pdf : analysis/src-analysis/Dit-RiseofTo-Graph.R analysis/mcmc-runs/ToRaising-Stan-Fit.RDS analysis/rdata-tmp/britdat.RData
	@mkdir -p $(@D)
	./$<

output/tables/to-mcmc.tex : analysis/src-analysis/Dit-RiseofTo-Table.R analysis/mcmc-runs/ToRaising-Stan-Fit.RDS analysis/rdata-tmp/britdat.RData
	@mkdir -p $(@D)
	./$<

analysis/mcmc-runs/ToRaising-Stan-Fit.RDS : analysis/src-analysis/Dit-RiseofTo-MCMC.R analysis/rdata-tmp/britdat.RData
	@mkdir -p $(@D)
	./$<

## Compile the dissertation
tex/book/Bacovcin-Dissertation.pdf : tex/book/Bacovcin-Dissertation.tex tex/book/chintro.tex tex/book/chbackground.tex tex/book/Abstract.tex tex/book/Acknowledgements.tex tex/book/appendixA.tex tex/book/appendixB.tex tex/book/chconc.tex tex/book/mcbride.bst tex/book/upenndiss.cls tex/diss.bib chactive chpassive chhist
	xelatex tex/book/Bacovcin-Dissertation
	biblatex tex/book/Bacovcin-Dissertation
	xelatex tex/book/Bacovcin-Dissertation
	xelatex tex/book/Bacovcin-Dissertation
