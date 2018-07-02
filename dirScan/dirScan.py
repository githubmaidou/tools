import threading
import re
import requests
import time
import math
import sys
import queue
import os
class dirScan:
    def __init__(self):
        self.proxy = {}
        self.timeout = 10
        self.headers = { 
            "Accept":"text/html,application/xhtml+xml,application/xml;",
            "Accept-Encoding":"gzip",
            "Accept-Language":"zh-CN,zh;q=0.8",
            "Referer":"https://www.baidu.com/",
            "User-Agent":"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.90 Safari/537.36"
                       } 
        self.url_keyword_file = 'url_keyword.dict'#'url_test.dict'
        self.file_keyword_file = 'file_keyword.dict'#'file_test.dict'
        self.thread_num = 10
        self.save_file_keywords = ['']
        self.save_url_keywords = ['']
        self.target_url = "http://baidu.com"
        self.scan_level = -1
        self.file_ext = 'php'
        self.bak_ext = ['zip','rar','tar','tar.gz']
        self.STOP_FILE = False #禁止文件扫描
        self.STOP_URL = False  #禁止目录扫描
        self.msg_queue = queue.Queue()
        self.STOP_ME = False
        threading.Thread(target=self._print_msg).start()#日志输出

    def _check_404(self,host):
        url = host + "/check_404_"+str(int(time.time()))
        code = self._req_code(url)
        if code in [200,520]:
            return True

    def _req_code(self,url):
        url = url if url[:4] == 'http' else 'http://' + url
        try:
            req = requests.get(url,headers=self.headers,timeout=self.timeout,proxies=self.proxy)
            code = req.status_code
        except:
            code = 520 #网络不可达 
        return code

    def _get_urlkeyword(self):
        f = open(self.url_keyword_file,'r')
        url_keywords = f.readlines()
        f.close()
        return [i.strip() for i in url_keywords]

    def _get_filekeyword(self):
        f = open(self.file_keyword_file,'r')
        file_keywords = f.readlines()
        f.close()
        return [i.strip() for i in file_keywords]

    def _get_console_width(self):
        return int(os.get_terminal_size().columns)

    def _get_script_language(self,url):
        php = url + '/index.php'
        asp = url + '/index.asp'
        aspx = url + '/index.aspx'
        jsp = url + '/index.jsp'
        scripts = {'asp':asp,'aspx':aspx,'php':php,'jsp':jsp}
        for k,v in scripts.items():
            if self._req_code(v) in [200,401]:
                return k
        return 'php'
    
    def _print_msg(self):
        _console_width = self._get_console_width()
        while not self.STOP_ME:
            try:
                _msg = self.msg_queue.get(timeout=0.1)
            except:
                continue
            if _msg[:4] == 'true':
                sys.stdout.write('\r'+_msg[4:].ljust(_console_width-20)+'\n')
            else:
                sys.stdout.write('\r'+_msg.ljust(_console_width-20))

        
                        
    def set_proxy(self,proxy):
        """设置代理{'http':'http://127.0.0.1:8080','https','https://127.0.0.1:8080'}"""
        self.proxy = proxy
 
    def set_timeout(self,t):
        """设置请求超时时间"""
        self.timeout = t

    def set_stop_me(self,t=True):
        """关闭输出"""
        self.STOP_ME=t

    def set_headers(self,headers):
        """设置headers头dict类型"""
        self.headers = headers

    def set_url_keyword_file(self,path):
        """"扫路径的字典"""
        self.url_keyword_file = path

    def set_file_keyword_file(self,path):
        """扫文件的字典"""
        self.file_keyword_file=path

    def set_thread(self,num):
        """设置线程"""
        self.thread_num = num
   
    def set_target_url(self,url):
        """设置扫描目标"""
        self.target_url = url
    
    def set_scan_level(self,level):
        """设置扫描深度,默认无限(-1)"""
        self.scan_level = level
   
    def set_file_ext(self,ext):
        """设置文件后缀"""
        self.file_ext = str(ext)

    def set_stop_file(self,bo = True):
        """是否扫描文件,默认开启"""
        self.STOP_FILE = bo

    def set_stop_url(self,bo = True):
        """是否扫描目录,默认开启"""
        self.STOP_URL = bo

    def set_url_scan_file(self,path):
        """设置目录扫描字典文件路径"""
        self.url_keyword_file = path

    def set_file_scan_file(self,path):
        """设置文件扫描字典文件路径"""
        self.file_keyword_file = path

    def url_keyword_scan(self,keywords):
        for key in keywords:
            key = key.strip()
            url = self.target_url + key if self.target_url[-1] == '/' or key[0] == '/' else self.target_url+ '/' + key
            self.msg_queue.put(url)
            code = self._req_code(url)
            if int(code) in [200,403]:
                self.msg_queue.put('true'+url)
                if url.split('/')[-1].find('.') == -1: #判断是文件还是目录
                    self.save_url_keywords.append(key)
    
    def saveKey_and_urlKey(self,keywords):
        """合成扫描路径字典"""
        and_keys = []
        urlkeys = self._get_urlkeyword()
        for uk in urlkeys:
            for sk in keywords:
                and_keys.append(sk+'/'+uk)
        return and_keys

    def saveKey_and_fileKey(self,keywords):
        """合成扫描文件字典"""
        and_keys = []
        filekeys = self._get_filekeyword()
        for fk in filekeys:
            for sk in keywords:
                and_keys.append(sk+'/'+fk+'.'+self.file_ext)
        for sk in keywords: #加入目录名为备份的可能
            for ext in self.bak_ext:
                and_keys.append(sk+'/'+sk.split('/')[-1]+'.'+ext)
        return and_keys  
    def scan(self,url,ext=False):
        self.num = 1
        self.set_target_url(url)
        if self._check_404(url):
                self.msg_queue.put("true目标(%s)有404跳转或没有网络" % url)
                self.STOP_ME = True
                exit()
        if ext:
            self.set_file_ext(ext)
        else:
            self.set_file_ext(self._get_script_language(self.target_url))
        while (len(self.save_url_keywords) > 0 and self.scan_level != 0):
            file_keywords = self.saveKey_and_fileKey(self.save_url_keywords) #生成下一层文件字典
            url_keywords = self.saveKey_and_urlKey(self.save_url_keywords)
            if self.STOP_FILE:
                scan_list = url_keywords
            elif self.STOP_URL:
                scan_list = file_keywords
                self.scan_level = 1
            else:
                scan_list = url_keywords + file_keywords  #生成下一层路径字典 + 文件字典
            self.save_url_keywords = []
            self.scan_level = self.scan_level - 1
            count = math.ceil(len(scan_list)/self.thread_num)
            thread_list = []
            for n in range(self.thread_num+1):
                thread_list.append(threading.Thread(target=self.url_keyword_scan,args=(scan_list[n*count:(n+1)*count],)))
            for t in thread_list:
                t.start()
            for t in thread_list:
                t.join()
        self.msg_queue.put('trueScan End')
        self.STOP_ME = True
def get_argv(alist,astr):
    if astr in alist:
        try:
            return alist[alist.index(astr)+1]
        except:
            print("%s 参数错误" % astr)
            return False
    else:
        return False
def in_argv(alist,astr):
    if astr in alist:
        return True
    else:
        return False
if __name__ == '__main__':
    s = dirScan()
    t = get_argv(sys.argv,'-t')
    s.set_thread(50) if not t else s.set_thread(int(t))
    l = get_argv(sys.argv,'-l')
    s.set_scan_level(2) if not l else s.set_scan_level(l)
    url = get_argv(sys.argv,'-u')
    e = False if not in_argv(sys.argv,'-e') else get_argv(sys.argv,'-e')
    if in_argv(sys.argv,'-fc'):s.set_stop_file() 
    if in_argv(sys.argv,'-dc'):s.set_stop_url()
    if not in_argv(sys.argv,'-u') or in_argv(sys.argv,'-h'):
        print("-t       指定线程")
        print("-l       指定扫描深度")
        print("-u       指定目标URL")
        print("-e       指定文件后缀")
        print("-fc      关闭文件扫描")
        print("-dc      关闭目录扫描")
        s.set_stop_me()
    else:
        s.scan(url,e)
