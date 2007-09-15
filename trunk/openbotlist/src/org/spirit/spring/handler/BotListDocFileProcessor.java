/**
 * Berlin Brown
 * Copyright (c) 2006 - 2007, Newspiritcompany.com
 *
 * Jan 13, 2007
 */
package org.spirit.spring.handler;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

import org.spirit.bean.impl.BotListDocFile;
import org.spirit.util.BotListUniqueId;
import org.spirit.util.markdown.doc.BotListDocWriteUtil;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class BotListDocFileProcessor {
	
	private BotListAdminHandler handler;
	private String filedir;
	
	public BotListDocFileProcessor(BotListAdminHandler handler) {
		this.handler = handler;
		String filedirtmp = handler.getController().getFileUploadUtil().getUploadDir();
		
		String uid = BotListUniqueId.getUniqueId();
		this.filedir = filedirtmp + "/tmp/docs" + uid; 
	}
	
	/**
	 * Write File.
	 * @throws IOException 
	 */
	public void writeFile(File file, String data) throws IOException {
		
		BufferedWriter bufWriter = null;
		bufWriter = new BufferedWriter(new FileWriter(file));
		bufWriter.write(data);
		bufWriter.newLine();
		bufWriter.flush();
		bufWriter.close();
	}
	
	/**
	 * Convert the raw message into a markdown formatted message and save
	 * the HTML/(or other) document file.
	 * @throws IOException 
	 */
	public void createDocumentFile(BotListDocFile docfile) throws IOException {
		String filename = docfile.getFilename();
		String fullpath = this.filedir + "/" + filename + ".html";
		String rawmsg = docfile.getMessage();
		BotListDocWriteUtil markdown = new BotListDocWriteUtil();
		String message = markdown.convert(rawmsg);
		File file = new File(fullpath);
		writeFile(file, message);
	}
	
	/**
	 * Generate the document.	 
	 */
	public void generate() {
		
		// First create the PARENT directory if it doesnt exist
		File fdir = new File(this.filedir);
		fdir.mkdirs();
		
		List files = this.handler.getController().getDocFileDao().listFiles();
		for (Iterator it = files.iterator(); it.hasNext();) {
			BotListDocFile file = (BotListDocFile) it.next();
			
			try {
				createDocumentFile(file);
				// Delay after creating file
				Thread.sleep(40);
			} catch (IOException e) {			
				e.printStackTrace();
			} catch (InterruptedException e) {				
				e.printStackTrace();
			}
		}
		
	}
}
