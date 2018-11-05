from memory_profiler import memory_usage
import time
import os
import sys
import string


if __name__ == '__main__':
	if not len(sys.argv) == 4 or not all(i in string.digits for i in sys.argv[1]):
		print("usage: %s PID" % sys.argv[0])
		exit(2)
	else:
		rNumber = int(time.time())
		frameworkName = sys.argv[2]
		datasetName = sys.argv[3]
		filename = "Results/Memory/"+str(frameworkName)+"_"+str(datasetName)+"_"+str(rNumber)+".txt"
		print("Memory Logger Start\n")
		print("Result File: " + filename)
		
		if not os.path.exists(os.path.dirname(filename)):
			try:
				os.makedirs(os.path.dirname(filename))
			except OSError as exc: # Guard against race condition
				if exc.errno != errno.EEXIST:
					raise
	
		f = open(filename, "a")
		print(os.getpid())
		mem_usage = memory_usage(int(sys.argv[1]), interval=1, timeout=360000,retval=False,stream=f)
