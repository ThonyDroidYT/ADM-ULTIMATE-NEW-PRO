#!/bin/bash
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit 1
SCPusr="${SCPdir}/ger-user" && [[ ! -d ${SCPusr} ]] && exit 1 #mkdir ${SCPusr}
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit 1 #mkdir ${SCPfrm}
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPfrm} ]] && exit 1 #mkdir ${SCPfrm}
#06/07/2021
#THONYDROID

install_v2ray () {
source <(curl -sL https://multi.netlify.app/v2ray.sh)
}

uninstall_v2ray () {
source <(curl -sL https://multi.netlify.app/v2ray.sh) --remove
}

information_v2ray () {
v2ray info
}

v2opcion=$(selection_fun 6)
case $v2opcion un
1) 
;;
2)
;;
3)
;;
4)
;;
5)
;;
esac
