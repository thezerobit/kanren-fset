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

;; fset:map

(defmethod equivp ((lhs fset:map) (rhs fset:map))
  (or (eq lhs rhs)
      (and (eql (fset:size lhs) (fset:size rhs))
           (or (and (fset:empty? lhs) (fset:empty? rhs))
               (fset:do-map (key lhs-val lhs T)
                 (multiple-value-bind (rhs-val exists) (fset:lookup rhs key)
                   (when (not (and exists
                                   (equivp lhs-val rhs-val)))
                     (return-from equivp nil))))))))

(defmethod unify-impl ((v fset:map) (w fset:map) subst)
  (cond
    ((and (fset:empty? v) (fset:empty? w)) subst)
    ((or (fset:empty? v) (fset:empty? w)) +fail+)
    (T (fset:do-map (key val-v v subst)
         (multiple-value-bind (val-w exists) (fset:lookup w key)
           (when (not exists) (return-from unify-impl +fail+))
           (setf subst (unify val-v val-w subst))
           (when (eq subst +fail+)
             (return-from unify-impl +fail+)))))))

(defmethod walk-impl ((val fset:map) subst)
  (if (fset:empty? val)
    val
    (multiple-value-bind (k v exists) (fset:arb val)
      (declare (ignorable exists))
      (fset:with
        (walk* (fset:less val k) subst)
        k
        (walk* v subst)))))

(defmethod reify-subst-impl ((val fset:map) subst)
  (if (fset:empty? val)
    subst
    (multiple-value-bind (k v exists) (fset:arb val)
      (declare (ignorable exists))
      (reify-subst (fset:less val k)
                   (reify-subst v subst)))))

;;; (WIP) fset:set
;;; *** here be dragons ***

;;; probably a fail, doesn't defer to equivp for element comparison
;(defmethod equivp ((lhs fset:set) (rhs fset:set))
  ;(fset:equal? lhs rhs))

;;; definitely a fail, doing the wrong thing, need to figure out
;;; the unification mechanism better to understand what really needs
;;; to go here.
;(defun unify-set-aux (elem-v elem-w v w subst)
  ;(let ((new-subst (unify elem-v elem-w subst)))
    ;(if (eq new-subst +fail+)
      ;(unify-impl v w subst)
      ;(unify-impl v w new-subst))))

;(defun unify-set (v w subst)
  ;(fset:do-set (elem-v v)
    ;(fset:do-set (elem-w w)
      ;(setf subst (unify-set-aux elem-v elem-w
                                 ;(fset:less v elem-v)
                                 ;(fset:less w elem-w)
                                 ;subst))))
  ;subst)

;(defmethod unify-impl ((v fset:set) (w fset:set) subst)
  ;(cond
    ;((and (fset:empty? v) (fset:empty? w)) subst)
    ;((or (fset:empty? v) (fset:empty? w)) +fail+)
    ;(T (unify-set v w subst))))

;(defmethod walk-impl ((val fset:set) subst)
  ;(if (fset:empty? val)
    ;val
    ;(let ((arb-elem (fset:arb val)))
      ;(fset:with
        ;(walk* (fset:less val arb-elem) subst)
        ;(walk* arb-elem subst)))))

;(defmethod reify-subst-impl ((val fset:set) subst)
  ;(if (fset:empty? val)
    ;subst
    ;(let ((arb-elem (fset:arb val)))
      ;(reify-subst (fset:less val arb-elem)
                   ;(reify-subst arb-elem subst)))))
