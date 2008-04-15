/* 
 * Berlin Brown
 * Created on 07/01/2007 
 */
package org.spirit.loadtest;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

/**
 * Class to pretty print output for this performance test.
 */
public class LoadTestHtmlOutput {

	public static final String HTML_STR_P = "<p>";
	public static final String HTML_END_P = "</p>";
	
	public static final String HTML_STR_DIV = "<div>";
	public static final String HTML_END_DIV = "</div>";
	
	public static final String HTML_STR_TD = "<td>";
	public static final String HTML_END_TD = "</td>";
	
	public static final String HTML_NEWLINE = "\n";
	
	public static final String HTML_STR_PRE = "<div style='width: 300px;'>";
	public static final String HTML_END_PRE = "</div>\n";
	
	private boolean enabled = false;
	private String outputFile = "data/logs/loadtest_local";
	private List dataList = new ArrayList();
	private List sectionList = new ArrayList();
	
	private String templateHeader = "data/template_header.html";
	private String templateFooter = "data/template_footer.html";

	public boolean isEnabled() {
		return enabled;
	}

	public String getOutputFile() {
		return outputFile;
	}

	public LoadTestHtmlOutput setEnabled(boolean b) {
		enabled = b;
		return this;
	}

	public void setOutputFile(String string) {
		outputFile = string;
	}
	
	public void addRequest(final String threadName, final String url, final int requestTime, final String responseCode) {						
		LoadTestRequest request = new LoadTestRequest();		
		request.setRequestThreadName(threadName);
		request.setRequestTime(requestTime);
		request.setResponseCode(responseCode);
		request.setUrl(url);		
		dataList.add(request);
	}
	public void clearRequest() {
		if (this.dataList != null) {
			this.dataList.clear();
		}
	}
	
	public void buildRequestSection(final String sectionRequestTime) {		
		StringBuffer sectBuf = new StringBuffer();
		sectBuf.append(HTML_STR_DIV);
		sectBuf.append("<table class='content'>").append("<tr>");		
		sectBuf.append("<th>").append("Request URL").append("</th>");
		sectBuf.append("<th>").append("thread").append("</th>");
		sectBuf.append("<th>").append("time (ms)").append("</th>");
		sectBuf.append("<th>").append("status").append("</th>");
		sectBuf.append("</tr>");
		for (Iterator it = this.dataList.iterator(); it.hasNext(); ) {
			LoadTestRequest request = (LoadTestRequest) it.next();
			sectBuf.append("<tr>");
			sectBuf.append("<td class='content'>" + request.getUrl() + HTML_END_TD);
			sectBuf.append("<td class='content'>" + request.getRequestThreadName() + HTML_END_TD);
			sectBuf.append("<td class='content'>" + request.getRequestTime() + HTML_END_TD);
			String status_css = "content_good";
			if (request.getResponseCode().equalsIgnoreCase("200"))
				status_css = "content_good";
			else
				status_css = "content_bad";
			
				sectBuf.append("<td class='" + status_css + "'>" + request.getResponseCode() + HTML_END_TD);
			
			sectBuf.append("</tr>" + HTML_NEWLINE);
		}
		sectBuf.append("</table>");
		sectBuf.append(HTML_END_DIV + HTML_NEWLINE);
		
		sectBuf.append(HTML_STR_P);
		sectBuf.append("<b>Section completed: " + sectionRequestTime + "</b>");
		sectBuf.append(HTML_END_P);
		
		sectionList.add(new LoadTestSection().setData(sectBuf.toString()));
	}
	
	public void writeOutput() {
		if (!this.isEnabled()) {
			System.out.println("WARN: load test html output disabled");
		}
		Collections.sort(this.sectionList, new DataSectionComp());
		//String outfilename = this.getOutputFile() + "_" + (new Date()).getTime() + ".html";
		String outfilename = this.getOutputFile() + ".html";
		BufferedWriter out = null;
		System.out.println("* writing HTML test report filename=" + outfilename);
		
		// Load the header and footer.
		StringBuffer templateBufHeader = new StringBuffer();
		StringBuffer templateBufFooter = new StringBuffer();
		Object [] data = LoadTestManager.loadTextFile(this.getTemplateHeader());
		if (data != null)
			for (int ln = 0; ln < data.length; ln++) { templateBufHeader.append(data[ln] + HTML_NEWLINE); }
		if (data != null)
			data = LoadTestManager.loadTextFile(this.getTemplateFooter());
		for (int ln = 0; ln < data.length; ln++) { templateBufFooter.append(data[ln] + HTML_NEWLINE); }
		
		try {
			out = new BufferedWriter(new FileWriter(outfilename, false));
			// Write header
			out.write(templateBufHeader.toString());
			out.flush();
			
			for (Iterator i = sectionList.iterator(); i.hasNext();) {            
				LoadTestSection entry = (LoadTestSection) i.next();
				out.write(entry.getData());
			}
			
			out.write(templateBufFooter.toString());
			out.flush();

		} catch(IOException ioe) {
			ioe.printStackTrace();									
		} finally {			
			try {
				out.flush();
			} catch (IOException e) {				
			}
			try {
				out.close();
			} catch (IOException e) {				
			}	
		}
	}

	public String getTemplateFooter() {
		return templateFooter;
	}

	public void setTemplateFooter(String templateFooter) {
		this.templateFooter = templateFooter;
	}

	public String getTemplateHeader() {
		return templateHeader;
	}

	public void setTemplateHeader(String templateHeader) {
		this.templateHeader = templateHeader;
	}
	
	//=====================================================
	//
	// Load Test Request Bean
	//
	//=====================================================
	private class LoadTestSection implements Serializable {
		private long createdOn;
		private String data;

		public LoadTestSection() {
			Random rnd = new Random();
			createdOn = System.currentTimeMillis() + rnd.nextInt(60);
		}
		public String getData() {
			return data;
		}
		public LoadTestSection setData(String data) {
			this.data = data;
			return this;
		}
		public long getCreatedOn() {
			return createdOn;
		}
	}
	private class LoadTestRequest implements Serializable {
		/**
		 * 
		 */
		private static final long serialVersionUID = 1L;
		private String requestThreadName;
		private int requestTime = -1;
		private String responseCode;
		private String url;
		private long createdOn;
		
		public LoadTestRequest() {
			createdOn = System.currentTimeMillis();
		}

		public String getRequestThreadName() {
			return requestThreadName;
		}

		public int getRequestTime() {
			return requestTime;
		}
	
		public String getUrl() {
			return url;
		}

		public void setRequestThreadName(String string) {
			requestThreadName = string;
		}

		public void setRequestTime(int i) {
			requestTime = i;
		}	

		public void setUrl(String string) {
			url = string;
		}

		public long getCreatedOn() {
			return createdOn;
		}

		public String getResponseCode() {
			return responseCode;
		}

		public void setResponseCode(String responseCode) {
			this.responseCode = responseCode;
		}
		
		public String toString() {
			String logLine = "html add-log-req=" + url + "\trtime=" + requestTime + "\tcode=" + responseCode;		
			return logLine;
		}

	}
		
	private class DataSectionComp implements Comparator {
		public int compare (Object o1, Object o2) {
			long diff = ((LoadTestSection)o1).getCreatedOn() - ((LoadTestSection)o2).getCreatedOn();
		    return (int) diff;
		}
	}
	
	//=====================================================
	//
	// Example Test Driver
	//
	//=====================================================
	private static void main(String [] args)  {
		System.out.println("Running test driver application");
		LoadTestHtmlOutput htmlOutput = new LoadTestHtmlOutput();
		htmlOutput.addRequest("Thread-1", "http://127.0.0.1", 130, "" + 200);
		htmlOutput.addRequest("Thread-1", "http://127.0.0.1", 132, "" + 200);
		htmlOutput.addRequest("Thread-1", "http://127.0.0.1", 133, "" + 200);
				
		htmlOutput.addRequest("Thread-2", "http://127.0.0.1", 133, "" + 200);
		htmlOutput.addRequest("Thread-2", "http://127.0.0.1", 134, "" + 200);
		htmlOutput.addRequest("Thread-2", "http://127.0.0.1", 135, "" + 200);		
		htmlOutput.buildRequestSection(" 100 ms");
		htmlOutput.clearRequest();
		
		htmlOutput.addRequest("Thread-1", "http://127.0.0.1", 139, "" + 200);
		htmlOutput.addRequest("Thread-1", "http://127.0.0.1", 138, "" + 200);		
		htmlOutput.buildRequestSection(" 100 ms");
		htmlOutput.clearRequest();		
		
		// Write html output
		htmlOutput.writeOutput();
				
		System.out.println("Done.");
	}
	
}
// End of File