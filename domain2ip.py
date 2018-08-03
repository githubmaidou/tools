import socket
import sys
def domain2ip(domain_file):
    try:
        domains = open(domain_file).readlines()
        for domain in domains:
            domain = domain.strip()
            ip = socket.gethostbyname(domain)
            print(ip,domain)
    except Exception as e:
        print(e)

if __name__ == '__main__':
    domain2ip(sys.argv[1])
