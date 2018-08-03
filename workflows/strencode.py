# -*- coding: utf-8 -*-
import sys
reload(sys)
sys.setdefaultencoding('utf8')
from workflow import Workflow
import hashlib,base64,binascii

def md5_s(strs):
	m5 = hashlib.md5()
	m5.update(strs)   
	return m5.hexdigest()   
def main(wf):
	args = wf.args[0].split()
	if len(args) == 1:
		wf.add_item("md5",u"md5加密")
		wf.add_item("base64",u"base64编码/解码")
		wf.add_item("hex",u"hex编码/解码")
		wf.add_item("ascii",u"ascii编码/解码")
		
	if len(args) == 2:
		action = args[0]
		strs = args[1]
		if action == "md5":
			m = md5_s(strs)
			wf.add_item("md5",m,arg=m)
		if action == "base64":
			try:
				m_e = str(base64.b64encode(strs)).encode("utf8")
				wf.add_item(u"base64编码",m_e,arg=m_e)
			except:
				wf.add_item("Error",u"base64编码错误")
			try:
				m_n = base64.b64decode(strs).encode("utf8")
				wf.add_item(u"base64解码",m_n,arg=m_n)
			except:
				wf.add_item("Error",u"base64解码错误")
		if action == "hex":
			try:
				m_e = str(binascii.hexlify(strs)).encode("utf8")
				wf.add_item(u"Hex编码",m_e,arg=m_e)
			except:
				wf.add_item("Error",u"Hex编码错误")
			try:
				m_n = str(binascii.unhexlify(strs)).encode("utf8")
				wf.add_item(u"Hex解码",m_n,arg=m_n)
			except:
				wf.add_item("Error",u"Hex解码错误")
		if action == "ascii":
			try:
				m_e = ""
				for i in strs:
					m_e = m_e+" "+str(ord(str(i)))
				wf.add_item(u"ASCII编码",m_e,arg=m_e)
			except:
				wf.add_item("Error",u"ASCII编码错误")
			try:
				m_n = chr(int(strs))
				wf.add_item(u"ASCII解码",m_n,arg=m_n)
			except:
				wf.add_item("Error",u"ASCII解码错误")
	wf.send_feedback()
if __name__== "__main__":
	wf = Workflow()
	sys.exit(wf.run(main))
