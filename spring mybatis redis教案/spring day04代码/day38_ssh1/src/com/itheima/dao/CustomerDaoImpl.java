package com.itheima.dao;

import org.springframework.orm.hibernate5.support.HibernateDaoSupport;

import com.itheima.domain.Customer;

/**
 * 持久层
 * @author Administrator
 */
public class CustomerDaoImpl extends HibernateDaoSupport implements CustomerDao {
	
	/**
	 * 保存客户
	 */
	public void save(Customer customer) {
		System.out.println("持久层：保存客户...");
		// 把数据，保存到数据库中
		this.getHibernateTemplate().save(customer);
	}
	
}
