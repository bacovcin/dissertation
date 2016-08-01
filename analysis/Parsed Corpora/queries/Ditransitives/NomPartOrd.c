node: CP*

define: Ditrans.def

coding_query:

22: {
   NA: (CP* iDoms IP*) AND (IP* iDoms nom) AND (nom iDoms \**)
   NomV: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms *VBN*|*VAN*) AND (nom Pres *VBN*|*VAN*)
   VNom: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms *VBN*|*VAN*) AND (*VBN*|*VAN* Pres nom)
   NA: ELSE
}
