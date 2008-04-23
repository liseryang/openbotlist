;;################################################
;;
;; For use with Clojure
;; Author: Berlin Brown <berlin dot brown at gmail.com>
;; Date: 4/15/2008
;;
;; [1] http://jonathanwatmough.com/?cat=10
;;     Good Reference on Swing and Clojure
;;################################################

(in-ns 'swing-view)
(clojure/refer 'clojure)


;;----------------------------
;; ** Java Class String Constant Definitions **
;;----------------------------
(defconstant *default-path* "file://./latin_text.txt")

(import '(java.awt Component))
(import '(java.awt Container))
(import '(java.awt LayoutManager))
(import '(java.awt BorderLayout))
(import '(java.awt.event ActionEvent))
(import '(javax.swing AbstractAction))
(import '(javax.swing BoxLayout))
(import '(javax.swing JButton))
(import '(javax.swing JFrame))
(import '(javax.swing JMenu))
(import '(javax.swing JMenuBar))
(import '(javax.swing JMenuItem))
(import '(javax.swing JPanel))
(import '(javax.swing JScrollPane))
(import '(javax.swing JTextArea))
(import '(javax.swing JTextField))
(import '(javax.swing ScrollPaneConstants))
(import '(javax.swing UIManager))

(defparameter *scroll-h-always* (jfield-raw j-scrollpaneconstants 
											"HORIZONTAL_SCROLLBAR_ALWAYS"))
(defparameter *scroll-v-always* (jfield-raw j-scrollpaneconstants
											"VERTICAL_SCROLLBAR_ALWAYS"))

(defparameter *bl-north* (jfield j-borderlayout "NORTH")
  "Definition for swing constants")
(defparameter *bl-east* (jfield j-borderlayout "EAST")
  "Definition for swing constants")
(defparameter *bl-center* (jfield j-borderlayout "CENTER")
  "Definition for swing constants")
(defparameter *bl-west* (jfield j-borderlayout "WEST")
  "Definition for swing constants")
(defparameter *bl-south* (jfield j-borderlayout "SOUTH")
  "Definition for swing constants")
(defparameter *box-y-axis* (jfield j-boxlayout "Y_AXIS")
  "Definition for swing constants")
(defparameter *box-x-axis* (jfield j-boxlayout "X_AXIS")
  "Definition for swing constants")

;;----------------------------
;; ** Java method definitions **
;;----------------------------
(defparameter *method-set-layout* 
  (jmethod j-container "setLayout" j-layout-manager))
(defparameter *method-jmenu-add* (jmethod j-jmenu "add" j-jmenuitem))
(defparameter *method-jpanel-add* (jmethod j-jpanel "add" j-component))
(defparameter *method-container-add* (jmethod j-container "add" j-component))
(defparameter *method-container-add-2* (jmethod j-container "add" 
												j-component "java.lang.Object"))

;; Java constructor definitions
(defparameter *new-jmenu-item* (jconstructor j-jmenuitem j-string))
(defparameter *new-scroll-pane* 
  (jconstructor j-jscrollpane j-component "int" "int"))
(defparameter *new-scroll-pane-2*  (jconstructor j-jscrollpane "int" "int"))
(defparameter *new-textarea* (jconstructor j-jtextarea "int" "int"))

;;----------------------------
;; Function implementations
;;----------------------------
(defn j-true () (make-immediate-object t :boolean))
(defn j-false () (make-immediate-object nil :boolean))

(defn to-java-string (s)
  (jnew (jconstructor "java.lang.String" "java.lang.String") s))

(defn init-swing (jframe)
  "Define the frame properties. Add the button panel and menu"
  (progn (setNativeLookUI)
		 (initTextAreaLayout (get-content-pane jframe))))

(defn get-content-pane (jframe)
  "Translated to natural language: Using the instance of
 the JFrame object called jframe, invoke the getContentPane method
 and return an instance of the Container class"
  (jcall (jmethod j-jframe "getContentPane") jframe))

(defn new-borderlayout ()
  "Create an instance of the border layout class"
  (jnew (jconstructor j-borderlayout)))

(defn new-box-layout (panel axis)
  (jnew (jconstructor j-boxlayout j-container "int") panel axis))

(defn path-textfield ()
  (jnew (jconstructor j-jtextfield j-string "int")
		*default-path* 40))
	
(defn initTextAreaLayout (content-pane)
  (let* ((text-field (path-textfield))
		 (contentArea (jnew *new-textarea* 25 60 ))
		 (topPanel (jnew (jconstructor j-jpanel)))
		 (buttonPanel (jnew (jconstructor j-jpanel)))
		 (scrollPane (jnew *new-scroll-pane* contentArea 
						   *scroll-v-always* *scroll-h-always*)))
	(format t "INFO: content-pane obj:= [ ~a | ~a ]~%" content-pane topPanel)
	(jcall *method-set-layout* topPanel
		   (new-box-layout topPanel *box-y-axis*))
	;; Add TO the top panel; in java this will look like: topPanel.add(pathField)
	(jcall *method-jpanel-add* topPanel text-field)
	(jcall *method-set-layout* content-pane (new-borderlayout))
	(jcall *method-container-add-2* content-pane topPanel *bl-north*)
	(jcall *method-container-add-2* content-pane scrollPane *bl-center*)))

(defn setNativeLookUI ()
  ;; Use the operating system native UI look and feel, do not use the Swing oriented look"
  (jstatic "setLookAndFeel"
		   (jclass j-uimanager)
				   "com.sun.java.swing.plaf.windows.WindowsLookAndFeel"))
(defn createReaderFrame []
  ;; Create the simple reader frame "
  (let ((simpleFrame (new JFrame "Swing View")))
	(init-swing simpleFrame)
	(jcall (jmethod j-jframe pack) simpleFrame)
	(jcall (jmethod j-jframe setVisible true))))

(defn lisp-main ()
  "Main entry point, create the jframe and attach the widget components then
 start the jframe thread"
  (println "INFO: creating panel objects")
  (createReaderFrame))

(lisp-main)

;;################################################
;; End of Script
;;################################################