node: CP*
copy_corpus: t

define: Ditrans.def

query: (CP* iDoms IP*) AND (IP* idoms !dat) AND (IP* iDoms {1}PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
append_label{1}: -DAT
