node: CP*
coding_query:

1: {
WISH: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA wish) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA for)
SPEAK: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA speak) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA of|about)
SEEK: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA seek) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA after|for)
SEND: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA send) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA after|for)
SAY: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA say) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA of)
PUT: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA put) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA upon)
PROVIDE: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA provide) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA for)
PRAY: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA pray) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA for)
MEET: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA meet) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA with)
LOOK: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA look) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA at|for|upon)
LAUGH: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA laugh) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA at)
HIT: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA hit) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA upon)
HEAR: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA hear) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA of)
ENTER: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA enter) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA into|upon)
DISPOSE: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA dispose) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA of)
CALL: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA call) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA for|on|upon)
ACCOUNT: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA account) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA for)
AGREE: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA agree) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA on|upon)
APPROVE: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA approve) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA of)
ARRIVE: (CP* iDoms IP-MAT*|IP-SUB*) AND (IP-MAT*|IP-SUB* iDoms V*) AND (V* iDomsMod META|LEMMA arrive) AND (IP-MAT*|IP-SUB* iDomsMod PP P) AND (P iDomsMod META|LEMMA at)
NONPSEUDO: ELSE
}
