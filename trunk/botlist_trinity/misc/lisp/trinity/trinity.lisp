;;
;; trinity.lisp
;; References:
;; [1] http://clsql.b9.com/manual/with-database.html

(in-package :botlist-trinity)

(require :cl-who)
(require :hunchentoot)
(require :html-template)

(require :clsql)
(require :clsql-mysql)

(clsql:locally-enable-sql-reader-syntax)
(setf clsql:*default-caching* nil)

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

;;------------------------------------------------
;; DB Connectivity Tests
;;------------------------------------------------

(defmacro with-db ((database) &body body)
  `(clsql:with-database
	   ;; Supply database connect str
	   ;; For mysql => URL DATABASE USER PASSWORD
	   (,database '("localhost" "botlist_development" "spirituser" "ramza97")
				  :database-type :mysql
				  :pool t 
				  :if-exists :new)
	 ,@body))

(defun test-db ()
  (with-db (db)
	(clsql:status t)
	(clsql:query "select max(id) from entity_links"))
  (format t "After with-db~%")
  (clsql:status t))

(defun main ()
  (format t "Running - ~%")
  (test-db)
  (format t "Done - ~%"))

(main)

;; End of the File