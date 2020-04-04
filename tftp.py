
import sys
import struct
from socket import *
g_server_ip = ''
g_downloadFileName = ''
def run_test():
	global g_server_ip
	global g_downloadFileName
	g_server_ip = sys.argv[1]
	g_downloadFileName = sys.argv[2]
def main():
	run_test()
	sendDataFirst = struct.pack('!H%dsb5sb'%len(g_downloadFileName), 1, g_downloadFileName.encode('gb2312'), 0, 'octet'.encode('gb2312'), 0)
	s = socket(AF_INET, SOCK_DGRAM)
	s.sendto(sendDataFirst, (g_server_ip, 69)) 
	downloadFlag = True 
	fileNum = 0 
	f = open(g_downloadFileName, 'wb')
	while True:
		responseData = s.recvfrom(1024)
		recvData, serverInfo = responseData
		packetOpt = struct.unpack("!H", recvData[:2])  
		packetNum = struct.unpack("!H", recvData[2:4]) 
		if packetOpt[0] == 3: 
			
			fileNum += 1
			
			if fileNum == 65536:
				fileNum = 0
			
			if fileNum == packetNum[0]:
				f.write(recvData[4:]) 
				fileNum = packetNum[0]
			ackData = struct.pack("!HH", 4, packetNum[0])
			s.sendto(ackData, serverInfo)
		
		elif packetOpt[0] == 5:
			
			downloadFlag = False
			break
		else:
			
			break
		
		if len(recvData) < 516:
			downloadFlag = True
			
			break
	if downloadFlag == True:
		f.close()
	else:
		os.unlink(g_downloadFileName) 

if __name__ == '__main__':
	main()
