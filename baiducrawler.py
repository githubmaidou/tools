import requests
import re
import math
import sys
import time
from bs4 import BeautifulSoup
headers = { "Accept":"text/html,application/xhtml+xml,application/xml;",
            "Accept-Encoding":"gzip",
            "Accept-Language":"zh-CN,zh;q=0.8",
            "Referer":"https://www.baidu.com/",
            "User-Agent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36"
            }
def get_pagenum(url,site=False):
	try:
		req = requests.get(url,headers=headers)
		text = req.text
		if site:
			r = re.search(r"<b style=\"color:#333\">(.*?)<\/b>",text)
		else:
			r = re.search(r"找到相关结果约(.*?)个",text)
		if r:
			num = r.group(1)
		else:
			num = '0'
		num = int(num.replace(",",""))
		return(num)
	except Exception as e:
		print(e)
		return 0
def set_keyword(keyword,site=False,gpc="0"):
	http = "https://www.baidu.com/s?wd=%s&gpc=%s&ie=utf-8" % (keyword,gpc)
	return http
def search(keyword,site=False,gpc="0"):
	"""gpc为搜索时间参数"""
	urls=[]
	if keyword.find('site:') > -1:
		site = True
	if gpc == 'd':
		t = int(time.time())
		tt = t - 86400
		gpc = "stf%%3D%s%%2C%s%%7Cstftype%%3D1" % (tt,t)
		site = False
	url = set_keyword(keyword,site,gpc)
	num = get_pagenum(url,site)
	num_mix = 0
	num_max = 75 if num/10 > 75 else math.ceil(num/10)
	print("发现%s页" % num_max)
	for i in range(num_max):
		print("开始爬第%s页" % (i+1))
		http = url + "&pn=%s" % (i*10)
		req = requests.get(http,headers=headers)
		text = req.text
		soup = BeautifulSoup(text,"html.parser")
		b_list = soup.find_all("a",class_="c-showurl") #baidu 跳转地址
		for b in b_list:
			req = requests.get(b["href"],headers=headers,allow_redirects = False)
			text = req.headers["Location"]
			urls.append(text)
	print("总共爬取%s条" % (len(urls)))
	return urls
if len(sys.argv) > 2:
	print(search(sys.argv[1],gpc=sys.argv[2]))
else:
	print(search(sys.argv[1]))
