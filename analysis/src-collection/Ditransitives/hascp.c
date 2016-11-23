node: CP*

define: Ditrans.def

coding_query:

15: {
	NomHasCP: (CP* iDoms IP*) AND (IP* iDoms nom) AND (nom Doms [2]CP*)	AND ([2]CP* iDoms !\**)
	NomNoCP: (CP* iDoms IP*) AND (IP* iDoms nom)
	NONom: ELSE
}

16: {
	DatHasCP: (CP* iDoms IP*) AND (IP* iDoms dat) AND (dat Doms [2]CP*) AND ([2]CP* iDoms !\**)
	DatHasCP: (CP* iDoms IP*) AND (IP* iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*|QP*) AND (NP*|QP* Doms [2]CP*) AND ([2]CP* iDoms !\**)
	DatNoCP: (CP* iDoms IP*) AND (IP* iDoms dat)
	DatNoCP: (CP* iDoms IP*) AND (IP* iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp)
	NODat: ELSE
}

17: {
	AccHasCP: (CP* iDoms IP*) AND (IP* iDoms acc) AND (acc Doms [2]CP*)	AND ([2]CP* iDoms !\**)
	AccNoCP: (CP* iDoms IP*) AND (IP* iDoms acc)
	NOAcc: ELSE
}
