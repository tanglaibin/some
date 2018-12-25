package com.itheima.demo1;

import org.junit.Test;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

/**
 * 演示的JDBC的模板类
 * @author Administrator
 */
public class Demo1 {
	
	/**
	 * 演示模板类
	 */
	@Test
	public void run1(){
		// Spring框架提供了内置的连接池，不想使用内置，整合其他的连接池
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName("com.mysql.jdbc.Driver");
		dataSource.setUrl("jdbc:mysql:///spring_day03");
		dataSource.setUsername("root");
		dataSource.setPassword("root");
		// 创建模板类
		JdbcTemplate template = new JdbcTemplate();
		// 设置连接池
		template.setDataSource(dataSource);
		// 完成操作
		template.update("insert into t_account values (null,?,?)", "冠希",10000);
	}
	
}















































