<%@ page contentType="text/html"%>

<%@include file="/WEB-INF/jsps/general/default_includes.jsp" %>

<html>
<head>
<title>Botverse - Calendar View</title>
<META NAME="DESCRIPTION" CONTENT="Botverse - Calendar View, popular links by date">
<META NAME="keywords" CONTENT="date view, listing, bot, botlist, botlisting, bot's list, list, ads, advertising">

<link href="<c:url value="/company/stylesheets/scaffold.css" />" media="screen" rel="Stylesheet" type="text/css" />
<link href="<c:url value="/company/stylesheets/newspirit.css" />" media="screen" rel="Stylesheet" type="text/css" />
<link href="<c:url value="/company/stylesheets/botlist.css" />" media="screen" rel="Stylesheet" type="text/css" />
<link href="<c:url value="/company/stylesheets/botlist_calendar.css" />" media="screen" rel="Stylesheet" type="text/css" />

<style type="text/css">
 <%@include file="/WEB-INF/jsps/general/botverse_link_css.jsp" %>	
</style>

</head>
<body>

 <h1 class="bot_titlelogo">Calender mode disabled</h1>
			
 <%-- Debug, how long to process page --%>
 <div style="font-size: 10px; color: #888;text-align: right">
 <i>(process in <c:out value="${processingtime}" />s)</i>
 </div>
 
</body>
</html>
