#!/bin/bash

proc_name="inotify"
proc_num()
{
  num=$(ps -ef | grep $proc_name | grep -v grep | wc -l)
  return $num 
}

proc_num
number=$?
if [ $number -eq 0 ]
then
  echo "here"
  nohup /etc/puppetlabs/puppet/inotify.sh > /dev/null 2>&1 &
else
  echo "there"
fi
