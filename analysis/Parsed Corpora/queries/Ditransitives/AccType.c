node: CP*

define: Ditrans.def

coding_query:
7: {
	AccConj: (CP* iDoms IP*) AND (IP* iDoms acc) AND (acc iDoms CONJ*)
	AccDefinite: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms possessor)
	AccPronoun: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms PRO*)
	AccDPronoun: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDomsOnly D)
	AccDefinite: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms D) AND (D iDoms definite)
	AccName: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms NPR*|NR*)
	AccWHPronoun: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
	AccWHEmpty: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
	AccWHIndefinite: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms \*T*) AND (\*T* SameIndex WNP*|WQP*)
	AccEmpty: (CP* iDoms IP*) AND (IP*  iDoms acc) AND (acc iDoms \**)
	AccIndefinite: (CP* iDoms IP*) AND (IP*  iDoms acc)
	AccCP: (CP* iDoms IP*) AND (IP* iDoms CP-THT*)
	AccINF: (CP* iDoms IP*) AND (IP* iDomsMod CP IP-INF*)
	AccNull: ELSE
}
