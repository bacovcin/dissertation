collection = false
ifeq($(collection,true))
	
endif

.PHONY: pdf
pdf : tex/book/Bacovcin-Dissertation.pdf 

## Compile the dissertation
tex/book/Bacovcin-Dissertation.pdf : tex/book/*.tex
	xelatex tex/book/Bacovcin-Dissertation
	biblatex tex/book/Bacovcin-Dissertation
	xelatex tex/book/Bacovcin-Dissertation
	xelatex tex/book/Bacovcin-Dissertation
