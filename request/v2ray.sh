#!/bin/bash
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit 1
SCPusr="${SCPdir}/ger-user" && [[ ! -d ${SCPusr} ]] && exit 1 #mkdir ${SCPusr}
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit 1 #mkdir ${SCPfrm}
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPfrm} ]] && exit 1 #mkdir ${SCPfrm}
#06/07/2021
#THONYDROID

install_v2ray () {
source <(curl -sL https://multi.netlify.app/v2ray.sh)

${SCPinst}/v2ray.sh
}

uninstall_v2ray () {
source <(curl -sL https://multi.netlify.app/v2ray.sh) --remove

${SCPinst}/v2ray.sh
}

information_v2ray () {
v2ray info

${SCPinst}/v2ray.sh
}

msg -ama "$(fun_trans "MENU V2RAY") $(msg -verd "[ADM-ULTIMATE-NEW-PRO]")"
menu_func "" ""
msg -verd "[0] $(msg -verm2 ">") $(msg -bra "$(fun_trans "REGRESAR")")"
msg -bar
v2opcion=$(selection_fun 6)
case $v2opcion in
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
