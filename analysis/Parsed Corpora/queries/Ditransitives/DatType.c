node: CP*

define: Ditrans.def

coding_query:

6: {
	DatConj: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms CONJ*)
	DatDefinite: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms possessor)
	DatPronoun: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms PRO*)
	DatDPronoun: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDomsOnly D)
	DatDefinite: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms D) AND (D iDoms definite)
	DatName: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms NPR*|NR*)
	DatWHPronoun: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat  iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
	DatWHEmpty: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
	DatWHIndefinite: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms \*T*) AND (\*T* SameIndex WNP*)
	DatEmpty: (CP* iDoms IP*) AND (IP*  iDoms dat) AND (dat iDoms \**)
	DatIndefinite: (CP* iDoms IP*) AND (IP*  iDoms dat)
	DatConj: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms CONJ*)
	DatDefinite: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms possessor)
	DatPronoun: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms PRO*)
	DatDPronoun: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDomsOnly D)
	DatDefinite: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms D) AND (D iDoms definite)
	DatName: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms NPR*|NR*)
	DatWPPronoun: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms P) AND (P iDoms ditp) AND (P HasSister WNP*) AND (WNP* iDomsOnly WPRO*)
	DatWPEmpty: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms P) AND (P iDoms ditp) AND (P HasSister WNP*) AND (WNP* iDoms \0)
	DatWPIndefinite: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms P) AND (P iDoms ditp) AND (P HasSister WNP*|WQP*)
	DatWHPronoun: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
	DatWHEmpty:(CP* iDoms IP*) AND  (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
	DatWHIndefinite: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*|QP*) AND (NP*|QP* iDoms \*T*) AND (\*T* SameIndex WNP*)
	DatEmpty: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms \**)
	DatIndefinite: (CP* iDoms IP*) AND (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*|QP*)
	DatNull: ELSE
}

