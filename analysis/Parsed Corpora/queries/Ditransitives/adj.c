node: CP*

define: Ditrans.def

coding_query:
21: {
	NA: (CP* iDoms IP*) AND (IP* iDoms dat) AND (dat iDoms \**)
	Adjacent: (IP* iDoms  V*) AND (IP* iDoms dat) AND (V* iPres dat)
	DOIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms dat) AND (V* iPres acc) AND (acc iPres dat)
	NomIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms dat) AND (V* iPres nom) AND (nom iPres dat)
        NegIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms dat) AND (V* iPres NEG) AND (NEG iPres dat)
        AdvIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms dat) AND (V* iPres ADV*) AND (ADV* iPres dat)
	PreverbAdjacent: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms dat) AND (dat iPres  V*)
	PreverbDOIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms dat) AND (acc iPres  V*) AND (dat iPres acc)
	PreverbNomIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms dat) AND (nom iPres  V*) AND (dat iPres nom)
        PreverbNegIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms dat) AND (NEG iPres  V*) AND (dat iPres NEG)
        PreverbAdvIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms ADV*) AND (IP* iDoms dat) AND (ADV* iPres  V*) AND (dat iPres ADV*)
	PreverbFiniteIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms finite_verb) AND (IP* iDoms dat) AND (finite_verb iPres  V*) AND (dat iPres finite_verb)
	NA: (CP* iDoms IP*) AND (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP) AND (NP iDoms \**)
	Adjacent: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms PP) AND (V* iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	DOIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms PP) AND (V* iPres acc) AND (acc iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	NomIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms PP) AND (V* iPres nom) AND (nom iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        NegIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms PP) AND (V* iPres NEG) AND (NEG iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        AdvIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms PP) AND (V* iPres ADV*) AND (ADV* iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbAdjacent: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms PP) AND (PP iPres V*) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbDOIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms PP) AND (acc iPres  V*) AND (PP iPres acc) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbNomIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms PP) AND (nom iPres  V*) AND (PP iPres nom) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        PreverbNegIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms PP) AND (NEG iPres  V*) AND (PP iPres NEG) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        PreverbAdvIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms ADV*) AND (IP* iDoms PP) AND (ADV* iPres  V*) AND (PP iPres ADV*) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbFiniteIntervene: (CP* iDoms IP*) AND (IP* iDoms  V*) AND (IP* iDoms finite_verb) AND (IP* iDoms PP) AND (finite_verb iPres  V*) AND (PP iPres finite_verb) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	NA: (CP* iDoms IP*) AND (IP*  Doms !ditp)
	OtherInterveners: ELSE
    }
