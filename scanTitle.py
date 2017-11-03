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
                r = requests.get(url,timeout=10)
        except Exception as e:
            continue
        if r.status_code == 200:
            r.encoding = 'utf-8'
            html = r.text
            title_re = re.search(r"<title>(.*?)</title>", html)
            if title_re:
                title = title_re.group(1)
                print(url,title)
def start(filename,threads):
    urls = getUrls(filename)
    count = math.ceil(len(urls)/float(threads))
    ths = []
    for t in range(1,int(threads)):
        ths.append(threading.Thread(target=getTitle,args=(urls[count*(t-1):count*t],)))
    for t in ths:
        t.start()
start(sys.argv[1],sys.argv[2])
