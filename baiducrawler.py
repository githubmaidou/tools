import requests,re,math,sys
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
			r = re.search(r"该网站共有(.*?)个网页被百度收录")
		else:
			r = re.search(r"百度为您找到相关结果约(.*?)个",text)
		if r:
			num = r.group(1)
		else:
			num = '0'
		num = int(num.replace(",",""))
		return(num)
	except Exception as e:
		print("Error: %s" , e)
		return 0
def set_keyword(keyword,site=False):
	if site:
		http = "https://www.baidu.com/s?wd=site:%s&ie=utf-8" % keyword
	else:
		http = "https://www.baidu.com/s?wd=%s&ie=utf-8" % keyword
	return http
def get_urls(keyword,site=False):
	urls=[]
	if keyword.find('site:') > -1:
		site = True
	url = set_keyword(keyword,site)
	num = get_pagenum(url,site)
	num_mix = 0
	num_max = 75 if num/10 > 75 else math.ceil(num/10)
	print(num_max)
	for i in range(num_mix,num_max):
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

print(get_urls("sinosig.com"))

import requests,re,math
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
			r = re.search(r"该网站共有(.*?)个网页被百度收录")
		else:
			r = re.search(r"百度为您找到相关结果约(.*?)个",text)
		if r:
			num = r.group(1)
		else:
			num = '0'
		num = int(num.replace(",",""))
		return(num)
	except Exception as e:
		print("Error: %s" , e)
		return 0
def set_keyword(keyword,site=False):
	if site:
		http = "https://www.baidu.com/s?wd=site:%s&ie=utf-8" % keyword
	else:
		http = "https://www.baidu.com/s?wd=%s&ie=utf-8" % keyword
	return http
def get_urls(keyword,site=False):
	urls=[]
	if keyword.find('site:') > -1:
		site = True
	url = set_keyword(keyword,site)
	num = get_pagenum(url,site)
	num_mix = 0
	num_max = 75 if num/10 > 75 else math.ceil(num/10)
	print(num_max)
	for i in range(num_mix,num_max):
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

print(get_urls(sys.argv[1]))
