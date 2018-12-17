import dns.resolver as dnsquery
import os
import sys
import threading
import time
import requests
import queue
import re
class dnsbrute:
    def __init__(self,sub_dict_path,sub3_dict_path,threads=50,dns_server_list=[]):
        if self.check_isfile(sub_dict_path):
            self.sub_dict_path = sub_dict_path
        else:
            exit("二级子域名字典(%s)不存在" % sub_dict_path)
        if self.check_isfile(sub3_dict_path):
            self.sub3_dict_path = sub3_dict_path
        else:
            exit("三级子域名字典(%s)不存在" % sub3_dict_path)
        self.d = dnsquery.Resolver()
        self.d.timeout=self.d.lifetime=2.0
        self.dns_server_list = ['114.114.114.114','223.5.5.5'] if not dns_server_list else dns_server_list
        self.d.nameservers=self.dns_server_list
        self.threads = int(threads)
        self.sub2_list = [] #存放存在的二级域名
        self.black_list = [] #存放API传入的已查询到的子域名
        self.company_id = 1 #目标企业
        self.msg_queue = queue.Queue()
        self.count = 1
        self.STOP_ME = False
        self.sub_sum = 1
        self.sub2_len = len(open(self.sub_dict_path,'r').readlines())
        self.sub3_len = len(open(self.sub3_dict_path,'r').readlines())
        self.sub2_count=0
        threading.Thread(target=self._print_msg).start()
    def _print_msg(self):
        _console_width = int(os.get_terminal_size().columns)
        while not self.STOP_ME:
            try:
                _msg = self.msg_queue.get(timeout=0.5)
            except:
                continue
            if _msg[:4] == 'true':
                sys.stdout.write('\r'+_msg[4:].ljust(_console_width)+'\n')
            else:
                _msg += '    '+str(self.count)+'/'+str(self.sub2_len + (self.sub2_count*self.sub3_len))
                sys.stdout.write('\r'+_msg.ljust(_console_width-len(_msg)))
    
    def set_black_list(self,b_list):
        self.black_list=b_list

    def set_company_id(self,id):
        self.company_id = id
    
    def check_cdn(self,domain):
        """检测是否有泛解析"""
        if not self.gethostbyname('x1x2x3x4dns',domain):
            return False
        return True

    def check_isfile(self,path):
        """检测文件是否存在"""
        if os.path.isfile(path):
            return path
        return ""

    def gethostbyname(self,sub,domain):
        if sub and domain:
            subdomain = "%s.%s" % (sub,domain)
        else:
            return
        self.msg_queue.put(">>%s"%(subdomain.strip()))
        self.count += 1
        if subdomain in self.black_list:
            return 
        try:
            d = self.d.query(subdomain)
        except dnsquery.NXDOMAIN as e:
            return
        except Exception as e:
            return 
        for j in d.response.answer:
            if j.rdtype == 1:
                self.sub2_list.append(sub)
                self.sub2_count += 1
                self.msg_queue.put("true%s %s"%(subdomain,j[0]))

    def dnsbrute_start(self,domain):
        if self.check_cdn(domain):
            print("存在泛解析")
            return
        with open(self.sub_dict_path,'r') as lines:
            subs = lines.readlines()
            for sub in subs:
                while threading.active_count() > self.threads:
                    time.sleep(0.1)
                threading.Thread(target=self.gethostbyname,args=(sub.strip(),domain.strip())).start()
        if len(self.sub2_list) > 0:
            with open(self.sub3_dict_path,'r') as lines:
                subs = lines.readlines()
                for sub2 in self.sub2_list:
                    for sub3 in subs:
                        sub = sub3 + '.' + sub2
                        while threading.active_count() > self.threads:
                            time.sleep(0.01)
                        threading.Thread(target=self.gethostbyname,args=(sub.strip(),domain.strip())).start()
        while threading.active_count() > 2:
            print(threading.active_count())
            time.sleep(1)
        self.STOP_ME = True
                
if __name__ == '__main__':
    ss = dnsbrute('/tmp/subdomain.dict','/tmp/subdomain3.dict',threads=300)
    ss.dnsbrute_start(sys.argv[1])

