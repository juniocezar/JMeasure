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


governor="performance"
echo "=== ${governor} ==="
cpufreqset "$governor"

CONFIGS=(08 10 f0 0f ff)

for config in ${CONFIGS[@]}; do
  echo "Running for configuration: $config"
  name="${config}-performance"
  for i in $(seq 1 5); do
    echo "Execution number $i"
    #java -cp JMeasure.jar lac.JMeasure ${name}-${i}.log 192.168.4.1 &
    adb shell "am force-stop  dvfs.lac.sampleparallelapp/.MainActivity"
    adb shell "am start -n dvfs.lac.sampleparallelapp/.MainActivity -e coreConfig $config -e file ${name}-${i}.log"
    sleep 10
  done
done

