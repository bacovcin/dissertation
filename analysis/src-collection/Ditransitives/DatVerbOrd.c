node: CP*

define: Ditrans.def

coding_query:

9: {
   NA: (CP* iDoms IP*) AND (IP* iDoms dat) AND (dat iDoms \**)
   DatV: (CP* iDoms IP*) AND (IP* iDoms dat) AND (IP* iDoms finite_verb) AND (dat Pres finite_verb)
   VDat: (CP* iDoms IP*) AND (IP* iDoms dat) AND (IP* iDoms finite_verb) AND (finite_verb Pres dat)
   DatV: (CP* iDoms IP*) AND (IP* iDoms dat) AND (IP* iDoms V*) AND (dat Pres V*)
   VDat: (CP* iDoms IP*) AND (IP* iDoms dat) AND (IP* iDoms V*) AND (V* Pres dat)
   NA: (CP* iDoms IP*) AND (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP) AND (NP iDoms \**)
   DatV: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms finite_verb) AND (PP Pres finite_verb)
   VDat: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms finite_verb) AND (finite_verb Pres PP)
   DatV: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms V*) AND (PP Pres V*)
   VDat: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms V*) AND (V* Pres PP)
   NA: ELSE
}
