#!/bin/bash

function cpufreqset() {
  shell="adb shell"
  echo "Setting CPU governor to $1"
  $shell "echo $1 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
  $shell "echo $1 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor"
  $shell "cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor"
}


governor="ondemand"
echo "=== ${governor} ==="
cpufreqset "$governor"


#default ondemand
name="default-on"
for i in $(seq 1 5); do
    java -cp JMeasure.jar lac.JMeasure ${name}-${i}.log 192.168.4.1 &
    adb shell "am force-stop  dvfs.lac.sampleparallelapp/.MainActivity"
    adb shell "am start -n dvfs.lac.sampleparallelapp/.MainActivity -e coreConfig ff -e file ${name}-${i}.log"
    sleep 7
done

governor="ondemand"
echo "=== ${governor} ==="
cpufreqset "$governor"


#oracle ondemand
name="oracle-on"
for i in $(seq 1 5); do
    java -cp JMeasure.jar lac.JMeasure ${name}-${i}.log 192.168.4.1 &
    adb shell "am force-stop  dvfs.lac.sampleparallelapp/.MainActivity"
    adb shell "am start -n dvfs.lac.sampleparallelapp/.MainActivity -e coreConfig oracle -e file ${name}-${i}.log"
    sleep 7
done


governor="performance"
echo "=== ${governor} ==="
cpufreqset "$governor"

#oracle performance
name="oracle-per"
for i in $(seq 1 5); do
    java -cp JMeasure.jar lac.JMeasure ${name}-${i}.log 192.168.4.1 &
    adb shell "am force-stop  dvfs.lac.sampleparallelapp/.MainActivity"
    adb shell "am start -n dvfs.lac.sampleparallelapp/.MainActivity -e coreConfig oracle -e file ${name}-${i}.log"
    sleep 7
done
