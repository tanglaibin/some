1.�Զ����쳣������
/**
 * @Description: ͳһ�쳣����
 * @Author:		���ǲ��� javaѧԺ	�����ν�
 * @Company:	http://java.itcast.cn
 * @CreateDate:	2015��1��8��
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

2.��struts.xml�н���ȫ���쳣������
<!-- ����ȫ���쳣 sysException��error -->
		<global-results>
			<result name="sysException">/WEB-INF/pages/error.jsp</result>
			<result name="error">/WEB-INF/pages/error.jsp</result>
		</global-results>
		<global-exception-mappings>
			<exception-mapping result="sysException" exception="cn.itcast.jk.exceptioin.SysException"/>
			<exception-mapping result="error" exception="java.lang.Exception"/>
		</global-exception-mappings>

3.pages/error.jspҳ��ļ���
  ����ͼƬ����WebRoot/imagesĿ¼��

