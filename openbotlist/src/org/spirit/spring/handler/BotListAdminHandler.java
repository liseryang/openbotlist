/**
 * Berlin Brown
 * Copyright (c) 2006 - 2007, Newspiritcompany.com
 *
 * Jan 12, 2007
 */
package org.spirit.spring.handler;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.spirit.bean.impl.BotListCalculatorVerification;
import org.spirit.bean.impl.BotListDocFile;
import org.spirit.bean.impl.BotListDocFileMetadata;
import org.spirit.dao.BotListDocFileDAO;
import org.spirit.form.BotListDocFileForm;
import org.spirit.spring.BotListAdminController;
import org.spirit.spring.validate.BotListDocFileValidator;
import org.spirit.util.BotListSessionManager;
import org.spirit.util.BotListUniqueId;
import org.spirit.util.text.KeywordProcessor;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class BotListAdminHandler {
	
	private BotListAdminController controller;
	private BotListDocFileProcessor processor;
	
	public BotListAdminHandler(BotListAdminController controller) {
		this.controller = controller;
		this.processor = new BotListDocFileProcessor(this);
	}
	
	private BotListCalculatorVerification generateCalcVerification() {
		
		Random rand = new Random(System.currentTimeMillis() + 1);
		BotListCalculatorVerification calc = new BotListCalculatorVerification();
		calc.setFirstInput(new Long(rand.nextInt(30)));
		calc.setSecondInput(new Long(rand.nextInt(10)));
		calc.setSolution(new Long(calc.getFirstInput().longValue() + calc.getSecondInput().longValue()));		
		return calc;
		
	}
	
	/**
	 * Get File History.
	 * 
	 * @param request
	 * @return
	 */
	public List getFileHistory() {
		BotListDocFileDAO dao = this.controller.getDocFileDao();
		return dao.listFilesHistory();
	}
	
	public Object getModel(HttpServletRequest request) {
		
		BotListDocFileForm command = new BotListDocFileForm();		
		BotListCalculatorVerification calc = generateCalcVerification();
		command.setFirstInput(calc.getFirstInput());
		command.setSecondInput(calc.getSecondInput());
		command.setSolution(calc.getSolution());
		
		// Set the file history list
		command.setFiles(getFileHistory());
		
		HttpSession session = request.getSession(false);
		if (session == null) {
			session = request.getSession();
		}
		
		BotListCalculatorVerification prev_calc = (BotListCalculatorVerification) session.getAttribute(BotListSessionManager.CALC_VERIFY_OBJECT);
	    if (prev_calc != null) {
	      command.setPrevSolution(prev_calc.getSolution());
	    }
	    
	    session.setAttribute(BotListSessionManager.CALC_VERIFY_OBJECT, calc);
	    
	    // Set the validator:	    
	    controller.setValidator(new BotListDocFileValidator());
	    
	    return command;
	}
	
	public Object onSubmit(HttpServletRequest request, HttpServletResponse response, Object form, BindException errors) {
		BotListDocFileForm docFile = (BotListDocFileForm) form;
		
		// First process the given request and if
		// in generate mode, create the document
		if (request.getParameter("generate") != null) {
			this.processor.generate();
			docFile.setViewName("botlistadmin/secure/extreme/docwrite/confirm");
			return form;
		}
		
		// Upload document file
		BotListDocFileMetadata metadata = null;
		String content = null;
		
		if (errors.getErrorCount() > 0) {					
			return form;
		}
		
		try {
			metadata = uploadDocFile(request, form);
			if (docFile.getUploadFilenameFirst() != null) { 
				content = new String(docFile.getUploadFilenameFirst().getBytes());
			}
		} catch (IllegalStateException e) {			
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}		
		
		BotListDocFile newDocFileBean = transformData(docFile, metadata, content);
		BotListDocFileDAO dao = this.controller.getDocFileDao();
		dao.createDocFile(newDocFileBean);
		
		docFile.setViewName("botlistadmin/secure/extreme/docwrite/confirm");
		return form;
		
	}
	
	public BotListDocFileMetadata uploadDocFile(HttpServletRequest request, 
			Object form) throws IllegalStateException, IOException {
		
		BotListDocFileMetadata metadata = null;
		BotListDocFileForm docFile = (BotListDocFileForm) form;		
		if (docFile.getUploadFilenameFirst() != null) {
			MultipartFile file = docFile.getUploadFilenameFirst();
			String filename = file.getOriginalFilename();
			if (filename.toLowerCase().endsWith(".txt")) {
				metadata = this.uploadCurFile(request, form, file);
			} else {
				System.out.println("ERR: invalid upload");
			}
		}
		
		return metadata;
	}
	
	public BotListDocFileMetadata uploadCurFile(HttpServletRequest request, 
					Object form, MultipartFile entity) 
				throws IllegalStateException, IOException {
		
		String uploadDir = this.controller.getFileUploadUtil().getUploadDir();
		String filename = entity.getOriginalFilename();
		String uid = BotListUniqueId.getUniqueId();
		
		String newFilename = "doc" + uid + ".txt";

	    File fileUpload = new File(uploadDir + "/" + newFilename);
	    entity.transferTo(fileUpload);
	    
	    // Create the file metadata bean
	    BotListDocFileMetadata metadata = new BotListDocFileMetadata();
	    
	    metadata.setDocFilesize(new Long(entity.getSize()));
	    metadata.setDocFilename(newFilename);
	    metadata.setDocOriginalname(filename);
	    
	    return metadata;

	}
		
	public BotListDocFile transformData(BotListDocFileForm form, 
				BotListDocFileMetadata metadata, String content) {
		
		BotListDocFile file = new BotListDocFile();
		file.setFullName("admin");
		file.setTitle(form.getTitle());
		
		String filenameTitle = KeywordProcessor.createFilenameTitle(form.getTitle());
		file.setFilename(filenameTitle);
		
		file.setMessage(content);
		return file;
	}

	/**
	 * @return the controller
	 */
	public BotListAdminController getController() {
		return controller;
	}

	/**
	 * @param controller the controller to set
	 */
	public void setController(BotListAdminController controller) {
		this.controller = controller;
	}

	/**
	 * @return the processor
	 */
	public BotListDocFileProcessor getProcessor() {
		return processor;
	}

	/**
	 * @param processor the processor to set
	 */
	public void setProcessor(BotListDocFileProcessor processor) {
		this.processor = processor;
	}
}
