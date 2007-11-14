import java.io.File;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.analysis.standard.StandardAnalyzer;


public class IndexDatabase {

	public static File index;
	public static final String USER_NAME = "full_name";
	public static final String KEYWORDS = "keywords";
	public static final String URL_TITLE = "url_title";
	public static final String IDENTITY = "id";

	public static ResultSet query(Statement statement, String str) throws Exception {
		return statement.executeQuery(str);
	}
	public static List processResults(ResultSet rs) throws Exception {
		List l = new ArrayList();
		while (rs.next()) {
			String [] arr = new String[5];
			arr[0] = rs.getString("main_url");
			arr[1] = rs.getString("url_title");
			arr[2] = rs.getString("keywords");
			arr[3] = rs.getString("full_name");
			arr[4] = rs.getLong("id") + "";
			System.out.println(arr[4]);
			l.add(arr);
		}
		return l;
	}
	public static void indexResults(String dir, List l) throws Exception {
		index = new File(dir);
		if (!index.exists()) {
			index.mkdir();
		}
		IndexWriter writer = new IndexWriter(index, new StandardAnalyzer(), true);
		for (Iterator it = l.iterator(); it.hasNext();) {
			String [] arr = (String []) it.next();
			final Document doc = new Document();

			doc.add(new Field(USER_NAME, arr[3], Field.Store.YES, Field.Index.TOKENIZED));
			doc.add(new Field(KEYWORDS, arr[2], Field.Store.YES, Field.Index.TOKENIZED));
			doc.add(new Field(URL_TITLE, arr[1], Field.Store.YES, Field.Index.TOKENIZED));
			doc.add(new Field(IDENTITY, arr[4], Field.Store.YES, Field.Index.UN_TOKENIZED));
			writer.addDocument(doc);
		}
		writer.optimize();
		writer.close();
	}

	public static void main(String [] args) throws Exception {
		System.out.println("indexing...");
		Class.forName("com.mysql.jdbc.Driver");
		Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/openbotlist_development", "USER", "PASSWORD");
		Statement statement = conn.createStatement();
		List l = processResults(query(statement, "select * from entity_links"));
		indexResults("\\index", l);
		conn.close();
		System.out.println("done");
	}
}

