package com.itheima.web.action;

import com.itheima.domain.Customer;
import com.itheima.service.CustomerService;
import com.opensymphony.xwork2.ActionSupport;
import com.opensymphony.xwork2.ModelDriven;

/**
 * 客户的控制层
 * @author Administrator
 */
public class CustomerAction extends ActionSupport implements ModelDriven<Customer>{
	
	private static final long serialVersionUID = 113695314694166436L;
	
	// 不要忘记手动new
	private Customer customer = new Customer();
	public Customer getModel() {
		return customer;
	}
	
	// 提供service的成员属性，提供set方法
	private CustomerService customerService;
	public void setCustomerService(CustomerService customerService) {
		this.customerService = customerService;
	}
	
	/**
	 * 保存客户的方法
	 * @return
	 */
	public String add(){
		System.out.println("WEB层：保存客户...");
		/*// WEB的工厂
		WebApplicationContext context = WebApplicationContextUtils.getWebApplicationContext(ServletActionContext.getServletContext());
		CustomerService cs = (CustomerService) context.getBean("customerService");
		// 调用方法
		cs.save(customer);*/
		
		customerService.save(customer);
		
		return NONE;
	}
	
	/**
	 * 演示的延迟加载的问题
	 * @return
	 */
	public String loadById(){
		Customer c = customerService.loadById(2L);
		// 打印客户的名称
		System.out.println(c.getCust_name());
		return NONE;
	}
	
}












