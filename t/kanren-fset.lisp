#|
  This file is a part of kanren-fset project.
  Copyright (c) 2013 Stephen A. Goss (steveth45@gmail.com)
|#

(in-package :cl-user)
(defpackage kanren-fset-test
  (:use :cl
        :kanren-fset
        :kanren-trs
        :cl-test-more))
(in-package :kanren-fset-test)

(plan nil)

;; fset:seq tests, mostly stolen from cl-kanren-trs tests

(is (run nil (q)
      (== q (fset:seq)))
    (list (fset:seq))
    :test #'fset:equal?)

;; 1.20
(is (run nil (q)
      (let ((x 't))
        (== (fset:seq) x)))
    '())

;; 1.21
(is (run nil (q)
      (let ((x (fset:seq)))
        (== (fset:seq) x)))
    '(:|_.0|))

;; 1.22
(is (run nil (q)
      (let ((x (fset:seq)))
        (== 't x)))
    '())

;; 1.30
(is (run nil (r)
      (fresh (x y)
        (== (fset:seq x y) r)))
    (list (fset:seq :_.0 :_.1))
    :test #'fset:equal?)

;; 1.32
(is (run nil (r)
      (fresh (x)
        (let ((y x))
          (fresh (x)
            (== (fset:seq y x y) r)))))
    (list (fset:seq :_.0 :_.1 :_.0))
    :test #'fset:equal?)

;; 1.53
(is (run nil (r)
      (fresh (x y)
        (== 'split x)
        (== 'pea y)
        (== (fset:seq x y) r)))
    (list (fset:seq 'split 'pea))
    :test #'fset:equal?)

;; 1.55
(is (run nil (r)
      (fresh (x y)
        (conde ((== 'split x) (== 'pea y))
               ((== 'navy x) (== 'bean y))
               (else +fail+))
        (== (fset:seq x y 'soup) r)))
    (list (fset:seq 'split 'pea 'soup) (fset:seq 'navy 'bean 'soup))
    :test #'fset:equal?)

;; fset:map tests

(is (run nil (q)
      (fresh (x)
        (== (fset:map (:a x)) (fset:map (:a 200)))
        (== q (fset:map (:b 100) (:c x)))))
    (list (fset:map (:b 100) (:c 200)))
    :test #'fset:equal?)

(is (run nil (q)
      (fresh (x)
        (== (fset:map (:a x)) (fset:map (:a 200)))
        (== (fset:map (:b 110) (:c q)) (fset:map (:b 100) (:c x)))))
    (list)
    :test #'fset:equal?)

(finalize)
