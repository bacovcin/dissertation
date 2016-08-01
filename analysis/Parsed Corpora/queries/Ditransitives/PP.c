node: CP*

define: Ditrans.def

coding_query:

4: {
  DP: (CP* iDoms IP*) AND (IP* iDoms dat)
  TO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms towe|too|toe|to|To|$to|TO|te|ta|tu|zuo)
  UNTO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ynto|vnto|Vnto|$vnto|vntoo|vn-to|unto|Unto)
  WTO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms towe|too|toe|to|To|$to|TO|te|ta|tu|zuo)
  WUNTO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms  ynto|vnto|Vnto|$vnto|vntoo|vn-to|unto|Unto)
  NoIO: ELSE
}
