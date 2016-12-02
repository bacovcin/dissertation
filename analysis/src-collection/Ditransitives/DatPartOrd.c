node: CP*

define: Ditrans.def

coding_query:

23: {
   NA: (CP* iDoms IP*) AND (IP* iDoms dat) AND (dat iDoms \**)
   DatV: (CP* iDoms IP*) AND (IP* iDoms dat) AND (IP* iDoms *VBN*|*VAN*) AND (dat Pres *VBN*|*VAN*)
   VDat: (CP* iDoms IP*) AND (IP* iDoms dat) AND (IP* iDoms *VBN*|*VAN*) AND (*VBN*|*VAN* Pres dat)
   NA: (CP* iDoms IP*) AND (IP*  iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDomsMod META|LEMMA ditp) AND (P HasSister NP) AND (NP iDoms \**)
   DatV: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDomsMod META|LEMMA ditp) AND (IP* iDoms *VBN*|*VAN*) AND (PP Pres *VBN*|*VAN*)
   VDat: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJ* P) AND (P iDomsMod META|LEMMA ditp) AND (IP* iDoms *VBN*|*VAN*) AND (*VBN*|*VAN* Pres PP)
   NA: ELSE
}
