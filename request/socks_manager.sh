#!/bin/bash
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;32m" [3]="\033[1;36m" [4]="\033[1;31m" [5]="\033[1;33m" )
barra="\033[0m\e[34m======================================================\033[1;37m"
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit

fun_trans () { 
local texto
local retorno
declare -A texto
SCPidioma="${SCPdir}/idioma"
[[ ! -e ${SCPidioma} ]] && touch ${SCPidioma}
local LINGUAGE=$(cat ${SCPidioma})
[[ -z $LINGUAGE ]] && LINGUAGE=pt
[[ ! -e /etc/texto-adm ]] && touch /etc/texto-adm
source /etc/texto-adm
if [[ -z "$(echo ${texto[$@]})" ]]; then
 retorno="$(source trans -e google -b pt:${LINGUAGE} "$@"|sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
 if [[ $retorno = "" ]];then
 retorno="$(source trans -e bing -b pt:${LINGUAGE} "$@"|sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
 fi
 if [[ $retorno = "" ]];then 
 retorno="$(source trans -e yandex -b pt:${LINGUAGE} "$@"|sed -e 's/[^a-z0-9 -]//ig' 2>/dev/null)"
 fi
echo "texto[$@]='$retorno'"  >> /etc/texto-adm
echo "$retorno"
else
echo "${texto[$@]}"
fi
}

mportas () {
unset portas
portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e $portas|grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
done <<< "$portas_var"
i=1
echo -e "$portas"
}

ssl_redir() {
msg -bra "$(fun_trans "Asigne un nombre para el redirecionador")"
msg -bar
read -p " nombre: " namer
msg -bar
msg -ama "$(fun_trans "A que puerto redirecionara el puerto SSL")"
msg -ama "$(fun_trans "Es decir un puerto abierto en su servidor")"
msg -ama "$(fun_trans "Ejemplo Dropbear, OpenSSH, ShadowSocks, OpenVPN, Etc")"
msg -bar
read -p " Local-Port: " portd
msg -bar
msg -ama "$(fun_trans "Que puerto desea agregar como SSL")"
msg -bar
    while true; do
    read -p " Puerto SSL: " SSLPORTr
    [[ $(mportas|grep -w "$SSLPORTr") ]] || break
    msg -bar
    echo -e "$(fun_trans "${cor[0]}Esta puerta está en uso")"
    msg -bar
    unset SSLPORT1
    done

echo "" >> /etc/stunnel/stunnel.conf
echo "[${namer}]" >> /etc/stunnel/stunnel.conf
echo "connect = 127.0.0.1:${portd}" >> /etc/stunnel/stunnel.conf
echo "accept = ${SSLPORTr}" >> /etc/stunnel/stunnel.conf
echo "client = no" >> /etc/stunnel/stunnel.conf


service stunnel4 restart > /dev/null 2>&1
msg -bar
msg -bra " $(fun_trans "AGREGADO CON EXITO") ${cor[2]}[!OK]"
msg -bar
}

remove_fun () {
msg -ama "$(fun_trans "Parando") Socks Python"
msg -bar
pidproxy=$(ps x | grep "tcp-client.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy ]] && pid_kill $pidproxy
pidproxy2=$(ps x | grep "Proxy-Publico.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy2 ]] && pid_kill $pidproxy2
pidproxy3=$(ps x | grep "Proxy-Privado.py" | grep -v "grep" | awk -F "pts" '{print $1}') && [[ ! -z $pidproxy3 ]] && pid_kill $pidproxy3
echo -e " Socks $(fun_trans "parado")!"
msg -bar
return
}

cleanreg () {
echo -ne " \033[1;31m[ ! ] Registro del limitador eliminado"
sudo rm -rf /etc/newadm/ger-user/Limiter.log > /dev/null 2>&1 && echo -e "\033[1;32m [OK]"
echo -e "$barra"
sleep 3s
adm
}

userdell () {
echo -e "\033[1;33mATENCION ESTO REMOVERA TODOS LOS USUARIOS\033[0m"
echo -e "\033[1;33mNO FUNCIONA CON OPENVPN\033[0m"
echo -e "$barra"
read -p "Opcion [S/N]: " -e -i s remov
if [ "$remov" = "s" ]
then
for u in `awk -F : '$3 > 900 { print $1 }' /etc/passwd | grep -v "nobody" |grep -vi polkitd |grep -vi system-`; do
userdel $u
done
echo -e "$barra"
echo -e "\033[1;31mUSUARIOS ELIMINADOS CON EXITO [OK]!\033[0m"
echo -e "$barra"
else
echo -e "$barra"
echo -e "\033[1;31mOPERACION CANCELADA\033[0m"
echo -e "$barra"
  sleep 5s
adm
fi
 }

gestor_fun () {
echo -e " ${cor[3]} $(fun_trans "ADMINISTRADOR BETA-TESTER") ${cor[2]}[NEW-ADM]"
echo -e "$barra"
while true; do
echo -e "${cor[2]} [1] > ${cor[3]}$(fun_trans "TCP-Client para TCP-OVER")"
echo -e "${cor[2]} [2] > ${cor[3]}$(fun_trans "Proxy Python Color Publico")"
echo -e "${cor[2]} [3] > ${cor[3]}$(fun_trans "Proxy Python Color Privado")"
echo -e "${cor[2]} [4] > ${cor[3]}$(fun_trans "ShadowSocks Libev Server")"
echo -e "${cor[2]} [5] > ${cor[3]}$(fun_trans "ShadowSocks Manager RRMU")"
echo -e "$barra"
echo -e "${cor[2]} [6] > ${cor[3]}$(fun_trans "Detenga todos los Sockts de python")"
echo -e "$barra"
echo -e "${cor[2]} [7] > ${cor[3]}$(fun_trans "Eliminar Registro del Limitador")"
echo -e "${cor[2]} [8] > ${cor[3]}$(fun_trans "Eliminar todos los usuarios del VPS")"
echo -e "${cor[2]} [9] > ${cor[3]}$(fun_trans "Multi portos SSL")"
echo -e "${cor[2]} [0] > ${cor[0]}$(fun_trans "VOLTAR")\n${barra}"
while [[ ${opx} != @(0|[1-9]) ]]; do
echo -ne "${cor[0]}$(fun_trans "Digite a Opcao"): \033[1;37m" && read opx
tput cuu1 && tput dl1
done
case $opx in
	0)
	return;;
	1)
	wget -O /bin/tcp-client.py https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/ADM-ULTIMATE-NEW-FREE/master/Herramientas/tcp-client.py > /dev/null 2>&1; chmod +x /bin/tcp-client.py; tcp-client.py 
	break;;
	2)
	wget -O /bin/Proxy-Publico.py https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/ADM-ULTIMATE-NEW-FREE/master/Herramientas/Proxy-Publico.py > /dev/null 2>&1; chmod +x /bin/Proxy-Publico.py; Proxy-Publico.py
	break;;
	3)
	wget -O /bin/Proxy-Privado.py https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/ADM-ULTIMATE-NEW-FREE/master/Herramientas/Proxy-Privado.py > /dev/null 2>&1; chmod +x /bin/Proxy-Privado.py; Proxy-Privado.py
	break;;
	4)
	wget -O /bin/shadowsocks.sh https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/ADM-ULTIMATE-NEW-FREE/master/Herramientas/shadowsocks.sh > /dev/null 2>&1; chmod +x /bin/shadowsocks.sh; shadowsocks.sh
	break;;
	5)
	wget -O /bin/ssrrmu.sh https://raw.githubusercontent.com/AAAAAEXQOSyIpN2JZ0ehUQ/ADM-ULTIMATE-NEW-FREE/master/Herramientas/ssrrmu.sh > /dev/null 2>&1; chmod +x /bin/ssrrmu.sh; ssrrmu.sh
	break;;
        6)
	remove_fun
	break;;
        7)
	cleanreg
	break;;
        8)
	userdell
	break;;
        9)
	ssl_redir
	break;;
esac
done
}
gestor_fun