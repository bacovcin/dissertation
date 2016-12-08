node: CP*
coding_query:

2: {
NA: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms NP-SBJ*) AND (IP-MAT*|IP-SUB* iDoms NP-OB1|NP-OB2|NP-ACC|NP-DAT|NP-DTV)
PAS: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms NP-SBJ*) AND (IP-MAT*|IP-SUB* iDoms VAN|VBN) AND (IP-MAT*|IP-SUB* iDoms PP) AND (PP iDoms NP*) AND (NP* iDomsMod META|ALT-ORTHO \**) AND (NP-SBJ* sameIndex \**)
NA: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms NP-SBJ*) AND (IP-MAT*|IP-SUB* iDoms VAN|VBN) AND (IP-MAT*|IP-SUB* iDoms PP)
ACT: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA account|agree|approve|arrive|call|complain|dispose|enter|hear|hit|look|meet|pray|provide|put|say|send|seek|speak|wish) AND (IP-MAT*|IP-SUB* iDoms PP) AND (PP iDoms P) AND (PP iDoms !CONJ) AND (P iDomsMod META|LEMMA for|on|upon|of|at|about|into|with|after) AND (V* iPres PP)
ACT: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA account|agree|approve|arrive|call|complain|dispose|enter|hear|hit|look|meet|pray|provide|put|say|send|seek|speak|wish) AND (IP-MAT*|IP-SUB* iDoms PP) AND (PP iDoms P) AND (PP iDoms !CONJ) AND (P iDomsMod META|LEMMA for|on|upon|of|at|about|into|with|after) AND (IP-MAT*|IP-SUB* iDoms ADV*) AND (V* iPres ADV*) AND (ADV* iPres PP)
NA: ELSE
}
