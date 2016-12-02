node: CP*
coding_query:

2: {
NA: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms NP-SBJ*) AND (IP-MAT*|IP-SUB* iDoms NP-OB1|NP-OB2|NP-ACC|NP-DAT|NP-DTV)
PAS: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms NP-SBJ*) AND (IP-MAT*|IP-SUB* iDoms VAN|VBN) AND (IP-MAT*|IP-SUB* iDoms PP) AND (PP iDoms NP*) AND (NP* iDomsMod META|ALT-ORTHO \**) AND (NP-SBJ* sameIndex \**)
NA: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms NP-SBJ*) AND (IP-MAT*|IP-SUB* iDoms VAN|VBN) AND (IP-MAT*|IP-SUB* iDoms PP)
NONPAS: ELSE
}
