#!/bin/bash

prefix=colorlistFileToSubmit
colorListFile=${colorList}
fileIndex=\${colorListFile#*\${prefix}}

sampleListFile=${sampleListsDir}/sampleList\${fileIndex}
touch \$sampleListFile

declare -a sampleArray
prefix="pathToCleaned"
index=0
while read pathToSample
do      
	if ((\$index==0))
	then    
		echo "REF" > \$sampleListFile
	else    
		echo \${pathToSample#*\$prefix} >> \$sampleListFile
	fi
	
	index=\$((\$index+1))
done < ${colorList}
