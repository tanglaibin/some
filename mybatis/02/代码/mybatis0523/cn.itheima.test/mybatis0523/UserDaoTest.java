package mybatis0523;

import java.io.InputStream;
import java.util.List;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.junit.Before;
import org.junit.Test;

import cn.itheima.dao.UserDao;
import cn.itheima.dao.UserDaoImpl;
import cn.itheima.pojo.User;

public class UserDaoTest {

	private SqlSessionFactory factory;
	
	//作用:在测试方法前执行这个方法
	@Before
	public void setUp() throws Exception{
		String resource = "SqlMapConfig.xml";
		//通过流将核心配置文件读取进来
		InputStream inputStream = Resources.getResourceAsStream(resource);
		//通过核心配置文件输入流来创建会话工厂
		factory = new SqlSessionFactoryBuilder().build(inputStream);
	}
	
	@Test
	public void testFindUserById() throws Exception{
		//将初始化好的工厂注入到实现类中
		UserDao userDao = new UserDaoImpl(factory);
		
		User user = userDao.findUserById(1);
		System.out.println(user);
	}
	
	@Test
	public void testFindUserByUserName () throws Exception{
		
		UserDao userDao = new UserDaoImpl(factory);
		
		List<User> list = userDao.findUserByUserName("王");
		System.out.println(list);
	}
}
