<%@ page contentType="text/html" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<html>
 <body>
    <c:forEach items="${command.sections}"
			var="section" varStatus="status">
		<a href="<c:url value="/spring/mocktestslist/mocktest_listings.html?viewid=${section.generatedId}" />" >
			<c:out value="${section.sectionName}" /><br>
		</a>			
	</c:forEach>
 </body>
</html>