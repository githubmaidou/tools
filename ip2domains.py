import requests
import json
import re
import socket
import sys
#https://www.virustotal.com/ui/ip_addresses/216.160.212.12/resolutions	#ip2domins
#https://www.virustotal.com/ui/domains/hao123.com/subdomains			#domain@subdomains
#https://www.virustotal.com/vtapi/v2/domain/report?apikey=<apikey>&domain=<domain>
#https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=<apikey>&ip=<ip>
class ipDomain:
	def __init__(self,target):
		self.apikey = 'apikey'
		self.target = target
		self.IP_DOMAINS = True #默认
		self.DOMAIN_SUBDOMAINS = False
		self.URL_API_IP = "https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=%s&ip=%%target%%" % (self.apikey)
		self.URL_API_DOMAIN = "https://www.virustotal.com/vtapi/v2/domain/report?apikey=%s&domain=%%target%%" % (self.apikey) 
		self.METHOD = "IP" if self.__checkip(self.target) else "DOMAIN"
		self.URL_API = self.URL_API_IP.replace('%target%',self.target) if self.METHOD == "IP" else self.URL_API_DOMAIN.replace('%target%',self.target)
		self.scan()


	def __checkip(self,target):
		r = re.match(r"([0-9]{1,3}\.){3}[0-9]{1,3}",target)
		if r:
			return True
		else:
			return False

	def __get_html(sefl,url):
		try:
			req = requests.get(url,timeout=5)
			html = req.text
			return html
		except Exception as e:
			print("Function %s Err: %s" % (sys._getframe().f_code.co_name,e))
			return ""

	def __str_json(self,json_str):
		try:
			json_text = json.loads(json_str)
			if "resolutions" not in json_text.keys():
				return ""
			else:
				return json_text
		except Exception as e:
			print("Function %s Err: %s" % (sys._getframe().f_code.co_name,e))
			return ""

	def __get_next(self,json_text):
		if json_text:
			try:
				next_link = json_text['links']['next'] if "next" in json_text['links'].keys() else ""
			except Exception as e:
				next_list = ""
			if next_link:
				return next_link
			else:
				return ""
		else:
			return ""

	def __domain_ip(self,domain):
		try:
			ip = socket.gethostbyname(domain)
			return ip
		except Exception as e:
			print("Function %s Err: %s" % (sys._getframe().f_code.co_name,e))
			return "127.0.0.1"


	def __get_data(self,json_text):
		out_list = []
		if not json_text:return out_list
		if self.METHOD == "IP":
			for j in json_text['resolutions']:
				ip = self.target
				subdomain = j['hostname']
				out_list.append((ip,subdomain))
		elif self.METHOD == "DOMAIN":
			for j in json_text['subdomains']:
				subdomain = j
				ip = self.__domain_ip(subdomain)
				out_list.append((ip,subdomain))
		return out_list

	def scan(self):
		next_link = self.URL_API
		out_list = []
		json_text = self.__str_json(self.__get_html(next_link))
		out_list = out_list + self.__get_data(json_text)
		for i in out_list:
			print(i)



if __name__ == '__main__':
	if len(sys.argv)==2:
		ipDomain(sys.argv[1])
	else:
		print("Eg: %s 127.0.0.1    查询旁站" % sys.argv[0])
		print("Eg: %s hey235.com	查询子域名" % sys.argv[0])








