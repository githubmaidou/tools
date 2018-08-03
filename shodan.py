import requests
import re
import time
import IPy
import sys
class shodan:
    def __init__(self):
        self.url = "https://www.shodan.io/host/"

    def _get_html(self,url):
        try:
            req = requests.get(url,timeout=10)
            code = req.status_code
        except Exception as e:
            print("Err:%s" % e)
            code = 404
        if code == 200:
            html = req.text
        else:
            html = ''
        return html.strip()

    def get_port(self,ip):
        html = self._get_html(self.url+str(ip))
        li_list = re.findall(r"<li class=\"service service-long\">(.*?)<\/li>",html,re.S)
        for li in li_list:
            re_port = re.search(r"<div class=\"port\">(.*?)<\/div>",li)
            re_protocol = re.search(r"<div class=\"protocol\">(.*?)<\/div>",li)
            re_state = re.search(r"<div class=\"state\">(.*?)<\/div>",li)
            re_server = re.search(r"<h3>(.*?)<\/small><\/h3>",li)
            port = re_port.group(1) if re_port else ''
            state = re_state.group(1) if re_state else ''
            server = re_server.group(1).replace("<small>","	") if re_server else ''
            print(ip,port,state,server)
s=shodan()
ips = IPy.IP(sys.argv[1])
for ip in ips:
    print(ip)
    s.get_port(ip)

