/*
 * SpiderRemote.scala
 */
package org.spirit.spiderremote

import scala.xml._
import java.sql.{DriverManager}
import org.spirit.loadtest.{LoadTestManager}
import scala.collection.jcl.{HashMap, Map}

import org.spirit.spiderremote.model.{AgentMessage, TypePayload}

object SpiderRemote {

  def main(args: Array[String]): Unit = {  
	Console.println("spider remote")
    Class.forName("org.sqlite.JDBC")
    val conn = DriverManager.getConnection("jdbc:sqlite:../../../var/lib/spiderdb/contentdb/spider_queue.db")
    val stat = conn.createStatement()
	Console.println(conn)
	val rs = stat.executeQuery("select * from remotequeue")

	while (rs.next()) {
	  Console.println("name = " + rs.getString("url"))
	}
	// Connect to the server
	LoadTestManager.verifySystemDirs
	val res_from_req = LoadTestManager.connectURL("http://127.0.0.1:8080/botlist/lift/pipes/types/remote_agent_req", false)
	val serv_agent_doc = XML.loadString(res_from_req(1))
	val b = serv_agent_doc \\ "message"
	Console.println(b)

	// Build the type payload list
	val a = new TypePayload {
	  val typeName = "linktype"
	  val title = "The Google"
	  val url = "http://www.google77.com"
	  val keywords = "google, google"
	  val descr = "The descr"
	}
	val d = new TypePayload {
	  val typeName = "linktype2"
	  val title = "The Google2"
	  val url = "http://www.google89.com"
	  val keywords = "google, google4"
	  val descr = "The descr2"
	}
	// Post to server
	val m = new java.util.HashMap
	val map = new HashMap[String, String](m)
	val types_msg_payload = new AgentMessage {
	  val message = "I enjoyed my cake."
	  val status = 200
	  val agentName = "botspiderremote"
	  val messageReqId = "123"
	  val types = List(a, d)
	}
	
	map("types_payload") = types_msg_payload.toXML.toString
	val res_from_snd = LoadTestManager.postData(m, "http://127.0.0.1:8080/botlist/lift/pipes/types/remote_agent_send", false)
	Console.println(res_from_snd(1))
	Console.println("done");
  }
}

