node: CP*

define: Ditrans.def

coding_query:

15: {
	NomHasCP: (IP* iDoms nom) AND (nom Doms [2]CP*)	AND ([2]CP* iDoms !\**)
	NomNoCP: (IP* iDoms nom)
	NONom: ELSE
}

16: {
	DatHasCP: (IP* iDoms dat) AND (dat Doms [2]CP*) AND ([2]CP* iDoms !\**)
	DatHasCP: (IP* iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*|QP*) AND (NP*|QP* Doms [2]CP*) AND ([2]CP* iDoms !\**)
	DatNoCP: (IP* iDoms dat)
	DatNoCP: (IP* iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp)
	NODat: ELSE
}

17: {
	AccHasCP: (IP* iDoms acc) AND (acc Doms [2]CP*)	AND ([2]CP* iDoms !\**)
	AccNoCP: (IP* iDoms acc)
	NOAcc: ELSE
}
