#!/bin/sh
#2007 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html)
#make the pup_save.2fs file bigger.

# 3-5-2011 re write to gtk2 Xdialog it was in xmessage before by Joe Arose

#variables created at bootup by /initrd/usr/sbin/init...
. /etc/rc.d/PUPSTATE #v2.02
#PUPMODE=current operating configuration,
#PDEV1=the partition have booted off, DEV1FS=f.s. of PDEV1,
#PUPSFS=pup_201.sfs versioned name, stored on PDEV1, PUPSAVE=vfat,sda1,/pup_save.2fs

#find out what modes use a pup_save.2fs file...
CANDOIT="no"
case $PUPMODE in
 "12") #pup_save.3fs (pup_rw), nothing on pup_ro1, pup_xxx.sfs (pup_ro2).
  PERSISTMNTPT="/initrd/pup_rw"
  CANDOIT="yes"
  ;;
 "13") #tmpfs (pup_rw), pup_save.3fs (pup_ro1), pup_xxx.sfs (pup_ro2).
  PERSISTMNTPT="/initrd/pup_ro1"
  CANDOIT="yes"
  ;;
esac

 if [ "$CANDOIT" != "yes" ];then
  Xdialog --title "Cambiar el tamaño del pupsave ( archivo personal )" \
          --infobox "Lo sentimos, usted no está usando actualmente un pupsave personal
. Si esta es la primera vez que se ha arrancado
, Digamos de un CD en vivo, que está actualmente en ejecución
totalmente en la memoria RAM y se le pedirá que cree un personal
almacenamiento de archivos cuando finaliza la sesión (apagar el PC o
reiniciar). Tenga en cuenta que el archivo se llamará pup_save.2fs y
se creará en un lugar que usted nombre.
Si se ha instalado en el disco duro, o instalar
de tal manera que el almacenamiento personal es toda una partición, entonces
usted no tiene un archivo pup_save.2fs tampoco.
Precione aceptar para salir..." 0 0 60000
  
 
  exit
 fi

[ ! "$PUPSAVE" ] && exit #precaution
[ ! "$PUP_HOME" ] && exit #precaution.



SAVEFS="`echo -n "$PUPSAVE" | cut -f 2 -d ','`"
SAVEPART="`echo -n "$PUPSAVE" | cut -f 1 -d ','`"
SAVEFILE="`echo -n "$PUPSAVE" | cut -f 3 -d ','`"
NAMEPFILE="`basename $SAVEFILE`"

HOMELOCATION="/initrd${PUP_HOME}${SAVEFILE}"
SIZEFREE=`df -m | grep "$PERSISTMNTPT" | tr -s " " | cut -f 4 -d " "` #free space in pup_save.3fs
ACTUALSIZK=`ls -sk $HOMELOCATION | tr -s " " | cut -f 1 -d " "` #total size of pup_save.3fs
if [ ! $ACTUALSIZK ];then
 ACTUALSIZK=`ls -sk $HOMELOCATION | tr -s " " | cut -f 2 -d " "`
fi
ACTUALSIZE=`expr $ACTUALSIZK \/ 1024`
APATTERN="/dev/${SAVEPART} "
PARTFREE=`df -m | grep "$APATTERN" | tr -s " " | cut -f 4 -d " "`



Xdialog --title "Cambiar el tamaño del pupsave personal" \
        --menu "
Su archivo personal es de $NAMEPFILE, y este contiene todo
de sus datos, archivos de configuración, archivos de historia,
paquetes instalados y así sucesivamente. 

tiene $SIZEFREE Mbytes de espacio libre en $NAMEPFILE,
de un tamaño total de $ACTUALSIZE Mbytes.

el archivo $NAMEPFILE se almacena en la partición $SAVEPART.
tiene $PARTFREE Mbytes espacio libre en $SAVEPART.

Por lo tanto, es necesario tomar una decisión. Si ve que se está ejecutando
poco espacio en $NAMEPFILE, usted puede hacer que sea más grande, pero
Por supuesto, debe haber suficiente espacio en $SAVEPART.

TENGA EN CUENTA QUE DESPUÉS DE HABER ELEGIDO UNA OPCIÓN DE LAS DE  ABAJO,
No pasará nada. El cambio de tamaño se vera  al reiniciar.

Seleccione una opción para hacer $NAMEPFILE más grande ...
(observar, se trata de un solo sentido, no se puede reducir el tamaño de su pupsave)" 0 0 9 \
        "64" "MB de grande" \
        "128" "MB de grande" \
        "256" "MB de grande" \
        "512" "MB de grande " \
        "1024" "MB de grande  1GB" \
        "2048" "MB de grande  2GB" \
        "4096" "MB de grande  4GB"  \
        "8192" "MB de grande  8GB"  2> /tmp/reply2

REPLYX=$?

#for debugging 

REPLY2=`cat /tmp/reply2`
# echo $REPLY2

#zero the value
KILOBIG=

case $REPLYX in
  0)
    echo "'$choice' chosen."
	;;
  1)
    echo "Cancel pressed."
	exit
	;;
  255)
    echo "Box closed."
	exit 
	;;
esac


#--------------------------------------------
#        ##   Select increase in MB       ##
#--------------------------------------------
   if [ "$REPLY2" = "64" ]; then
   KILOBIG="65536"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "64M" > /tmp/reply3   
   
   elif  [ "$REPLY2" = "128" ]; then
   KILOBIG="131072"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "128M" > /tmp/reply3 
   
   elif  [ "$REPLY2" = "256" ]; then
   KILOBIG="262144"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "256M" > /tmp/reply3 
    
   
   elif  [ "$REPLY2" = "512" ]; then
   KILOBIG="524288"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "512M" > /tmp/reply3 
   
   elif  [ "$REPLY2" = "1024" ]; then
   KILOBIG="1048576"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "1G" > /tmp/reply3 
   
   elif  [ "$REPLY2" = "2048" ]; then
   KILOBIG="2097152"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "2G" > /tmp/reply3 
   
   elif  [ "$REPLY2" = "4096" ]; then
   KILOBIG="4194304"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "4G" > /tmp/reply3 
   
   
   elif  [ "$REPLY2" = "8192" ]; then
   KILOBIG="8388608"
   echo -n "$KILOBIG" > /initrd${PUP_HOME}/pupsaveresize.txt
   echo "8G" > /tmp/reply3 
         
   fi

#/initrd/pupsaveresize.txt


Xdialog --title "Resize personal storage file"  \
        --infobox "Okay, you have chosen to increase $NAMEPFILE by $KILOBIG Kbytes,
        however as the file is currently in use, it will happen at reboot.

Technical notes:
The required size increase has been written to file pupsaveresize.txt,
in partition $SAVEPART (currently mounted on /mnt/home).
File pupsaveresize.txt will be read at bootup and the resize performed
then pupsaveresize.txt will be deleted.

WARNING: If you have multiple pup_save files, be sure to select
the same one when you reboot.

The change will only happen at reboot.
Click OK to exit..." 0 0 60000


#notes:
#  dd if=/dev/zero bs=1k count=$KILOBIG | tee -a $HOMELOCATION > /dev/null
