import socket
import sys
import time
def domain2ip(domain_file):
    domains = open(domain_file,'r').readlines()
    for domain in domains:
        domain = domain.strip()
        try:
            ip = socket.gethostbyname(domain)
        except:
            ip = '127.0.0.1'
        print(ip,domain)

if __name__ == '__main__':
    domain2ip(sys.argv[1])
