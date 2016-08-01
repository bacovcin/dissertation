node: CP*

define: Ditrans.def

coding_query:

5: {
	NomConj: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms CONJ*)
        NomDefinite: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms possessor)
        NomPronoun: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms PRO*)
        NomDPronoun: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDomsOnly D)
        NomDefinite: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms D) AND (D iDoms definite)
	NomName: (CP* iDoms IP*) AND (IP* iDoms nom) AND (nom iDoms NPR*|NR*)
        NomWHPronoun: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
        NomWHEmpty: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
        NomWHIndefinite: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms \*T*) AND (\*T* SameIndex WNP*)
        NomEmpty: (CP* iDoms IP*) AND (IP*  iDoms nom) AND (nom iDoms \**)
        NomIndefinite: (CP* iDoms IP*) AND (IP*  iDoms nom)
        NomNull: ELSE
}
