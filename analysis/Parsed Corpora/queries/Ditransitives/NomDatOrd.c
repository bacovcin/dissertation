node: CP*

define: Ditrans.def

coding_query:

11: {
   NA: (IP* iDoms dat) AND (dat iDoms \**)
   NA: (IP* iDoms nom) AND (nom iDoms \**)
   NomDat: (IP* iDoms nom) AND (IP* iDoms dat) AND (nom Pres dat)
   DatNom: (IP* iDoms nom) AND (IP* iDoms dat) AND (dat Pres nom)
   NA: (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP) AND (NP iDoms \**)
   NomDat: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms nom) AND (nom Pres PP)
   DatNom: (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (IP* iDoms nom) AND (PP Pres nom)
   NA: ELSE
}
