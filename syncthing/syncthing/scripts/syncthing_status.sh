#! /bin/sh
source /jffs/softcenter/scripts/base.sh

syncthing_pid=`pidof syncthing`
syncthing_tool_version=`dbus get syncthing_version`
syncthing_version=`/jffs/softcenter/bin/syncthing --version | head -n 1`
if [ -n "$syncthing_pid" ];then
    echo "当前插件版本：${syncthing_tool_version}；${syncthing_version} 进程运行正常！（PID：$syncthing_pid）" > /tmp/syncthing_status.log
else
    echo "${syncthing_version} 进程未运行！" > /tmp/syncthing_status.log
fi


