# Kanren-Fset

Implementation of unification methods to allow Fset collections to
operate with cl-kanren-trs (Common Lisp port of miniKanren). Currently
only supports the "SEQ" type (ordered collection).

## Usage

```common-lisp
(ql:quickload "kanren-fset")
(in-package :kanren-trs)

(run nil (q)
  (fresh (x)
    (== x 10)
    (== q (fset:seq x 20))))

;; -> (#[ 10 20 ])
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

