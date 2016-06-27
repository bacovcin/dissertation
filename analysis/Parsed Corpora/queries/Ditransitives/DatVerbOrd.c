node: CP*

define: Ditrans.def

coding_query:

9: {
   NA: (IP* iDoms dat) AND (dat iDoms \**)
   DatV: (IP* iDoms dat) AND (IP* iDoms finite_verb) AND (dat Pres finite_verb)
   VDat: (IP* iDoms dat) AND (IP* iDoms finite_verb) AND (finite_verb Pres dat)
   DatV: (IP* iDoms dat) AND (IP* iDoms V*) AND (dat Pres V*)
   VDat: (IP* iDoms dat) AND (IP* iDoms V*) AND (V* Pres dat)
   NA: (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP) AND (NP iDoms \**)
   DatV: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms finite_verb) AND (PP Pres finite_verb)
   VDat: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms finite_verb) AND (finite_verb Pres PP)
   DatV: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms V*) AND (PP Pres V*)
   VDat: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms V*) AND (V* Pres PP)
   NA: ELSE
}
