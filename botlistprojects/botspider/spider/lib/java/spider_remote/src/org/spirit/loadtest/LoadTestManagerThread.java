/*-----------------------------------------------
 * Berlin Brown
 * Created on Apr 13, 2007
 * LoadTestManagerThread.java
 *-----------------------------------------------
 */
package org.spirit.loadtest;

/**
 * Thread launched to send out HTTP requests and if enabled, write response and status
 * information to file.
 */
public class LoadTestManagerThread implements Runnable {
    
    private LoadTestManager client;

    public LoadTestManagerThread(LoadTestManager client) {
        this.client = client;
    }
    public LoadTestManager getTestClient() {
        return this.client;
    }
    
    private void loadSingleURL(String url) {
        try {
            long allStart = System.currentTimeMillis();
            for (int i = 0; i < getTestClient().getLinesWrite(); i++) {
                long tStart = System.currentTimeMillis();
                System.out.println("attempting request to=" + url);
                String [] responseTuple = LoadTestManager.connectURL(url, false);
                long tEnd = System.currentTimeMillis();
                long diff = tEnd - tStart;
                System.out.println("single request time="
                    + diff + " ms -- from " + Thread.currentThread().getName());
                LoadTestManager.log(diff, responseTuple, url);
                // Move to next iteration.
                this.getTestClient().incNumberOfRequests();
                this.getTestClient().incTotalTime(diff);
                Thread.sleep(getTestClient().getThreadSleepTime());
            }
                        
            long allEnd = System.currentTimeMillis();
            long perThreadDiff = allEnd - allStart;
            System.out.println("All requests time=" + perThreadDiff + " ms");
            
            // The following code buildRequestSection, clearRequest are needed after writing the HTML content
            this.getTestClient().getHtmlOutput().buildRequestSection(perThreadDiff + " ms, requests=" + getTestClient().getLinesWrite());
            this.getTestClient().getHtmlOutput().clearRequest();            

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    private void loadSequenceFile(final String script) {
        try {
            System.out.println("INFO: loading sequence script=" + script);
            LoadTestSequenceParser parser = new LoadTestSequenceParser();
            String realFilename = script.substring("script://".length());
        	parser.parse(realFilename);
        	parser.printSummary();
        	parser.handleSequence();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }    
    
    public void run() {
        if (this.getTestClient().isUseDataFile()) {
            Object [] data = LoadTestManager.loadDataFile(this.getTestClient().getDataFile());
            for (int i = 0; i < data.length; i++) {
                String url = (String) data[i];        		
                if (url.startsWith("script://")) {
                	loadSequenceFile(url);
                } else {
                	loadSingleURL(url);
                }
                	
            }
        } else {
            loadSingleURL(getTestClient().getTestURL());
        }
    }
}
// End of File