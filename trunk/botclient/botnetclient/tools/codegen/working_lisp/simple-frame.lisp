;;
;; Simple Swing Example
(in-package :cl-user)

(defconstant jframe "javax.swing.JFrame")
(defconstant runnable "java.lang.Runnable")
(defconstant thread "java.lang.Thread")
(defconstant j-utils "javax.swing.SwingUtilities")

(defmacro let-if ((var test-form) if-true &optional if-false)
  `(let ((,var ,test-form))
      (if ,var ,if-true ,if-false)))

(defmacro str+ (&rest strings)
  `(concatenate 'string ,@strings))

(defun str->int (str)
  (ignore-errors (parse-integer str)))

(defun unbox (obj)
  (if (java:java-object-p obj)
      (java:jobject-lisp-value obj) obj))

;; Call the method setVisible against the frame instance
(setf set-visible 
	  (jmethod jframe "setVisible" "boolean"))

(defun thread-test ()
  (jcall (jmethod "java.lang.Runnable" "run")
		 (jinterface-implementation (jclass "java.lang.Runnable") "run"
									(lambda () (loop (print "Testing"))))))
  
(defun lisp-main ()
  (setf frame (jnew (jconstructor "javax.swing.JFrame" "java.lang.String")
					"Script Frame"))
  (jcall set-visible frame (make-immediate-object t :boolean)))

(lisp-main)

 ;; End of Script
