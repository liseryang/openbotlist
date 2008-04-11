;;
;; swing_view.lisp
;; Author: Berlin Brown
;; Date: 4/11/2008
;;--------------------------------------
;; Swing Client View (abcl oriented swing frame creation)
;; "The opposite of a correct statement is a false statement." -- Niels Bohr
;;--------------------------------------

(load "jfli-abcl.lisp")

(defpackage :swing-view
  (:use :common-lisp :java :jfli))

(in-package :swing-view)

(defconstant j-string "java.lang.String")

(defconstant j-borderlayout "java.awt.BorderLayout")
(defconstant j-actionevent "java.awt.event.ActionEvent")
(defconstant j-abstractaction "javax.swing.AbstractAction")
(defconstant j-boxlayout "javax.swing.BoxLayout")
(defconstant j-jbutton "javax.swing.JButton")
(defconstant j-jframe "javax.swing.JFrame")
(defconstant j-jmenu "javax.swing.JMenu")
(defconstant j-jmenubar "javax.swing.JMenuBar")
(defconstant j-jmenuitem "javax.swing.JMenuItem")
(defconstant j-jpanel "javax.swing.JPanel")
(defconstant j-jscrollpane "javax.swing.JScrollPane")
(defconstant j-jtextarea "javax.swing.JTextArea")
(defconstant j-jtextfield "javax.swing.JTextField")
(defconstant j-scrollpaneconstants "javax.swing.ScrollPaneConstants")
(defconstant j-uimanager "javax.swing.UIManager")

;; ** ABCL Lisp Helpers
;;----------------------------
;; Example static method call "System.getenv('KEY')
;; (jstatic "getenv" (jclass "java.lang.System") "KEY")
;;
;; jfli:new-class:
;; ---------------------------
;;
;; defmacro new-class (
;;  class-name, super-and-interface-names, 
;;        constructor-defs, method-defs field-defs)
;;
;; Creates, registers and returns a Java object 
;; that implements the supplied interfaces
;; --------------------
;; Arguments: 
;;
;;  * [!] class-name -> string
;;  * [!] super-and-interface-names -> class-name | (class-name interface-name*)
;;  * [!] constructor-defs -> (constructor-def*)
;;  * constructor-def -> (ctr-arg-defs body) 
;;          /the first form in body may be (super arg-name+); this will call the constructor of the superclass
;;           with the listed arguments/
;;  * ctr-arg-def -> (arg-name arg-type)
;;  * method-def -> (method-name return-type access-modifiers arg-defs* body)
;;          /access-modifiers may be nil (to get the modifiers from the superclass), a keyword, or
;;           a list of keywords/
;;  * method-name -> string 
;;  * arg-def -> arg-name | (arg-name arg-type)
;;  * arg-type -> \"package.qualified.ClassName\" | classname. | :primitive
;;  * class-name -> \"package.qualified.ClassName\" | classname. 
;;  * interface-name -> \"package.qualified.InterfaceName\" | interfacename. 
;;
;; Example new-class usage:
;; (new-class "SERVLET1.Servlet1" "javax.servlet.GenericServlet" ()
;;	   (("service" :void :public 
;;		 ((req "javax.servlet.ServletRequest")
;;		  (resp "javax.servlet.ServletResponse"))
;;		 (with-simple-restart (abort "Exit to hyperspace")
;;							  (servlet1-service req resp))))
;;	   ())
;;----------------------------

;; ** Constructors **
;;----------------------------
;; JTextField() / JTextField(String text, int columns)
;; JPanel() 

(defconstant *DEFAULT_PATH* "file://./latin_text.txt")

(defun init-swing ()
  (progn (setNativeLookUI)
		 (initTextAreaLayout)
		 (initMenus) (initActions)))

(defun initTextAreaLayout ()
  (let ((pathField (jnew 
					(jconstructor j-jtextfield j-string :int) DEFAULT_PATH 40))
		(topPanel (jnew 
				   (jconstructor j-jpanel))))
	(jcall (jmethod topPanel "setLayout(new BoxLayout" 
					topPanel BoxLayout.Y_AXIS))
	(jcall (jmethod topPanel "add" pathField))
	(let ((JPanel buttonPanel 
				  (jnew (jconstructor "JPanel")))))
	(jcall (jmethod this "readRequestsButton@NEW_EXPR_JButton" "Run Action"))
	(jcall (jmethod buttonPanel "add" this.readRequestsButton))
	(jcall (jmethod topPanel "add" buttonPanel))
	(let ((contentArea 
		   (jnew (jconstructor j-jtextarea :int :int) 25 60))))
	;;JScrollPane scrollPane@NEW_EXPR_JScrollPane(contentArea 
	;;											ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS,
	;;											ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS)
	(jcall (jmethod getContentPane() "setLayout(new BorderLayout" )))
  (jcall (jmethod getContentPane() "add" topPanel BorderLayout.NORTH))
  (jcall (jmethod getContentPane() "add" scrollPane BorderLayout.CENTER)))

(defun initMenus ()
  (let ((JMenuBar bar (jnew (jconstructor j-jmenubar )))
		(JMenu fileMenu (jnew (jconstructor j-jmenu j-string) "File"))
		(newMenuItem (jnew (jconstructor j-jmenuitem j-string) "New"))
		(openMenuItem (jnew (jconstructor j-jmenuitem j-string) "Open"))
		(exitMenuItem (jnew (jconstructor j-jmenuitem j-string) "Exit")))  
		(jcall (jmethod fileMenu "add" newMenuItem))
		(jcall (jmethod fileMenu "add" openMenuItem))
		(jcall (jmethod fileMenu "add" exitMenuItem))
		(jcall (jmethod bar "add" fileMenu))
		(jcall (jmethod this "setJMenuBar" bar))))

(defun initActions ()
  (jcall (jmethod this.exitMenuItem "addActionListener(new QuitAction" ))
  (let ((LoadFileAction loadFileAction (jnew (jconstructor "LoadFileAction" <ARG TYPES>) ))))
  (jcall (jmethod readRequestsButton "addActionListener" loadFileAction)))

(defun quit-action ()
  (jcall (jmethod "java.lang.Runnable" "run")
		 (jinterface-implementation (jclass "java.lang.Runnable") "run"
									(lambda () (loop (print "Testing"))))))

;;
;; Create the new class - extending the abstraction action class.
(jfli:new-class "Swing.QuitAction" j-abstractaction ()		   
  (("actionPerformed" :void :public
;((evt j-actionevent)))) ())

(defun setNativeLookUI ()
  (jcall (jmethod UIManager 
				  "setLookAndFeel" 
				  "com.sun.java.swing.plaf.windows.WindowsLookAndFeel")))

(defun createReaderFrame ()
  " Create the simple reader frame "
  (let ((simpleFrame 
		 (jnew (jconstructor "SimpleSwing"))))
	(jcall (jmethod simpleFrame "pack" ))
	(jcall (jmethod simpleFrame "setVisible" 
					(make-immediate-object t :boolean)))))

(defun lisp-main ()
  (createReaderFrame))

(lisp-main)

;; End of Script