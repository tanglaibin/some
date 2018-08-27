package cn.itheima.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/login")
public class LoginController {

	//跳转到登录页面
	@RequestMapping("/login")
	public String login() throws Exception{
		return "login";
	}
	
	@RequestMapping("/submit")
	public String submit(String username, String pwd ,HttpServletRequest request) throws Exception{
		
		HttpSession session = request.getSession();
		//判断用户名密码的正确性,如果正确则将登录信息放入session中
		//这里简写,真正项目中需要去数据库中校验用户名和密码
		if(username != null){
			session.setAttribute("username", username);
		}
		
		//跳转到列表页
		return "redirect:/items/list";
	}
}
