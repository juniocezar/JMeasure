#!/bin/bash

JmeasureLib="${HOME}/repositories/LibraryJava/release/jmeasure-linuxlib.jar "
# could have just done the arithmetic, but used array to
# be easier to undestand the experiment. Each sub block
# has 4 elements under a same AP
iterations=(1 10 100 1000 2000 3000 4000 5000 10000 15000 20000 25000 50000 75000 100000 125000 250000 375000 500000 625000)

# cpu governors used in out experiment
governors=("performance" "powersave")

# core configuration used in experiment
# first = one big core, second = one little core
configs=("80" "08")


# function for setting CPU Governor
function cpufreq {
  echo ""
  echo "Setting CPU governor to $1"  
  sudo echo "$1" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  sudo echo "$1" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu1/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu5/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu6/cpufreq/scaling_governor
  cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor
}

# set fan to max speed
function fanmaxspeed {
  echo "Setting FAN to manual mode"
  sudo echo 0 > /sys/devices/odroid_fan.14/fan_mode
  echo "Setting FAN to maximum rotation: 250"
  sudo echo 250 > /sys/devices/odroid_fan.14/pwm_duty
}

# script client side
function clientside {
  # Running experiment with one big core
  # performance and powersave governors
  for config in ${configs[@]}; do
    echo ""
    echo "Using core configuration 0x${config}"
    for governor in ${governors[@]}; do
      cpufreq "$governor"
      for it in ${iterations[@]}; do
        sleep 2 #just some time to the JMeasure tool be opened in the server
        echo ""
        echo "Running Loop microbench with the input: $it"

        echo ""
        echo "Enabling JMeasure monitor on the host machine"
        java -cp ${JmeasureLib} lac.JMeasure enable

        for exp in $(seq 1 10); do
          echo "$exp / 10"
          taskset 0x${config} java -cp bin:lib/jmeasure-linuxlib.jar Loop $it
          sleep 1.5
        done

        echo ""
        echo "Disabling JMeasure monitor on the host machine"
        java -cp ${JmeasureLib} lac.JMeasure disable

      done
    done
  done
}

# script server side
function serverside {

  for config in ${configs[@]}; do
    echo ""
    echo "Using core configuration 0x${config}"
    for governor in ${governors[@]}; do
      for it in ${iterations[@]}; do
        echo "java -cp ../release/JMeasure.jar lac.JMeasure 192.168.4.1 evaluation/measures/log-${config}-${governor}-${it}.txt"
        java -cp ../release/JMeasure.jar lac.JMeasure 192.168.4.1 measures/log-${config}-${governor}-${it}.txt
      done
    done
  done
  
}



# main
if [[ -z "$1" ]]; then
  echo ""
  echo "You must specify if you are running this script on the client (board)"
  echo "or on the host (laptop collecting samples)"
  echo ""
  echo "Example:"
  echo "$0 board"
  echo "or"
  echo "$0 host"
else
  if   [ "$1" == "board" ] || [ "$1" == "client" ]; then
    clientside
  elif [ "$1" ==  "host" ] || [ "$1" == "laptop" ]; then
    serverside
  else
    echo "Invalid argument: '$1'"
  fi
fi
