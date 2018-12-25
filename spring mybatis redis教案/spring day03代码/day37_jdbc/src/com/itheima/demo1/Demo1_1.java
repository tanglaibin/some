package com.itheima.demo1;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * 测试JDBC的模板类，使用IOC的方式
 * @author Administrator
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class Demo1_1 {
	
	@Resource(name="jdbcTemplate")
	private JdbcTemplate jdbcTemplate;
	
	@Test
	public void run1(){
		jdbcTemplate.update("insert into t_account values (null,?,?)", "小苍",10000);
	}
	
	/**
	 * update(String sql,Object...params)	可以完成增删改操作
	 */
	@Test
	public void run2(){
		jdbcTemplate.update("update t_account set name = ? where id = ?","熊大",4);
	}
	
	/**
	 * 删除测试
	 */
	@Test
	public void run3(){
		jdbcTemplate.update("delete from t_account where id = ?",4);
	}
	
	/**
	 * 测试查询：通过主键查询一条记录
	 */
	@Test
	public void run4(){
		Account ac = jdbcTemplate.queryForObject("select * from t_account where id = ?", new BeanMapper(), 1);
		System.out.println(ac);
	}
	
	/**
	 * 查询所有的数据
	 */
	@Test
	public void run5(){
		List<Account> list = jdbcTemplate.query("select * from t_account", new BeanMapper());
		System.out.println(list);
	}
	
}

/**
 * 自己手动的来封装数据（一行一行封装数据）
 * @author Administrator
 */
class BeanMapper implements RowMapper<Account>{
	
	public Account mapRow(ResultSet rs, int rowNum) throws SQLException {
		Account ac = new Account();
		ac.setId(rs.getInt("id"));
		ac.setName(rs.getString("name"));
		ac.setMoney(rs.getDouble("money"));
		return ac;
	}
}





























