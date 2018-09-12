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




同一个问题关联到不同版本的补丁，新版本对应的测试人员变化后，所有版本的测试人员都变化为同一个，影响查询；补丁网站编辑需求时，输入类似“90%”格式语句，报错bug异常。
补丁网站 V2R2SPH016补丁，第20个问题，测试人员名字消失原因。
补丁网站，新建需求页面、编辑需求页面，更新问题涉及形态最新设备信息，并由之前手动输入设备型号，改为点击输入框，弹出新窗口下拉框多选形式，避免形态遗漏；
补丁网站，编辑需求页面，表单信息遗漏及中文乱码问题。













