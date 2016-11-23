node: CP*

coding_query:

// date of author's birth - century

3: {
   MAT: (CP* IsRoot) AND (CP* iDoms IP-MAT*)
   SUB: (CP* IsRoot) AND (CP* iDoms IP-SUB*)
   IMP: (CP* IsRoot) AND (CP* iDoms IP-IMP*)
   INF: (CP* IsRoot) AND (CP* iDoms IP-INF*)
   PPL: (CP* IsRoot) AND (CP* iDoms IP-PPL*)
   _: ELSE
}
