
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.index.FilterIndexReader;
import org.apache.lucene.index.IndexReader;
import org.apache.lucene.queryParser.MultiFieldQueryParser;
import org.apache.lucene.search.Hits;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.Searcher;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Date;

/** Simple command-line based search demo. */
public class SearchDatabase {

	public static final String USER_NAME = "full_name";
	public static final String KEYWORDS = "keywords";
	public static final String URL_TITLE = "url_title";
	public static final String IDENTITY = "id";

	private static class OneNormsReader extends FilterIndexReader {
		private String field;

		public OneNormsReader(IndexReader in, String field) {
			super(in);
			this.field = field;
		}

		public byte[] norms(String field) throws IOException {
			return in.norms(this.field);
		}
	}

	private SearchDatabase() {}

	/** Simple command-line based search demo. */
	public static void main(String[] args) throws Exception {
		String usage =
			"Usage: java org.apache.lucene.demo.SearchFiles [-index dir] [-field f] [-repeat n] [-queries file] [-raw] [-norms field]";
		if (args.length > 0 && ("-h".equals(args[0]) || "-help".equals(args[0]))) {
			System.out.println(usage);
			System.exit(0);
		}

		String index = "\\index";
		String field = URL_TITLE;
		String queries = null;
		int repeat = 0;
		boolean raw = false;
		String normsField = null;

		for (int i = 0; i < args.length; i++) {
			if ("-index".equals(args[i])) {
				index = args[i+1];
				i++;
			} else if ("-field".equals(args[i])) {
				field = args[i+1];
				i++;
			} else if ("-queries".equals(args[i])) {
				queries = args[i+1];
				i++;
			} else if ("-repeat".equals(args[i])) {
				repeat = Integer.parseInt(args[i+1]);
				i++;
			} else if ("-raw".equals(args[i])) {
				raw = true;
			} else if ("-norms".equals(args[i])) {
				normsField = args[i+1];
				i++;
			}
		}

		IndexReader reader = IndexReader.open(index);

		if (normsField != null)
			reader = new OneNormsReader(reader, normsField);

		Searcher searcher = new IndexSearcher(reader);
		Analyzer analyzer = new StandardAnalyzer();

		BufferedReader in = null;
		if (queries != null) {
			in = new BufferedReader(new FileReader(queries));
		} else {
			in = new BufferedReader(new InputStreamReader(System.in, "UTF-8"));
		}
		String [] fields = { URL_TITLE, USER_NAME, KEYWORDS };
		MultiFieldQueryParser parser = new MultiFieldQueryParser( fields, analyzer);

		while (true) {
			if (queries == null)                        // prompt the user
				System.out.print("Query: ");

			String line = in.readLine();

			if (line == null || line.length() == -1)
				break;
			Object obj = parser.parse(line);
			System.out.println("----> Type=" + obj);
			Query query = parser.parse(line);
			System.out.println("Searching for: " + query.toString(field));

			Hits hits = searcher.search(query);

			if (repeat > 0) {                           // repeat & time as benchmark
				Date start = new Date();
				for (int i = 0; i < repeat; i++) {
					hits = searcher.search(query);
				}
				Date end = new Date();
				System.out.println("Time: "+(end.getTime()-start.getTime())+"ms");
			}

			System.out.println(hits.length() + " total matching documents");

			final int HITS_PER_PAGE = 10;
			for (int start = 0; start < hits.length(); start += HITS_PER_PAGE) {
				int end = Math.min(hits.length(), start + HITS_PER_PAGE);
				for (int i = start; i < end; i++) {

					System.out.println("doc="+hits.id(i)+" score="+hits.score(i));

					Document doc = hits.doc(i);
					String path = doc.get(USER_NAME);
					if (path != null) {
						System.out.println((i+1) + ". " + path);
						String title = doc.get(URL_TITLE);
						String id = doc.get(IDENTITY);
						if (title != null) {
							System.out.println("   Title: " + doc.get(URL_TITLE));
						}
						System.out.println("   id: " + id);
					} else {
						System.out.println((i+1) + ". " + "No path for this document");
					}
				}

				if (queries != null)                      // non-interactive
					break;

				if (hits.length() > end) {
					System.out.print("more (y/n) ? ");
					line = in.readLine();
					if (line.length() == 0 || line.charAt(0) == 'n')
						break;
				}
			}
		}
		reader.close();
	}
}