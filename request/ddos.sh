#!/bin/bash
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;32m" [3]="\033[1;36m" [4]="\033[1;31m" )
barra="\033[0m\e[34m======================================================\033[1;37m"
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit 1
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit
SCPidioma="${SCPdir}/idioma" && [[ ! -e ${SCPidioma} ]] && touch ${SCPidioma}

antiddos (){
if [ -d '/usr/local/ddos' ]; then
	if [ -e '/usr/local/sbin/ddos' ]; then
		rm -f /usr/local/sbin/ddos
	fi
	if [ -d '/usr/local/ddos' ]; then
		rm -rf /usr/local/ddos
	fi
	if [ -e '/etc/cron.d/ddos.cron' ]; then
		rm -f /etc/cron.d/ddos.cron
	fi
	sleep 4s
	echo -e "$barra"
	echo -e "${cor[4]}$(fun_trans "ANTIDDOS DESINSTALADO CON SUCESSO")"
	echo -e "$barra"
	return 1
else
	mkdir /usr/local/ddos
fi
wget -q -O /usr/local/ddos/ddos.conf https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/ADM-ULTIMATE-NEW-FREE/master/Install/ddos.conf -o /dev/null
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf -o /dev/null
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE -o /dev/null
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list -o /dev/null
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh -o /dev/null
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
sleep 2s
echo -e "$barra"
echo -e "${cor[2]}$(fun_trans "ANTIDDOS INSTALAÇÃO CON SUCESSO")"
echo -e "$barra"
}
unset ddos
[[ -e /usr/local/ddos/ddos.conf ]] && ddos="\033[1;32m$(source trans -b pt:${id} "Online")"

echo -e "${cor[3]} $(fun_trans "ANTI DDOS INSTALAÇÃO") ${cor[2]}[NEW-ADM]"
echo -e "$barra"
echo -e "${cor[2]} [1] > ${cor[3]}$(fun_trans "Anti-DDOS") $ddos"
echo -e "${cor[2]} [0] > ${cor[0]}$(fun_trans "VOLTAR")"
echo -e "$barra"
echo -ne "\033[1;37m$(fun_trans "Digite a Opcao"): "
read optons
case $optons in
0)
exit
;;
1)
antiddos
;;
esac