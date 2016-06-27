node: CP*

define: Ditrans.def

coding_query:
21: {
	NA: (IP* iDoms dat) AND (dat iDoms \**)
	Adjacent: (IP* iDoms  V*) AND (IP* iDoms dat) AND (V* iPres dat)
	DOIntervene: (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms dat) AND (V* iPres acc) AND (acc iPres dat)
	NomIntervene: (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms dat) AND (V* iPres nom) AND (nom iPres dat)
        NegIntervene: (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms dat) AND (V* iPres NEG) AND (NEG iPres dat)
        AdvIntervene: (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms dat) AND (V* iPres ADV*) AND (ADV* iPres dat)
	PreverbAdjacent: (IP* iDoms  V*) AND (IP* iDoms dat) AND (dat iPres  V*)
	PreverbDOIntervene: (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms dat) AND (acc iPres  V*) AND (dat iPres acc)
	PreverbNomIntervene: (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms dat) AND (nom iPres  V*) AND (dat iPres nom)
        PreverbNegIntervene: (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms dat) AND (NEG iPres  V*) AND (dat iPres NEG)
        PreverbAdvIntervene: (IP* iDoms  V*) AND (IP* iDoms ADV*) AND (IP* iDoms dat) AND (ADV* iPres  V*) AND (dat iPres ADV*)
	PreverbFiniteIntervene: (IP* iDoms  V*) AND (IP* iDoms finite_verb) AND (IP* iDoms dat) AND (finite_verb iPres  V*) AND (dat iPres finite_verb)
	NA: (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP) AND (NP iDoms \**)
	Adjacent: (IP* iDoms  V*) AND (IP* iDoms PP) AND (V* iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	DOIntervene: (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms PP) AND (V* iPres acc) AND (acc iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	NomIntervene: (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms PP) AND (V* iPres nom) AND (nom iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        NegIntervene: (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms PP) AND (V* iPres NEG) AND (NEG iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        AdvIntervene: (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms PP) AND (V* iPres ADV*) AND (ADV* iPres PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbAdjacent: (IP* iDoms  V*) AND (IP* iDoms PP) AND (PP iPres V*) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbDOIntervene: (IP* iDoms  V*) AND (IP* iDoms acc) AND (IP* iDoms PP) AND (acc iPres  V*) AND (PP iPres acc) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbNomIntervene: (IP* iDoms  V*) AND (IP* iDoms nom) AND (IP* iDoms PP) AND (nom iPres  V*) AND (PP iPres nom) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        PreverbNegIntervene: (IP* iDoms  V*) AND (IP* iDoms NEG) AND (IP* iDoms PP) AND (NEG iPres  V*) AND (PP iPres NEG) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
        PreverbAdvIntervene: (IP* iDoms  V*) AND (IP* iDoms ADV*) AND (IP* iDoms PP) AND (ADV* iPres  V*) AND (PP iPres ADV*) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	PreverbFiniteIntervene: (IP* iDoms  V*) AND (IP* iDoms finite_verb) AND (IP* iDoms PP) AND (finite_verb iPres  V*) AND (PP iPres finite_verb) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ditp)
	NA: (IP*  Doms !ditp)
	OtherInterveners: ELSE
    }
