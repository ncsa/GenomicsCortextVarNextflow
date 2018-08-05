#!/bin/python3
def findOptimalHandW (targetN):
	complete_list = []
	#format of list = [0] is height, [1] is width, [2] is calculated N
	for height in range(1,31):
		for width in range(1,31):
			
			complete_list.append([height, width, (2**height)*width])

	for element in complete_list:
		if element[2] < targetN:
			element[2] = 0


	targetN_fulfilled_list = []
	for element in complete_list:   
		if element[2] != 0:
			targetN_fulfilled_list.append(element)

	minElement = targetN_fulfilled_list[0]
	minN = targetN_fulfilled_list[0][2]
	for element in targetN_fulfilled_list:
		if element[2] < minN:
			minN = element[2]
			minElement = element	
	
	height = minElement[0]
	width = minElement[1]
	print ("height = " + str(height))
	print ("width = " + str (width))
	return 
 
inputGenomeSize = int(input("Enter genome size in bases: "))
inputTargetN = 2*inputGenomeSize

findOptimalHandW(inputTargetN)




