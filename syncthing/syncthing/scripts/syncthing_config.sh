#!/bin/sh 

# Copyright (C) 2021 MerlinRdev
# Copyright (C) 2021 沐心

eval `dbus export syncthing_`
source /jffs/softcenter/scripts/base.sh
alias echo_date='echo $(date +%Y年%m月%d日\ %X):'
echo " " > /tmp/.syncthing.log
[ -z "$syncthing_run_path" ] && syncthing_run_path=~/.config/syncthing
[ -z "$syncthing_port" ] && syncthing_port=8384
syncthing_announce_port=$(cat $syncthing_run_path/config.xml | grep -o \<localAnnouncePort\>[0-9]*\</localAnnouncePort\> | grep -o [0-9]*)

auto_start(){
	if [ "${syncthing_enable}" = "1" ];then
		echo_date 添加nat-start触发事件...
		ln -sf /jffs/softcenter/scripts/syncthing_config.sh /jffs/softcenter/init.d/M98syncthing.sh
		ln -sf /jffs/softcenter/scripts/syncthing_config.sh /jffs/softcenter/init.d/N98syncthing.sh
	else
		echo_date 删除nat-start触发...
		rm -rf /jffs/softcenter/init.d/M98syncthing.sh
		rm -rf /jffs/softcenter/init.d/N98syncthing.sh
	fi
}

open_ports(){
	if [ "$syncthing_wan_port" = "1" ]; then
		echo_date "开启syncthing WebGUI 端口 ${syncthing_port} 公网访问" >> /tmp/.syncthing.log
		iptables -I INPUT -p tcp --dport $syncthing_port -j ACCEPT >/dev/null 2>&1
		echo_date "开启syncthing Announce 端口 ${syncthing_announce_port} 公网访问" >> /tmp/.syncthing.log
		iptables -I INPUT -p tcp --dport $syncthing_announce_port -j ACCEPT >/dev/null 2>&1
	fi
}

close_ports(){
	iptables -D INPUT -p tcp --dport $syncthing_port -j ACCEPT >/dev/null 2>&1
	iptables -D INPUT -p tcp --dport $syncthing_announce_port -j ACCEPT >/dev/null 2>&1
}

stop_syncthing() {
	echo_date 关闭syncthing进程！
	killall -9 syncthing >/dev/null 2>&1
}

start_syncthing() {

	echo_date 开启syncthing主进程！
	export HOME="/jffs/softcenter/bin/sync"
	cd /jffs/softcenter/bin
	syncthing -gui-address="0.0.0.0:$syncthing_port" -home="$syncthing_run_path" -logfile="/tmp/syncthing.log" -no-browser >/dev/null &
}

case $ACTION in

stop)
	echo_date "停止syncthing！" >> /tmp/.syncthing.log
	auto_start
	close_ports >> /tmp/.syncthing.log
	stop_syncthing >> /tmp/.syncthing.log
	;;
*)
	if [ "$syncthing_enable" = "1" ]; then
		echo_date "启动syncthing！" >> /tmp/.syncthing.log
		auto_start
		close_ports >> /tmp/.syncthing.log
		stop_syncthing >> /tmp/.syncthing.log
		open_ports >> /tmp/.syncthing.log
		start_syncthing >> /tmp/.syncthing.log
	else
		echo_date "停止syncthing！" >> /tmp/.syncthing.log
		auto_start
		close_ports >> /tmp/.syncthing.log
		stop_syncthing >> /tmp/.syncthing.log
	fi
	;;
esac
