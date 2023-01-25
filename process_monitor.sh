#!/bin/bash

if [ -z "$1" ]; then
  echo "Provide a process name as 1st argument"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Provide a log file name as 2nd argument"
  exit 1
fi

PROCESS_NAME=$1
LOG_FILE=$2

echo "Starting monotoring $PROCESS_NAME" > $LOG_FILE

echo "time,pid,cpu_usage,mem_usage,open_fds" >> $LOG_FILE

while true; do
  pid=$(pgrep $PROCESS_NAME)
  if [ -z "$pid" ]; then
    echo "Process $PROCESS_NAME is not running"
    exit 1
  fi
  open_fds=$(lsof -p $pid | wc -l)
  cpu_usage=$(ps -p $pid -o %cpu | awk 'NR>1')
  #mem_usage=$(ps -p $pid -o %mem | awk 'NR>1')
  mem_usage_kb=$(ps -p $pid -o %mem | awk 'NR>1')
  mem_usage_mb=$(echo "scale=2; $mem_usage_kb/1024" | bc)

  #echo "$(date +'%Y-%m-%d %H:%M:%S') $PROCESS_NAME (PID $pid) $cpu_usage% CPU usage and $mem_usage% memory usage and $open_fds open fds"
  #echo "$(date +'%Y-%m-%d %H:%M:%S') $PROCESS_NAME (PID $pid) $cpu_usage% CPU usage and $mem_usage% memory usage and $open_fds open fds" >> $LOG_FILE

  echo "$(date +'%Y-%m-%d %H:%M:%S'),$pid,$cpu_usage,$mem_usage_mb,$open_fds" >> $LOG_FILE
  sleep 5
done