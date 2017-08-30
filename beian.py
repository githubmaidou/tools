import requests,re,sys
def get_beian(domain):
	if domain.find('://') > -1:
		print("Error:%s 不是一个有效的域名" % (domain))
		exit()
	http = "http://www.baidu.com/s?wd=site:%s&ie=utf-8" % (domain)
	req = requests.get(http)
	text = req.text
	r = re.search(r"备案方：(.*?)</p>",text)
	if r:
		print(r.group(1))
	else:
		print("Error:没有找到备案信息")
get_beian(sys.argv[1])

