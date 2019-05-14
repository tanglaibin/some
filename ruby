了解です    


tang.laibin@tci-cn.co.jp

copy env_sample.txt .env


$ git config --global user.name “tanglaibin”
$ git config --global user.email “tang.laibin@tci-cn.co.jp”


ssh-keygen -t rsa -C "tang.laibin@tci-cn.co.jp"

AWS：
ssh-keygen -t rsa -C "tang.laibin@tci-cn.co.jp" -f ~/.ssh/id_rsa -P ""

cat ~/.ssh/id_rsa.pub

ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDwyWYaoAQAIByI1w5vIfUhjdP8+YpzjzP1uOFly67ioE1tqF0kN0/BlvXIYeSivYpXoM09iIUgfRYUF1EqI31Tqww0qpeyhao41OUC9pl9ZrSfNuCCYtgXGh3a/JtxkpA5RFBZsMB5HdNe4qwXlqqDIrvro2OSyLNZRU5IIW8hIqLRe7P+b2+TsSVd4Gc0WKGjgCLqgNn1QQhw0c2tTaDQGS2rCH8WGFnetU3rsVL4gbbM3IpEkZiRa+3t/zujqzL9IcaTUl5pKmnIyZoyeX5ZoqS9ANXwEZtK+7SRQwnWAAVobm1+WU4z1g2AbLN1vHHRVyUv5biwgL2+71+x/tSd tang.laibin@tci-cn.co.jp													


git remote add origin git@bitbucket.org:tanglaibin/hello_app.git
git push -u origin master


git clone -b poc http://redmine.tci-cn.co.jp/gitlab/intra/approvalsys.git
git clone -b poc http://redmine.tci-cn.co.jp/gitlab/intra/approvalsys.git



bundle install
rails db:migrate
rails db:seed
rails s


rake db:migrate


gem install sqlite3 -v "=3.28.0" --platform=ruby -- --with-sqlite3-include=C:\sqlite-amalgamation-3280000 --with-sqlite3-lib=C:\Ruby24-x64\bin


gem install rails -v 5.1.7							



rails new lesson01
rails _5.1.6_ new hello_app
bundle install
bundle update

大量的 gem（代码库，一个 gem 解决一个特定的问题，例如分页和图像上传）；
创建完一个新的 Rails 应用后，下一步是使用 Bundler 安装和引入该应用所需的 gem。
gem 'uglifier', '>= 1.3.0' 
安装版本号大于或等于 1.3.0 的 uglifier


gem 'coffee-rails', '~> 4.0.0'
安装版本号大于或等于 4.0.0，但不大于 4.1 的 coffee-rails。

rails server


cd ~/environment/hello_app/
rm -rf app/controllers/
-rf 旗标的意思是“强制递归”，无需明确征求同意就递归删除所有文件、目录和子目录等。

ls app/controllers/


Rails 采用了“模型-视图-控制器”（简称 MVC）架构模式。

把应用中的数据（例如用户信息）与显示数据的代码分开，这是图形用户界面（Graphical User Interface，简称 GUI）常用的架构方式。

与 Rails 应用交互时，浏览器发出一个请求（request），Web 服务器收到请求之后将其传给 Rails 应用的控制器，决定下一步做什么。某些情况下，控制器会立即渲染视图（view），生成 HTML，然后发送给浏览器。在动态网站中，更常见的是控制器与模型（model）交互。模型是一个 Ruby 对象，表示网站中的一个元素（例如一个用户），并且负责与数据库通信。与模型交互后，控制器再渲染视图，把生成的 HTML 返回给浏览器。

ls app/controllers/*_controller.rb

要告诉 Rails 使用这个动作，而不再显示默认的首页。为此，我们要修改 Rails 路由器（router）。路由器在控制器之前，决定浏览器发给应用的请求由哪个动作处理。


如何定义根路由
root 'controller_name#action_name'
root 'application#hello'

使用倒置的感叹号（如“¡Hola, mundo!”中的第一个字符），证明 Rails 支持非 ASCII 字符。





执行 git add -A 命令，把项目中的所有文件都放到仓库中：

$ git add -A
这个命令会把当前目录中的所有文件都放到仓库中，但是匹配特殊文件 .gitignore 中模式的文件除外。rails new 命令会自动生成一个适用于 Rails 项目的 .gitignore 文件，此外你还可以添加其他模式。

加入仓库的文件一开始位于暂存区（staging area），这一区用于存放待提交的内容。执行 status 命令可以查看暂存区中有哪些文件：

$ git status

如果想让 Git 保存这些改动，使用 commit 命令：
$ git commit -m "Initialize repository"
-m 旗标的意思是为这次提交添加一个说明。如果没指定 -m 旗标，Git 会打开系统默认使用的编辑器，让你在其中输入说明。

如何把改动推送到远程仓库（使用 git push 命令）。
可以使用 log 命令查看提交历史。
$ git log

如果仓库的提交历史很多，可能需要输入 q 退出。

本地，推送代码到远端git仓库：
git remote add origin git@bitbucket.org:tanglaibin/hello_app.git

先告诉 Git，你想添加 Bitbucket 作为这个仓库的源（origin），然后再把仓库推送到这个远端的源。（别管 -u 旗标的意思，如果好奇，可以搜索“git set upstream”。）当然了，你要把 <username> 换成你自己的用户名。例如，我执行的命令是：$ git remote add origin git@bitbucket.org:railstutorial/hello_app.git

git push -u origin master


GitHub 和 Bitbucket
目前，托管 Git 仓库最受欢迎的网站是 GitHub 和 Bitbucket。这两个网站有很多相似之处：都能托管仓库，也可以协作，而且浏览和搜索仓库很方便。但二者之间有个重要的区别（对本书而言）：GitHub 为开源项目提供无限量的免费仓库，但私有仓库收费；而 Bitbucket 提供了无限量的私有仓库，仅当协作者超过一定数量时才收费。所以，选择哪个网站，取决于具体的需求。


使用 cat 命令打印公钥
$ cat ~/.ssh/id_rsa.pub




执行 rails new 命令（明确指定版本号）
$ cd ~/environment
$ rails _5.1.6_ new hello_app
      create
      create  README.md


README.md 文件由rails new 命令自动生成


Markdown 是一门人类可读的标记语言，易于转换成 HTML






分支
Git 分支（branch）的功能很强大。分支是对仓库的高效复制，在分支中所做的改动（或许是实验性质的）不会影响父级文件。大多数情况下，父级仓库是 master 分支。我们可以使用 checkout 命令，并指定 -b 旗标，创建一个新主题分支（topic branch）：

$ git checkout -b modify-README
Switched to a new branch 'modify-README'
$ git branch
  master
* modify-README
其中，第二个命令 git branch 的作用是列出所有本地分支。星号（*）表示当前所在的分支。注意，git checkout -b modify-README 命令先创建一个新分支，然后再切换到这个新分支——modify-README 分支前面的星号证明了这一点。

git branch 的作用是列出所有本地分支。星号（*）表示当前所在的分支。注意，git checkout -b modify-README 命令先创建一个新分支，然后再切换到这个新分支——modify-README 分支前面的星号证明了这一点。


本可以使用前面用过的 git add -A 命令，但是 git commit 命令提供了 -a 旗标，可以直接提交现有文件中的全部改动：$ git commit -a -m "Improve the README file"

使用 -a 旗标一定要小心，千万别误用了。如果上次提交之后项目中添加了新文件，应该使用 git add -A，先告诉 Git 新增了文件。


合并
我们已经改完了，现在可以把结果合并（merge）到主分支了：

$ git checkout master
Switched to branch 'master'
$ git merge modify-README

合并之后，我们可以清理一下分支——如果主题分支不用了，可以使用 git branch -d 命令将其删除：
$ git branch -d modify-README

还可以使用 git branch -D 命令放弃主题分支中的改动：


在大多数系统中都可以省略 origin master，直接执行 git push 命令：
$ git push

















