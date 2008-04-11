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
SimpleSwing extends JFrame
String DEFAULT_PATH = "file://./latin_text.txt"
JButton readRequestsButton
JMenuItem newMenuItem
JMenuItem openMenuItem
JMenuItem exitMenuItem
JTextField pathField
JTextArea contentArea
Thread loadFileActionThread
/**
* Default constructor.
*/
SimpleSwing()
setNativeLookUI()
initTextAreaLayout()
initMenus()
initActions()
initTextAreaLayout()
(let ((pathField (jnew (jconstructor "JTextField" <ARG TYPES>) DEFAULT_PATH, 40))))
(let ((JPanel topPanel (jnew (jconstructor "JPanel" <ARG TYPES>) ))))
(jcall (jmethod topPanel "setLayout(new BoxLayout" topPanel, BoxLayout.Y_AXIS)))
(jcall (jmethod topPanel "add" pathField))
// Set the button panel
(let ((JPanel buttonPanel (jnew (jconstructor "JPanel" <ARG TYPES>) ))))
(jcall (jmethod this "readRequestsButton@NEW_EXPR_JButton" "Run Action"))
(jcall (jmethod buttonPanel "add" this.readRequestsButton))
(jcall (jmethod topPanel "add" buttonPanel))
// Set the content area
(let ((contentArea (jnew (jconstructor "JTextArea" <ARG TYPES>) 25, 60))))
JScrollPane scrollPane@NEW_EXPR_JScrollPane(contentArea,
ScrollPaneConstants.VERTICAL_SCROLLBAR_ALWAYS,
ScrollPaneConstants.HORIZONTAL_SCROLLBAR_ALWAYS)
(jcall (jmethod getContentPane() "setLayout(new BorderLayout" )))
(jcall (jmethod getContentPane() "add" topPanel, BorderLayout.NORTH))
(jcall (jmethod getContentPane() "add" scrollPane, BorderLayout.CENTER))
initMenus()
(let ((JMenuBar bar (jnew (jconstructor "JMenuBar" <ARG TYPES>) ))))
(let ((JMenu fileMenu (jnew (jconstructor "JMenu" <ARG TYPES>) "File"))))
// Create the menu items.
(let ((newMenuItem (jnew (jconstructor "JMenuItem" <ARG TYPES>) "New"))))
(let ((openMenuItem (jnew (jconstructor "JMenuItem" <ARG TYPES>) "Open"))))
(let ((exitMenuItem (jnew (jconstructor "JMenuItem" <ARG TYPES>) "Exit"))))
// Add the menu items to the file menu
(jcall (jmethod fileMenu "add" newMenuItem))
(jcall (jmethod fileMenu "add" openMenuItem))
(jcall (jmethod fileMenu "add" exitMenuItem))
(jcall (jmethod bar "add" fileMenu))
(jcall (jmethod this "setJMenuBar" bar))
initActions()
(jcall (jmethod this.exitMenuItem "addActionListener(new QuitAction" )))
(let ((LoadFileAction loadFileAction (jnew (jconstructor "LoadFileAction" <ARG TYPES>) ))))
(jcall (jmethod readRequestsButton "addActionListener" loadFileAction))
QuitAction extends AbstractAction
actionPerformed(ActionEvent e)
(jcall (jmethod System.out "println" "INFO: exiting application"))
(jcall (jmethod System "exit" 0))
LoadFileAction extends AbstractAction implements Runnable
actionPerformed(ActionEvent e)
(let ((loadFileActionThread (jnew (jconstructor "Thread(" <ARG TYPES>) Runnable) this))))
(jcall (jmethod loadFileActionThread "start" ))
run()
(let ((ExampleReaderWithUI reader (jnew (jconstructor "ExampleReaderWithUI" <ARG TYPES>) SimpleSwing.this.contentArea, (make-immediate-object t :boolean)))))
(jcall (jmethod ExampleReaderWithUI "runFilterStackTrace" reader, "latin_text.txt", "swing.log", false))
loadFileActionThread = null
setNativeLookUI()
(jcall (jmethod UIManager "setLookAndFeel" "com.sun.java.swing.plaf.windows.WindowsLookAndFeel"))
(Exception e)
(jcall (jmethod e "printStackTrace" ))
SimpleSwing createReaderFrame()
(let ((SimpleSwing simpleFrame (jnew (jconstructor "SimpleSwing" <ARG TYPES>) ))))
(jcall (jmethod simpleFrame "pack" ))
(jcall (jmethod simpleFrame "setVisible" (make-immediate-object t :boolean)))
return simpleFrame
main(String [] args)
createReaderFrame()
