import requests
import re
import sys

def ip138(url):
    re_ip = re.search(r"([0-9]{1,3}\.){3}[0-9]{1,3}",url)
    if re_ip:
        target = re_ip.group()
        api = "http://site.ip138.com/%s/" % target
    else:
        target = url
        api = "http://site.ip138.com/%s/domain.htm" % target
    try:
        req = requests.get(api,timeout=10)
        html = req.text
    except Exceptions as e:
        html = ''
        print(e)
    if re_ip:
        re_domains = re.findall(r"</span><a href=\"/(.*?)/\"",html)
        returnlist = re_domains
    else:
        re_subdomains = re.findall(r"\"_blank\">(.*?)</a></p>",html)
        returnlist = re_subdomains
    return returnlist
if __name__ == '__main__':
    print(ip138(sys.argv[1]))


