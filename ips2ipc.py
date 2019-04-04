
def ips2ipc(filename):
    minip={}
    maxip={}
    ips = open(filename).readlines()
    for ip in ips:
        minip_keys = minip.keys()
        maxip_keys = maxip.keys()
        ip_k = ".".join(ip.strip().split('.')[:3])
        ip_v = ip.strip().split('.')[-1]
        if ip_k not in maxip_keys and ip_k not in minip_keys:
            maxip[ip_k] = ip_v
            minip[ip_k] = ip_v
        elif int(ip_v) > int(maxip[ip_k]):
            maxip[ip_k]=int(ip_v)
        elif int(ip_v) < int(minip[ip_k]):
            minip[ip_k] = int(ip_v)
    for k in maxip.keys():
        if int(maxip[k]) == int(minip[k]):
            print("%s.%s"%(k,maxip[k]))
        else:
            print("%s.%s-%s"%(k,minip[k],maxip[k]))
if '__main__' == __name__:
    import sys
    if len(sys.argv) != 2:
        exit("%s %s" % (sys.argv[0],"/tmp/ip  #文件路径"))
    ips2ipc(sys.argv[1])