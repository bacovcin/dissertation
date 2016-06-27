node: CP*

define: Ditrans.def

coding_query:

5: {
	NomConj: (IP*  iDoms nom) AND (nom iDoms CONJ*)
        NomDefinite: (IP*  iDoms nom) AND (nom iDoms possessor)
        NomPronoun: (IP*  iDoms nom) AND (nom iDoms PRO*)
        NomDPronoun: (IP*  iDoms nom) AND (nom iDomsOnly D)
        NomDefinite: (IP*  iDoms nom) AND (nom iDoms D) AND (D iDoms definite)
	NomName: (IP* iDoms nom) AND (nom iDoms NPR*|NR*)
        NomWHPronoun: (IP*  iDoms nom) AND (nom iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
        NomWHEmpty: (IP*  iDoms nom) AND (nom iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
        NomWHIndefinite: (IP*  iDoms nom) AND (nom iDoms \*T*) AND (\*T* SameIndex WNP*)
        NomEmpty: (IP*  iDoms nom) AND (nom iDoms \**)
        NomIndefinite: (IP*  iDoms nom)
        NomNull: ELSE
}
