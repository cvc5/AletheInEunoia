(set-logic UF)

(declare-sort S 0)
(declare-fun P (S) Bool)

(assert (forall ((x S)) (P x)))
(assert (not (forall ((y S)) (P y))))

(check-sat)
(exit)
