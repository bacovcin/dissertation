node: CP*

define: Ditrans.def

coding_query:

10: {
   NA: (IP* iDoms acc) AND (acc iDoms \**)
   AccV: (IP* iDoms acc) AND (IP* iDoms finite_verb) AND (acc Pres finite_verb)
   VAcc: (IP* iDoms acc) AND (IP* iDoms finite_verb) AND (finite_verb Pres acc)
   AccV: (IP* iDoms acc) AND (IP* iDoms V*) AND (acc Pres V*)
   VAcc: (IP* iDoms acc) AND (IP* iDoms V*) AND (V* Pres acc)
   NA: ELSE
}
