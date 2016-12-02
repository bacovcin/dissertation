node: CP*

define: Ditrans.def

coding_query:

4: {
  DP: (CP* iDoms IP*) AND (IP* iDoms dat)
  TO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDomsMod META|LEMMA to)
  UNTO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDomsMod META|LEMMA unto)
  WTO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDomsMod META|LEMMA to)
  WUNTO: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDomsMod META|LEMMA unto)
  NoIO: ELSE
}
