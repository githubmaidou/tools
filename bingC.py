import requests
import re
import time
import json
import sys

class bingSearch:
    def __init__(self):
        self.num = -1
        self.proxys = self.githubproxy()
 
    def githubproxy(self):
        proxy = []
        s = requests.get("http://proxylist.nslookup.site/proxylist.json")
        
        t = s.text.split('\n')[:-1]
        for p in t:
            e = json.loads(p)
            proxy.append(e['host'].strip() + ':' + str(e['port']).strip())
        return proxy

    def get_proxy(self):
        self.num = self.num + 1
        ip = self.proxys[self.num]
        proxy = {'http':'http://' + ip,'https':'https://'+ip}
        return proxy



    def get_urls(self,ip):
        self.domains = []
        self.headers = {}
        self.headers['User-Agent'] = 'User-Agent:Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36'
        self.req = requests.Session()
        r  = self.req.get("https://www.bing.com/",headers=self.headers)
        bing_url = "https://www.bing.com/search?q=ip%%3A%s" % ip
        arr = self.urls(bing_url)
        pages = arr[-1]
        urls = arr[0]
        for n in pages:
            bing_url = "http://www.bing.com" + n[0]
            bing_url = bing_url.replace('&amp;','&')
            arr = self.urls(bing_url)
            p = arr[-1]
            u = arr[0]
            self.domains = self.domains + u
            for i in p:
                i = i[0]
                if i.replace('format=rss&amp;','') not in pages and 'PQRE' not in i:
                    pages.append(i)
        self.domains = list(set(self.domains))
        for u in self.domains:
            print(u)

    def urls(self,url):
        html = self.req.get(url,timeout=10,verify=False)
        html = html.text
        while (html.find('Ref A') > -1):
            proxy=self.get_proxy()
            try:
                html = self.req.get(url,timeout=10,verify=False,proxies=proxy).text
            except:
                html = 'Ref A'                
        urls = re.findall(r"<cite>(.*?)<",html)
        pages = self.get_pages(html)
        return (urls,pages)

   
    def get_pages(self,html):
        pages = re.findall(r"href=\"(/search.+?PERE(|\d))\"",html)
        return pages


s = bingSearch()
s.get_urls(sys.argv[1])
