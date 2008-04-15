/* 
 * LoadTestXMLValidate.java
 * Apr 15, 2008
 */
package org.spirit.loadtest;

import java.io.StringReader;

import org.apache.xerces.parsers.DOMParser;
import org.xml.sax.InputSource;

/**
 * Simple validator to validate XHTML documents.
 * @author bbrown
 */
public class LoadTestXMLValidate {
	
	/**	
	 * @param   url
	 * @param   http_data
	 * @return  Tuple:(err_flag:Boolean, String Data) 
	 */
	public static Object [] validateXML(final String url, final String http_data) {		
		try {
			if ((http_data == null) || (http_data.length() == 0)) {
				throw new RuntimeException("Invalid HTTP data argument");
			}
			
			final DOMParser parser = new DOMParser();
			parser.setFeature("http://xml.org/sax/features/validation", true);
			parser.setProperty("http://apache.org/xml/properties/schema/external-noNamespaceSchemaLocation",
							"memory.xsd");
			LoadTestXMLDefaultHandler errors = new LoadTestXMLDefaultHandler();
			parser.setErrorHandler(errors);
			parser.parse(new InputSource(new StringReader(http_data)));
			Object tuple [] =  { new Boolean(true), "" };
			return tuple;
		} catch (Exception e) {
			final StringBuffer err_msg = new StringBuffer();
			err_msg.append("ERR: validateXML() - Error validating HTTP content.");
			err_msg.append("ERR: url=" + url + " error=" + e.getMessage());
			Object tuple [] =  { new Boolean(false), err_msg.toString() };
			return tuple;
		}
	}
	
	private static void main(String [] args) { 
		// Driver Test
		final String data_header = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>";
		final StringBuffer xml_buf_good = new StringBuffer();
		final StringBuffer xml_xhtml = new StringBuffer();
		
		xml_buf_good.append(data_header);
		xml_buf_good.append("<root><data value=\"3\" /></root>");
		LoadTestXMLValidate.validateXML("http://www.google.com", xml_buf_good.toString());
		
		xml_xhtml.append(data_header);
		xml_xhtml.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"><html xmlns=\"http://www.w3.org/1999/xhtml\">");
		xml_xhtml.append("<head><title>The Title</title></head><body><p>Data</p></body></html>");
		Object res = LoadTestXMLValidate.validateXML("http://www.google.com", xml_xhtml.toString());
		System.out.println("Result XHTML parse ->" + res);
	}
	
} // End of Class
