#!/bin/bash
#######################################
#
# Obtener informacion de un host
# Sistema Operativo RedHat / Oracle Linux
# Daniela Torres - danielatorres@danielatorres.me
#
#######################################

usage(){
cat << EOF
	Uso: $0 optiones

	Este script recolecta informacion sobre el sistema

	OPTIONS:
	   -help   Muestra este mensaje 
	   -h      Nombre de la maquina
	   -l      Nombre del archivo de log
EOF
}

HOST=
LOGFILE=

while getopts h:l:help OPTION
do
     case $OPTION in
         help)
             usage
             exit 1
             ;;
         h)
	     echo $OPTARG
             HOST=$OPTARG
             ;;
         l)
	     echo $OPTARG
             LOGFILE=$OPTARG
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z ${HOST} ]] || [[ -z ${LOGFILE} ]]
then
     echo "Variables vacias"
     echo ${HOST}
     echo ${LOGFILE}
     usage
     exit 1
fi

# display usage if the script is not run as root user 
if [[ $USER != "root" ]]; then 
	echo "Este script debe ser ejecutado como root" 
	exit 1
fi 

HOSTNAME=`hostname`
echo "###############################################" >> $LOGFILE
echo "# Informacion para el Host $HOST" >> $LOGFILE
echo "# Hostname: $HOSTNAME" >> $LOGFILE
echo "###############################################" >> $LOGFILE


echo "###############################################" >> $LOGFILE
echo "# MEMORIA RAM Y CPU" >> $LOGFILE
echo "###############################################" >> $LOGFILE

free -m >> $LOGFILE
echo "###############################################" >> $LOGFILE
cat /proc/meminfo >> $LOGFILE
echo "###############################################" >> $LOGFILE
cat /proc/cpuinfo >> $LOGFILE


echo "###############################################" >> $LOGFILE
echo "# INFORMACION DE DISCOS ">> $LOGFILE
echo "###############################################" >> $LOGFILE

fdisk -l >> $LOGFILE
df -h >> $LOGFILE

echo "###############################################" >> $LOGFILE
echo "# INFORMACION DEL SISTEMA ">> $LOGFILE
echo "###############################################" >> $LOGFILE

echo "######### Dispositivos Instalados #########" >> $LOGFILE

lspci >> $LOGFILE

echo "######### Parametros de kernel #########" >> $LOGFILE
sysctl -a >> $LOGFILE

echo "######### Servicios #########" >> $LOGFILE

chkconfig >> $LOGFILE

echo "######### Release de Sistema Operativo #########" >> $LOGFILE
uname -a >> $LOGFILE
cat /etc/redhat-release >> $LOGFILE
rpm -qf /etc/redhat-release >> $LOGFILE

echo "######### Limites para usuarios  #########" >> $LOGFILE
cat /etc/security/limits.conf >> $LOGFILE

echo "######### Paquetes Instalados  #########" >> $LOGFILE
yum list installed >> $LOGFILE

echo "######### Configuracion de SELinux  #########" >> $LOGFILE
cat /etc/selinux/config >> $LOGFILE

echo "###############################################" >> $LOGFILE
echo "# INFORMACION DE RED ">> $LOGFILE
echo "###############################################" >> $LOGFILE

echo "######### Interfaces de Red #########" >> $LOGFILE
ifconfig -a >> $LOGFILE
echo "######### Informacion del Router Default  #########" >> $LOGFILE
route >> $LOGFILE
echo "######### Informacion del DNS  #########" >> $LOGFILE
cat /etc/resolv.conf >> $LOGFILE
echo "######### Informacion del archivo de Hosts  #########" >> $LOGFILE
cat /etc/hosts >> $LOGFILE
echo "######### Informacion puertos abiertos del sistema  #########" >> $LOGFILE
ss -tulpn >> $LOGFILE

echo "###############################################" >> $LOGFILE
echo "# INFORMACION DE USUARIOS ">> $LOGFILE
echo "###############################################" >> $LOGFILE
echo "######### Listado de usuarios  #########" >> $LOGFILE
cat /etc/passwd >> $LOGFILE
echo "######### Listado de grupos  #########" >> $LOGFILE
cat /etc/group >> $LOGFILE
