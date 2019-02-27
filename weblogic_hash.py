import sys
def convert_n_bytes(n, b):
    bits = b * 8
    return (n + 2 ** (bits - 1)) % 2 ** bits - 2 ** (bits - 1)

def convert_4_bytes(n):
    return convert_n_bytes(n, 4)

def getHashCode(s):
    h = 0
    n = len(s)
    for i, c in enumerate(s):
        h = h + ord(c) * 31 ** (n - 1 - i)
    return convert_4_bytes(h)

def toString(strs,radix):
    i = int(strs)
    digits = [
        '0' , '1' , '2' , '3' , '4' , '5' ,
        '6' , '7' , '8' , '9' , 'a' , 'b' ,
        'c' , 'd' , 'e' , 'f' , 'g' , 'h' ,
        'i' , 'j' , 'k' , 'l' , 'm' , 'n' ,
        'o' , 'p' , 'q' , 'r' , 's' , 't' ,
        'u' , 'v' , 'w' , 'x' , 'y' , 'z'
    ]
    buf = list(range(65))
    charPos = 64
    negative = int(strs) < 0
    if not negative:
        i = -int(strs)

    while (i<=-radix):
        buf[int(charPos)] = digits[int(-(i%radix))]
        charPos = charPos - 1
        i = int(i / radix)
    buf[charPos] = digits[int(-i)]
    if negative:
        charPos = charPos - 1
        buf[charPos] = '-'
    return (buf[charPos:charPos+65-charPos])
def get_path(serverName,appName="bea_wls_internal",packName="bea_wls_internal.war"):
    strings = "%s_%s_%s" % (serverName,appName,packName)
    print("".join(toString(getHashCode(strings),36)).replace("-",""))
if len(sys.argv) == 2:
    get_path(sys.argv[1])
elif len(sys.argv) == 4:
    args = sys.argv[1:]
    get_path(*args)
else:
    print("%s AdminServer" % __file__)
    print("%s AdminServer bea_wls_internal bea_wls_internal.war" % __file__)
