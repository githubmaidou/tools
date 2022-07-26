import json
import base64
import config
import requests
import re
import sys
import time


class bigData():
    def __init__(self,keyword):
        self.fofa = False
        self.hunter = False
        self.censys = False
        self.shoadan = False
        #self.keyword = base64.b64encode(keyword.encode()).decode()
        self.keyword = keyword

    def importAuth(self):
        try:
            print("Import Auth")
            configFields = set(dir(config))
            self.fofa = True if  len(set(["fofa_key","fofa_email"]) & configFields) == 2 else False
            self.hunter = True if  len(set(["hunter_key","hunter_username"]) & configFields) == 2 else False
            self.censys = True if  len(set(["censys_key","censys_email"]) & configFields) == 2 else False
            self.shodan = True if  len(set(["shodan_key"]) & configFields) ==1  else False
        except Exception as e:
            exit(e)

    def sendReq(self,url):
        headers = {"User-Agent":"curl/7.64.1"}
        req = requests.get(url,headers=headers)
        if req.status_code == 200:
            return req.text
        return False
        

    def __SearchByfofa(self):
        if not self.fofa:
            return self.fofa
        keyword = self.keyword
        keyword = base64.b64encode(keyword.encode()).decode()
        displayFields = ["ip","port","host","title"]
        api_url = "https://fofa.info/api/v1/search/all?email={email}&key={key}&qbase64={b64_keyword}&size=10000&fields={fields}"
        url = api_url.format(email=config.fofa_email,key=config.fofa_key,b64_keyword=keyword,fields=",".join(displayFields))
        result = self.sendReq(url)
        if result:
            result = json.loads(result)
            for r in result.get('results',[]):
                print(*r)


    def __SearchByhunter(self,page=1):
        if not self.hunter or page > 5:
            return self.hunter
        reRule = {"^hash_icon=":"icon="}
        keyword = self.keyword
        for k,v in reRule.items():
            keyword = re.sub(k,v,keyword)
        keyword = base64.b64encode(keyword.encode()).decode()
        total = 0 
        #data/arr[]/url,ip,port,web_title,domain.cpmpany,number
        displayFields = ["ip","port","domain","web_title","company","number"]
        api_url = "https://hunter.qianxin.com/openApi/search?username={username}&api-key={key}&search={b64_keyword}&page={page}&page_size=100&is_web=3"
        url = api_url.format(username=config.hunter_username,key=config.hunter_key,b64_keyword=keyword,page=page)
        result = self.sendReq(url)
        if result:
            result = json.loads(result)
            if not result or not result.get("data",{}):
                return False
            datalist = result.get("data",{}).get("arr",[])
            for a in datalist:
                out = []
                for j in displayFields:
                    out.append(a.get(j,""))
                print(*out)
            total = result.get("data",{}).get("total",0)
            if int(total) > page * 50:
                time.sleep(2)
                page = page + 1
                self.__SearchByhunter(page)

    def __SearchByshodan(self,page=1):
        if not self.shodan:
            return self.shodan
        reRule = {"^body=":"http.html:","^title=":"http.title:","^icon_hash=|icon=":"http.favicon.hash:"}
        keyword = self.keyword
        for k,v in reRule.items():
            keyword = re.sub(k,v,keyword)
        keyword = requests.utils.quote(keyword)
        displayFields = ["ip_str","port","host","title","hostnames","org"]
        api_url = "https://api.shodan.io/shodan/host/search?query={keyword}&key={key}"
        url = api_url.format(key=config.shodan_key,keyword=keyword)
        result = self.sendReq(url)
        if result:
            result = json.loads(result)
            for a in result.get("matches",[]):
                out = []
                for j in displayFields:
                    out.append(a.get(j,""))
                print(*out)

        
if __name__ == '__main__':
    searchObj = bigData(sys.argv[1])
    searchObj.importAuth()
    for m in dir(searchObj):
        if "__searchby" in m.lower():
            __f = getattr(searchObj,m)
            __f()
