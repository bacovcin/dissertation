node: CP*

define: Ditrans.def

coding_query:

4: {
  DP: (IP* iDoms dat)
  TO: (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms towe|too|toe|to|To|$to|TO|te|ta|tu|zuo)
  UNTO: (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ynto|vnto|Vnto|$vnto|vntoo|vn-to|unto|Unto)
  WTO: (IP* iDoms PP) AND (PP iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms towe|too|toe|to|To|$to|TO|te|ta|tu|zuo)
  WUNTO: (IP* iDoms PP) AND (PP iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms  ynto|vnto|Vnto|$vnto|vntoo|vn-to|unto|Unto)
  NoIO: ELSE
}
