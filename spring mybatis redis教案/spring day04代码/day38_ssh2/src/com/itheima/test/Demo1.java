package com.itheima.test;

import java.util.List;

import javax.annotation.Resource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.itheima.domain.Customer;
import com.itheima.service.CustomerService;

/**
 * 测试Hibernate模板类的简单方法
 * @author Administrator
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext.xml")
public class Demo1 {
	
	@Resource(name="customerService")
	private CustomerService customerService;
	
	/**
	 * 测试
	 */
	@Test
	public void run1(){
		Customer customer = new Customer();
		customer.setCust_id(1L);
		customer.setCust_name("测试");
		customerService.update(customer);
	}
	
	/**
	 * 查询某个客户
	 */
	@Test
	public void run2(){
		Customer customer = customerService.getById(2L);
		System.out.println(customer);
	}
	
	/**
	 * 查询所有客户
	 */
	@Test
	public void run3(){
		List<Customer> list = customerService.findAll();
		System.out.println(list);
	}
	
	/**
	 * QBC查询所有的数据
	 */
	@Test
	public void run4(){
		List<Customer> list = customerService.findAllByQBC();
		System.out.println(list);
	}
}


















