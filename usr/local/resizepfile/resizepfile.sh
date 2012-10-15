#!/bin/sh
#2007 Lesser GPL licence v2 (http://www.fsf.org/licensing/licenses/lgpl.html)
#make the pup_save.2fs file bigger.

# 3-5-2011 re write to gtk2 Xdialog it was in xmessage before by Joe Arose

#variables created at bootup by /initrd/usr/sbin/init...
. /etc/rc.d/PUPSTATE #v2.02
#PUPMODE=current operating configuration,
#PDEV1=the partition have booted off, DEV1FS=f.s. of PDEV1,
#PUPSFS=pup_201.sfs versioned name, stored on PDEV1, PUPSAVE=vfat,sda1,/pup_save.2fs
# july 15 2012 minor changes  by don570 to make window smaller and  internationalize
# internalization using Zigbert method

APPDIR="`dirname $0`"
[ "$APPDIR" = "." ] && APPDIR="`pwd`"
export APPDIR="$APPDIR"


export APPDIR=`dirname $0`
[ $APPDIR = '.' ] && export APPDIR=`pwd`

#set language
TMP="`ls -1 $APPDIR/locals/ | grep ${LANG%.*}`"
. $APPDIR/locals/en_US:english #always run to fill gaps in translation
#fallback to macrolanguage if available (ISO 639-1 two letter code: en, es, fr, etc.)
[ -z $TMP ] && TMP="`ls -1 $APPDIR/locals/ | grep ${LANG%_*}:`" && echo $TMP
[ "$TMP" != "en_US:english" ] && . $APPDIR/locals/$TMP 2> /dev/null


export VERSION=v1.1


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
  Xdialog --title "$LOC100 $VERSION" --left \
          --infobox "$LOC200
$LOC201
$LOC202
$LOC203
$LOC204
$LOC205
$LOC206
$LOC207
$LOC208
$LOC209
$LOC210" 0 0 60000
  
 
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



Xdialog --title "$LOC100 $VERSION" --left  \
        --menu "$LOC300 $NAMEPFILE.
$LOC301 $SIZEFREE $LOC302 $NAMEPFILE$LOC303 $ACTUALSIZE $LOC304
$LOC305 $NAMEPFILE $LOC306 $SAVEPART.
$LOC307 $PARTFREE $LOC308 $SAVEPART.
$LOC309 $NAMEPFILE$LOC310
$LOC311 $SAVEPART.

$LOC312
$LOC313

$LOC314 $NAMEPFILE $LOC315
$LOC316" 0 0 9 \
        "64" "$LOC317" \
        "128" "$LOC317" \
        "256" "$LOC317" \
        "512" "$LOC317" \
        "1024" "$LOC318" \
        "2048" "$LOC319" \
        "4096" "$LOC320"  \
        "8192" "$LOC321"  2> /tmp/reply2

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


Xdialog --title "$LOC100 $VERSION"  --left \
        --infobox "$LOC400 $NAMEPFILE $LOC401 $KILOBIG $LOC402
$LOC403

$LOC404
$LOC405
$LOC406 $SAVEPART $LOC407
$LOC408
$LOC409

$LOC410
$LOC411

$LOC412
$LOC413" 0 0 60000


#notes:
#  dd if=/dev/zero bs=1k count=$KILOBIG | tee -a $HOMELOCATION > /dev/null
