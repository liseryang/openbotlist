/*
 * SpiderRemote.scala
 */
package org.spirit.spiderremote

import scala.xml._
import java.sql.{DriverManager}
import org.spirit.loadtest.{LoadTestManager}

object SpiderRemote {

  def main(args: Array[String]): Unit = {  
	Console.println("spider remote")
    Class.forName("org.sqlite.JDBC")
    val conn = DriverManager.getConnection("jdbc:sqlite:../../../var/lib/spiderdb/contentdb/spider_queue.db")
    val stat = conn.createStatement()
	val rs = stat.executeQuery("select * from remotequeue")
	while (rs.next()) {
	  Console.println("name = " + rs.getString("url"))
	  Console.println("title = " + rs.getString("title"))
	}
	// Connect to the server
	LoadTestManager.verifySystemDirs
	val res_from_req = LoadTestManager.connectURL("http://127.0.0.1:8080/botlist/lift/pipes/types/remote_agent_req", false)
	val serv_agent_doc = XML.loadString(res_from_req(1))
	val b = serv_agent_doc \\ "message"
	Console.println(b)

	// Post to server
	val map = Map.empty[String, String]
	val v = new java.util.HashMap
	val res_from_snd = LoadTestManager.postData(v, "http://127.0.0.1:8080/botlist/lift/pipes/types/remote_agent_send", false)
	Console.println(res_from_snd(1))
	Console.println("done");
  }
}
