package com.itheima.demo1;

import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallbackWithoutResult;
import org.springframework.transaction.support.TransactionTemplate;

public class AccountServiceImpl implements AccountService {
	
	private AccountDao accountDao;
	public void setAccountDao(AccountDao accountDao) {
		this.accountDao = accountDao;
	}
	
	// 注入事务的模板类
	private TransactionTemplate transactionTemplate;
	public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
		this.transactionTemplate = transactionTemplate;
	}
	
	/**
	 * 转账的方法
	 */
	public void pay(final String out, final String in, final double money) {
		transactionTemplate.execute(new TransactionCallbackWithoutResult() {
			// 事务的执行，如果没有问题，提交。如果出现了异常，回滚
			protected void doInTransactionWithoutResult(TransactionStatus arg0) {
				// 先扣钱
				accountDao.outMoney(out, money);
				// 模拟异常
				int a = 10/0;
				// 加钱
				accountDao.inMoney(in, money);
			}
		});
	}

}
