node: CP*

define: Ditrans.def

coding_query:

12: {
   NA: (CP* iDoms IP*) AND (IP* iDoms nom) AND (nom iDoms \**)
   NA: (CP* iDoms IP*) AND (IP* iDoms acc) AND (acc iDoms \**)
   AccNom: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms nom) AND (acc Pres nom)   
   NomAcc: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms nom) AND (nom Pres acc)
   NA: ELSE
}
