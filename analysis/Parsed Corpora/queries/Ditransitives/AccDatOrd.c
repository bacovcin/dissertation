node: CP*

define: Ditrans.def

coding_query:

13: {
   NA: (IP* iDoms dat) AND (dat iDoms \**)
   NA: (IP* iDoms acc) AND (acc iDoms \**)
   AccDat: (IP* iDoms acc) AND (IP* iDoms dat) AND (acc Pres dat)   
   DatAcc: (IP* iDoms acc) AND (IP* iDoms dat) AND (dat Pres acc)
   NA: (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP) AND (NP iDoms \**)
   AccDat: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms acc) AND (acc Pres PP)
   DatAcc: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms acc) AND (PP Pres acc)
   NA: ELSE
}
