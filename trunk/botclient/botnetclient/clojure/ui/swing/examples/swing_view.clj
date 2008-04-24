;;################################################
;; For use with Clojure
;; Author: Berlin Brown <berlin dot brown at gmail.com>
;; Date: 4/24/2008
;;
;; [1] http://jonathanwatmough.com/?cat=10
;;     Good Reference on Swing and Clojure
;;
;; (. instance-expr instanceFieldName-symbol)
;; (. Classname-symbol staticFieldName-symbol)
;; (. instance-expr (instanceMethodName-symbol args*))
;; (. Classname-symbol (staticMethodName-symbol args*))
;;################################################

(in-ns 'swing-view)
(clojure/refer 'clojure)

;;----------------------------
;; ** Java Class String Constant Definitions **
;;----------------------------
(def *default-path* "file://./latin_text.txt")
(def *win-look-feel* "com.sun.java.swing.plaf.windows.WindowsLookAndFeel")

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

;;----------------------------
;; Function implementations
;;----------------------------
(defn exit []
  (. System (exit 0)))

(defn path-textfield []
  (new JTextField *default-path* 40))
   
(defn initTextAreaLayout [content-pane]
  (let [text-field (path-textfield)
				   contentArea (new JTextArea 25 60)
				   topPanel (new JPanel)
				   buttonPanel (new JPanel)
				   scrollPane (new JScrollPane contentArea 
								   (. ScrollPaneConstants VERTICAL_SCROLLBAR_ALWAYS)
								   (. ScrollPaneConstants HORIZONTAL_SCROLLBAR_ALWAYS))]
	(println "INFO: content-pane obj:= " content-pane " |" topPanel)
	(println "INFO: text-field:=" text-field)
	(println "-----------------------------")
	(. topPanel (setLayout 
				 (new BoxLayout topPanel (. BoxLayout Y_AXIS))))
	;; Add TO the top panel; in java this will look like: topPanel.add(pathField)
	(. topPanel (add buttonPanel))
	(. content-pane (setLayout (new BorderLayout)))
	(. content-pane (add topPanel (. BorderLayout NORTH)))
	(. content-pane (add scrollPane(. BorderLayout CENTER)))))

(defn setNativeLookUI []
  ;; Use the operating system native UI look and feel, do not use the Swing oriented look
  (. UIManager (setLookAndFeel *win-look-feel*)))

(defn initMenus [jframe]
  (let [bar (new JMenuBar)
			fileMenu (new JMenu "File")
			newMenuItem (new JMenuItem "New")
			openMenuItem (new JMenuItem "Open")
			exitMenuItem (new JMenuItem "Exit")]
	(. fileMenu (add newMenuItem))
	(. fileMenu (add openMenuItem))
	(. fileMenu (add exitMenuItem))
	(. bar (add fileMenu))
	(. jframe (setJMenuBar bar))))
	;;---------------------
	;; Attach the listeners
	;;---------------------
	;;(. exitMenuItem
	 ;;  (addActionListener
		;;(implement [ActionListener]
		  ;;(actionPerformed [evt]
			;;			   (println "INFO: Exiting")
				;;		   (exit)))))))

(defn init-swing [jframe]
  ;; Define the frame properties. Add the button panel and menu"
  (setNativeLookUI)
  (initTextAreaLayout (. jframe getContentPane))
  (initMenus jframe))

(defn createReaderFrame []
  ;; Create the simple reader frame
  (let [simpleFrame (new JFrame "Swing View Client")]
		  (init-swing simpleFrame)
		  (. simpleFrame (pack))
		  (. simpleFrame (setVisible true))))

(defn lisp-main []
  ;; Main entry point, create the jframe and attach the widget components then
  ;; start the jframe thread"
  (println "INFO: creating panel objects")
  (createReaderFrame))

(lisp-main)
(. Thread (sleep 20000))
(println "INFO: exiting.")

;;################################################
;; End of Script
;;################################################