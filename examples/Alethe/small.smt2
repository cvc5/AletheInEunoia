(set-logic QF_UFLRA)

(declare-const a Real)
(declare-const b Real)

(assert (xor (not (> a 5.0)) (= b 10.0)))
(assert (not (= b 10.0)))
(assert (not (<= a 5.0)))
