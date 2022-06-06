import requests
import json
import base64
import config
import sys
email = config.fofa_email
key = config.fofa_key

def search(keyword,fields="ip,port,host,title"):
    b64_keyword = base64.b64encode(keyword.encode()).decode()
    proxies={"https":"127.0.0.1:7890"}
    url = "https://fofa.info/api/v1/search/all?email=%s&key=%s&qbase64=%s&size=10000&fields=%s" % (email,key,b64_keyword,fields)
    out = {}
    try:
        req = requests.get(url=url,timeout=60,proxies=proxies)
        out = json.loads(req.text)
        results = out
        if len(results) > 0 :
            for result in results['results']:
                print("%s%s    %s" % ((result[0]+":"+result[1]).ljust(21),result[2],result[3]))
    except Exception as e:
        print(e)
if __name__ == "__main__":
    search(sys.argv[1])
