import re
import sys
nmap_log = open(sys.argv[1]).readlines()
ip_re = r"([0-9]{1,3}\.){3}[0-9]{1,3}"
port_re = r"([0-9]{2,5})\/open"
for log in nmap_log:
    ip= re.compile(ip_re).search(log)
    ports=re.compile(port_re).findall(log)
    if ip and ports:
        for p in ports:
            print("%s:%s"%(ip.group(),p))
