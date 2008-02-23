;;;
;;; trinity.lisp
;;; 

(in-package :botlist-trinity)

(require :cl-who)
(require :hunchentoot)

(defvar *this-file* (load-time-value
                     (or #.*compile-file-pathname* *load-pathname*)))

(defmacro with-html (&body body)
  `(cl-who:with-html-output-to-string (*standard-output* nil :prologue t)
     ,@body))

(defun simple-test ()
  (with-html
   (:html
	(:body
	 (:h2 "Test")))))

(setq *dispatch-table*
      (nconc
	   (mapcar (lambda (args)
                 (apply #'create-prefix-dispatcher args))
               '(("/trinity/test/test.html" simple-test)))
       (list #'default-dispatcher)))

;;; End of the File