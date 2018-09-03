#coding=utf-8
import socket
import threading
import time
import sys
import queue
import os
from tqdm import tqdm
STOP_ME = False
msg_queue = queue.Queue()

def print_msg():
    while not STOP_ME:
        try:
            msg = msg_queue.get(timeout=0.1)
            sys.stdout.write('\r'+msg.ljust(os.get_terminal_size().columns)+'\n')
        except:
            continue

def scan(ip,port):
    global msg_queue
    global count
    start_time = time.time()
    ss = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
    try:
        ss.settimeout(1)
        ss.connect((ip,int(port)))
        ss.send(b'\r\n\r\nexit\r\nquit\r\n')
        try:
            ss.recv(5)
            msg_queue.put("%s    %s    open" % (ip,port))
        except Exception as e:
            pass#print(e)
        ss.close()
    except Exception as e:
        pass#print(e)
if __name__ == '__main__':
    options = sys.argv
    ports = options[options.index('-p')+1] if '-p' in options else ''
    ip = options[options.index('-t')+1] if '-p' in options else ''
    thread_num = options[options.index('-n')+1] if '-n' in options else 50
    threading.Thread(target=print_msg).start()
    if ports and ip and len(options)>4:
        ports = ports.split(',')
        port_list = []
        for p in ports:
            if '-' in p:
                p_list = p.split('-')
                ps = range(int(p_list[0]),int(p_list[-1])+1)
                port_list = port_list + list(ps)
            else:
                try:
                    int(p)
                    port_list.append(p)
                except:
                    pass

        if ip.count('.') == 3:
            c = str(ip.split('.')[-1])
            ab = '.'.join(ip.split('.')[:-1])+'.'
            if '-' in c:
                ips = []
                for i in range(int(c.split('-')[0]),int(c.split('-')[-1])+1):
                    ips.append(ab+str(i))
                ip = ips
            else:
                ip = [ip]
        else:
            ip =[]
        threads = []
        semaphore = threading.Semaphore(int(thread_num))
        msg_queue.put("扫描ip %s 个,端口 %s 个，共 %s 个请求" % (len(ip),len(port_list),len(ip)*len(port_list)))
        for i in ip:
            for p in port_list:
                threads.append(threading.Thread(target=scan,args=(i,p)))
        for t in tqdm(threads):
            while threading.activeCount()-3 >= int(thread_num):
            #    #print(threading.activeCount())
                time.sleep(0.1)
            #    #continue 
            t.start()
            #print(threading.activeCount())
        time.sleep(3)
        STOP_ME=True
            
    else:
        msg_queue.put("%s -t 127.0.0.1 -p 80,88,8080-9000" % options[0])
        msg_queue.put("%s -t 127.0.0.1-100 -p 80,88,8080-9000" % options[0])
        STOP_ME=True
