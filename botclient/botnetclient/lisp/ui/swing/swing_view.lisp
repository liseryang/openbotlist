;;
;; ABCL oriented swing_view.lisp
;; Author: Berlin Brown
;; Date: 4/11/2008
;;--------------------------------------
;; Swing Client View (abcl oriented swing frame creation)
;;
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

(defparameter *scroll-h-always* (jfield-raw j-scrollpaneconstants 
											HORIZONTAL_SCROLLBAR_ALWAY))
(defparameter *scroll-v-always* (jfield-raw j-scrollpaneconstants
											VERTICAL_SCROLLBAR_ALWAY))

(defparameter *bl-north* (jfield-raw j-borderlayout "NORTH")
  "Definition for swing constants")
(defparameter *bl-east* (jfield-raw j-borderlayout "EAST")
  "Definition for swing constants")
(defparameter *bl-center* (jfield-raw j-borderlayout "CENTER")
  "Definition for swing constants")
(defparameter *bl-west* (jfield-raw j-borderlayout "WEST")
  "Definition for swing constants")
(defparameter *bl-south* (jfield-raw j-borderlayout "SOUTH")
  "Definition for swing constants")

(defparameter *box-y-axis* (jfield-raw j-boxlayout "Y_AXIS")
  "Definition for swing constants")
(defparameter *box-x-axis* (jfield-raw j-boxlayout "X_AXIS")
  "Definition for swing constants")

;; ** ABCL Lisp Helpers
;;----------------------------
;; Example static method call "System.getenv('KEY')
;; (jstatic "getenv" (jclass "java.lang.System") "KEY")
;;
;; Fields:
;; (jfield-raw "java.lang.Boolean" "TRUE")
;;----------------------------

;; ** Swing Constructors **
;;----------------------------
;; JTextField() / JTextField(String text, int columns)
;; JPanel() 

(defconstant *DEFAULT_PATH* "file://./latin_text.txt")

(defun init-swing (jframe)
  (progn (setNativeLookUI)
		 (initTextAreaLayout)
		 (initMenus) 
		 (initActions)))

(defun initTextAreaLayout (content-pane)
  (let* ((pathField (jnew
					 (jconstructor j-jtextfield j-string "int") DEFAULT_PATH 40))
		 (topPanel (jnew (jconstructor j-jpanel))))
	(jcall (jmethod j-jpanel "setLayout") topPanel *box-y-axis*)
	(jcall (jmethod j-jpanel "add") pathField)
	(let* ((buttonPanel
			(jnew (jconstructor "JPanel"))))
	  (jcall (jmethod j-jpanel "add") topPanel buttonPanel))
	  (let* ((contentArea
			  (jnew (jconstructor j-jtextarea "integer" "integer") 25 60))
			 (scrollPane 
			  (jnew (jconstructor j-jscrollpane "integer" "integer") 
					*scroll-v-always* *scroll-h-always*)))
		(jcall (jmethod "setLayout(new BorderLayout"))
		(jcall (jmethod getContentPane "add" topPanel *bl-north*))
		(jcall (jmethod getContentPane "add" scrollPane *bl-center*)))))

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

(defun setNativeLookUI ()
  (jstatic "setLookAndFeel"
		   (jclass j-uimanager)
				   "com.sun.java.swing.plaf.windows.WindowsLookAndFeel"))
(defun createReaderFrame ()
  " Create the simple reader frame "
  (let ((simpleFrame (jnew (jconstructor j-jframe))))
	(jcall (jmethod j-jframe "pack" ) simpleFrame)
	(jcall (jmethod j-jframe "setVisible" "boolean") simpleFrame
		   (make-immediate-object t :boolean))))

(defun lisp-main ()
  (createReaderFrame))

(lisp-main)

;; End of Script