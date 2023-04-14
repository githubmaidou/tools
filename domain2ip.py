import socket
import sys
import time
def domain2ip(domains):
    for domain in domains:
        domain = domain.strip()
        try:
            ip = socket.gethostbyname(domain)
        except:
            ip = '127.0.0.1'
        print(ip,domain)



if __name__ == '__main__':
    if sys.argv[1] == '--stdin':
        domains = sys.stdin.read().split("\n")
        domain2ip(domains)


    else:
        domain_file = sys.argv[1]
        domains = open(domain_file,'r').readlines()
        domain2ip(domains)

        

