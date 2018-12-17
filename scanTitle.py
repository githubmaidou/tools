import sys,requests,threading,re,math
def getUrls(filename):
    f = open(filename,'r',encoding="utf8")
    lines = f.readlines()
    urls = [url.strip() for url in lines]
    return urls

def getTitle(urls):
    for url in urls:
        try:
            try:
                url = 'http://' + url.strip() if url[:5] != 'http:' else url.strip()
                r = requests.get(url,timeout=10)
            except:
                url = 'https://' + url.strip() if url[:5] != 'https' else url.strip()
                r = requests.get(url,timeout=10,verify=False)
        except Exception as e:
            continue
        if r.status_code == 200:
            r.encoding = 'utf-8'
            html = r.text
            title_re = re.search(r"<title>(.*?)</title>", html)
            if title_re:
                t = title_re.group(1)
                print(url,t)
def start(filename,threads=2):
    urls = getUrls(filename)
    count = math.ceil(len(urls)/float(threads))
    ths = []
    for t in range(1,int(threads)):
        ths.append(threading.Thread(target=getTitle,args=(urls[count*(t-1):count*t],)))
    for t in ths:
        t.start()
if len(sys.argv) >2:
    start(sys.argv[1],sys.argv[2]) 
else:
    start(sys.argv[1])
