#!/bin/python3

import math

def findRightQueue ( height, width, kmerSize, numberOfSamples):

	memoryConstant = math.ceil((8*kmerSize/32) + 5*numberOfSamples + 1)
		
	while True:
		if memoryConstant % 8 != 0:
			memoryConstant = memoryConstant + 1
			continue
		else:
			memoryConstant = memoryConstant
			break

	N = (2**height)*width
	
	memoryRequiredInBytes = memoryConstant * N

	print ("Memory Required in GB: " + str(memoryRequiredInBytes/1000000000))

	print ("Memory Required in TB: " + str(memoryRequiredInBytes/1000000000000))
	
	if memoryRequiredInBytes < 64000000000:
		print ("FOR IFORGE USERS ONLY: Use normal")

	elif memoryRequiredInBytes > 64000000000 and memoryRequiredInBytes < 256000000000:
		print ("FOR IFORGE USERS ONLY: Use big_mem")

	elif memoryRequiredInBytes > 256000000000 and memoryRequiredInBytes < 1500000000000:
		print ("FOR IFORGE USERS ONLY: Use super_mem")	

	else:
		print("FOR IFORGE USERS ONLY: too big! not enough memory")

	return 	


inputHeight = int(input("Enter height: "))
inputWidth = int(input("Enter width: "))
inputKmerSize = int(input("enter kmer size: "))
inputNumberOfSamples = int(input("enter number of samples: "))


findRightQueue(inputHeight, inputWidth, inputKmerSize, inputNumberOfSamples)
