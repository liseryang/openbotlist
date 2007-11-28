<%@ page contentType="text/html" %>
<%@include file="/WEB-INF/jsps/general/default_includes.jsp" %>
<html>
<head>
 	<title>Botlist - Interesting Things Online</title>
 
  	<META NAME="DESCRIPTION" CONTENT="Botlist - Promote yourself or something else interesting. Like Reddit or Digg but for adults.">
 	<META NAME="keywords" CONTENT="listing, bot, botlist, botlisting, bot's list, list, ads, advertising, social bookmarking, networking, social networking, reddit, digg">
    <meta name="verify-v1" content="5vYTM0GqfzX+H+qkXwFSztV8Y7vHygc6kxtGldxcc+8=" />
   
  	<link type="application/rss+xml" rel="alternate" title="Botverse - Link Listings" href="<c:url value="/spring/rss/listings_rss.html" />">
	<link href="<c:url value="/company/stylesheets/scaffold.css" />" media="screen" rel="Stylesheet" type="text/css" />
  	<link href="<c:url value="/company/stylesheets/newspirit.css" />" media="screen" rel="Stylesheet" type="text/css" /> 
  	<link href="<c:url value="/company/stylesheets/botlist.css" />" media="screen" rel="Stylesheet" type="text/css" /> 
  	<link href="<c:url value="/company/stylesheets/botlist_general2.css" />" media="screen" rel="Stylesheet" type="text/css" /> 
  	
  	<style type="text/css">
	 <%@include file="/WEB-INF/jsps/general/botverse_link_stat.jsp" %>	
	</style>
</head>
<body>
		<div id="body_content_center">
			<div style="border-bottom: 1px solid #816943;">
				<img src="<c:url value="/company/images/building_orange_roof.jpg" />" >
 			</div>
			<h1 class="bot_titlelogo">
				[ Botlist Home ]
			</h1>
			<%-- Navigation Header --%>
			<%@include file="/WEB-INF/jsps/general/default_navigation.jsp" %>			
			<%-- End of Navigation Header --%>
			
			<div style="margin: 8px;">
				<h3 class="bot_headerinfo">				
				All your favorite links in one place.  Bookmark things for yourself and friends.  Check out what other people are bookmarking.								
				</h3>
			</div>			
			<!-- Section with City Listing -->
			<div style="margin: 8px;">
				
				<%-- Add Welcome user message and login content (above content border line) --%>
				<%@include file="/WEB-INF/jsps/general/default_profile_nav.jsp" %>
				<%-- End of Welcome Header --%>
				
				<div style="border: 1px solid #DDD;">
				
				<!-- Table of Data Grid and Image (rowspan on the left = City Listings ) -->
				<table width="100%" >
				<tr>
				<td valign="top" align="right">
					<%-- ==== Next Set of Data, Recent Links ==== --%>
					<div style="margin-left: 4px;">
						<table width="100%">
						<tr>
							<td>
								<span style="background-color: #e8e8e8; padding: 4px;">
								&nbsp;most recent updates:
								</span>
								&nbsp;/ <a href="<c:url value="/spring/botverse/botverse.html?filterset=mostrecent" />" class="linklist_botnav">view more</a> 
									/ <a href="<c:url value="/spring/botverse/botverse_submit.html" />" class="linklist_botnav">submit</a>									
								
								&nbsp;&nbsp;<span style="color: #555;"><i>(<c:out value="${linkCount}" /> entries)</i></span>
								
								<%-- Banner Section --%>
								<c:choose>
									<c:when test="${headline != null}" >
									  <div style="width: 80%;">
										<div style="color: #444; font-size: 14pt; background-color: #e7f0f1; padding: 6px;">
										  <c:out value="${headline}" />
										</div>
									 </div>
									</c:when>
								</c:choose>
								<%-- End of Banner Section --%>																		
							</td>
						</tr>
						<tr>
							<td>
							<%-- == Next Row, Iterate through updates == --%>
							<table cellspacing="0" cellpadding="0">
							<c:forEach items="${linklistings}"
										var="listing" varStatus="status">
								<%-- Begin row production for botverse links --%>
								<tr>					
									<td colspan="3">
											<a class="linklist_objlinks" href="<c:url value="${listing.mainUrl}" />" >
												<c:out value='${botlistutil:getMaxWord(listing.urlTitle, 48)}' />
											</a>
											(<a class="linklist_comments_host" href="<c:url value="/spring/botverse/linkviewcomments.html?viewid=${listing.id}" />">#</a>)
									</td>
								</tr>
								<tr>
								<td>
									<!-- Inner table for data/status information -->
									<table>
									<tr>					
									<td>
										<div class="linklist_comments_txt">						 	
										 <span class="linklist_comments_date">						
											<botlistutil:timePast dateValue="${listing.createdOn.time}" />							
										 </span>
										</div>
									</td>
									<td>					  
									  <span style="margin-left: 0px; font-size: 10px">
											<span class="linklist_comments_date"><strong>by
												<c:out value="${listing.fullName}" /></strong>
											</span>
									  </span>
									</td>
									</tr>
									</table>
									<!-- End of inner table (loop) -->				
								</td>
								</tr>
								<%-- End row production for botverse links --%>								
												
							</c:forEach>							
							</table>
							<%-- End of table for botverse links --%>
							<div style="margin-top: 6px; background-color: #f3f3f3; padding: 6px; width: 30%">
								<a href="<c:url value="/spring/botverse/botverse.html?filterset=mostrecent" />" class="linklist_botnav">view more</a> 
							</div>
							
							</td>
						</tr>						
						<%-- ==== Print Map Reduce Top Terms ====  --%>
						<%-- 
						<tr>
							<td>
								 <c:forEach items="${popularwordmap}" var="curWord" varStatus="status">
								 	<c:out value="${curWord}" />
								</c:forEach>
							</td>
						</tr>
						--%>
						<%-- ==== End of Top Terms ==== ---%>						
						</table>
					</div>
					<%-- ==== End Next Set of Data, Recent Links ==== --%>
					
				</td>
				<td valign="top" align="right">										
					<!-- table just for search -->
					<table class="sample">
					<tr>
						<th>
							&nbsp;Search
						</th>						
					</tr>
					<tr>
					<td>
							<!-- Begin Search Form -->
							<form method="get" action="<c:url value="/spring/search/search.html" />">
								<table>
								<tr>
								<td>
									<input name="query" size="26" />
								</td>
								<td>
									<input type="submit" value=" Search " />
								</td>
								</tr>
								</table>
								<input type="hidden" name="querymode" value="enabled" />
							</form>
							<!-- End of Form -->
							<p align="right">
							<a href="<c:url value="/spring/rss/listings_rss.html" />" class="index_img">
								<img border="0" src="<c:url value="/company/images/rss.gif" />" />
							</a>
							</p>
					</td>
					</tr>
					</table>
					<!-- End of Table -->					
					<%-- ============================== --%>
					<%-- New table for botverse image / media feeds / hot topics --%>
					<%-- ============================== --%>
					<table border="0">
					<tr>
						<td width="100%" rowspan="2" valign="top">
							<%-- ============================== --%>
							<%-- Hot Topic Section --%>
							<%-- ============================== --%>
							<table cellspacing="0" cellpadding="0" width="100%">
							<tr>
								<td style="background-color: #e8e8e8; padding: 4px; width: 100%;">
									<span >
									<b>hot search topics</b>
									</span>
								</td>						
							</tr>
							<tr>
								<td align="left">
								   <c:forEach items="${hotTopics}" var="curTopic" varStatus="status">
									  <div><a href="<c:url value="/spring/search/search.html?querymode=enabled&query=${curTopic.searchTermEncoded}" />"  class="linklist_small">
									  	* <c:out value="${curTopic.searchTermShorten}" />
									  </a></div>
									</c:forEach>									
								</td>
							</tr>
							</table>
							<%-- ============================== --%>
							<%-- End Hot topic section --%>
							<%-- ============================== --%>
						</td>
					    <td align="right">
					    	<%-- == Botlist Logo Image == --%>
							<a href="<c:url value="/spring/botverse/botverse.html" />" class="index_img">
						 		<img src="<c:url value="/company/images/BoxLogoVertical3.jpg" />" border="0">
							</a>
						</td>
					</tr>						
					<tr>
						<td valign="top">					
						<%-- ============================== --%>
						<%-- Display Media Table if enabled --%>
						<%-- ============================== --%>
						<c:if test="${mediaListEnabled}">
						 <div style="margin-top: 8px;">
							<table cellspacing="0" cellpadding="0">
							<tr>
								<td style="background-color: #e8e8e8; padding: 4px; width: 100%;">
									<span style="background-color: #e8e8e8; padding: 4px; width: 100%;">
									<b>related media feeds</b>
									</span>
								</td>						
							</tr>
							<c:forEach items="${mediaList}" var="curmedia" varStatus="status">
								<tr>
									<td>
										<%-- Media Section is made up table (image, title) --%>
										<table cellspacing="0" cellpadding="12" width="100%">
											<tr><td style="background-color: #e7f0f1;">
											   <a href="<c:out value="${curmedia.media.mediaUrl}" />" 
											   	   class="index_img">
												<img src="<c:out value="${curmedia.media.imageThumbnail}" />" border="0" width="130" />
											   </a>
											</td></tr>
											<tr><td style="background-color: #f1f1f1; width: 100%;">
												<b><c:out value='${botlistutil:getMaxWord(curmedia.media.mediaTitle, 22)}' /></b>
											</td></tr>
										</table>
										<%-- End of Media Table --%>
									</td>
								</tr>
							</c:forEach>
							</table>
						  </div>					
						</c:if>
						<%-- ============================== --%>
						<%-- End of Display Media table --%>
						<%-- ============================== --%>					
						</td>
						</tr>
						<%-- Table containg media feeds / botlist image --%>
					</table>
					
					<%-- Right Section for media feeds / rss link, etc --%>
					
				</td>
				</tr>
				
				<%-- Header Content --%>	
				<tr>
					<td colspan="2" align="right">
						<div style="text-align: right">
						<h2 class="bot_splashinfo">
							Botlist contains fresh, user driven content.
						</h2>
						</div>										
					</td>
				</tr>
				<%-- End of Header Content --%>
				</table>
				<!-- End Data/Image Table -->
					
				</div>
			</div>								
			<%@include file="/WEB-INF/jsps/general/default_footer.jsp" %>
		</div>  

<div>		
<script src="http://www.google-analytics.com/urchin.js" type="text/javascript">
</script>
<script type="text/javascript">
_uacct = "UA-286501-2";
urchinTracker();
</script>
</div>
		
</body>
</html>