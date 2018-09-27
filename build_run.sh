#!/bin/bash

echo "Compiling source code"
javac -d release src/lac/*
cd release

echo ""
echo "Creating JMeasure jar file"
jar -cvf JMeasure.jar lac
rm -r lac

echo ""
echo "You can run the tool with the following command line:"
echo "java -cp release/JMeasure.jar lac.JMeasure 192.168.4.1 output_file "
