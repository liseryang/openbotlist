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


(import '(java.io IOException PrintStream
				  OutputStream))
(import '(java.awt Component Color Font
				   Container LayoutManager BorderLayout))
(import '(java.awt.event ActionEvent 
						 KeyAdapter
						 ActionListener))
(import '(javax.swing
		  AbstractAction BoxLayout JButton JFrame JMenu
		  JMenuBar JMenuItem JPanel
		  JScrollPane JTextArea JTextField 
		  ScrollPaneConstants UIManager))

;;----------------------------
;; ** Java Class String Constant Definitions **
;;----------------------------

(def *cmd-prompt* ">>>")

(def *default-path* "file://./latin_text.txt")
(def *win-look-feel* "com.sun.java.swing.plaf.windows.WindowsLookAndFeel")

(def *command-buffer* (new StringBuffer))
(def contentArea (new JTextArea 25 60))

;;----------------------------
;; Class implementations
;;----------------------------
(defn textarea-stream-class [textarea]
  (proxy [OutputStream] []
		 (write [data]
				(. textarea (append "!!!")))))

(defn init-textarea-stream [textarea]
  (let [out (new PrintStream (textarea-stream-class textarea))]	
	;; Redirect standard output stream to the TextAreaOutputStream
	(. System (setOut out))
	;; Redirect standard error stream to the TextAreaOutputStream
	(. System (setErr out))))

;;----------------------------
;; Function implementations
;;----------------------------
(defn exit []
  (. System (exit 0)))

;;(defn j-println [str]
;;  (let [sys-out (. System out)]
;;	(. sys-out (println str))))

(defn path-textfield []
  (new JTextField *default-path* 40))

(defn textarea-font [textarea]
  (let [font (new Font "Courier New" 
				  (. Font PLAIN) 14)]
	(. textarea (setFont font))))

(defn prompt-key-listener []
  (proxy [KeyAdapter] []
		 (keyTyped [evt]
				   (let [c (. evt getKeyChar)]
					 (. *command-buffer* (append c))
					 (when (= c \newline)
					   (. contentArea 
						  (append (. *command-buffer* (toString)))))
					   (println "sdF"))					 
					 )))

(defn initTextAreaLayout [content-pane]
  (let [text-field (path-textfield)
				   topPanel (new JPanel)
				   buttonPanel (new JPanel)
				   scrollPane (new JScrollPane contentArea 
								   (. ScrollPaneConstants VERTICAL_SCROLLBAR_ALWAYS)
								   (. ScrollPaneConstants HORIZONTAL_SCROLLBAR_ALWAYS))]
	(println "INFO: content-pane obj:= " content-pane " |" topPanel)
	(println "INFO: text-field:=" text-field)
	;; Associate the content area with the output stream
	(textarea-font contentArea)
	(. contentArea (addKeyListener (prompt-key-listener)))
	(. contentArea (append *cmd-prompt*))
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
	(. jframe (setJMenuBar bar))
	;;---------------------
	;; Attach the listeners
	;;---------------------
	(. exitMenuItem
	   (addActionListener
		(proxy [ActionListener] []
			   (actionPerformed [evt]
								(println "INFO: Exiting")
								(exit)))))))

(defn init-swing [jframe]
  ;; Define the frame properties. Add the button panel and menu"
  ;;(setNativeLookUI)
  (initTextAreaLayout (. jframe getContentPane))
  (initMenus jframe))

(defn createReaderFrame []
  ;; Create the simple reader frame
  (let [simpleFrame (new JFrame "Swing View Client")]
	(. simpleFrame 
	   (setDefaultCloseOperation (. JFrame EXIT_ON_CLOSE)))
	(init-swing simpleFrame)
	(. simpleFrame (setLocation 100 100))
	(. simpleFrame (pack))
	(. simpleFrame (setVisible true))))

(defn lisp-main []
  ;; Main entry point, create the jframe and attach the widget components then
  ;; start the jframe thread"
  (println "INFO: creating panel objects")
  (createReaderFrame))

(lisp-main)
;; Lock the thread on this file, to wait until the frame is closed.
(let [o (new Object)] (locking o (. o (wait))))

;;################################################
;; End of Script
;;################################################