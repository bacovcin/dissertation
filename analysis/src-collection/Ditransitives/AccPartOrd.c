node: CP*

define: Ditrans.def

coding_query:

24: {
   NA: (CP* iDoms IP*) AND (IP* iDoms acc) AND (acc iDoms \**)
   AccV: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms *VBN*|*VAN*) AND (acc Pres *VBN*|*VAN*)
   VAcc: (CP* iDoms IP*) AND (IP* iDoms acc) AND (IP* iDoms *VBN*|*VAN*) AND (*VBN*|*VAN* Pres acc)
   NA: ELSE
}
