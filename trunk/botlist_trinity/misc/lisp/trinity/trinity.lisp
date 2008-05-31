;;
;; trinity.lisp
;; 

(in-package :botlist-trinity)

(require :cl-who)
(require :hunchentoot)
(require :html-template)

(defun generate-index-page ()
  "Generate the index page showing all the blog posts."
  (with-output-to-string (stream)
    (html-template:fill-and-print-template 
     #P"index.html" '() :stream stream)))

;;------------------------------------------------
;; Hunchentoot server settings
;;------------------------------------------------

(setq hunchentoot:*catch-errors-p* nil)

;; Set the web server dispatch table
(setq hunchentoot:*dispatch-table*
      (list (hunchentoot:create-regex-dispatcher 
			 "^/$" 'generate-index-page)
            (hunchentoot:create-regex-dispatcher 
			 "^/trinity/$" 'generate-index-page)))
		  
;; Make sure html-template looks for files in the right directory
(setq html-template:*default-template-pathname* 
	  #P"/home/bbrown/workspace_omega/botlist_trinity/misc/lisp/trinity/")

;; Start the web server utilities
(defvar *ht-server* nil)
(defun start-app ()
  "Start the web server"
  (defvar *ht-server* (hunchentoot:start-server :port 9980)))

(defun stop-app ()
  (hunchentoot:stop-server *ht-server*))

;; End of the File