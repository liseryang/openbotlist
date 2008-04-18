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

	public static final String XML_STR_INFO = "<summ_info>";
	public static final String XML_END_INFO = "</summ_info>";
	
	public static final String XML_STR_SECT = "<request_report>";
	public static final String XML_END_SECT = "</request_report>";
		
	public static final String HTML_NEWLINE = "\n";
			
	
	private boolean enabled = false;
	private int reportPass = 0;
	private int reportFail = 0;
	private String outputFile = "data/logs/loadtest_local";
	
	private final List dataList = new ArrayList();
	private final List sectionList = new ArrayList();
	
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
	
	public void addRequest(final String threadName, final String url, final int requestTime, final String responseCode, final String additional_msg) {						
		LoadTestRequest request = new LoadTestRequest();		
		request.setRequestThreadName(threadName);
		request.setRequestTime(requestTime);
		request.setResponseCode(responseCode);
		request.setAdditionalMsg(additional_msg);
		request.setUrl(url);
		
		// For later reporting set the report pass/fail statistics
		if ("200".equals(responseCode)) {
			this.inc_pass();
		} else if ("500".equals(responseCode)) {
			this.inc_fail();
		}
		
		dataList.add(request);
	}
	public void addRequest(final String threadName, final String url, final int requestTime, final String responseCode) {						
		this.addRequest(threadName, url, requestTime, responseCode, null); 				
	}
	public void clearRequest() {
		if (this.dataList != null) {
			this.dataList.clear();
		}
	}
	
	private void resetReportPassFail() {
		this.reportPass = 0;
		this.reportFail = 0;
	}
	public void inc_pass() {
		this.reportPass++;
	}
	public void inc_fail() {
		this.reportFail++;
	}
	/**
	 * Transform the collection of request objects and convert into the XML document.
	 * @param sectionRequestTime
	 */
	public void buildRequestSection(final String sectionRequestTime) {		
		StringBuffer sectBuf = new StringBuffer();	
		sectBuf.append(XML_STR_SECT);		
		for (Iterator it = this.dataList.iterator(); it.hasNext(); ) {
			LoadTestRequest request = (LoadTestRequest) it.next();
			sectBuf.append("<request_info>");
			String enc_url = "";
			/*
			try {
				enc_url = URLEncoder.encode(request.getUrl(), "UTF-8");
			} catch (UnsupportedEncodingException e) {
				System.out.println("WARN: unable to encode URL: " + e.getMessage());
			}*/
			enc_url =  TidyUtilHtmlEncode.encode(request.getUrl());
			sectBuf.append("<url class='content'>" + enc_url + "</url>");
			sectBuf.append("<request_name class='content'>" + request.getRequestThreadName() + "</request_name>");
			sectBuf.append("<request_time class='content'>" + request.getRequestTime() + "</request_time>");
			String status_css = "content_good";
			if (request.getResponseCode().equalsIgnoreCase("200")) {
				status_css = "content_good";				
			} else {
				status_css = "content_bad";				
			} // End of if - else
			
			if ((request.getAdditionalMsg() != null) && (request.getAdditionalMsg().length() != 0)) {
				sectBuf.append("<request_msg><![CDATA[" + TidyUtilHtmlEncode.encode(request.getAdditionalMsg()) + "]]></request_msg>");
			}
			sectBuf.append("<resp_code class='" + status_css + "'>" + request.getResponseCode() + "</resp_code>");			
			sectBuf.append("</request_info>\n");
		}				
		sectBuf.append(XML_STR_INFO);
		sectBuf.append("Section completed: " + sectionRequestTime);
		sectBuf.append(XML_END_INFO);
		sectBuf.append(XML_END_SECT);
		sectionList.add(new LoadTestSection().setData(sectBuf.toString()));
	}
	
	public String printPassFailSummary(final boolean verbose) {
		final StringBuffer buf = new StringBuffer();
		buf.append("INFO: [Test Statistics] tests passed: " + this.reportPass + " failed: " + this.reportFail);
		if (verbose) {			
			System.out.println(buf.toString());
		}
		return buf.toString();
	}
	public void writeOutput() {
		if (!this.isEnabled()) {
			System.out.println("WARN: load test html output disabled");
		}
		Collections.sort(this.sectionList, new DataSectionComp());
		//String outfilename = this.getOutputFile() + "_" + (new Date()).getTime() + ".html";
		String outfilename = this.getOutputFile() + ".xml";
		BufferedWriter out = null;
		System.out.println("INFO: writing HTML test report filename=" + outfilename);		
		// Load the header and footer.
		StringBuffer templateBufHeader = new StringBuffer();
		StringBuffer templateBufFooter = new StringBuffer();
		Object [] data = LoadTestManager.loadTextFile(this.getTemplateHeader());
		if (data != null) {
			for (int ln = 0; ln < data.length; ln++) { templateBufHeader.append(data[ln] + HTML_NEWLINE); }
		}
		if (data != null) {
			data = LoadTestManager.loadTextFile(this.getTemplateFooter());
		}
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
			final String passFailXML = "<report_pass_summ>" +  printPassFailSummary(false) + "</report_pass_summ>";
			out.write(passFailXML);
			out.write(templateBufFooter.toString());
			out.flush();
		} catch(IOException ioe) {
			ioe.printStackTrace();									
		} finally {
			printPassFailSummary(true);
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
		private String additionalMsg = null;
		
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

		public String getAdditionalMsg() {
			return additionalMsg;
		}

		public void setAdditionalMsg(String additionalMsg) {
			this.additionalMsg = additionalMsg;
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