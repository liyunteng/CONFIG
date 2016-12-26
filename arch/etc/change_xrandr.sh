#!/bin/bash
###############################################################################
# Author : liyunteng
# Email : li_yunteng@163.com
# Created Time : 2014-08-15 11:57
# Filename : test.sh
# Description : 
###############################################################################
if [ "x$1" = "x" ];then
	echo "mode invalid"
	exit -1
fi

if [ "x$2" = "x" ];then
	echo "mode invalid"
	exit -1
fi

interfaces=`ls -d /sys/class/drm/card0/card0-*`
monitor=
for interface in $interfaces
do
	status=
	status=`cat $interface/status`
	if [ x"$status" = "xconnected" ]; then
		monitor=`basename $interface|cut -b 7-`
		break
	fi
done

if [ x"$monitor" = "x" ]; then
	echo "can't find display"
	exit -1
fi

x=$1
y=$2
if grep ${x}x${y} /sys/class/drm/card0/card0-$monitor/modes;then
	exit 0
fi

modeline=`cvt ${x} ${y}|sed -n 2p|cut -b 10- |tr -d \"`
xrandr --newmode $modeline
mode=`xrandr|grep ${x}x${y}|awk '{print $2}'|tr -d "()"`
xrandr --addmode $monitor $mode
xrandr --output $monitor --mode ${x}x${y}_60.00
exit 0
