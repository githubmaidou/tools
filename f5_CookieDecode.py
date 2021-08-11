import re
import sys

if __name__ == "__main__":
    cookie = sys.argv[1]
    __tmp = cookie.split(".")
    Iip = __tmp[0]
    Iport = __tmp[1]
    Hip = hex(int(Iip))[2:]
    Hport = hex(int(Iport))[2:]
    Cport = "".join([str(i) for i in re.findall(r"\w{2}",Hport)][::-1])
    ip = ".".join([str(int(i,16)) for i in re.findall(r"\w{2}",Hip)])
    port = str(int(Cport,16))
    print("%s:%s" % (ip,port))

