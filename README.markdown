# Kanren-Fset

Implementation of unification methods to allow Fset collections to
operate with cl-kanren-trs (Common Lisp port of miniKanren). Currently
supports the fset:seq type (ordered collection) and fset:map type
(hash map).

## Usage

```common-lisp
(ql:quickload "kanren-fset")
(in-package :kanren-trs)

(run nil (q)
  (fresh (x)
    (== x 10)
    (== q (fset:seq x 20))))

;; -> (#[ 10 20 ])

(run nil (q)
      (fresh (x)
        (== (fset:map (:a x)) (fset:map (:a 200)))
        (== q (fset:map (:b 100) (:c x)))))

;; -> (#{| (:B 100) (:C 200) |})
```

## Installation

Clone repository into ~/quicklisp/local-projects, load with
(ql:quickload "kanren-fset").

## Author

* Stephen A. Goss (steveth45@gmail.com)

## Copyright

Copyright (c) 2013 Stephen A. Goss (steveth45@gmail.com)

# License

Licensed under the Modified BSD License.

