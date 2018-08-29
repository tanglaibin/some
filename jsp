1，得到工程根路径 全路径名
<%=request.getContextPath()%>
jquery下 ：${pageContext.request.contextPath}
 
2，打开新窗口，得到值，传递到之前窗口  window.opener
function getPerson(devicemodel) {
	document.getElementById("involvedBoard").value = devicemodel;
}

function selectT() {
	var devicemodelList = document.getElementsByName("devicemodels");
	window.opener.getPerson(devicemodelList[0].value);
	window.close();
}

















