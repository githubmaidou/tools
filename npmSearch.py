#npm keywrods search
import requests
import json
import sys

npmSearchApi = "https://npmmirror.com/package/{keyword}"

def checkPackage(keyword):
	req = requests.get(url=npmSearchApi.format(keyword=keyword.strip()))
	if req.status_code != 200:
		print(keyword,"不存在")

def getPackageByUrl(url):
	req = requests.get(url)
	if req.status_code == 200:
		return req.json()
	return False

def getPackageByFile(filepath):
	filehandle = open(filepath,"r")
	jsonstr = json.loads(filehandle.read())
	filehandle.close()
	return jsonstr

def printHelp():
	print(sys.argv[0] + " --url https://github.com/github/package.json")
	print(sys.argv[0] + " --file ./package.json")
if __name__ == "__main__":
	if "--url" in sys.argv:
		packageJson = getPackageByUrl(sys.argv[2])
	elif "--file" in sys.argv:
		packageJson = getPackageByFile(sys.argv[2])
	else:
		printHelp()
		exit()
	packageList = {}
	packageList.update(packageJson.get("dependencies",{}))
	packageList.update(packageJson.get("devDependencies",{}))
	if len(packageList) == 0:
		exit()
	print(packageJson.get("repository").get("url"))
	for p,v in packageList.items():
		checkPackage(p)


