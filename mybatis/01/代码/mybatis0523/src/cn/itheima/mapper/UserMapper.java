package cn.itheima.mapper;

import java.util.List;

import cn.itheima.pojo.User;

public interface UserMapper {

	public User findUserById(Integer id);
	
	//动态代理形势中,如果返回结果集问List,那么mybatis会在生成实现类的使用会自动调用selectList方法
	public List<User> findUserByUserName(String userName);
	
	public void insertUser(User user);
}
