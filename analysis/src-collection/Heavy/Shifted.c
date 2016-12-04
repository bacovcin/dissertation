node: CP*

coding_query:
1: {
	BothNotShifted: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (IP* iDoms ADVP) AND (IP* iDoms PP*) AND (IP* iDoms V*) AND (NP-OB1|NP-ACC Pres PP*) AND (NP-OB1|NP-ACC Pres ADV*) AND (V* Pres PP*) AND (V* Pres NP-OB1|NP-ACC) AND (V* Pres ADV*)
	BothShifted: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (IP* iDoms ADV*) AND (IP* iDoms PP*) AND (IP* iDoms V*) AND (PP* Pres NP-OB1|NP-ACC) AND (ADV* Pres NP-OB1|NP-ACC) AND (V* Pres PP*) AND (V* Pres NP-OB1|NP-ACC) AND (V* Pres ADV*)
	PPNotShifted: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (IP* iDoms PP*) AND (IP* iDoms V*) AND (NP-OB1|NP-ACC Pres PP*) AND (V* Pres PP*) AND (V* Pres NP-OB1|NP-ACC)
	PPShifted: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (IP* iDoms PP*) AND (IP* iDoms V*) AND (PP* Pres NP-OB1|NP-ACC) AND (V* Pres PP*) AND (V* Pres NP-OB1|NP-ACC)
	AdvNotShifted: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (IP* iDoms ADVP) AND (IP* iDoms V*) AND (NP-OB1|NP-ACC Pres ADV*) AND (V* Pres ADV*) AND (V* Pres NP-OB1|NP-ACC)
	AdvShifted: (CP* iDoms IP*) AND (IP* iDoms NP-OB1|NP-ACC) AND (IP* iDoms ADVP) AND (IP* iDoms V*) AND (ADV* Pres NP-OB1|NP-ACC) AND (V* Pres ADV*) AND (V* Pres NP-OB1|NP-ACC)
	NA: ELSE
}
