/*
 * SpiderRemote.scala
 */
package org.spirit.spiderremote

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
	LoadTestManager.verifySystemDirs()
	LoadTestManager.connectURL("http://127.0.0.1:8080/botlist/lift/pipes/types/remote_agent_req", false)

	System.out.println("done");
  }
}
