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

add_user(){
	unset seg
	seg=$(date +%s)
	while :
	do
	clear
	users="$(cat $config | jq -r .inbounds[].settings.clients[].email)"

	title "		CREAR USUARIO V2RAY"
	userDat

	n=0
	for i in $users
	do
		unset DateExp
		unset seg_exp
		unset exp

		[[ $i = null ]] && {
			i="default"
			a='*'
			DateExp=" unlimit"
			col "$a)" "$i" "$DateExp"
		} || {
			DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
			seg_exp=$(date +%s --date="$DateExp")
			exp="[$(($(($seg_exp - $seg)) / 86400))]"

			col "$n)" "$i" "$DateExp" "$exp"
		}
		let n++
	done
	echo -e $barra
	col "0)" "VOLVER"
	echo -e $barra
	blanco "NOMBRE DEL NUEVO USUARIO" 0
	read opcion

	[[ -z $opcion ]] && vacio && sleep 3 && continue

	[[ $opcion = 0 ]] && break

	blanco "DURACION EN DIAS" 0
	read dias

	espacios=$(echo "$opcion" | tr -d '[[:space:]]')
	opcion=$espacios

	mv $config $temp
	num=$(jq '.inbounds[].settings.clients | length' $temp)
	new=".inbounds[].settings.clients[$num]"
	new_id=$(uuidgen)
	new_mail="email:\"$opcion\""
	aid=$(jq '.inbounds[].settings.clients[0].alterId' $temp)
	echo jq \'$new += \{alterId:${aid},id:\"$new_id\","$new_mail"\}\' $temp \> $config | bash
	echo "$opcion | $new_id | $(date '+%y-%m-%d' -d " +$dias days")" >> $user_conf
	chmod 777 $config
	rm $temp
	clear
	echo -e $barra
	blanco "	Usuario creado con exito"
	echo -e $barra
	restart_v2r
	sleep 2
    done
}

renew(){
	while :
	do
		unset user
		clear
		title "		RENOVAR USUARIOS"
		userDat
		userEpx=$(cut -d " " -f1 $user_conf)
		n=1
		for i in $userEpx
		do
			DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
			seg_exp=$(date +%s --date="$DateExp")
			[[ "$seg" -gt "$seg_exp" ]] && {
				col "$n)" "$i" "$DateExp" "\033[0;31m[Exp]"
				uid[$n]="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f2|tr -d '[[:space:]]')"
				user[$n]=$i
				let n++
			}
		done
		[[ -z ${user[1]} ]] && blanco "		No hay expirados"
		echo -e $barra
		col "0)" "VOLVER"
		echo -e $barra
		blanco "NUMERO DE USUARIO A RENOVAR" 0
		read opcion

		[[ -z $opcion ]] && vacio && sleep 3 && continue
		[[ $opcion = 0 ]] && break

		[[ ! $opcion =~ $numero ]] && {
			blanco " solo numeros apartir de 1"
			sleep 2
		} || {
			[[ $opcion>=${n} ]] && {
				let n--
				blanco "solo numero entre 1 y $n"
				sleep 2
		} || {
			blanco "DURACION EN DIAS" 0
			read dias

			mv $config $temp
			num=$(jq '.inbounds[].settings.clients | length' $temp)
			aid=$(jq '.inbounds[].settings.clients[0].alterId' $temp)
			echo "cat $temp | jq '.inbounds[].settings.clients[$num] += {alterId:${aid},id:\"${uid[$opcion]}\",email:\"${user[$opcion]}\"}' >> $config" | bash
			sed -i "/${user[$opcion]}/d" $user_conf
			echo "${user[$opcion]} | ${uid[$opcion]} | $(date '+%y-%m-%d' -d " +$dias days")" >> $user_conf
			chmod 777 $config
			rm $temp
			clear
			echo -e $barra
			blanco "	Usuario renovado"
			echo -e $barra
			restart_v2r
			sleep 2
		  }
		}
	done
}

dell_user(){
	unset seg
	seg=$(date +%s)
	while :
	do
	clear
	users=$(cat $config | jq .inbounds[].settings.clients[] | jq -r .email)

	title "	ELIMINAR USUARIO V2RAY"
	userDat
	n=0
	for i in $users
	do
		userd[$n]=$i
		unset DateExp
		unset seg_exp
		unset exp

		[[ $i = null ]] && {
			i="default"
			a='*'
			DateExp=" unlimit"
			col "$a)" "$i" "$DateExp"
		} || {
			DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
			seg_exp=$(date +%s --date="$DateExp")
			exp="[$(($(($seg_exp - $seg)) / 86400))]"
			col "$n)" "$i" "$DateExp" "$exp"
		}
		p=$n
		let n++
	done
	userEpx=$(cut -d " " -f 1 $user_conf)
	for i in $userEpx
	do	
		DateExp="$(cat ${user_conf}|grep -w "${i}"|cut -d'|' -f3)"
		seg_exp=$(date +%s --date="$DateExp")
		[[ "$seg" -gt "$seg_exp" ]] && {
			col "$n)" "$i" "$DateExp" "\033[0;31m[Exp]"
			expUser[$n]=$i
		}
		let n++
	done
	echo -e $barra
	col "0)" "VOLVER"
	echo -e $barra
	blanco "NUMERO DE USUARIO A ELIMINAR" 0
	read opcion

	[[ -z $opcion ]] && vacio && sleep 3 && continue
	[[ $opcion = 0 ]] && break

	[[ ! $opcion =~ $numero ]] && {
		blanco " solo numeros apartir de 1"
		sleep 2
	} || {
		let n--
		[[ $opcion>=${n} ]] && {
			blanco "solo numero entre 1 y $n"
			sleep 2
		} || {
			[[ $opcion>=${p} ]] && {
				sed -i "/${expUser[$opcion]}/d" $user_conf
			} || {
			sed -i "/${userd[$opcion]}/d" $user_conf
			mv $config $temp
			echo jq \'del\(.inbounds[].settings.clients[$opcion]\)\' $temp \> $config | bash
			chmod 777 $config
			rm $temp
			clear
			echo -e $barra
			blanco "	Usuario eliminado"
			echo -e $barra
			restart_v2r
			}
			sleep 2
		}
	}
	done
}

information_v2ray () {
v2ray info

${SCPinst}/v2ray.sh
}

msg -ama "$(fun_trans "MENU V2RAY") $(msg -verd "[ADM-ULTIMATE-NEW-PRO]")"
menu_func "INSTALAR V2RAY" ""
msg -verd "[0] $(msg -verm2 ">") $(msg -bra "$(fun_trans "REGRESAR")")"
msg -bar
v2opcion=$(selection_fun 6)
case ${v2opcion} in
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
