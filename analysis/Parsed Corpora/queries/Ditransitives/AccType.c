node: CP*

define: Ditrans.def

coding_query:
7: {
	AccConj: (IP* iDoms acc) AND (acc iDoms CONJ*)
	AccDefinite: (IP*  iDoms acc) AND (acc iDoms possessor)
	AccPronoun: (IP*  iDoms acc) AND (acc iDoms PRO*)
	AccDPronoun: (IP*  iDoms acc) AND (acc iDomsOnly D)
	AccDefinite: (IP*  iDoms acc) AND (acc iDoms D) AND (D iDoms definite)
	AccName: (IP*  iDoms acc) AND (acc iDoms NPR*|NR*)
	AccWHPronoun: (IP*  iDoms acc) AND (acc iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
	AccWHEmpty: (IP*  iDoms acc) AND (acc iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
	AccWHIndefinite: (IP*  iDoms acc) AND (acc iDoms \*T*) AND (\*T* SameIndex WNP*|WQP*)
	AccEmpty: (IP*  iDoms acc) AND (acc iDoms \**)
	AccIndefinite: (IP*  iDoms acc)
	AccCP: (IP* iDoms CP-THT*)
	AccINF: (IP* iDoms IP-INF*)
	AccNull: ELSE
}
