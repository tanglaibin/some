package com.itheima.demo2;

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
