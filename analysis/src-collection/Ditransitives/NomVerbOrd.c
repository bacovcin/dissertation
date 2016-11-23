node: CP*

define: Ditrans.def

coding_query:

8: {
   NA: (CP* iDoms IP*) AND (IP* iDoms nom) AND (nom iDoms \**)
   NomV: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms finite_verb) AND (nom Pres finite_verb)
   VNom: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms finite_verb) AND (finite_verb Pres nom)
   NomV: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms V*) AND (nom Pres V*)
   VNom: (CP* iDoms IP*) AND (IP* iDoms nom) AND (IP* iDoms V*) AND (V* Pres nom)
   NA: ELSE
}
