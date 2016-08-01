node: CP*

coding_query:

100: {
   DA: (CP* iDoms IP*) AND (IP* iDoms NP-DAT*|NP-DTV*|NP-OB2*) AND (IP* iDoms NP-ACC*|NP-OB1*) AND (NP-DAT*|NP-DTV*|NP-OB2* Pres NP-ACC*|NP-OB1*)
   AD: (CP* iDoms IP*) AND (IP* iDoms NP-DAT*|NP-DTV*|NP-OB2*) AND (IP* iDoms NP-ACC*|NP-OB1*) AND (NP-ACC*|NP-OB1* Pres NP-DAT*|NP-DTV*|NP-OB2*)
   DA: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ynto|vnto|Vnto|$vnto|vntoo|vn-to|unto|Unto|towe|too|toe|til|Til|till|Till|tille|to|To|$to|TO|te|ta|tu|tho|ffor|Ffor|ffore|foore|Foore|for|For|$for|FOR|fore|$fore|Fore|forr|Forr|zuo) AND (IP* iDoms NP-ACC*|NP-OB1*) AND (PP Pres NP-ACC*|NP-OB1*)
   AD: (CP* iDoms IP*) AND (IP* iDoms PP) AND (PP iDomsMod PP|CONJP P) AND (P iDoms ynto|vnto|Vnto|$vnto|vntoo|vn-to|unto|Unto|towe|too|toe|til|Til|till|Till|tille|to|To|$to|TO|te|ta|tu|tho|ffor|Ffor|ffore|foore|Foore|for|For|$for|FOR|fore|$fore|Fore|forr|Forr|zuo) AND (IP* iDoms NP-ACC*|NP-OB1*) AND (NP-ACC*|NP-OB1* Pres PP)
   MONO: ELSE
}
