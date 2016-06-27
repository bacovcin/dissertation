node: CP*

define: Ditrans.def

coding_query:

8: {
   NA: (IP* iDoms nom) AND (nom iDoms \**)
   NomV: (IP* iDoms nom) AND (IP* iDoms finite_verb) AND (nom Pres finite_verb)
   VNom: (IP* iDoms nom) AND (IP* iDoms finite_verb) AND (finite_verb Pres nom)
   NomV: (IP* iDoms nom) AND (IP* iDoms V*) AND (nom Pres V*)
   VNom: (IP* iDoms nom) AND (IP* iDoms V*) AND (V* Pres nom)
   NA: ELSE
}
