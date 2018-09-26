#!/bin/bash

echo "Compiling source code"
javac -d release src/lac/*
cd release
echo "Creating JMeasure jar file"
jar -cvf JMeasure.jar lac
rm -r lac
