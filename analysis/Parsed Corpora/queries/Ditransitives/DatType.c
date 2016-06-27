node: CP*

define: Ditrans.def

coding_query:

6: {
	DatConj: (IP*  iDoms dat) AND (dat iDoms CONJ*)
	DatDefinite: (IP*  iDoms dat) AND (dat iDoms possessor)
	DatPronoun: (IP*  iDoms dat) AND (dat iDoms PRO*)
	DatDPronoun: (IP*  iDoms dat) AND (dat iDomsOnly D)
	DatDefinite: (IP*  iDoms dat) AND (dat iDoms D) AND (D iDoms definite)
	DatName: (IP*  iDoms dat) AND (dat iDoms NPR*|NR*)
	DatWHPronoun: (IP*  iDoms dat) AND (dat  iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
	DatWHEmpty: (IP*  iDoms dat) AND (dat iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
	DatWHIndefinite: (IP*  iDoms dat) AND (dat iDoms \*T*) AND (\*T* SameIndex WNP*)
	DatEmpty: (IP*  iDoms dat) AND (dat iDoms \**)
	DatIndefinite: (IP*  iDoms dat)
	DatConj: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms CONJ*)
	DatDefinite: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms possessor)
	DatPronoun: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms PRO*)
	DatDPronoun: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDomsOnly D)
	DatDefinite: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms D) AND (D iDoms definite)
	DatName: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms NPR*|NR*)
	DatWPPronoun: (IP*  iDoms PP*) AND (PP* iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms P) AND (P iDoms ditp) AND (P HasSister WNP*) AND (WNP* iDomsOnly WPRO*)
	DatWPEmpty: (IP*  iDoms PP*) AND (PP* iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms P) AND (P iDoms ditp) AND (P HasSister WNP*) AND (WNP* iDoms \0)
	DatWPIndefinite: (IP*  iDoms PP*) AND (PP* iDoms \*T*) AND (\*T* SameIndex WPP*) AND (WPP* iDoms P) AND (P iDoms ditp) AND (P HasSister WNP*|WQP*)
	DatWHPronoun: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDomsOnly WPRO*)
	DatWHEmpty: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms \*T*) AND (\*T* SameIndex WNP*) AND (WNP* iDoms \0)
	DatWHIndefinite: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*|QP*) AND (NP*|QP* iDoms \*T*) AND (\*T* SameIndex WNP*)
	DatEmpty: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*) AND (NP* iDoms \**)
	DatIndefinite: (IP*  iDoms PP*) AND (PP* iDomsMod PP|CONJ* P) AND (P iDoms ditp) AND (P HasSister NP*|QP*)
	DatNull: ELSE
}

