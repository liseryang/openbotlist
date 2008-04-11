/*
 * File Read Writer Utilites for Log file analysis.
 * Berlin Brown
 * Created on Oct 8, 2007
 * 
 * AnalyzeLogsHtml.java
 */
package ui;

import java.io.BufferedReader;
import java.util.List;

import javax.swing.JTextArea;
import javax.swing.SwingUtilities;

public class ExampleReaderWithUI {
		
	public static final int MIN_LINE_LEN = 5;
		
	private JTextArea contentArea = null;
	private boolean hasWorker = false; 
	
	public ExampleReaderWithUI(final JTextArea contentArea, final boolean hasWorker) { 
		this.contentArea = contentArea;
		this.hasWorker = hasWorker;
	}
	
	public JTextArea getContentArea() {
		return contentArea;
	}
	public boolean isHasWorker() {
		return hasWorker;
	}
	
	/**
	 * Usage of the loadFile utility; instantiate the ReaderWriter callback class implementing the
	 * necessary writer setup routines.  <code>read()</code> contains the core functionality that
	 * will read a log file, filter and rewrite to another log output file.
	 *  
	 * @param filename
	 * @param outFilename
	 * @param append
	 */
	public static void runFilterStackTrace(final ExampleReaderWithUI reader_obj, final String filename, final String outFilename, final boolean append) {		
		FileUtil.loadFile(filename,					
				(new BasicFileUtilReaderWriter() {
					public boolean filterAllow(String linePreFilter) {
						boolean filterAllowFlag = false;
						int parseAllowFSM = 0;			
						final int PARSE_ALLOW_VALID = 2;						
						if (linePreFilter != null) {
							String line = linePreFilter.toLowerCase();
							if (line.length() > MIN_LINE_LEN)
								parseAllowFSM++;							
							if (line.startsWith("at"))
								parseAllowFSM++;
							
							// After parsing all filter flags, enable allow flag
							if (parseAllowFSM == PARSE_ALLOW_VALID)
								filterAllowFlag = true;
						} // end of null check							
						return filterAllowFlag;			
					} // End of Filter Allow
					
					public void read(BufferedReader bufInput, List resultList) throws Exception {						
						System.out.println("Reading file=" + filename);
						String feed = "";
						final StringBuffer buf = new StringBuffer();
						while ((feed = bufInput.readLine()) != null) {
							feed = feed.trim();
							buf.append(feed + "\n");
						} // End of the While						
						if (reader_obj.isHasWorker()) {
							reader_obj.getContentArea().setText(buf.toString());
							reader_obj.getContentArea().setCaretPosition(0);
						} else {
							final StringBuffer mainBuf = buf;
							Thread worker = new Thread() {
								public void run() {
									// Reference the parent class
									reader_obj.getContentArea().setText(mainBuf.toString());
									reader_obj.getContentArea().setCaretPosition(0);
								}
							};
							SwingUtilities.invokeLater(worker);
						} // End of the if - else
						
					} // End of the Method														
					// Note, set init parameters through method chaining.
				}).setOutfilename(outFilename).setOutAppend(append),
				new FileUtilExceptionHandler() {
					public void handleException(Exception e) {
						System.out.println("ERROR processing file=" + filename);
						System.out.println("ERROR: " + e.getMessage());
					}
				});
	}
		
	public static void main(String [] args) {
		
		if (args.length != 2) {
			System.out.println("Usage: AnalyzeLogsHtml filename-to-analyze filename-output");
			System.exit(-1);
		}		
		long tstart = System.currentTimeMillis();		
		System.out.println("Analyzing Logs HTML output");	
		//ExampleReaderWithUI.runFilterStackTrace(args[0], args[1], false);	
		long tend = System.currentTimeMillis();
		long diff = tend - tstart;
		System.out.println("Completed in=" + diff + " ms");
	}
}
