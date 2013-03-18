#|
  This file is a part of kanren-fset project.
  Copyright (c) 2013 Stephen A. Goss (steveth45@gmail.com)
|#

#|
  Author: Stephen A. Goss (steveth45@gmail.com)
|#

(in-package :cl-user)
(defpackage kanren-fset-asd
  (:use :cl :asdf))
(in-package :kanren-fset-asd)

(defsystem kanren-fset
  :version "0.1"
  :author "Stephen A. Goss"
  :license "Modified BSD"
  :depends-on (:kanren-trs
               :fset)
  :components ((:module "src"
                :components
                ((:file "kanren-fset"))))
  :description ""
  :long-description
  #.(with-open-file (stream (merge-pathnames
                             #p"README.markdown"
                             (or *load-pathname* *compile-file-pathname*))
                            :if-does-not-exist nil
                            :direction :input)
      (when stream
        (let ((seq (make-array (file-length stream)
                               :element-type 'character
                               :fill-pointer t)))
          (setf (fill-pointer seq) (read-sequence seq stream))
          seq)))
  :in-order-to ((test-op (load-op kanren-fset-test))))
