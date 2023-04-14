import requests
import mmh3
import sys
import base64
url = sys.argv[1]
if not url.endswith("favicon.ico"):
    if url.endswith("/"):
        url = url + "favicon.ico"
    else:
        url = url + "/favicon.ico"
req = requests.get(url=url,timeout=10,verify=False)
print("http.favicon.hash:%s"%(mmh3.hash(base64.encodebytes(req.content).decode())))
print("icon_hash=\"%s\""%(mmh3.hash(base64.encodebytes(req.content).decode())))
