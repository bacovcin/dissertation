node: CP*

define: Ditrans.def

coding_query:

13: {
   NA: (CP* iDoms IP*) AND (IP* iDoms dat) AND (dat iDoms \**)
   NA: (CP* iDoms IP*) AND (IP* iDoms acc) AND (acc iDoms \**)
   AccDat: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms dat) AND (acc Pres dat)   
   DatAcc: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms dat) AND (dat Pres acc)
   NA: (CP* iDoms IP*) AND (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP) AND (NP iDoms \**)
   AccDat: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms acc) AND (acc Pres PP)
   DatAcc: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms acc) AND (PP Pres acc)
   NA: ELSE
}
