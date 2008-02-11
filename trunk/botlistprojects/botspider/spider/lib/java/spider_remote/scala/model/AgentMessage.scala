//
// Berlin Brown
// 2/2/2008
// Model: Spider Remote
// Would you like some cake?
//
package org.spirit.spiderremote.model

abstract class TypePayload  {
  val typeName: String
  val url: String
  val title: String
  val keywords: String
  val descr: String

  override def toString = title

  def toXML = 
	<type>
	  <type>{typeName}</type>
	  <url>{url}</url>
	  <title>{title}</title>
  	  <keywords>{keywords}</keywords>
	  <descr>{descr}</descr>
	</type>
}

abstract class AgentMessage {
  val message: String
  val status: Int
  val agentName: String
  val messageReqId: String
  val types: List[TypePayload]

  override def toString = message

  def toXML = 
	<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
	   <agentmsg>
		  <botid>{agentName}</botid>
		  <message>{message}</message>
		  <status>{status}</status>
		  <typespayload>
		  { types map (_.toXML) }
		  </typespayload>
	   </agentmsg>
	</rdf:RDF>
}
