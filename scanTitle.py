import sys
import requests
import threading
import re
import math
import time
import os
from requests.packages.urllib3.exceptions import InsecureRequestWarning
# 禁用安全请求警告
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)
onlyHttp = False  # 只输出带http/https域名
def getUrls(filename):
    f = open(filename,'r',encoding="utf8")
    lines = f.readlines()
    urls = [url.strip() for url in lines]
    return urls
def check_http(target):
    """检测目录是否为http服务"""
    target = target.strip()
    headers={"User-Agent":"Mozilla/5.0 (compatible; Baiduspider-render/2.0; +http://www.baidu.com/search/spider.html)"}
    try:
        url = "%s://%s/" % ("http",target)
        req = requests.get(url,headers=headers,verify=False,timeout=10)
        if req.status_code == 302 and "Location" in req.headers.keys():
            if str(req.headers['Location']).startswith('https'):
                return "https"
        if req.status_code == 200:
            r = re.search(r"<meta\shttp-equiv=\"refresh\"\scontent=\"[0-9]*;url=(.*?)\">",req.text)
            if r:
                if r.group(1).startswith('https'):
                    return "https"
        return "http"
    except:
        try:
            url = "%s://%s/" % ("https",target)
            requests.get(url,headers=headers,verify=False,timeout=10)
            return "https"
        except:
            return False
def get_console_width():
    return int(os.get_terminal_size().columns)

def getTitle(url):
    server = ""
    console_width = get_console_width()
    aa = (0.3,0.3,0.1) if console_width > 80 else (0.4,0.2,0.3)
    a5 = int(console_width*aa[0])
    a4 = int(console_width*aa[1])
    try:
        http = check_http(url)
        if http and not onlyHttp:
            url = "%s://%s/" % (http,url)
            reqs = requests.get(url,timeout=10,verify=False)
            if reqs.status_code == 200:
                html = reqs.text
                if 'Content-Type' in reqs.headers.keys() and 'charset' in reqs.headers['Content-Type']:
                    en = re.search(";(\s|)charset=(.*?)$|charset=\"(.*?)\"",reqs.headers['Content-Type'])
                else:
                    en = re.search(";(\s|)charset=(.*?)\"|charset=\"(.*?)\"",reqs.text)
                if en:
                    reqs.encoding=en.group(3) if en.group(2) == None else en.group(2)
                    html = reqs.text
                title_re = re.search(r"<title>(.*?)</title>", html)
                if title_re:
                    t = title_re.group(1)
                    if 'Server' in reqs.headers.keys():
                        server = reqs.headers['Server']
                    print(url.ljust(a5),server.ljust(a4),t)
                    
            elif reqs.status_code in [404,403]:
                pass
                print(url.ljust(a5),server.ljust(a4),reqs.status_code)
        else:
            if http:
                print("%s://%s/" % (http,url))
    except Exception as e:
        pass
        #print(e)
def start(filename,threads=2):
    urls = getUrls(filename)
    for url in urls:
        while threading.active_count() > int(threads):
            time.sleep(0.5)
        threading.Thread(target=getTitle,args=(url,)).start()
if __name__ == '__main__':
    if '-s' in sys.argv:
        onlyHttp = True
        sys.argv.remove('-s')
    if len(sys.argv) >2:
        start(sys.argv[1],sys.argv[2]) 
    else:
        start(sys.argv[1])
