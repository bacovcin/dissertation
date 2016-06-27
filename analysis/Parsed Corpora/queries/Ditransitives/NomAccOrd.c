node: CP*

define: Ditrans.def

coding_query:

12: {
   NA: (IP* iDoms nom) AND (nom iDoms \**)
   NA: (IP* iDoms acc) AND (acc iDoms \**)
   AccNom: (IP* iDoms acc) AND (IP* iDoms nom) AND (acc Pres nom)   
   NomAcc: (IP* iDoms acc) AND (IP* iDoms nom) AND (nom Pres acc)
   NA: ELSE
}
