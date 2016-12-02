node: CP*
define: Ditrans.def
coding_query:
2: {
	ObjConj: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (NP-OB1|NP-ACC iDoms CONJ*)
	ObjDefinite: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (NP-OB1|NP-ACC iDoms possessor)
	ObjPronoun: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (NP-OB1|NP-ACC iDoms pro*)
	ObjDPronoun: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (NP-OB1|NP-ACC iDomsOnly D)
	ObjDefinite: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (NP-OB1|NP-ACC iDoms D) AND (d iDoms definite)
	ObjName: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (NP-OB1|NP-ACC iDoms NPR*|NR*)
	ObjIndefinite: (CP* iDoms IP*) AND (IP*  iDoms NP-OB1|NP-ACC)
	ObjCP: (CP* iDoms IP*) AND (IP* iDoms CP-THT*)
	ObjINF: (CP* iDoms IP*) AND (IP* iDomsMod CP IP-INF*)
	ObjNull: ELSE
}
