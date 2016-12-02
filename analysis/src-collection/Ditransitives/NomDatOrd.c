node: CP*

define: Ditrans.def

coding_query:

11: {
   NA: (CP* iDoms IP*) AND (IP* iDoms dat) AND (dat iDoms \**)
   NA: (CP* iDoms IP*) AND (IP* iDoms nom) AND (nom iDoms \**)
   NomDat: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms dat) AND (nom Pres dat)
   DatNom: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms dat) AND (dat Pres nom)
   NA: (CP* iDoms IP*) AND (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDomsMod META|LEMMA ditp) AND (P HasSister NP) AND (NP iDoms \**)
   NomDat: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDomsMod META|LEMMA ditp) AND (IP* iDoms nom) AND (nom Pres PP)
   DatNom: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDomsMod META|LEMMA ditp) AND (IP* iDoms nom) AND (PP Pres nom)
   NA: ELSE
}
