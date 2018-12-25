package com.itheima.dao;

import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
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

	/**
	 * 修改客户
	 */
	public void update(Customer customer) {
		this.getHibernateTemplate().update(customer);
	}
	
	/**
	 * 通过主键，查询
	 */
	public Customer getById(Long id) {
		return this.getHibernateTemplate().get(Customer.class, id);
	}

	/**
	 * 查询所有
	 */
	public List<Customer> findAll() {
		List<Customer> list = (List<Customer>) this.getHibernateTemplate().find("from Customer");
		return list;
	}
	
	/**
	 * 查询所有的数据，使用QBC的查询
	 */
	public List<Customer> findAllByQBC() {
		DetachedCriteria criteria = DetachedCriteria.forClass(Customer.class);
		// 设置查询条件
		List<Customer> list = (List<Customer>) this.getHibernateTemplate().findByCriteria(criteria);
		return list;
	}

	/**
	 * 演示延迟加载
	 */
	public Customer loadById(long id) {
		return this.getHibernateTemplate().load(Customer.class, id);
	}
	
}
