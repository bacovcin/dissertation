collection = false

ifeq($(collection,true))
	corpora = /analysis/corpora/PCEEC/corpus/psd-cs1/*.psd /analysis/corpora/PCEEC/corpus/psd-cs2/*.psd /analysis/corpora/PPCEME/psd/*/*.psd /analysis/corpora/PPCMBE/psd/*.psd /analysis/corpora/PPCME2/psd/*.psd /analysis/corpora/ycoe/psd/*.psd
	CS_COMMAND=---java -classpath /analysis/src-collection/CS_2.0003.04.jar csearch/CorpusSearch---
	col-tmp = /analysis/collection-tmp
	col-src = /analysis/src-collection
	dit-tmp = /analysis/collection-tmp/Ditransitives
	dit-src = /analysis/src-collection/Ditransitives
	## Create a combined corpus file
	$(col-tmp)/corpus.txt	: $(corpora) 
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
		mv /analysis/src-collection/corpus-tools/dummy.out $@

	## run RemoveDup.py on the output from dummy.q (Removes tokens with identical text; deals with corpus overlap issues)
	$(col-tmp)/dummy.psd : $(col-tmp)/dummy.out $(col-src)/corpus-tools/RemoveDup.py
		@echo --- Removing duplicate tokens from corpus ---
		python $(word 2,$^) $<
	
	## run the Full.q query on dummy.psd
	$(col-tmp)/Ditransitives/Full.out : $(col-tmp)/dummy.psd $(dit-src)/Full.q
		@echo --- Extracting ditransitive verbs ---
		@mkdir -p $(@D)
		$(CS_COMMAND) $(word 2,$^) $<

	## run the Verbs.c query on Full.out
	$(dit-tmp)/Verbs.cod : $(dit-tmp)/Full.out $(dit-src)/Verbs.c
        @echo ---Coding Verbs---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the clausetype.c query on Verbs.cod
	$(dit-tmp)/clausetype.cod : $(dit-tmp)/Verbs.cod $(dit-src)/clausetype.c
        @echo ---Coding clausetype---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the PP.c query on clausetype.cod
	$(dit-tmp)/PP.cod : $(dit-tmp)/clausetype.cod $(dit-src)/PP.c
        @echo ---Coding PP---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the NomType.c query on PP.cod
	$(dit-tmp)/NomType.cod : $(dit-tmp)/PP.cod $(dit-src)/NomType.c
        @echo ---Coding NomType---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the DatType.c query on NomType.cod
	$(dit-tmp)/DatType.cod : $(dit-tmp)/NomType.cod $(dit-src)/DatType.c
        @echo ---Coding DatType---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the AccType.c query on DatType.cod
	$(dit-tmp)/AccType.cod : $(dit-tmp)/DatType.cod $(dit-src)/AccType.c
        @echo ---Coding AccType---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the NomVerbOrd.c query on AccType.cod
	$(dit-tmp)/NomVerbOrd.cod : $(dit-tmp)/AccType.cod $(dit-src)/NomVerbOrd.c
        @echo ---Coding NomVerbOrder---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the DatVerbOrd.c query on NomVerbOrd.cod
	$(dit-tmp)/DatVerbOrd.cod : $(dit-tmp)/NomVerbOrd.cod $(dit-src)/DatVerbOrd.c
        @echo ---Coding DatVerbOrd---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the AccVerbOrd.c query on DatVerbOrd.cod
	$(dit-tmp)/AccVerbOrd.cod : $(dit-tmp)/DatVerbOrd.cod $(dit-src)/AccVerbOrd.c
        @echo ---Coding NomType---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the NomDatOrd.c query on AccVerbOrd.cod
	$(dit-tmp)/NomDatOrd.cod : $(dit-tmp)/AccVerbOrd.cod $(dit-src)/NomDatOrd.c
        @echo ---Coding NomDatOrd---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the NomAccOrd.c query on NomDatOrd.cod
	$(dit-tmp)/NomAccOrd.cod : $(dit-tmp)/NomDatOrd.cod $(dit-src)/NomAccOrd.c
        @echo ---Coding NomAccOrd---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the AccDatOrd.c query on NomAccOrd.cod
	$(dit-tmp)/AccDatOrd.cod : $(dit-tmp)/NomAccOrd.cod $(dit-src)/NomAccOrd.c
        @echo ---Coding AccDatOrd---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the pas.c query on AccDatOrd.cod
	$(dit-tmp)/pas.cod : $(dit-tmp)/AccDatOrd.cod $(dit-src)/pas.c
        @echo ---Coding pas---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the hascp.c query on pas.cod
	$(dit-tmp)/hascp.cod : $(dit-tmp)/pas.cod $(dit-src)/hascp.cod
        @echo ---Coding hascp---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the adj.c query on hascp.cod
	$(dit-tmp)/adj.cod : $(dit-tmp)/hascp.cod $(dit-src)/adj.c
        @echo ---Coding adj---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the NomPartOrd.c query on adj.cod
	$(dit-tmp)/NomPartOrd.cod : $(dit-tmp)/adj.cod $(dit-src)/NomPartOrd.c
        @echo ---Coding NomPartOrd---
		$(CS_COMMAND) /analysis/src-collection/Ditransitives/NomPartOrd.c $<

	## run the DatPartOrd.c query on NomPartOrd.cod
	$(dit-tmp)/DatPartOrd.cod : $(dit-tmp)/NomPartOrd.cod $(dit-src)/DatPartOrd.c
        @echo ---Coding DatPartOrd---
		$(CS_COMMAND) $(word 2,$^) $<

	## run the AccPartOrd.c query on DatPartOrd.cod
	$(dit-tmp)/AccPartOrd.cod : $(dit-tmp)/DatPartOrd.cod $(dit-src)/AccPartOrd.c
        @echo ---Coding AccPartOrd---
		$(CS_COMMAND) $(word 2,$^) $<

	## count the subjects
	$(dit-tmp)/adj-sbj.cod : $(dit-tmp)/AccPartOrd.cod $(col-src)/corpus-tools/count-words.py
        @echo ---Counting subject words---
		python $(word 2,$^) NP-SBJ:NP-NOM 18 $<
		mv $(dit-tmp)/AccPartOrd_NP-SBJ_NP-NOM.cod $(dit-tmp)/adj-sbj.cod

	## count the indirect objects
	$(dit-tmp)/adj-io.cod : $(dit-tmp)/adj-sbj.cod $(col-src)/corpus-tools/count-words.py
        @echo ---Counting IO words---
		python $(word 2,$^) NP-DAT:NP-DTV:NP-OB2:PP-DAT 19 $<
		mv $(dit-tmp)/adj-sbj.cod_NP-DAT_NP-DTV_NP-OB2_PP-DAT.cod $(dit-tmp)/adj-io.cod

	## count the direct objects
	$(dit-tmp)/adj-do.cod : $(dit-tmp)/adj-io.cod $(col-src)/corpus-tools/count-words.py
        @echo ---Counting DO words---
		python $(word 2,$^) NP-OB1:NP-ACC 20 $<
		mv $(dit-tmp)/adj-io_NP-OB1_NP-ACC.cod $(dit-tmp)/adj-do.cod

	## Run the only-coding.q query (from corpus-tools repository)
	$(dit-tmp)/adj-do.cod.ooo : $(dit-tmp)/adj-do.cod $(col-src)/corpus-tools/only-coding.q
        @echo ---Extracting codes---
		$(CS_COMMAND) $(word 2,$^) $<

#24) Run add_metadata.py to create the final tab-separated file
	/analysis/data/dit.dat : $(dit-tmp)/adj-do.cod.ooo $(col-src)/parsedenglish_database/add_metadata.py $(col-src)/parsedenglish_database/English_database.txt
        @echo ---Adding metadata and creating final file---
		@mkdir -p $(@D)
		python $(word 2,$^) $(word 3,$^) $< $@ "Blank" "Verb" "Clause" "PP" "Nom" "Dat" "Acc" "NomVerb" "DatVerb" "AccVerb" "NomDat" "NomAcc" "DatAcc" "Pas" "NomCP" "DatCP" "AccCP" "NomSize" "DatSize" "AccSize" "Adj" "NomPart" "DatPart" "AccPart"

endif

.PHONY: pdf
pdf : tex/book/Bacovcin-Dissertation.pdf 

## Create intermediate Rdata files by post-processing the raw data
/analysis/rdata-tmp/*.RData : /analysis/src-analysis/Dit-Processing.R /analysis/data/*.dat
	@echo --- Post-processing Raw Data ---
	@mkdir -p $(@D)
	./$<

## Run To-Rates stan model
: /analysis/rdata-tmp/britdat.RData /analysis/src-analysis/Dit-Processing.R /analysis/src-analysis/stan-models/ToReanalysis.stan

## Compile the dissertation
tex/book/Bacovcin-Dissertation.pdf : tex/book/*.tex output/images/*.pdf output/tables/*.tex
	xelatex tex/book/Bacovcin-Dissertation
	biblatex tex/book/Bacovcin-Dissertation
	xelatex tex/book/Bacovcin-Dissertation
	xelatex tex/book/Bacovcin-Dissertation
