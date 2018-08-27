package cn.itheima.test;

import org.junit.Before;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import cn.itheima.dao.UserDao;
import cn.itheima.pojo.User;

public class UserDaoTest {

	private ApplicationContext applicatonContext;
	
	@Before
	public void setUp() throws Exception{
		String configLocation = "classpath:ApplicationContext.xml";
		applicatonContext = new ClassPathXmlApplicationContext(configLocation);
	}
	
	@Test
	public void testFindUserById() throws Exception{
		//获取UserDao对象, getBean中的字符串是在ApplicationContext.xml中声明的
		UserDao userDao = (UserDao)applicatonContext.getBean("userDao");
		
		User user = userDao.findUserById(1);
		System.out.println(user);
	}
}
