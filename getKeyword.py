import requests
import re
import sys
import jieba
import jieba.posseg as pseg
from pypinyin import slug, lazy_pinyin
import tldextract
class getKeyword:
    def get_html(self,url):
        url = url if '://' in url else 'http://'+url
        try:
            headers = { 'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Safari/537.36',
                        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8',}
            re = requests.get(url,headers=headers,timeout=10)
            re.encoding = 'utf-8'
            return re.text.lower()
        except Exception as e:
            print(e)
            return ''

    def __re_list(self):
        """可以直接在这个re_list加关键字的正则"""
        re_list=[
                    re.compile(r"[a-z]{2,12}",re.S), #2到12位的字母
                    re.compile(r"[0-9]{4}|[0-9]{8}|[0-9]{11}",re.S), #4位数字2018,8位数字座机号,11位数字手机号
                    re.compile(r"[0-9a-z]{4,8}",re.S),               #混合型,会造成较多的数据，不想使用可以注释此行
                ]
        return re_list
    
    def __split_domain(self,url):
        """分割域名"""
        domain = url if '://' not in url.split('/')[0] else url.split('/')[2]
        tld = tldextract.extract(domain)
        sub = tld.subdomain
        domain = tld.domain
        return [sub,domain]
    
    def __jieba_html(self,html):
        """jieba分词"""
        keys = []
        words = pseg.cut(html)
        for word,flag in words:
            if flag in ['ns','n','nt','nz']: # 中文分词的词性类别 参考https://www.cnblogs.com/adienhsuan/p/5674033.html
                keys.append(slug(word,separator=''))
        return keys

    def re_html(self,html):
       if html:
           keys = []
           tag_=re.findall(r"=\"(.*?)\"",html)      #标签属性,可以过滤掉html标签
           content_=re.findall(r">(.*?)<",html)    #文本内容
           text = ' '.join(tag_+content_)
           for r in self.__re_list():
               keys = r.findall(text) + keys
           jieba_keys = self.__jieba_html(text)
           return list(set(keys+jieba_keys))
    def get_keywords(self,url):
        return self.__split_domain(url)+self.re_html(self.get_html(url))

if __name__ == '__main__':        
    p = getKeyword()
    print(p.get_keywords(sys.argv[1]))
