//
// Author: Berlin Brown
// Remote Agents
// Date: 2/2/2008

package org.spirit.lift.agents

import java.util.Random
import org.springframework.context.{ApplicationContext => AC}
import org.spirit.dao.impl.{BotListUserVisitLogDAOImpl => LogDAO}
import org.spirit.dao.impl.{BotListSessionRequestLogDAOImpl => SessDAO}
import org.spirit.bean.impl.{BotListUserVisitLog => Log}
import org.spirit.bean.impl.{BotListSessionRequestLog => Sess}
import net.liftweb.http._
import net.liftweb.http.S._
import net.liftweb.http.S
import scala.xml.{NodeSeq, Text, Group}
import net.liftweb.util.Helpers._
import javax.servlet.http.{HttpServlet, HttpServletRequest, HttpServletResponse, HttpSession}

import org.spirit.lift.agents._

/**
 * Example request:
 * http://localhost:8080/botlist/lift/pipes/agents/remote_agent
 */
class RemoteAgents (val request: RequestState, val httpRequest: HttpServletRequest) extends SimpleController {

  def remote_agent_req : XmlResponse = {
	// Cast to the user visit log bean (defined in the spring configuration)
	val log_obj = AgentUtil.getAC(httpRequest).getBean("userVisitLogDaoBean")
	val log_dao = log_obj.asInstanceOf[LogDAO]
	val sess_obj = AgentUtil.getAC(httpRequest).getBean("sessionRequestLogDaoBean")
	val sess_dao = sess_obj.asInstanceOf[SessDAO]
	val uniq_id = AgentUtil.buildRequestSession(sess_dao, httpRequest, "request_auth", "true")
	AgentUtil.auditLogPage(log_dao, httpRequest, "remote_agent")

    XmlResponse(
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:botmsg="http://xmlns.com/botmsg/0.1/" >
	<botmsg:agentmsg>
 		<botmsg:botid>serverbot</botmsg:botid>
 		<botmsg:message>Hello my name is serverbot, go ahead with your request</botmsg:message>
 		<botmsg:status>200</botmsg:status>
 		<botmsg:requestid>{ Text(uniq_id) }</botmsg:requestid>
 		<botmsg:majorvers>0</botmsg:majorvers>
 		<botmsg:minorvers>0</botmsg:minorvers>
 	</botmsg:agentmsg>
</rdf:RDF>)
  } // End of Method Request

  
  def remote_agent_send : XmlResponse = {
	if (S.post_?) XmlResponse(<fuck></fuck>)
    else AgentUtil.invalidXMLResponse
  } // End of Method Send

}
