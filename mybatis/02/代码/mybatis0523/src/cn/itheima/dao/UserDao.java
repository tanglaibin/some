package cn.itheima.dao;

import java.util.List;

import cn.itheima.pojo.User;

public interface UserDao {

	public User findUserById(Integer id);
	
	public List<User> findUserByUserName(String userName);
}
