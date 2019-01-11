#!/usr/bin/env python

sampleName = "$coverageInfo".replace(".ctx.covg","")

fh = open("$coverageInfo", "r")

pairsList = []

for line in fh:
	line = line.strip()
	pairsList.append(line.split("\t"))
fh.close()


firstMinPair = pairsList[2]
for i in range(2,len(pairsList) - 2):
	if int(pairsList[i][1]) < int(pairsList[i+1][1]):
		firstMinPair = pairsList[i]
		break
if int(firstMinPair[0]) > 8:
	firstMinPair[0] = 1
pairString = sampleName + "," + str(firstMinPair[0])


