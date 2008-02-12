//
// Berlin Brown
// 2/2/2008
// Model - botlist 
// Would you like some cake?
//

package org.spirit.lift.agents.model

import scala.Console.{println}
import scala.xml._

import org.spirit.lift.agents.util.{GlobalUtil}
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
  def processPayload(payload_content: String, rootNode: Node, httpRequest: HttpServletRequest) = {
	val stats_payload_sz = payload_content.length
	val payload = (rootNode \\ "typespayload")
    val agent_msg = fromXML(rootNode)
	var chat_forum_msg = agent_msg.message
	var chat_forum_title = agent_msg.message
	var success_count = 0
	payload(0) match {
	  case <typespayload>{elems @ _*}</typespayload> =>   
		for (curtype @ <type>{_*}</type> <- elems) {
		  try {
			// Unmarshall the payload data
			val link_type = new BotListEntityLinks
			val model_title = GlobalUtil.formatTextAscii( (curtype \ "title").text )
			val model_url =  GlobalUtil.formatTextAscii( (curtype \ "url").text )
			val model_keywords = GlobalUtil.formatKeywords( (curtype \ "keywords").text )
			val model_descr =  GlobalUtil.formatDescription( (curtype \ "descr").text )
			link_type.setUrlTitle(model_title)
			link_type.setMainUrl(model_url)
			link_type.setKeywords(model_keywords)
			link_type.setUrlDescription(model_descr)
			link_type.setFullName(agent_msg.agentName)
			link_type.setRating(new java.lang.Long(0))
			
			val bean_obj = AgentUtil.getAC(httpRequest).getBean("entityLinksDaoBean")
			val link_dao = bean_obj.asInstanceOf[LinkDAO]
			link_dao.createLink(link_type)
			 success_count = success_count + 1
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
	val additional_chat_msg = GlobalUtil.msgFormatStr(
"""<br />Server Agent: I had to do a lot of work, the payload was large with
 a size of {0} characters. I was able to handle {1} of those widgets.""",
 stats_payload_sz, success_count)
	AgentUtil.createBotForumMsg(httpRequest, agent_msg.agentName,
								(chat_forum_msg + additional_chat_msg), 
								(chat_forum_title take 40) + "...")
  } // End of Method

} // End of Object
