import sys
def low2high(d):
    # 高低位转换
    d = ord(d)
    return hex(d & 0xff).lstrip('0x') + hex(d >> 8).lstrip('0x')

def toHex(s):
    sHex = "0x"
    for i in s:
        if ord(i) < 255:
            sHex = sHex + hex(ord(i)).lstrip('0x') + '00'
        else:
            sHex = sHex + low2high(i)
    return sHex


if __name__ == '__main__':
    data = sys.argv[1]
    print(toHex(data))
    
