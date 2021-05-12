#! /bin/sh
source /jffs/softcenter/scripts/base.sh
if [ -z "$ACTION" ];then
    exit
fi
keys=dis_${ACTION}
#获取当前目录元素
getdirs(){
    eval "$keys=\"treeitems = [\""
    i=0
    backpath=${get_path}
    fordirs="$get_path/*"
    for d in $fordirs
    do
        if test -d $d ;then
            dirname=${d##*/}
            if [ $i -gt 0 ];then
                eval "$keys=\"\${$keys} , \""
            fi
            eval "backdir$i=\"$dirname\""
            subnum=$(ls -l $backpath/$dirname/ | grep -E "^(d|l)" | grep -o -E "[0-9]{1,2}:[0-9]{1,2} +" | wc -l)
            eval "$keys=\"\${$keys} \\\"$dirname#$i#$subnum\\\"\""
            i=$(($i+1));
        fi
    done
     eval "$keys=\"\${$keys} ]\""
}
get_path=/mnt
is=0
for local_set in $(echo $ACTION | grep -o "[^_]")
do
    eval use_dir="\$backdir$local_set"
    if [ -n "$use_dir" ];then
        get_path=${get_path}/${use_dir}
    fi
    if [ $is -gt 0 ];then
        getdirs
    fi
    is=$(($is+1))
done
eval ext="\$$keys"
echo $ext > /tmp/syncthing_disk.log