action获取response，向浏览器写文字时，设置字符：

HttpServletResponse response = ServletActionContext.getResponse();	
response.setContentType("text/html;charset=UTF-8");


根据类标签数量，阻止表单提交，以及提交时提示为空等信息：
onsubmit="return checkForm()"

function checkForm(){
// 先让校验名称的方法先执行以下
checkcode();
// 获取error的数量，如果数量 > 0，说明存在错误，不能提交表单
if($(".error").size() > 0){
return false;
}
}



<error-page>
  <error-code>500</error-code>
  <location>/jsp/error.jsp</location>
  </error-page>




包下配置全局结构页面：
 <!-- 配置全局的结果页面 -->
<global-results>
<result name="login" type="redirect">/login.jsp</result>
</global-results>



qbc查询：
DetachedCriteria criteria = DetachedCriteria.forClass(User.class);
		//增加查询条件
		criteria.add(Restrictions.eq("user_code", user.getUser_code()));
		criteria.add(Restrictions.eq("user_password", user.getUser_password()));
		criteria.add(Restrictions.eq("user_state", "1"));
		List<User> list = (List<User>) this.getHibernateTemplate().findByCriteria(criteria);

		
		Pagebean<Customer> page=new Pagebean<Customer>();
		page.setCurrentpage(currentpage);
		page.setPagesize(pagesize);
		//count
		criteria.setProjection(Projections.rowCount());
		List<Number> list = (List<Number>) this.getHibernateTemplate().findByCriteria(criteria);
		if(list!=null && list.size()>0){
			int totalcount= list.get(0).intValue();
			page.setTotalcount(totalcount);
		}
		//清空查询条件
		criteria.setProjection(null);
		//list
		List<Customer> list2 = (List<Customer>) this.getHibernateTemplate().findByCriteria(criteria, (currentpage-1)*pagesize, pagesize);
		page.setList(list2);
		
		return page;
	}
		
		


session移除user  不要销毁session


ServletActionContext.getRequest().getSession().setAttribute("user", u);



域中有值 ，用转发。


action中压栈  取得值栈  set 放入map。


jsp页面加载后  功能：
$(function(){
		alert("xxx");
	});


jQuery 遍历 dom 操作：
$(data).each(function(i,n){
		//alert(n.dict_item_name);
		$("#levelid").append("<option value='"+n.dict_id+"'>"+n.dict_item_name+"</option>");
	});







正则表达式规则：
\\d  表示0-9；
\\D  表示不是数字。

外国是0-11月，我国是1-12月。
国外星期是0-6，我国是1-7。 

接口是更加抽象方法的集合，是服务特定的类的，实现他们功能的拓展，比如迭代器接口，是服务collection集合类的，collection子类调用方法，返回迭代器接口实现类对象，再通过调用接口实现类对象重写接口的方法，完成对collection子类的操作。【就类似于厨师是vip的实现类，厨师满足vip接口要求，厨师通过vip接口方法要求，实现更特殊的功能，如加盐；集合也是一样，通过迭代器实现自身更特殊的功能——遍历，只不过不是通过实现的方法直接调用接口，而是通过集合自身方法，将自身转换返回迭代器接口实现类对象，进而调用迭代器方法操作。】【说白了，就是迭代器这个接口有功能，它的实现类重写他的方法，实现具体化。】

list接口三大特性：
1，有序录入，有序取出；
2，有索引，可以编辑内部内容；
3，可以有重复数据录入。


遍历方式：
1，iterator迭代器
2，for循环
3，增强for循环【不能遍历map（set），因为没有索引，无序的，可以通过set方法间接遍历map；list有索引。】

引用类型不能用==比较是否等于，他们不是基本数据类型，而要用equals进行比较。比如string。


数据存储结构：
1，堆栈，类似于子弹夹，先进后出。
2，队列，类似于安检，先进先出。
3，数组，查找快，增删慢。
4，链表式，查找慢，增删快。


接口内部接口都是静态的，因为如果不是静态的，它是接口的内部成员，须由对象调用，而父接口是不能建立对象的。要有静态类名调。


接口就是个带有功能的类，有自己的特殊自有方法。主要的思想，就是返回该接口的对象，或者直接继承它，调用它的方法。

内部类调用，由外部类.内部类 调用。

一个自定义类的组成部分：
如person类
1，私有变量，private。
2，get set方法。
3，构造器（含空参构造器）。
4，重写tostring方法。
5，重写hashcode和equals方法。【看是否要写入哈希表，以保证map类集合 键等唯一性】
6，把序列号固定下来，static final long serialversionuid。编译器再给java文件编程成class文件时，就不会再给对象生成序列号了。

Ctrl shift o  导包。

writer字符输出流  写数据  要做刷新。流要关，.close。

writer字符流  输入100，得到的是d，要走码表；printwriter打印流，打印100，得到100，因为是原样输出。

接口的好处：是功能方法的集合；其次，解决了类的单继承局限，降低耦合性。

父类抛异常  子类可抛可不抛。



java：

Ctrl+o  展示javabean 类所含方法

ctrl shift o 导入类包

Ctrl shift f  格式化页面
eclipse 页面格式化快捷键

对象转int等基本数据类型  不能强转   用对象的方法转，比如long值对象转int，long.intvalue。

java \ 符号转义

mvc设计思想  业务逻辑 代码 显示相分离

c3p0

配置java home

数组（length）
list（add、size、get[index]）  有序
hashmap（put、键值对形式元素 name value、get[name]）
hashset(add)  无序

重定向
请求转发
隐藏域

mime类型  jason 格式

相对路径  绝对路径



配置bin目录




设计  图层混合模式加深理解：   设计卖点  她发广告
线性减淡：实际意义，给选区加光，强化亮光部分。
强光模式：图片反差增大，白场到黑场之间层次减弱。



csdn
18501408569
1234qwer,,






如果使用了request域 必须使用请求转发，
其他随便  请求转发 重定向。

如果访问站外资源，必须使用重定向。

cookie不支持写入中文


Ctrl t  体系结构

方法加强重写
装饰者模式 静态代理

listener（了解）
filter
servlet
Javaweb三大组件  后面框架对齐封装

class.forname(driverclass)注册数据库驱动
 

所有的jsp页面不让直接访问，不安全，Jsp也是个servlet，把所有的jsp servlet放到webinfo目录下，浏览器直接访问不到，通过java代码请求转发访问到。


ssh框架整合遇到的几个问题：
1，依赖注入，属性名与id名要区别开来。
2，spring 往action 中注入service问题，属性名与id名要一致。
3，javabean与映射文件，类路径要确认好。

action对应的是服务器端行为，请求转发也是服务器端行为，浏览器客户端行为。重定向是客户端行为，不能访问web-inf下文件资源。如果值栈中 域中有值，一般使用请求转发，如果是重定向，二次转发，值栈中值会没了。


el表达式 ${   } 默认就是调用get方法。



压栈后，只能用请求转发，不能用重定向，重定向是两次请求，发新请求时，值栈空了，只能用请求转发。


http://localhost:8080/store/user?method=ddd
http://localhost:8080/store/jsp/index.jsp


domain实例化类  如果要跟流有关，比如要读写，一般要实现序列化接口。


访问相应页面方法：

1，访问jsp页面，页面直接转发到新页面及servlet【示例：<jsp:forward page="/index"></jsp:forward>】；如index页面。

2，jsp页面点击按钮，直接访问servlet【示例：href="${pageContext.request.contextPath }/user?method=registUI】，servlet（处理相应数据）返回相应页面路径，base请求转发打开。如点击首页注册按钮。

jsp页面写链接：
${pageContext.request.contextPath }/user?method=registUI
等同于
/store/user?method=registUI


将数据放入域中：
request.setAttribute("list", list);




form表单要提交数据，必须给字段要添加name属性。


alt  shift  r 快速重命名


自定义转换器——
字符串装成时间类型的是出现错误
BeanUtils不支持字符串装成时间

解决方案:
自定义转化器
1.编写一个类 实现Conventer接口
2.实现方法
convert(转换成的类型,前台页面传入的字符串)
3.注册转化器 在封装数据之前注册
ConvertUtils.register(new MyConventer(), Date.class);

jsp页面导入c标签
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


//session 重定向
request.getSession().setAttribute("user", user);
response.sendRedirect(request.getContextPath()+"/");
return null;

//转发到此页面
request.getRequestDispatcher(s).forward(request, response);






byte[] data = "abcde大好大号等级啊毫无动静啊我的".getBytes();


String str = "\r\n"+"itcast";
fos.write(str.getBytes());


String str="akdbkbdkadb";
byte[] br= str.getBytes();
System.out.println(new String(br,0,3));


字符的编码过程
计算机底层数据存储的都是二进制数据，而我们生活中的各种各样的数据，如何才能和计算机中存储的二进制数据对应起来呢？
这时老美他们就把每一个字符和一个整数对应起来，就形成了一张编码表，老美他们的编码表就是ASCII表。其中就是各种英文字符对应的编码。

能识别中文的码表：GBK、UTF-8；正因为识别中文码表不唯一，涉及到了编码解码问题。
对于我们开发而言；常见的编码 GBK  UTF-8  ISO-8859-1
文字--->(数字) ：编码。 “abc”.getBytes()  byte[]
(数字)--->文字  : 解码。 byte[] b={97,98,99}  new String(b) 



【读取字符的字节数值，并转成字符】
FileReader fr = new FileReader("C:\\tlb\\1.txt");
int ch = 0;
while((ch = fr.read())!=-1){
//输出的字符对应的编码值
System.out.println(ch);
//输出字符本身
System.out.println((char)ch);
}






