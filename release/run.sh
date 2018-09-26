#!/bin/bash

echo "Script name: $0"
echo "Arguments: $@"
if [ $# -ne 2 ]; then 
	echo "illegal number of parameters"
	echo "Correct syntax: $0 smartpowerIP outFile.txt"
fi


java -cp JMeasure.jar lac.JMeasure $1 $2
