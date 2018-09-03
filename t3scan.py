import asyncio
import re
import os
import sys
import socket


class t3scan:
    def __init__(self, snum=50):
        self.t3str = "t3 12.1.2\nAS:2048\nHL:19\n\n"
        self.snum = int(snum)
        if os.name == 'nt':
            self.loop = asyncio.ProactorEventLoop() # for subprocess' pipes on Windows
            asyncio.set_event_loop(self.loop)
        else:
            self.loop = asyncio.get_event_loop()

    async def __send_t3(self, ip, port):
        sem = asyncio.Semaphore(self.snum)
        async with sem:
            connect = asyncio.open_connection(ip, port)
            try:
                r, w = await asyncio.wait_for(connect, 3)
            except:
                return ""
            w.write(self.t3str.encode())
            await w.drain()
            try:
                line = await asyncio.wait_for(r.readline(), 3)
            except:
                w.close()
                return ""
            w.close()
            if line:
                r = re.search(
                    r"^(HELO:|LGIN:|SERV:|UNAV:|LICN:|RESC:|VERS:|CATA:|CMND:)((\d{1,2}\.\d{1,2}\.\d{1,2})|)", line.decode())
                if r:
                    print("%s:%s 存在T3协议 %s" % (ip,port,r.group(2)))

    def fileScan(self, path, sp=None):
        tasks = []
        if os.path.isfile(path):
            lines = open(path, 'r').readlines()
            for line in lines:
                line = line.strip().split(sp)
                ip = line[0].strip()
                port = line[-1].strip()
                tasks.append(self.__send_t3(ip, port))
            self.loop.run_until_complete(asyncio.wait(tasks))
            self.loop.close()
        else:
            print("文件%s 不存在" % path)

    def scan(self, ip, port):
        self.loop.run_until_complete(self.__send_t3(ip, port))
        self.loop.close()


def get_argv(alist, astr):
    if astr in alist:
        try:
            return alist[alist.index(astr)+1]
        except:
            print("%s 参数错误" % astr)
            return False
    else:
        return False


def in_argv(alist, astr):
    if astr in alist:
        return True
    else:
        return False


if __name__ == '__main__':
    alist = sys.argv
    snum = 10 if not in_argv(alist, '-t') else get_argv(alist, '-t')
    filepath = None if not in_argv(alist, '-f') else get_argv(alist, '-f')
    split = None if not in_argv(alist, '-p') else get_argv(alist, '-p')
    t3 = t3scan(snum)
    if filepath:
        t3.fileScan(filepath, split)
    elif not split and not filepath and len(alist) == 3:
        t3.scan(sys.argv[1], sys.argv[2])
    else:
        print("-t 指定并发数,默认10")
        print("-f 指定读取文件")
        print("-p 指定ip&port分割符，如果是空格分割不用此参数")
        print("%s 127.0.0.1 7001 单目标检测" % alist[0])
        exit()
