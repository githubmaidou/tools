import aiohttp
from aiofile import async_open
import json
import asyncio
import sys
npmSearchApi = "https://npmmirror.com/package/{keyword}"
async def checkPackage(keyword):
    url = npmSearchApi.format(keyword=keyword)
    async with aiohttp.ClientSession() as session:
        async with session.get(url=url) as req:
            status_code = req.status
            if status_code != 200:
                print(keyword,"不存在")
    
async def getPackageByUrl(url):
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as req:
            if req.status ==200:
                return json.loads(await req.text())
        return False

async def getPackageByFile(filepath):
    async with async_open(filepath,"r") as fhand:
        text = await fhand.read()
        return json.loads(text)

async def asyncList(slist):
    __tmpArray = []
    listSize = len(slist)
    listIndex = 0
    for k,v in slist.items():
        __tmpArray.append(k)
    while True:
       if listIndex > listSize - 1: 
           break
       yield __tmpArray[listIndex]
       listIndex = listIndex + 1


def printHelp():
    print(sys.argv[0] + " --url https://github.com/github/package.json")
    print(sys.argv[0] + " --file ./package.json")

async def main():
    #async with aiohttp.ClientSession() as session:
    if "--url" in sys.argv:
        packageJson = await getPackageByUrl(sys.argv[2])
    elif "--file" in sys.argv:
        packageJson = await getPackageByFile(sys.argv[2])
    else:
        printHelp()
        exit()
    packageList = {}
    packageList.update(packageJson.get("dependencies",{}))
    packageList.update(packageJson.get("devDependencies",{}))
    if len(packageList) == 0:
        exit()
    print(packageJson.get("repository",{}).get("url",""))
    async for p in asyncList(packageJson):
        await checkPackage(p)
        

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())

    
