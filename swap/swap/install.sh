#! /bin/sh

find /jffs/softcenter/init.d/ -name "*swap.sh*"|xargs rm -rf
cd /tmp
cp -rf /tmp/swap/scripts/* /jffs/softcenter/scripts/
cp -rf /tmp/swap/init.d/* /jffs/softcenter/init.d/
cp -rf /tmp/swap/webs/* /jffs/softcenter/webs/
cp -rf /tmp/swap/res/* /jffs/softcenter/res/
cd /
rm -rf /tmp/swap* >/dev/null 2>&1

chmod +x /jffs/scripts/post-mount
chmod +X /jffs/softcenter/scripts/swap*
chmod +X /jffs/softcenter/init.d/*

