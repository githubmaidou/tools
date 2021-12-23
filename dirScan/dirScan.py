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
            "User-Agent":"Mozilla/5.0 (Linux;u;Android 4.2.2;zh-cn;) AppleWebKit/534.46 (KHTML,like Gecko) Version/5.1 Mobile Safari/10600.6.3 (compatible; Baiduspider/2.0; +http://www.baidu.com/search/spider.html)"
                       } 
        #self.url_keyword_file = 'weblogic.dict'#'url_test.dict'
        self.url_keyword_file = 'dirname2.dict'#'url_test.dict'
        #self.file_keyword_file = 'filename2.dict'#'file_test.dict'
        self.file_keyword_file = 'filename2.dict'#'file_test.dict'
        self.thread_num = 10
        self.save_file_keywords = ['']
        self.save_url_keywords = ['']
        self.target_url = "http://baidu.com"
        self.scan_level = -1
        self.file_ext = 'php'
        self.bak_ext = ['zip','rar','tar','tar.gz','bak','tar.bz2']
        self.tmp_ext = ['old','log','bak','swp']
        self.STOP_FILE = False #禁止文件扫描
        self.STOP_URL = False  #禁止目录扫描
        self.status_code = [200,403,500]
        self.msg_queue = queue.Queue()#消息日志队列
        self.target_queue = queue.Queue()#待扫描URL队列
        self.re_keyword = False #对文件内容进行匹配，基于正则。对抗404重定向
        self.STOP_ME = False
        self.ignore_case = True #忽略目标大小写
        self.__no_check = True
        self.request_method = "get" #请求方式
        self.request_error_max = 12 #最大连接错误次数
        self.request_error_count =0 #当访问成功后会被重置为0
        threading.Thread(target=self._print_msg).start()#日志输出

    def _check_404(self,host):
        if self.__no_check:
            return
        url = host + "/check_404_"+str(int(time.time()))
        code = self._req_code(url)
        if code in [200,520]:
            return True

    def _req_code(self,url):
        url = url if url[:4] == 'http' else 'http://' + url
        try:
            if self.request_method.lower() not in ["get","head","post","put","delete"]:
                exit("请求方式不存在")
            if self.proxy:
                    __mreq = getattr(requests,self.request_method)
                    req = __req(url,headers=self.headers,timeout=self.timeout,proxies=self.proxyi,allow_redirects=False)

            else:
                    __mreq = getattr(requests,self.request_method)
                    req = __mreq(url,headers=self.headers,timeout=self.timeout,allow_redirects=False)
            if self.re_keyword and self.request_method in ["get","post"]:
                r=re.compile(self.re_keyword)
                if not r.search(req.text):
                    code = 200
                else:
                    code = 404
            else:
                code = req.status_code
                self.request_error_count = 0
        except Exception as e:
            code = 520 #网络不可达 
            self.request_error_count = self.request_error_count + 1
        return code

    def _get_urlkeyword(self):
        f = open(self.url_keyword_file,'r')
        url_keywords = f.readlines()
        f.close()
        if self.ignore_case:
            return list(set([i.strip().lower() for i in url_keywords]))
        else:
            return [i.strip() for i in url_keywords]

    def _get_filekeyword(self):
        f = open(self.file_keyword_file,'r')
        file_keywords = f.readlines()
        f.close()
        if self.ignore_case:
            return list(set([i.strip().lower() for i in file_keywords]))
        else:
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
            if self._req_code(v) in self.status_code:
                return k
        return 'php'

    def _zh_len(self,zhstr):
        """len在判断中文中度时不正确的问题"""
        row_l=len(zhstr)
        utf8_l=len(zhstr.encode('utf-8'))
        return int((utf8_l-row_l)/2+row_l)

    def _print_msg(self):
        _console_width = self._get_console_width()
        while not self.STOP_ME:
            try:
                _msg = self.msg_queue.get(timeout=0.1)
            except:
                continue
            if _msg[:4] == 'true':
                sys.stdout.write('\r'+_msg[4:].ljust(_console_width-1)+'\n')
            else:
                
                sys.stdout.write('\r'+_msg.ljust(_console_width-(self._zh_len(_msg)-len(_msg))))
            if self.request_error_count > self.request_error_max:
                self.STOP_ME = True
                print("请求错误次数太多! Count: %s" % self.request_error_count)

                        
    def set_proxy(self,proxy):
        """设置代理{'http':'http://127.0.0.1:8080','https','https://127.0.0.1:8080'}"""
        self.proxy = proxy
 
    def set_timeout(self,t):
        """设置请求超时时间"""
        self.timeout = t

    def set_request_error_max(self,i):
        """设置最大请求错误次数"""
        self.request_error_max = int(i)

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
    def set_status_code(self,codes):
        """设置返回正常的状态码"""
        self.status_code = codes
        print(self.status_code)
 
    def set_url_scan_file(self,path):
        """设置目录扫描字典文件路径"""
        self.url_keyword_file = path

    def set_file_scan_file(self,path):
        """设置文件扫描字典文件路径"""
        self.file_keyword_file = path

    def set_not_ignore_case(self):
        """ 设置是否忽律大小写"""
        self.ignore_case = False

    def set_re_keyword(self,re):
        """ 当开启404重定向时，对返回包进行正则匹配来判断页面是否存在"""
        self.re_keyword = re

    def set_request_method(self,method="get"):
        self.request_method = method.lower()

    def url_keyword_scan(self):
        while not self.STOP_ME and not self.target_queue.empty():
            key = self.target_queue.get()
            key = key.strip()
            url = self.target_url + key if self.target_url[-1] == '/' or key[0] == '/' else self.target_url+ '/' + key
            self.msg_queue.put("Queue: %s<-->%s"%(self.target_queue.qsize(),url))
            code = self._req_code(url)
            if int(code) in self.status_code:
                self.msg_queue.put('true'+url)
                if url.split('/')[-1].find('.') == -1: #判断是文件还是目录
                    if self.scan_level > key.count('/'):#利用/来判断当前目标深度
                        if not self.STOP_FILE:
                            self.saveKey_and_fileKey([key])
                        if not self.STOP_URL:
                            self.saveKey_and_urlKey([key])
                else:
                    for ext in self.tmp_ext: #加入备份文件的可能
                        self.target_queue.put(key+'.'+ext)
    
    def saveKey_and_urlKey(self,keywords):
        """合成扫描路径字典"""
        and_keys = []
        urlkeys = self._get_urlkeyword()
        for uk in urlkeys:
            for sk in keywords:
                self.target_queue.put(sk+'/'+uk)

    def saveKey_and_fileKey(self,keywords):
        """合成扫描文件字典"""
        and_keys = []
        filekeys = self._get_filekeyword()
        for fk in filekeys:
            for sk in keywords:
                self.target_queue.put(sk+'/'+fk+'.'+self.file_ext)
        for sk in keywords: #加入目录名为备份的可能
            for ext in self.bak_ext:
                if not sk.endswith("."+ext):#避免重复检测死循环a.bak a.bak.bak a.bak.bak.bak
                    self.target_queue.put(sk+'/'+sk.split('/')[-1]+'.'+ext)
                    self.target_queue.put('/'.join(sk.split('/')[:-1])+'/'+sk.split('/')[-1]+'.'+ext)    

    def scan(self,urls,ext=False):
        for url in urls:
            url = url.strip()
            self.set_target_url(url)
            if not self.re_keyword:
                if self._check_404(url):
                    self.msg_queue.put("true目标(%s)有404跳转或没有网络" % url)
                    continue
            if ext:
                self.set_file_ext(ext)
            else:
                self.set_file_ext(self._get_script_language(self.target_url))
            #首次初始化,因队列先进先出，尽量不要改变顺序
            if not self.STOP_FILE:
                self.saveKey_and_fileKey([''])
            if not self.STOP_URL:
                self.saveKey_and_urlKey([''])
            thread_list=[]
            for n in range(self.thread_num+1):
                thread_list.append(threading.Thread(target=self.url_keyword_scan))
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
    c = get_argv(sys.argv,'-c')
    if c:
        s.set_status_code([int(i) for i in c.strip().split(',')])
    l = get_argv(sys.argv,'-l')
    if l:
        s.set_scan_level(int(l))
    urls = [get_argv(sys.argv,'-u')] if in_argv(sys.argv,'-u') else []
    if in_argv(sys.argv,'-U'):
        urls = open(get_argv(sys.argv,'-U'),'r').readlines()
    e = False if not in_argv(sys.argv,'-e') else get_argv(sys.argv,'-e')
    if in_argv(sys.argv,'-fc'):s.set_stop_file() 
    if in_argv(sys.argv,'-dc'):s.set_stop_url()
    if in_argv(sys.argv,'-i'):s.set_not_ignore_case()
    if in_argv(sys.argv,'-H'):s.set_request_method("head")
    k = get_argv(sys.argv,'-k')
    if k:
        s.set_re_keyword(k)
    if (not in_argv(sys.argv,'-u') and not in_argv(sys.argv,'-U')) or in_argv(sys.argv,'-h'):
        print("-t       指定线程")
        print("-c       指定返回HTTP状态码(默认200,403,500) -c 200,500")
        print("-l       指定扫描深度")
        print("-u       指定目标URL")
        print("-U       指定目标URL文件,每行一个")
        print("-e       指定文件后缀")
        print("-fc      关闭文件扫描")
        print("-dc      关闭目录扫描")
        print("-i       开启大小写敏感")
        print("-k       404关键字,支持正则")
        print("-H       使用HEAD方式请求，默认为GET")
        s.set_stop_me()
    else:
        try:
            s.scan(urls,e)
        except KeyboardInterrupt:
            s.set_stop_me()
            sys.exit(1)
