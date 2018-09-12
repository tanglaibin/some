1.自定义异常处理类
/**
 * @Description: 统一异常处理
 * @Author:		传智播客 java学院	传智宋江
 * @Company:	http://java.itcast.cn
 * @CreateDate:	2015年1月8日
 */
public class SysException extends Exception {
	private String message;
	public String getMessage() {
		return message;
	}
	
	public SysException(String message) {
		this.message = message;
	}
}

2.在struts.xml中进行全局异常的配置
<!-- 配置全局异常 sysException，error -->
		<global-results>
			<result name="sysException">/WEB-INF/pages/error.jsp</result>
			<result name="error">/WEB-INF/pages/error.jsp</result>
		</global-results>
		<global-exception-mappings>
			<exception-mapping result="sysException" exception="cn.itcast.jk.exceptioin.SysException"/>
			<exception-mapping result="error" exception="java.lang.Exception"/>
		</global-exception-mappings>

3.pages/error.jsp页面的加入
  两个图片加入WebRoot/images目录下

