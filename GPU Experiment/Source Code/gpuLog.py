# -*- coding: utf-8 -*-
"""
Created on Wed Oct 10 16:27:18 2018

@author: nesma
"""

from subprocess import Popen, PIPE
import os
import math
import random
import time
import sys
import psutil
import time
import string

class GPU:
    def __init__(self, ID, uuid, load, memoryTotal, memoryUsed, memoryFree, driver, gpu_name, serial, display_mode, display_active, temp_gpu):
        self.id = ID
        self.uuid = uuid
        self.load = load
        self.memoryUtil = float(memoryUsed)/float(memoryTotal)
        self.memoryTotal = memoryTotal
        self.memoryUsed = memoryUsed
        self.memoryFree = memoryFree
        self.driver = driver
        self.name = gpu_name
        self.serial = serial
        self.display_mode = display_mode
        self.display_active = display_active
        self.temperature = temp_gpu
        
def safeFloatCast(strNumber):
    try:
        number = float(strNumber)
    except ValueError:
        number = float('nan')
    return number

def getGPUs():
    try:
        p = Popen(["nvidia-smi","--query-gpu=index,uuid,utilization.gpu,memory.total,memory.used,memory.free,driver_version,name,gpu_serial,display_active,display_mode,temperature.gpu", "--format=csv,noheader,nounits"], stdout=PIPE)
        stdout, stderror = p.communicate()
    except:
        return []
    output = stdout.decode('UTF-8')
    lines = output.split(os.linesep)
    numDevices = len(lines)-1
    GPUs = []
    for g in range(numDevices):
        line = lines[g]
        vals = line.split(', ')
        for i in range(12):
            if (i == 0):
                deviceIds = int(vals[i])
            elif (i == 1):
                uuid = vals[i]
            elif (i == 2):
                gpuUtil = safeFloatCast(vals[i])/100
            elif (i == 3):
                memTotal = safeFloatCast(vals[i])
            elif (i == 4):
                memUsed = safeFloatCast(vals[i])
            elif (i == 5):
                memFree = safeFloatCast(vals[i])
            elif (i == 6):
                driver = vals[i]
            elif (i == 7):
                gpu_name = vals[i]
            elif (i == 8):
                serial = vals[i]
            elif (i == 9):
                display_active = vals[i]
            elif (i == 10):
                display_mode = vals[i]
            elif (i == 11):
                temp_gpu = safeFloatCast(vals[i]);
        GPUs.append(GPU(deviceIds, uuid, gpuUtil, memTotal, memUsed, memFree, driver, gpu_name, serial, display_mode, display_active, temp_gpu))
    return GPUs  # (deviceIds, gpuUtil, memUtil)

def showUtilization( attrList=None):
    GPUs = getGPUs()
    #print(' ID | Name | Serial | UUID || GPU util. | Memory util. || Memory total | Memory used | Memory free || Display mode | Display active |')
    #print('------------------------------------------------------------------------------------------------------------------------------') 
    res = ""
    for gpu in GPUs:
        res += ' {0:3.0f}% | {1:3.0f}MB'.format(gpu.load*100,gpu.memoryUsed)
    return res

def StartMonitoring(index,pid,frameworkName,datasetName):
        process = psutil.Process(int(pid))
        rNumber = int(time.time())
        filename = "Results/Gpu/"+str(frameworkName)+"_"+str(datasetName)+"_"+str(rNumber)+".txt"
        print("Gpu Logger Start\n")
        print("Result File: " + filename)
        
        if not os.path.exists(os.path.dirname(filename)):
            try:
                os.makedirs(os.path.dirname(filename))
            except OSError as exc: # Guard against race condition
                if exc.errno != errno.EEXIST:
                    raise
        for index in range(1,360000):
            f=open(filename, "a+")
            message = str(index) + ", gpu_percent: "+ str(showUtilization())
            f.write(message+"\n")
            time.sleep(1)

if __name__ == '__main__':
    if not len(sys.argv) == 4 or not all(i in string.digits for i in sys.argv[1]):
        print("usage: %s PID" % sys.argv[0])
        exit(2)
    else:
        print("%GPU\t%")
        StartMonitoring(0,sys.argv[1],sys.argv[2],sys.argv[3])
