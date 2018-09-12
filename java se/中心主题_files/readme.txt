

URLȨ�޹���




shiro��ȫ��ܣ�
+ehcache����

1����������pom.xml

		<!-- Apache Shiro Ȩ�޼ܹ� -->
		<dependency>
			<groupId>org.apache.shiro</groupId>
			<artifactId>shiro-all</artifactId>
			<version>1.2.3</version>
		</dependency>

2������filter��һ��filter�൱��10��filter��web.xml

	ע�⣺shiro��filter������struts2��filter֮ǰ������action�޷�����

    <!-- Shiro Security filter  filter-name������ֵ�ֵ����������spring���õ�  -->
    <filter>
        <filter-name>shiroFilter</filter-name>
        <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
        <init-param>
            <param-name>targetFilterLifecycle</param-name>
            <param-value>true</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>shiroFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>


3����spring applicationContext.xml�м���shiro�����ļ�,�������������֮ǰ����
<aop:aspectj-autoproxy proxy-target-class="true" />

ͬʱ���ר������shiro�������ļ�
<import resource="spring/applicationContext-shiro.xml"/>

��ehcache֧��ehcache-shiro.xml

<ehcache updateCheck="false" name="shiroCache">

    <defaultCache
            maxElementsInMemory="10000"
            eternal="false"
            timeToIdleSeconds="120"
            timeToLiveSeconds="120"
            overflowToDisk="false"
            diskPersistent="false"
            diskExpiryThreadIntervalSeconds="120"
            />
</ehcache>


4��applicationContext-shiro.xml������У��Ĳ��ԣ���ЩУ�飬��Щ����

<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"  
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"       
	xmlns:p="http://www.springframework.org/schema/p"  
	xmlns:context="http://www.springframework.org/schema/context"   
	xmlns:tx="http://www.springframework.org/schema/tx"  
	xmlns:aop="http://www.springframework.org/schema/aop"  
	xsi:schemaLocation="http://www.springframework.org/schema/beans    
	http://www.springframework.org/schema/beans/spring-beans.xsd    
	http://www.springframework.org/schema/aop    
	http://www.springframework.org/schema/aop/spring-aop.xsd    
	http://www.springframework.org/schema/tx    
	http://www.springframework.org/schema/tx/spring-tx.xsd    
	http://www.springframework.org/schema/context    
	http://www.springframework.org/schema/context/spring-context.xsd">
	
	<description>Shiro������</description>
	
	<!-- SecurityManager���� -->
	<!-- ����Realm�� -->
	<!-- ����Ƚ��� -->
	<!-- ����������ɣ� �ù���������Shiro����ع�����-->
	<!-- ���û��棺ehcache���� -->
	<!-- ��ȫ���� -->
    <bean id="securityManager" class="org.apache.shiro.web.mgt.DefaultWebSecurityManager">
        <!-- Single realm app.  If you have multiple realms, use the 'realms' property instead. -->
        <property name="realm" ref="authRealm"/><!-- �����Զ����realm -->
        <!-- ���� -->
        <property name="cacheManager" ref="shiroEhcacheManager"/>
    </bean>

    <!-- �Զ���Ȩ����֤ -->
    <bean id="authRealm" class="cn.itcast.jk.shiro.AuthRealm">
		<property name="userService" ref="userService"/>
		<!-- �Զ�����������㷨  -->
		<property name="credentialsMatcher" ref="passwordMatcher"/>
	</bean>
	
	<!-- ����������ܲ��� md5hash -->
	<bean id="passwordMatcher" class="cn.itcast.jk.shiro.CustomCredentialsMatcher"/>

    <!-- filter-name������ֵ�ֵ������web.xml��filter������ -->
    <bean id="shiroFilter" class="org.apache.shiro.spring.web.ShiroFilterFactoryBean">
        <property name="securityManager" ref="securityManager"/>
        <!--��¼ҳ��  -->
        <property name="loginUrl" value="/index.jsp"></property>
        <!-- ��¼�ɹ��� -->      
        <property name="successUrl" value="/home.action"></property>
        <property name="filterChainDefinitions">
            <!-- /**��������Ķ༶Ŀ¼Ҳ���� -->
            <value>
				/index.jsp* = anon
				/home* = anon
				/sysadmin/login/login.jsp* = anon
				/sysadmin/login/logout.jsp* = anon
				/login* = anon
				/logout* = anon
				/components/** = anon
				/css/** = anon
				/images/** = anon
				/js/** = anon
				/make/** = anon
				/skin/** = anon
				/stat/** = anon
				/ufiles/** = anon
				/validator/** = anon
				/resource/** = anon
				/** = authc
				/*.* = authc
            </value>
        </property>
    </bean>

    <!-- �û���Ȩ/��֤��ϢCache, ����EhCache  ���� -->
    <bean id="shiroEhcacheManager" class="org.apache.shiro.cache.ehcache.EhCacheManager">
        <property name="cacheManagerConfigFile" value="classpath:ehcache-shiro.xml"/>
    </bean>

    <!-- ��֤ʵ����Shiro�ڲ�lifecycle������beanִ�� -->
    <bean id="lifecycleBeanPostProcessor" class="org.apache.shiro.spring.LifecycleBeanPostProcessor"/>

    <!-- ���ɴ���ͨ��������п��� -->
    <bean class="org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator"
          depends-on="lifecycleBeanPostProcessor">
        <property name="proxyTargetClass" value="true"/>
    </bean>
    
    <!-- ��ȫ������ -->
    <bean class="org.apache.shiro.spring.security.interceptor.AuthorizationAttributeSourceAdvisor">
        <property name="securityManager" ref="securityManager"/>
    </bean>
	
</beans>


5���Զ���realm	AuthRealm

����֤����Ȩ�ڲ�ʵ�ֻ����ж����ᵽ�����մ���������Realm���д���
��Ϊ��Shiro�У�������ͨ��Realm����ȡӦ�ó����е��û�����ɫ��Ȩ����Ϣ�ġ�
ͨ������£���Realm�л�ֱ�Ӵ����ǵ�����Դ�л�ȡShiro��Ҫ����֤��Ϣ������˵��Realm��ר���ڰ�ȫ��ܵ�DAO.

public class AuthRealm extends AuthorizingRealm{
	private UserService userService;
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	//��Ȩ
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		System.out.println("��Ȩ");
		//��ȡ��ǰ�û�
		User user = (User)principals.fromRealm(getName()).iterator().next();
		//�õ�Ȩ���ַ���
		SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
		
		Set<Role> roles = user.getRoles();
		List<String> list = new ArrayList();
		for(Role role :roles){
			Set<Module> modules = role.getModules();
			for(Module m:modules){
				if(m.getCtype()==0){
					//˵�������˵�
					list.add(m.getCpermission());
				}
			}
		}

		info.addStringPermissions(list);
		return info;
	}
	//��֤  ��¼
	protected AuthenticationInfo doGetAuthenticationInfo(
			AuthenticationToken token) throws AuthenticationException {
		System.out.println("��֤");
		UsernamePasswordToken upToken = (UsernamePasswordToken)token;
		
		User user = userService.findUserByName(upToken.getUsername());
		if(user==null){
			return null;
		}else{
			AuthenticationInfo info = new SimpleAuthenticationInfo(user, user.getPassword(), getName());
			return info;
		}
		
	}

}


6���޸Ĵ�ͳ��¼Ϊshiro��¼

package cn.itcast.jk.action;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.crypto.hash.Md5Hash;
import org.apache.shiro.subject.Subject;

import cn.itcast.common.SysConstant;
import cn.itcast.jk.service.UserService;

/**
 * @Description: ��¼���Ƴ���
 * @Author:		���ǲ��� javaѧԺ	�ν�
 * @Company:	http://java.itcast.cn
 * @CreateDate:	2014��10��31��
 */
public class LoginAction extends BaseAction {

	private static final long serialVersionUID = 1L;

	private String username;
	private String password;

	private UserService userService;
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	
	public String login() throws Exception {	
		/*
		 * shiro��¼��ʽ�������û�����ȡ���룬����Ϊnull�Ƿ��û������������Ƿ��û���д������
		 * ��¼�ɹ���������httpsession�д�ŵ�ǰ�û��������͸�web�����󶨣�����̫���ܣ����Լ�����
		 * subject����ʵ���Լ���session�������web�������룬ʵ������ϡ�
		 */

		//����shiro�жϵ�ǰ�û��Ƿ���ϵͳ�û�
		Subject subject = SecurityUtils.getSubject();	//�õ���ǰ�û�
		//shiro�ǽ��û�¼��ĵ�¼�������루δ���ܣ���װ��token������
		UsernamePasswordToken token = new UsernamePasswordToken(userName,password);
		
		try{
			subject.login(token);	//�Զ�����AuthRealm.doGetAuthenticationInfo
			
			//дseesion�����浱ǰuser����
			User curUser = (User)subject.getPrincipal();			//��shiro�л�ȡ��ǰ�û�
			System.out.println(curUser.getDept().getDeptName());	//�������ر����������
			Set<Role> roles = curUser.getRoles();
			for(Role role :roles){
				Set<Module> moduless =  role.getModules();
				for(Module m :moduless)
				   System.out.println(m.getName());
			}
			session.put(SysConstant.CURRENT_USER_INFO, curUser);	//Principal ��ǰ�û�����
		}catch(Exception ex){
			super.put("errorInfo","�û������������������д!");
			ex.printStackTrace();
			
			return "login";
		}
		return SUCCESS;
	}
	
	public String logout(){
		session.remove(SysConstant.CURRENT_USER_INFO);		//ɾ��session
		return "logout";
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

}



7����Ȩ(��һ�ּ������ݵ�˼��   ��ʡ����Ϊ�ڵ�¼ʱ�Ѽ���)
�����û���ѯ����ɫ��Ӧ��Ȩ�ޣ�������Ȩ�޴�

-hql��service

	public List<String> getPermission(String userName) {
		List<String> _list = new ArrayList<String>();
		
		//�û�����ɫ��Ȩ�ޣ�������Զ࣬ʹ��left join����ʵ��
		String hql = "select p from User as u left join u.roles as r left join r.modules as p where u.username='"+userName+"'";
		List<Module> moduleList = baseDao.find(hql, Module.class, null);
		
		for(Module m : moduleList){
			if(m!=null){	//�۲�hibernateʵ�ֵ�SQL������һ��Null��¼
				_list.add(m.getName());
			}
		}
		
		return _list;
	}



��realm�н�����ȨuserService.getPermission

	//��Ȩ
	protected AuthorizationInfo doGetAuthorizationInfo(
			PrincipalCollection principals) {
		log.info("ִ����Ȩ...");
		
		//��ȡ��¼�û���Ȩ�ޣ����jspҳ���е�shiro��ǩ���п���
		User curUser = (User) principals.fromRealm(getName()).iterator().next();  
		String userName = curUser.getUsername();
		List<String> sList = userService.getPermission(userName );
		SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
		for(String permission : sList){
			//���õ�ǰ�û���Ȩ��
			authorizationInfo.addStringPermission(permission);
		}

		return authorizationInfo;
	}


8��ҳ��ʹ��shiro��ǩ��/home/title.jsp ���˵�


<%@ taglib uri="http://shiro.apache.org/tags" prefix="shiro"%>


			    		<shiro:hasPermission name="sysadmin">
			    		<span id="topmenu" onclick="toModule('sysadmin');">ϵͳ����</span>
			    		</shiro:hasPermission>

