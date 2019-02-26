# tools
	自己写的PYTHON小工具集(渗透测试工具集)
	beian.py                    备案查询小工具 beian.py baidu.com
	baiducrawler.py             百度关键字爬取小工具 baiducrawler.py 大黑客
	scanTitle.py                批量获取域名标题 scanTitle.py urls.txt 10 (线程)
	bingC.py                    用bing搜索的ip指令进行ip到域名的反查 bingC.py 127.0.0.1
	shodan.py                   用shadan接口查询ip开放端口，shodan.py 127.0.0.1 支持C段shodan.py 127.0.0.0/24	
	getKeyword.py               获取网页内容，生成关键字，和passdict项目可以一起用，生成密码字典；需要pypinyin,jieba,tldextract库
	ip138.py		    用ip138接口实现ip历史解析记录与子域名查询 ip138.py 127.1.1.1或github.com 
	dns.py			    copy以前乌云的代码。加一个A记录xxxx.domain.com指向服务器ip,再加一个ns记录dnslog.domain.com,指向xxxx.domain.com。test.dnslog.domain.com
	domain2ip.py		    使用socket.gethostbyname 查询域名对应ip。domain2ip.py domains.dict
	portScan.py		    如果目标是windows且将所有未开放的端口全转发到一个端口上，NMAP将显示说有端口开放。portScan.py -t 127.0.0.1-100 -p 80,8000-10000 -n 100 
	ip2domains.py		    使用virustotal.com的查询接口，实现ip反查域名，子域名查询。效果不错
	t3scan.py		    T3协议扫描，建议使用64位python
	nmap_oG.py		    对nmap -oG 的输出进行格式化127.0.0.1:80
	shellcode_injection.py	    shellcode注入工具,用pyinstaller转成exe后可免杀。使用：shellcode_injection.exe notepad.exe[进程名]，可先起一个notepad
	<shellcode_injection class="exe">将shellcode_injection.py转exe生成，使用：shellcode_injection.exe shellcode 进程名</shellcode_injection>
	/dirScan		    目录扫描项目
	/passdict                  根据关键字生成密码
	/cmd_bash                   常用的命令语句
	/burpext		    burp 插件。报错SQL注入检测、	
	/workflows                  Alfred workflows插件
		/strencode.py           alfred workflows,字符编码/解码小插件,支持Md5,Base64,Hex,ASCII的编码与解码

