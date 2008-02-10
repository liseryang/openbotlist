//
// 4/20/2007

import scala.Console
import java.io._
import scala.xml._
import java.net._  
import org.jdom._
import org.jdom.{Document => JDocument}
import java.util.{Iterator => JIterator}
import org.jdom.input._
import scala.dbc._
import scala.dbc.Syntax._
import scala.dbc.statement._
import scala.dbc.statement.expression._
import scala.dbc.value._
import scala.dbc.syntax._
import syntax.Statement._
import scala.dbc.statement.{Select => DBCSelect}
import java.sql.{DriverManager, Connection, ResultSet, PreparedStatement, Statement, Date }
import DriverManager.{getConnection => connect};

import RichSQL._;

//------------------------------------------------
// Rich Scala JDBC
// From http://scala.sygneca.com/code/simplifying-jdbc
//------------------------------------------------

object RichSQL {
 
    implicit def query[X](s: String, f: RichResultSet => X)(implicit stat: Statement) = {
        def strm(rs: ResultSet): Stream[X] = 
            if (rs.next) Stream.cons(f(new RichResultSet(rs)), strm(rs)) else { rs.close(); Stream.empty };
        strm(stat.executeQuery(s));
    }
    
    implicit def conn2Statement(conn: Connection): Statement = conn.createStatement;
    
    implicit def rrs2Byte(rs: RichResultSet) = rs.nextByte;
    implicit def rrs2Int(rs: RichResultSet) = rs.nextInt;
    implicit def rrs2Long(rs: RichResultSet) = rs.nextLong;
    implicit def rrs2Float(rs: RichResultSet) = rs.nextFloat;
    implicit def rrs2Double(rs: RichResultSet) = rs.nextDouble;
    implicit def rrs2String(rs: RichResultSet) = rs.nextString;
    
    implicit def resultSet2Rich(rs: ResultSet) = new RichResultSet(rs);
    implicit def rich2ResultSet(r: RichResultSet) = r.rs;
    
    class RichResultSet(val rs: ResultSet) {
        
        var pos = 1
        def apply(i: Int) = { pos = i; this }
        
        def nextInt: Int = { val ret = rs.getInt(pos); pos = pos + 1; ret }
        def nextString: String = { val ret = rs.getString(pos); pos = pos + 1; ret }
        def nextLong: Long = { val ret = rs.getLong(pos); pos = pos + 1; ret }
        def nextFloat: Float = { val ret = rs.getFloat(pos); pos = pos + 1; ret }
        def nextDouble: Double = { val ret = rs.getDouble(pos); pos = pos + 1; ret }
        def nextByte: Byte = { val ret = rs.getByte(pos); pos = pos + 1; ret }
        
        def foldLeft[X](init: X)(f: (ResultSet, X) => X): X = rs.next match {
            case false => init
            case true => foldLeft(f(rs, init))(f)
        }
        def map[X](f: ResultSet => X) = {
            var ret = List[X]()
            while (rs.next())
                ret = f(rs) :: ret
            ret;
        }
    }
 
    implicit def str2RichPrepared(s: String)(implicit conn: Connection): RichPreparedStatement = conn prepareStatement(s);
    
    implicit def ps2Rich(ps: PreparedStatement) = new RichPreparedStatement(ps);
    implicit def rich2PS(r: RichPreparedStatement) = r.ps;
    class RichPreparedStatement(val ps: PreparedStatement) {
      var pos = 1;
      private def inc = { pos = pos + 1; this }
      def execute = { pos = 1; ps.execute }
      def <<! = execute;
      def <<(o: String) = { ps.setString(pos, o); inc }
      def <<(x: Date) = { ps.setDate(pos, x); inc }
      def <<(x: Byte) = { ps.setByte(pos, x); inc }
      def <<(x: Long) = { ps.setLong(pos, x); inc }
      def <<(b: Boolean) = { ps.setBoolean(pos, b); inc }
      def <<(i: Int) = { ps.setInt(pos, i); inc }
      def <<(f: Float) = { ps.setFloat(pos, f); inc }
      def <<(d: Double) = { ps.setDouble(pos, d); inc }      
    }
    
    implicit def conn2Rich(conn: Connection) = new RichConnection(conn);
    
    class RichConnection(val conn: Connection) {
        def <<(sql: String) = new RichStatement(conn.createStatement) << sql;
        def <<(sql: Seq[String]) = new RichStatement(conn.createStatement) << sql;
        def << = new RichStatement(conn.createStatement);
    }
 
    implicit def st2Rich(s: Statement) = new RichStatement(s);
    implicit def rich2St(rs: RichStatement) = rs.s;
    
    class RichStatement(val s: Statement) {
      def <<(sql: String) = { s.execute(sql); this }
      def <<(sql: Seq[String]) = { for (val x <- sql) s.execute(x); this }
    }
 
}

//------------------------------------------------
// End of Rich Scala JDBC
//------------------------------------------------

