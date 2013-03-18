#|
  This file is a part of kanren-fset project.
  Copyright (c) 2013 Stephen A. Goss (steveth45@gmail.com)
|#

(in-package :cl-user)
(defpackage kanren-fset-test-asd
  (:use :cl :asdf))
(in-package :kanren-fset-test-asd)

(defsystem kanren-fset-test
  :author "Stephen A. Goss"
  :license "Modified BSD"
  :depends-on (:kanren-fset
               :cl-test-more)
  :components ((:module "t"
                :components
                ((:file "kanren-fset"))))
  :perform (load-op :after (op c) (asdf:clear-system c)))
