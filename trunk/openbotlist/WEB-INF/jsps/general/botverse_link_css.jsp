<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
/** =============================================== */
/** == Link List Data, Only for the Link Section == */
/** == Bold and Dark Blue / Purple == */
/** =============================================== */
a.linklist_objlinks:link {
	font-family: "arial", verdana, helvetica, sans-serif;
	font-size: 10pt;
	font-weight: bold;
	margin-bottom: 0px;
	margin-top: 0px;
	background-color: transparent;
	<c:choose>
   	 <c:when test="${command.userInfo != null}" >														  
	  color: <c:out value='#${command.userInfo.linkColor};' />
	 </c:when>
	 <c:otherwise>
	  color: #447;
     </c:otherwise> 
	</c:choose>
}

/** Leave the visited link as darker than others */
a.linklist_objlinks:visited {
	font-family: "Lucida Grande", "Lucida Sans Unicode", verdana, geneva, sans-serif;
	font-size: 10pt;
	font-weight: bold;
	margin-bottom: 0px;
	margin-top: 0px;
	color: #460C7B;
	background-color: transparent;
}

a.linklist_objlinks:hover {
	font-family: "Lucida Grande", "Lucida Sans Unicode", verdana, geneva, sans-serif;
	font-size: 10pt;
	font-weight: bold;
	margin-bottom: 0px;
	margin-top: 0px;
	color: #447;
	background-color: transparent;
}
a.linklist_objlinks:active {
	font-family: "Lucida Grande", "Lucida Sans Unicode", verdana, geneva, sans-serif;
	font-size: 10pt;
	font-weight: bold;
	margin-bottom: 0px;
	margin-top: 0px;
	color: #447;
	background-color: transparent;
}

/** =============================================== */
/** == End of Link List table == */
/** =============================================== */