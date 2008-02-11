//
// Berlin Brown
// 2/2/2008
// Model - botlist 
// Would you like some cake?
//

package org.spirit.lift.agents.model

import scala.Console.{println}
import scala.xml._

import org.spirit.lift.agents.{AgentUtil}
import org.spirit.bean.impl.BotListEntityLinks
import org.spirit.dao.impl.{BotListEntityLinksDAOImpl => LinkDAO}
import javax.servlet.http.{HttpServlet, HttpServletRequest, HttpServletResponse, HttpSession}

abstract class AgentMessage {
  val message: String
  val status: Int
  val agentName: String
  val messageReqId: String
  
  override def toString = message + "@" +  messageReqId

  def toXML = 
	<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	   <agentmsg>
		 <botid>{agentName}</botid>
 		 <message>{message}</message>
 		 <status>{status}</status>
	   </agentmsg>
	</rdf:RDF>  
}
object MessageUtil {
  def fromXML(node: Node): AgentMessage  =
	new AgentMessage {
	  val message = (node \\ "message").text
	  val status = Integer.parseInt((node \\ "status").text)
	  val agentName = (node \\ "botid").text
	  val messageReqId = "none"
	}
  /**
   * Iterate through all of the nodes and commit
   * the data to the database.
   */
  def processPayload(rootNode: Node, httpRequest: HttpServletRequest) = {

	val payload = (rootNode \\ "typespayload")
    val agent_msg = fromXML(rootNode)
	var chat_forum_msg = agent_msg.message
	var chat_forum_title = agent_msg.message
	payload(0) match {
	  case <typespayload>{elems @ _*}</typespayload> =>   
		for (curtype @ <type>{_*}</type> <- elems) {
		  try {
			// Unmarshall the payload data
			val link_type = new BotListEntityLinks		  
			link_type.setUrlTitle( (curtype \ "title").text )
			link_type.setMainUrl( (curtype \ "url").text )
			link_type.setFullName( agent_msg.agentName )
			link_type.setRating( new java.lang.Long(0) )
			
			val bean_obj = AgentUtil.getAC(httpRequest).getBean("entityLinksDaoBean")
			val link_dao = bean_obj.asInstanceOf[LinkDAO]
			link_dao.createLink(link_type)		  
		  } catch {
			case e => {
			  println("ERR: " + e)
			  chat_forum_msg = "There was an issue with your payload<br />Msg: " + agent_msg.message
			  chat_forum_title = "There was an issue with your payload"
			}
		  } // End of try - catch

		} // End of for
	}
	// Also create a message telling us that the bot message
	// was received.
	AgentUtil.createBotForumMsg(httpRequest, agent_msg.agentName, 
								chat_forum_msg, 
								(chat_forum_title take 30) + "...")

  } // End of Method

} // End of Object
