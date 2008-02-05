/*
 * SpiderRemote.scala
 */
package org.spirit.spiderremote

import java.sql.{DriverManager}

object SpiderRemote {
  def main(args: Array[String]): Unit = {  
	Console.println("spider remote")
    Class.forName("org.sqlite.JDBC")
    val conn = DriverManager.getConnection("jdbc:sqlite:../../../var/lib/spiderdb/contentdb/spider_queue.db")
    val stat = conn.createStatement()
	val rs = stat.executeQuery("select * from remotequeue")
	while (rs.next()) {
	  Console.println("name = " + rs.getString("url"))
	}
	System.out.println("done");
  }
}
