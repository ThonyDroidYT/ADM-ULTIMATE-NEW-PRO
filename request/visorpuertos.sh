#!/bin/bash
declare -A cor=( [0]="\033[1;37m" [1]="\033[0;34m" [2]="\033[1;31m" [3]="\033[1;33m" [4]="\033[1;32m" [5]="\033[1;36m" )
barra="\033[0m\e[34m======================================================\033[1;37m"
SCPdir="/etc/newadm" && [[ ! -d ${SCPdir} ]] && exit
SCPfrm="/etc/ger-frm" && [[ ! -d ${SCPfrm} ]] && exit
SCPinst="/etc/ger-inst" && [[ ! -d ${SCPinst} ]] && exit
echo -e "${cor[5]} $(fun_trans "PORTAS ACTIVAS VPS") ${cor[4]}[NEW-ADM]"
echo -e "${cor[1]}====================================================== ${cor[0]}"
echo -e "${cor[3]} $(fun_trans "PORTAS ACTIVAS TOTAIS NO SEU SERVIDOR VPS")"
echo -e "${cor[1]}====================================================== ${cor[0]}"

os_system () {
system=$(echo $(cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/      //'))
echo $system|awk '{print $1, $2}'
}

_hora=$(printf '%(%H:%M:%S)T')

echo -e "\033[1;31mHORA SISTEMA: \033[1;37m$_hora     \033[1;31mIP: \033[1;37m$(meu_ip)"

echo -e "${cor[1]}====================================================== ${cor[0]}"

#PROCESSADOR
_usop=$(printf '%-1s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
_core=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")

#SISTEMA-USO DA CPU-MEMORIA RAM
ram1=$(free -h | grep -i mem | awk {'print $2'})
ram2=$(free -h | grep -i mem | awk {'print $4'})
ram3=$(free -h | grep -i mem | awk {'print $3'})
uso=$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')
system=$(cat /etc/issue.net)

uso=$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')
system=$(cat /etc/issue.net)
if [ "$system" ]
then
echo -e "\033[1;31mSISTEMA\033[1;37m: \033[1;32m$system     \033[1;31mUSO DA CPU \033[1;37m[\033[1;32m$uso\033[1;37m]"
else
echo -e "\033[1;32mSISTEMA: \033[1;33m[ \033[1;37mNao disponivel \033[1;33m]"
fi
echo -e "${cor[1]}====================================================== ${cor[0]}"
echo -e "\033[1;31mPROCESSADOR: \033[1;37mNUCLEOS: \033[1;32m$_core \033[1;37mEM USO: \033[1;32m$_usop"
echo -e "${cor[1]}====================================================== ${cor[0]}"
echo -e "\033[1;31mMEMORIA RAM\033[1;37m TOTAL: \033[1;32m$ram1  \033[1;37mUSADO: \033[1;32m$ram3  \033[1;37mLIVRE: \033[1;32m$ram2"

echo -e "${cor[1]}====================================================== ${cor[0]}"

mine_port () {
unset portas
portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
i=0
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e ${portas[@]}|grep "$var1 $var2")" ]] || {
    portas[$i]="$var1 $var2"
    let i++
    }
done <<< "$portas_var"
for((i=0; i<=${#portas[@]}; i++)); do
servico="$(echo ${portas[$i]}|cut -d' ' -f1)"
porta="$(echo ${portas[$i]}|cut -d' ' -f2)"
[[ -z $servico ]] && break
texto="\033[1;31m${servico}: \033[1;32m${porta}"
     while [[ ${#texto} -lt 35 ]]; do
        texto=$texto" "
     done
echo -ne "${texto}"
let i++
servico="$(echo ${portas[$i]}|cut -d' ' -f1)"
porta="$(echo ${portas[$i]}|cut -d' ' -f2)"
[[ -z $servico ]] && {
   echo -e " "
   break
   }
texto="\033[1;31m${servico}: \033[1;32m${porta}"
     while [[ ${#texto} -lt 35 ]]; do
        texto=$texto" "
     done
echo -ne "${texto}"
let i++
servico="$(echo ${portas[$i]}|cut -d' ' -f1)"
porta="$(echo ${portas[$i]}|cut -d' ' -f2)"
[[ -z $servico ]] && {
   echo -e " "
   break
   }
texto="\033[1;31m${servico}: \033[1;32m${porta}"
     while [[ ${#texto} -lt 35 ]]; do
        texto=$texto" "
     done
echo -e "${texto}"
done
echo -e "$barra"
}
mine_port