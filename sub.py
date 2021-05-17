import requests
import re
import socket
import time
import sys
import urllib3
import json
try:
    import fofa
except:
    sys.argv.append('--sub')
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
try:
    import config
    keys = config.__dir__()
    if "vt_key" in keys:
        vt_key = config.vt_key
    else:
        vt_key=""
    if "sec_keys" in keys:
        #是数组，这个接口只有第个月只有50次，需要多个key
        sec_keys = config.sec_keys
    else:
        sec_keys=[]
except:
    print("未发现接口key")
    


class subdomain:
    def __init__(self):
        self.api_list = [
            {'method':'get','url':"https://site.ip138.com/{target}/domain.htm",'data':"ok=1",'headers':{},'re':"/([a-zA-Z0-9_\-\.]*?{target})/"},
            {'method': 'get', 'url': "http://ce.baidu.com/index/getRelatedSites",
                'data': "site_address={target}", 'headers': {}, 're': "domain\":\"([a-zA-Z0-9_\-\.]*?)\","}, #baidu接
            {'method':'get','url':"https://www.virustotal.com/vtapi/v2/domain/report",'data':"apikey=%s&domain={target}" % vt_key,'headers':{'Origin': 'https://developers.virustotal.com'},'re':"\"([a-zA-Z0-9_\-\.]*?)\","},
            {"method":"get","url":"https://crt.sh/","data":"q=%.{target}&output=json","headers":{"accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8"},"re":"name_value\":\"([a-zA-Z0-9_\-\.]*?)\""},
            {"method":"post","url":"https://hackertarget.com/find-dns-host-records/","data":"theinput={target}&thetest=hostsearch&name_of_nonce_field=8a94567cc2","headers":{},"re":"([a-zA-Z0-9_\-\.]*?{target}),"},
            {'method':'get','url':"https://rapiddns.io/subdomain/{target}#result",'data':"ok=2",'headers':{"User-Agent": "curl/7.64.1","Referer": "https://rapiddns.io/subdomain"},'re':"//([a-zA-Z0-9_\-\.]*?{target})\""},
            {'method':'get','url':"https://dns.bufferover.run/dns?q=.{target}",'data':"ok=2",'headers':{"User-Agent": "curl/7.64.1","Referer": "https://dns.bufferover.run"},'re':",([a-zA-Z0-9_\-\.]*?{target})\""},
            {'method':'get','url':"https://searchdns.netcraft.com/?host={target}&restriction=site contains",'data':"ok=2",'headers':{"User-Agent": "curl/7.64.1","Referer": "https://searchdns.netcraft.com"},'re':"//([a-zA-Z0-9_\-\.]*?{target})\""},
            {'method':'get','url':"https://otx.alienvault.com/api/v1/indicators/domain/{target}/passive_dns",'data':"ok=1",'headers':{},'re':"\"([a-zA-Z0-9_\-\.]*?{target})\","},
            {'method':'get','url':"https://api.certspotter.com/v1/issuances?domain={target}&include_subdomains=true&expand=dns_names",'data':"ok=1",'headers':{},'re':"\"([a-zA-Z0-9_\-\.]*?{target})\""},
            {'method':'get','url':"https://sonar.omnisint.io/subdomains/{target}",'data':"ok=1",'headers':{},'re':"\"([a-zA-Z0-9_\-\.]*?{target})\","},
            {'method':'get','url':"https://www.threatcrowd.org/searchApi/v2/domain/report/?domain={target}",'data':"ok=1",'headers':{},'re':"\"([a-zA-Z0-9_\-\.]*?{target})\","},
            {'method':'get','url':"https://api.threatminer.org/v2/domain.php?q={target}&rt=5",'data':"ok=1",'headers':{},'re':"\"([a-zA-Z0-9_\-\.]*?{target})\""},
            {'method':'get','url':"http://web.archive.org/cdx/search/cdx?url=*.{target}/*&output=txt&fl=original&collapse=urlkey",'data':"ok=1",'headers':{},'re':"//([a-zA-Z0-9_\-\.]*?{target})/"},

            
            
        ]  # api接口列表
        self.domain = ""
        #self.start(self.domain)
    def securitytrails_api(self,domain):
        api_url = "https://api.securitytrails.com/v1/domain/%s/subdomains?children_only=false" % domain
        for key in sec_keys:
            headers = {
                        'accept': "application/json",
                        'apikey': key,
                        }
            try:
                req = requests.get(api_url,headers,timeout=60,verify=False)
            except:
                return []
            if req.status_code == 200:
                json_text = json.loads(req.text)
                if "subdomains" not in json_text.keys():
                    continue
                subs = json_text['subdomains']
                subdomains = [sub+"."+domain for sub in subs]
                return subdomains
        return []
        

    def req_text(self, method, url, data, headers):
        if not headers:
            headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.106 Safari/537.36',
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            }
        if method.upper() == 'GET':
            url = url.strip()+'?'+data.strip()
            try:
                
                req = requests.get(url, headers=headers,timeout=60,verify=False)
            except:
                return ""
        elif method.upper() == 'POST':
            try:
                req = requests.post(url, data, headers=headers,timeout=60,verify=False)
            except:
                return ""
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
        subdomains = subdomains + self.securitytrails_api(domain)
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
    if '--sub' in sys.argv:
        exit()
    print("-"*30 + "fofa search" + "-"*30)
    fofa.search("domain=\"%s\"||cert=\"%s\"" % (domain,domain))
