;;;
;;; packages.lisp
;;;

(in-package :cl-user)

(defpackage :botlist-trinity
  (:use :cl :html-template :hunchentoot
		:clsql :clsql-mysql)
  (:export :start-app
		   :stop-app))

;;; End of File