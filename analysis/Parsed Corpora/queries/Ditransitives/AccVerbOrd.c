node: CP*

define: Ditrans.def

coding_query:

10: {
   NA: (CP* iDoms IP*) AND (IP* iDoms acc) AND (acc iDoms \**)
   AccV: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms finite_verb) AND (acc Pres finite_verb)
   VAcc: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms finite_verb) AND (finite_verb Pres acc)
   AccV: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms V*) AND (acc Pres V*)
   VAcc: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms V*) AND (V* Pres acc)
   NA: ELSE
}
