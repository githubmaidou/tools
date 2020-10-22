#!/usr/bin/env python
#coding=utf-8

try:
    from aliyunsdkcore.client import AcsClient
    from aliyunsdkcore.acs_exception.exceptions import ClientException
    from aliyunsdkcore.acs_exception.exceptions import ServerException
    from aliyunsdkecs.request.v20140526.DescribeInstanceAttributeRequest import DescribeInstanceAttributeRequest
    from aliyunsdkecs.request.v20140526.DescribeRegionsRequest import DescribeRegionsRequest
    from aliyunsdkecs.request.v20140526.DescribeInstanceStatusRequest import DescribeInstanceStatusRequest
    from aliyunsdkecs.request.v20140526.RunCommandRequest import RunCommandRequest
    from aliyunsdkecs.request.v20140526.DescribeInvocationResultsRequest import DescribeInvocationResultsRequest
except Exception as e:
    print(e)
    print("请先安装aliyun sdk 库")
    print("pip3 install aliyun-python-sdk-core")
    print("pip3 install aliyun-python-sdk-ecs")
    exit()
import json
import base64
import time
#密钥信息
accessKeyId="aaaa"
accessSecret="ffff"
if not accessKeyId or not accessSecret:
    print("请填写accessKeyId与accessSecret密钥信息!")
    exit()
def get_regionid():
    client = AcsClient(accessKeyId, accessSecret, 'cn-hangzhou')
    request = DescribeRegionsRequest()
    request.set_accept_format('json')
    response = client.do_action_with_exception(request)
    return json.loads(str(response, encoding='utf-8'))["Regions"]["Region"]


def get_ecsid(regionID):
    client = AcsClient(accessKeyId, accessSecret, regionID)
    request = DescribeInstanceStatusRequest()
    request.set_accept_format('json')
    response = client.do_action_with_exception(request)
    InstanceStatuses=json.loads(str(response, encoding='utf-8'))["InstanceStatuses"]
    return InstanceStatuses["InstanceStatus"]
        

def get_status(ecsid):
    client = AcsClient(accessKeyId, accessSecret, 'cn-hangzhou')
    request = DescribeInstanceAttributeRequest()
    request.set_accept_format('json')
    request.set_InstanceId(ecsid)
    response = client.do_action_with_exception(request)
    return json.loads(str(response, encoding='utf-8'))

def exec_ecs(ecsid,command):
    regionID = get_status(ecsid)["RegionId"]
    client = AcsClient(accessKeyId, accessSecret, regionID)
    request = RunCommandRequest()
    request.set_accept_format('json')
    request.set_Type("RunShellScript")
    request.set_CommandContent(command)
    request.set_InstanceIds([ecsid])
    response = client.do_action_with_exception(request)
    return json.loads(str(response, encoding='utf-8'))



def get_result(ecsid,invokeid):
    regionID = get_status(ecsid)["RegionId"]
    client = AcsClient(accessKeyId,accessSecret,regionID)
    request = DescribeInvocationResultsRequest()
    request.set_accept_format('json')
    request.set_InstanceId(ecsid)
    request.set_InvokeId(invokeid)
    response = client.do_action_with_exception(request)
    return json.loads(str(response, encoding='utf-8'))

def listecs():
    regions = get_regionid()
    for region in regions:
        regionID = region["RegionId"]
        ecsids = get_ecsid(regionID)
        if len(ecsids) > 0:
            print("地区: ",region["LocalName"] + " - " + region["RegionId"])
        for ids in ecsids:
            info = get_status(ids["InstanceId"])
            print("---->实列ID: %s (%s)" % (ids["InstanceId"],ids["Status"]))
            print("---->公有IP: " ,info["PublicIpAddress"]["IpAddress"])
            print("---->私有IP: " ,info["VpcAttributes"]["PrivateIpAddress"]["IpAddress"])
            print("---->镜像名: ",info["ImageId"])
        print("")
def exececs(ecsid,command):
    comm = exec_ecs(ecsid,command)
    invokeid = comm["InvokeId"]
    time.sleep(1)
    print(base64.b64decode(get_result(ecsid,invokeid)["Invocation"]["InvocationResults"]["InvocationResult"][0]["Output"]).decode())
if __name__ == "__main__":    
    import sys
    args = sys.argv
    action = args[1] if len(args) > 1 else "help"
    if "list" == action:
        listecs()
    elif "exec" == action:
        ecsid = args[2]
        command = args[3]
        exececs(ecsid,command)    
    else:
        print(args[0],"list  列出ECS")
        print(args[0],"exec 实列ID 命令")
