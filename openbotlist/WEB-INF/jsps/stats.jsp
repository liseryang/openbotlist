<%@ page contentType="text/html"%>
<%@include file="/WEB-INF/jsps/general/default_includes.jsp" %>

<html>
<head>
<title>Botlist - Statistics</title>

<META NAME="DESCRIPTION" CONTENT="Botlist - (statistics) Promote yourself or something else interesting">
<META NAME="keywords" CONTENT="listing, bot, botlist, botlisting, bot's list, list, ads, advertising">

<link href="<c:url value="/company/stylesheets/scaffold.css" />" media="screen" rel="Stylesheet" type="text/css" />
<link href="<c:url value="/company/stylesheets/newspirit.css" />" media="screen" rel="Stylesheet" type="text/css" />
<link href="<c:url value="/company/stylesheets/botlist.css" />" media="screen" rel="Stylesheet" type="text/css" />

</head>
<body>

<div id="body_content_center">

 <div style="border-bottom: 1px solid #816943;">
	<img src="<c:url value="/company/images/building_orange_roof.jpg" />">
 </div>
<h1 class="bot_titlelogo">Botlist - Statistics | Home</h1>
			<%-- Navigation Header --%>
			<%@include file="/WEB-INF/jsps/general/default_navigation.jsp" %>			
			<%-- End of Navigation Header --%>					

<div style="margin: 2px;">
<div style="padding: 2px; margin-right: 4px;">
<!-- Display the error message -->
<div class="bot_profile_sect_add_link ">

	<!-- Build the table for entering the new department information -->
	<br />	
	<table width="100%">
	<tr>
	<td valign="top">
		<%-- *** Page View Section with other user data --%>
		<table>
		<tr>
			<td style="border-right: 1px solid #ccc;">
				<b>Page Views: </b><c:out value="${command.totalvisits}" />
				<br />
				Unique Visitors: <c:out value="${command.uniquevisits}" />
				<br />
				since: <fmt:formatDate pattern="EE dd, MMM yy" value="${command.timeFirstVisit.time}" /> 
			</td>
			<td valign="top">
				<b>Registered Users: </b><c:out value="${command.totalregusers}" />
				<br />
				Members logged in: <c:out value="${command.totalloggedin}" />
				<br />
				Active guests online: <c:out value="${command.totalsessions}" />
			</td>
		</tr>
		</table>
		<%-- End of section / page view and user data --%>
		
		<div style="border-top: 1px solid #CCC; padding: 6px; margin-top: 6px;">
			<b>Visits this Week:</b>  <c:out value="${command.stats.weekVisits}" />
			
			<%-- Present the Date by a particular Day --%>
			<div>
				<table class="forstats" cellpadding="0" cellspacing="0">
				<tr>
					<td style="background-color: #e7f0f1;">
						<fmt:formatDate pattern="EE dd, MMM yy" value="${command.stats.weekStatsDates['stats6'].time}" /> 
					</td>
					<td>
						<c:out value="${command.stats.weekStats['stats6']}" /> views
					</td>
				</tr>
				<tr>			
					<td style="background-color: #f4f4f4;">
						<fmt:formatDate pattern="EE dd, MMM yy" value="${command.stats.weekStatsDates['stats5'].time}" /> 
					</td>
					<td>
						<c:out value="${command.stats.weekStats['stats5']}" /> views					
					</td>
				</tr>
				<tr>
					<td style="background-color: #f4f4f4;">
						<fmt:formatDate pattern="EE dd, MMM yy" value="${command.stats.weekStatsDates['stats4'].time}" /> 
					</td>
					<td>
						<c:out value="${command.stats.weekStats['stats4']}" /> views
					</td>
				</tr>
				<tr>			
					<td>
						<fmt:formatDate pattern="EE dd, MMM yy" value="${command.stats.weekStatsDates['stats3'].time}" /> 
					</td>
					<td>
						<c:out value="${command.stats.weekStats['stats3']}" /> views
					</td>
				</tr>
				<tr>
					<td>
						<fmt:formatDate pattern="EE dd, MMM yy" value="${command.stats.weekStatsDates['stats2'].time}" /> 
					</td>
					<td>
						<c:out value="${command.stats.weekStats['stats2']}" /> views
					</td>
				</tr>
				<tr>
					<td>		
						<fmt:formatDate pattern="EE dd, MMM yy" value="${command.stats.weekStatsDates['stats1'].time}" /> 
					</td>
					<td style="background-color: #f4f4f4;">
						<c:out value="${command.stats.weekStats['stats1']}" /> views
					</td>
				</tr>
				<tr>								
					<td>
						<fmt:formatDate pattern="EE dd, MMM yy" value="${command.stats.weekStatsDates['stats0'].time}" /> 
					</td>
					<td style="background-color: #f4f4f4;">
						<c:out value="${command.stats.weekStats['stats0']}" /> views
					</td>
				</tr>
				</table>
			<div>
			<%-- End of Date Totals --%>
			
			<%-- Section to display stat image --%>			
			<div style="margin-top: 6px; margin-left: 10px;">
				<%-- **************************** --%>
				<%-- Build image chart based on freechart, on request --%>
				<%-- **************************** --%>
				<%-- 
				 (TODO: removed for more testing
				 <img src="<c:url value="/dayStatChart.png" />" border="0"/>
				 --%>
			
			</div>
			
		</div>				
	</td>
	<td valign="top" align="right" width="40%">
			<!-- New DIV with orange background -->
			<div>					
				<div>
					<img src="<c:url value="/company/images/BoxLogoVertical1.jpg" />" />
				</div>
			</div>												
	</td>
	</tr>
	</table>
	<!--  End of Outer Table -->
</div>

</div>

</div>

<%@include file="/WEB-INF/jsps/general/default_footer.jsp"%>
</div>

</body>
</html>
