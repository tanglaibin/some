package com.itheima.demo3;

import org.springframework.transaction.annotation.Transactional;

/**
 * Transactional类上添加了注解，类中的所有的方法全部都有事务
 * @author Administrator
 */
@Transactional
public class AccountServiceImpl implements AccountService {
	
	private AccountDao accountDao;
	public void setAccountDao(AccountDao accountDao) {
		this.accountDao = accountDao;
	}
	
	/**
	 * 转账的方法
	 */
	public void pay(final String out, final String in, final double money) {
		// 先扣钱
		accountDao.outMoney(out, money);
		// 模拟异常
		int a = 10/0;
		// 加钱
		accountDao.inMoney(in, money);
	}
	
}
