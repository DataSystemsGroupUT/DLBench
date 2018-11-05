import psutil
import time
import os
import sys
import string

def StartMonitoring(index,pid,frameworkName,datasetName):
        process = psutil.Process(int(pid))
        rNumber = int(time.time())
        filename = "Results/Cpu/"+str(frameworkName)+"_"+str(datasetName)+"_"+str(rNumber)+".txt"
        print("CPU Logger Start\n")
        print("Result File: " + filename)
        
        if not os.path.exists(os.path.dirname(filename)):
            try:
                os.makedirs(os.path.dirname(filename))
            except OSError as exc: # Guard against race condition
                if exc.errno != errno.EEXIST:
                    raise
        for index in range(1,360000):
            f=open(filename, "a+")
            message = str(index) + ", memory_percent: "+ str(process.memory_percent()) + ", cpu_percent: " + str(psutil.cpu_percent(percpu=False))
            f.write(message+"\n")
            time.sleep(1)

if __name__ == '__main__':
    if not len(sys.argv) == 4 or not all(i in string.digits for i in sys.argv[1]):
        print("usage: %s PID" % sys.argv[0])
        exit(2)
    else:
        print("%CPU\t%MEM")
        StartMonitoring(0,sys.argv[1],sys.argv[2],sys.argv[3])
