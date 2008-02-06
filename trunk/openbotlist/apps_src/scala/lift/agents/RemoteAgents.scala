//
//

package org.spirit.lift.agents

import net.liftweb.http._
import javax.servlet.http.{HttpServlet, HttpServletRequest, HttpServletResponse, HttpSession}

class RemoteAgents (val request: RequestState,val httpRequest: HttpServletRequest) extends SimpleController {
  def remote_agent: XmlResponse = {
    XmlResponse(
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:botmsg="http://xmlns.com/botmsg/0.1/" >
	<botmsg:agentmsg>
 		<botmsg:botid>serverbot</botmsg:botid>
 		<botmsg:message>Hello my name is bot, go ahead with your request</botmsg:message>
 		<botmsg:status>200</botmsg:status>
 		<botmsg:requestid>12312312</botmsg:requestid>
 		<botmsg:majorvers>0</botmsg:majorvers>
 		<botmsg:minorvers>0</botmsg:minorvers>
 	</botmsg:agentmsg>
</rdf:RDF>)
  } // End of Method
}
