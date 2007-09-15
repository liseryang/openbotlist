/**
 * Berlin Brown
 * Nov 18, 2006
 */
package org.spirit.bean.impl;

import java.io.Serializable;

/**
 * This is class is used by botverse.
 * @author Berlin Brown
 *
 */
public class BotListCalculatorVerification implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5767760461182300259L;
	private Long firstInput;
	private Long secondInput;
	private Long solution;
	private Long userSolution;
	
	/**
	 * @return the userSolution
	 */
	public Long getUserSolution() {
		return userSolution;
	}
	/**
	 * @param userSolution the userSolution to set
	 */
	public void setUserSolution(Long userSolution) {
		this.userSolution = userSolution;
	}
	/**
	 * @return the firstInput
	 */
	public Long getFirstInput() {
		return firstInput;
	}
	/**
	 * @param firstInput the firstInput to set
	 */
	public void setFirstInput(Long firstInput) {
		this.firstInput = firstInput;
	}
	/**
	 * @return the secondInput
	 */
	public Long getSecondInput() {
		return secondInput;
	}
	/**
	 * @param secondInput the secondInput to set
	 */
	public void setSecondInput(Long secondInput) {
		this.secondInput = secondInput;
	}
	/**
	 * @return the solution
	 */
	public Long getSolution() {
		return solution;
	}
	/**
	 * @param solution the solution to set
	 */
	public void setSolution(Long solution) {
		this.solution = solution;
	}

}
