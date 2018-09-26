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


governor=$1
echo "=== ${governor} ==="
cpufreqset "$governor"
