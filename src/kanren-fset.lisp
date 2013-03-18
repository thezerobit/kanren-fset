#|
  This file is a part of kanren-fset project.
  Copyright (c) 2013 Stephen A. Goss (steveth45@gmail.com)
|#

(in-package :cl-user)
(defpackage kanren-fset
  (:use :cl :kanren-trs))
(in-package :kanren-fset)

;; implementation of generic kanren-trs interface to support fset
;; collections
;;
;; interface:
;;   #:equivp
;;   #:unify-impl
;;   #:walk-impl
;;   #:reify-subst-impl

;; fset:seq

(defmethod equivp ((lhs fset:seq) (rhs fset:seq))
  (or (eq lhs rhs)
      (and (eql (fset:size lhs) (fset:size rhs))
           (or (and (fset:empty? lhs) (fset:empty? rhs))
               (and (equivp (fset:first lhs) (fset:first rhs))
                    (equivp (fset:less-first lhs) (fset:less-first rhs)))))))

(defmethod unify-impl ((v fset:seq) (w fset:seq) subst)
  (cond
    ((and (fset:empty? v) (fset:empty? w)) subst)
    ((or (fset:empty? v) (fset:empty? w)) +fail+)
    (T (let ((subst (unify (fset:first v) (fset:first w) subst)))
         (if (not (eq subst +fail+))
           (unify (fset:less-first v) (fset:less-first w) subst)
           +fail+)))))

(defmethod walk-impl ((val fset:seq) subst)
  (if (fset:empty? val)
    val
    (fset:with-first
      (walk* (fset:less-first val) subst)
      (walk* (fset:first val) subst))))

(defmethod reify-subst-impl ((val fset:seq) subst)
  (if (fset:empty? val)
    subst
    (reify-subst (fset:less-first val)
                      (reify-subst (fset:first val) subst))))


