//
// Author: Berlin Brown
// Remote Agents
// Date: 2/2/2008

package org.spirit.lift.agents

import scala.Console.{println}
import java.util.Random

import net.liftweb.http._
import S._
import net.liftweb.http.S._
import net.liftweb.http.S
import scala.xml.{XML, NodeSeq, Text, Group}
import net.liftweb.util.Helpers._
import javax.servlet.http.{HttpServlet, HttpServletRequest, HttpServletResponse, HttpSession}

import org.spirit.lift.agents._
import org.spirit.lift.agents.model._

import org.springframework.context.{ApplicationContext => AC}
import org.spirit.dao.impl.{BotListUserVisitLogDAOImpl => LogDAO}
import org.spirit.dao.impl.{BotListSessionRequestLogDAOImpl => SessDAO}
import org.spirit.bean.impl.{BotListUserVisitLog => Log}
import org.spirit.bean.impl.{BotListSessionRequestLog => Sess}

/**
 * Example request:
 * http://localhost:8080/botlist/lift/pipes/agents/remote_agent
 */
class RemoteAgents (val request: RequestState) {
  def httpRequest = request.request

  def remote_agent_req : XmlResponse = {
	// Cast to the user visit log bean (defined in the spring configuration)
	val log_obj = AgentUtil.getAC(httpRequest).getBean("userVisitLogDaoBean")
	val log_dao = log_obj.asInstanceOf[LogDAO]
	val sess_obj = AgentUtil.getAC(httpRequest).getBean("sessionRequestLogDaoBean")
	val sess_dao = sess_obj.asInstanceOf[SessDAO]
	val uniq_id = AgentUtil.buildRequestSession(sess_dao, httpRequest, "request_auth", "true")
	AgentUtil.auditLogPage(log_dao, httpRequest, "remote_agent")

    XmlResponse(
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
	<agentmsg>
 		<botid>serverbot</botid>
 		<message>Hello my name is serverbot.  Would you like some cake?</message>
 		<status>200</status>
 		<requestid>{ Text(uniq_id) }</requestid>
 		<majorvers>0</majorvers>
 		<minorvers>0</minorvers>
 	</agentmsg>
</rdf:RDF>)
  } // End of Method Request
  
  def remote_agent_send : XmlResponse = {
	try {
	  var payload = ""
	  S.param("types_payload").map { (u => payload = u) }
	  val xml_payload = XML.loadString(payload)
	  val client_agent_msg = MessageUtil.fromXML(xml_payload)
	  MessageUtil.processPayload(payload, xml_payload, httpRequest)
	} catch {
	  case e => {
		// On error return invalid XML message
		println("ERR: " + e)
		return AgentUtil.invalidXMLResponse
	  }
	} // End of try - catch
	if (S.post_?) XmlResponse { (
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" >
	  <message>Enjoy your cake</message>
</rdf:RDF>) }
    else AgentUtil.invalidXMLResponse
  } // End of Method Send

}
