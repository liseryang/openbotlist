;;; ********************************************************
;;; FILE IDENTIFICATION
;;;
;;; Name:          botlist-trinity.asd
;;; Purpose:       ASDF definition file for botlist trinity project
;;; Author:        Berlin Brown
;;; Date Started:  Feb 2008
;;;
;;; ********************************************************

(defpackage #:botlist-trinity-system (:use #:asdf #:cl))

(in-package :botlist-trinity-system)

(asdf:defsystem :botlist-trinity
				:name "botlist-trinity"
				:author "Berlin Brown"
				:version "0.1"
				:maintainer "Berlin Brown <berlin.brown@gmail.com>"
				:licence "BSD"
				:description "Botlist Trinity Web Front End" 
				:long-description "Botlist Trinity Web Front End" 
				
				:depends-on (:hunchentoot
							 :cl-who
							 :html-template)							 
				:components ((:file "packages")
							 (:file "trinity")))
;;; End of File