node: CP*

define: Ditrans.def

coding_query:
1: {
  PSEUDO: (CP* iDoms IP*) AND (IP* iDoms NP-SBJ*) AND (IP* iDoms *VAN*|*VBN*) AND (IP* iDoms PP) AND (PP iDoms NP*) AND (NP* iDoms \**) AND (NP-SBJ* sameIndex \**)	
  PAS: (CP* iDoms IP*) AND (IP*  iDoms BE*) AND (IP*  iDoms *VBN*|*VAN*)
  ACT: (CP* iDoms IP*) AND (IP* iDomsMod NP|CONJ* NP-OB1*)
  MONO: ELSE
}
