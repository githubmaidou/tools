# tools
	自己写的PYTHON小工具集(渗透测试工具集)
	scanTitle.py                批量获取域名标题 scanTitle.py urls.txt 10 (线程)
	shodan.py                   用shadan接口查询ip开放端口，shodan.py 127.0.0.1 支持C段shodan.py 127.0.0.0/24	
	getKeyword.py               获取网页内容，生成关键字，和passdict项目可以一起用，生成密码字典；需要pypinyin,jieba,tldextract库
	dns.py			    copy以前乌云的代码。加一个A记录xxxx.domain.com指向服务器ip,再加一个ns记录dnslog.domain.com,指向xxxx.domain.com。test.dnslog.domain.com
	domain2ip.py		    使用socket.gethostbyname 查询域名对应ip。domain2ip.py domains.dict
	portScan.py		    如果目标是windows且将所有未开放的端口全转发到一个端口上，NMAP将显示说有端口开放。portScan.py -t 127.0.0.1-100 -p 80,8000-10000 -n 100 
	ip2domains.py		    使用virustotal.com的查询接口，实现ip反查域名，子域名查询。效果不错
	t3scan.py		    T3协议扫描，建议使用64位python
	nmap_oG.py		    对nmap -oG 的输出进行格式化127.0.0.1:80
	weblogic_hash.py	    weblogic 6位随机路径名计算
	chunked.py		    复制t00ls w8ayy写的分块传输脚本。chunked.py "id=1' and 1=1 and ''='"
	ips2ipc.py		    ips2ipc.py /tmp/ip 把文件/tmp/ip内的独立IP转换成ip段,127.0.0.1;127.0.0.100 转换成127.0.0.1-100
	brute.py 		    爆破工具，暂时只支持ssh
	sub.py 			    多个接口查询子域名
	iis_shortname_Scan.py 	    复制lijiejie的iis短文件名漏洞利用工具
	tftp.py 		    python 实现tftp下载工具，UDP协议
 	aliyunECS.py 		    aliyun ECS命令执行并回显,需要先用pip安装aliyun sdk
	fofa.py 		    简单的fofa搜索工具,需要配置key
	redisWriteFile.py 	    redis写文件工具,支持python2,python3 会有点bug
	socks5.py2 		    python2下无需三方库实现socks5代理，来原互联网
	simple_http.py2 	    python2下无需三方库现实web服务与上传simple_http.py2	
	/dirScan		    目录扫描项目
	/passdict 		    根据关键字生成密码

