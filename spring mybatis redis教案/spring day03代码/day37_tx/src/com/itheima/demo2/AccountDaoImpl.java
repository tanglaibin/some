package com.itheima.demo2;

import org.springframework.jdbc.core.support.JdbcDaoSupport;

public class AccountDaoImpl extends JdbcDaoSupport implements AccountDao {
	
	/**
	 * 扣钱
	 */
	public void outMoney(String out, double money) {
		this.getJdbcTemplate().update("update t_account set money = money - ? where name = ?", money,out);
	}
	
	/**
	 * 加钱
	 */
	public void inMoney(String in, double money) {
		this.getJdbcTemplate().update("update t_account set money = money + ? where name = ?", money,in);
	}

}
