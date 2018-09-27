#!/bin/bash

echo "Compiling Loop.java"
javac -cp lib/jmeasure-linuxlib.jar -d bin src/Loop.java
echo ""

if [[ ! -z "$1" ]]; then
  echo "Running Loop with $1 iterations"
  java -cp bin:lib/jmeasure-linuxlib.jar Loop $1
else
  echo "You may pass an integer as argument to this script"  
  echo "As a result, you will run the Loop class with this"
  echo "argument as an input (defs the number of iterations)."
fi
