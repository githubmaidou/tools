import requests
import re
import socket
import time
import sys
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
try:
    import config
    vt_key = config.vt_key
except:
    vt_key = ""
    


class subdomain:
    def __init__(self):
        self.api_list = [
            {'method':'get','url':"https://site.ip138.com/{target}/domain.htm",'data':"ok=1",'headers':{},'re':"/([a-zA-Z0-9_\-\.]*?{target})/"},
            {'method': 'get', 'url': "http://ce.baidu.com/index/getRelatedSites",
                'data': "site_address={target}", 'headers': {}, 're': "domain\":\"([a-zA-Z0-9_\-\.]*?)\","}, #baidu接口
            {'method':'get','url':"https://www.virustotal.com/vtapi/v2/domain/report",'data':"apikey=%s&domain={target}" % vt_key,'headers':{'Origin': 'https://developers.virustotal.com'},'re':"\"([a-zA-Z0-9_\-\.]*?)\","},
            {"method":"get","url":"https://crt.sh/","data":"q=%.{target}&output=json","headers":{"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"},"re":"name_value\":\"([a-zA-Z0-9_\-\.]*?)\""},
            {"method":"post","url":"https://hackertarget.com/find-dns-host-records/","data":"theinput={target}&thetest=hostsearch&name_of_nonce_field=8a94567cc2","headers":{},"re":"([a-zA-Z0-9_\-\.]*?{target}),"},
            
            
        ]  # api接口列表
        self.domain = ""
        #self.start(self.domain)

    def req_text(self, method, url, data, headers):
        if not headers:
            headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36',
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            }
        if method.upper() == 'GET':
            url = url.strip()+'?'+data.strip()
            req = requests.get(url, headers=headers,verify=False)
        elif method.upper() == 'POST':
            req = requests.post(url, data, headers=headers,verify=False)
        else:
            return ""
        if req.status_code == 200:
            text = req.text
        else:
            text = ""
        return text

    def get_domains(self,reStr,text):
        temp = []
        r = re.compile(reStr)
        r1 = re.findall(r,text)
        if r1:
            for subdomain in r1:
                if self.domain in subdomain:
                    temp.append(subdomain)
            return temp
        return []
    
    def api_start(self,domain):
        subdomains = []
        subip={}
        for api in self.api_list:
            data=api['data'].replace('{target}',domain)
            url = api['url'].replace('{target}',domain)
            text = self.req_text(api['method'],url,data,api['headers'])
            re_domain_list = self.get_domains(api['re'].replace("{target}",domain),text)
            if re_domain_list:
                subdomains = subdomains + re_domain_list
        return subdomains



if __name__ == '__main__':
    domain = sys.argv[1]
    sub = subdomain()
    s = sub.api_start(domain)
    for s1 in list(set(s)):
        if domain in s1:
            print(s1)
