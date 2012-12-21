#!/bin/bash -a
# Quickpet #
#quickpackage-1.4 #01micko 2010-4-12 #GPL
#revised 2010-4-17 #renamed
#revised 2010-4-21 #removed qp-update, move sfs button
#revised 2010-5-07 #rewrote update section, far too complicated, let's make it simple
#revised 2010-5-09 #bugfix, added driver tab
#revised 2010-5-09 #bugfix, added size
#revised 2010-6-23 #2.2 fixed browser-installer, will cater to any generic browser
#revised 2010-6-29 #2.9 switched to main lucid repo and changed some entries, also non-centred for gtkdialog-splash
#revised 2010-7-13 #2.9.7 added google-earth and test-vid
#revised 2010-7-19 #2.9.8 scrapped test-vid added Lupu recommends
#revised 2010-8-02 #opening video help files in browser or viewer to help with translation #bugfixed if no connection, these still work
#revised 2010-8-12 #testing release for satellite problems #scsijon and Kevin Bowers report issues
#revised 2010-10-21 #4beta1 #add back nvidia help, #add new sfs_grab
#revised 2010-10-24 #4beta2 #support for full installs (not released)
#revised 2010-11-02 #4beta4 #fixing internationalisation
#revised 2010-11-20 #4beta7 #bugfix for ftp servers, add radeon/ati
#revised 2010-11-22 #4rc2  # added simple sfs_grabber gui for local and remote sfs
#revised 2010-11-25 #4rc3  # added wget choke for drivers
#revised 2010-12-02 #4rc5 #Lobster proofing ;) Also added direct download for driver links (hope we got that right), locale bugfix, Tasgarth
#revised 2010-12-02 #4rc6 #bigpup bugfix for drivers
#revised 2010-12-02 #4rc7 #add sfs, bugfix, removed sfs install in LIT
#revised 2010-12-08 #4rc9 #revised browser calls, added Iron to BI
#revised 2010-12-10 *added pidgin, try to fix fglrx issue
#revised 2010-12-12 #qp4 final minor adjustments
#revised 2010-12-29 # add lupq support, shinobar

#define working directorys
APPDIR="`dirname $0`"
[ "$APPDIR" = "." ] && APPDIR="`pwd`"
export APPDIR="$APPDIR"

WORKDIR=$HOME/.quickpet

#CONFFILE=$HOME/.packages/Packages-puppy-lucid-official   #added for 4

IMGDIR=$WORKDIR/icons

#remove /tmp files
rm -f /tmp/docheck 2>/dev/null
rm -f /tmp/statcheck 2>/dev/null
rm -f /tmp/quickpet-get 2>/dev/null
rm -f /tmp/quickpet-ud 2>/dev/null
rm -f /tmp/petsizeme 2>/dev/null
rm -f /tmp/LucidPuppyUpdate 2>/dev/null
rm -rf $APPDIR/tabs/ 2>/dev/null

VER=`cat $WORKDIR/version`

#read config
. $WORKDIR/qpet.conf
. $WORKDIR/prefs.conf 2>/dev/null
. $WORKDIR/repos.conf 2>/dev/null
. $WORKDIR/sleeprc
. /etc/DISTRO_SPECS
. /etc/rc.d/PUPSTATE
#what puppy are we in?
case $DISTRO_FILE_PREFIX in
qrky|qret)
   echo "you have quirky"
   # whatever quirky repo code you want goes here
   CONFFILE=$HOME/.packages/Packages-puppy-quirky-official
   BUTTON_IMG="/usr/share/doc/puppylogo48.png"
   ;;
wary)
   echo "you have wary"
   # wary5 repo code
   CONFFILE=$HOME/.packages/Packages-puppy-wary5-official
   BUTTON_IMG="/usr/share/doc/puppylogo48.png"
        ;;
Passagio|lupu|luci|luma|upup|lupq)
   echo "you have lupu or upup" #maybe more filtering needed here
   #lupu or whatever repo code here
   CONFFILE=$HOME/.packages/Packages-puppy-lucid-official
   BUTTON_IMG="/usr/share/doc/puppylogo48.png" #"$HOME/.quickpet/icons/lupu.png"
   ;;
dpup|spup)
   if [[ $DISTRO_FILE_PREFIX = "dpup" ]];then
    echo "you have dpup"
    # puppy5 repo code
    CONFFILE=$HOME/.packages/Packages-puppy-5-official
     else echo "you have spup"
    # puppy5 repo code
    CONFFILE=$HOME/.packages/Packages-puppy-5-official #not sure about the repo for spup yet
   fi
   BUTTON_IMG="/usr/share/doc/puppylogo48.png"
   ;;
pup|ppup)
   echo "you have puppy"
   # puppy4 repo code
   CONFFILE=$HOME/.packages/Packages-puppy-4-official
   BUTTON_IMG="/usr/share/doc/puppylogo48.png"
   ;;
#apup)
#   echo "you have apup"
   # arch puppy repo code
   #   ;;
*)  #Now we cover non woof pups #also, arch is unsupported at this stage
	xmessage -center "sorry quickpet doesn't support your puppy" && exit
	;;
esac
export BUTTON_IMG
#end case
#set language
DEFLANG=`env|grep "LANG="`
if [[ "$DEFLANG" = "LANG=C" ]];then xmessage -center "Please set your locale" &
exit
fi
LANGUAGE=`echo $LANG|head -c5` #workaround for utf8
TMPLANG="`ls $APPDIR/locals/ | grep $LANGUAGE`"
. $APPDIR/locals/en_US:english #always run to fill gaps in translation
[[ "$TMPLANG" != "en_US:english" ]] && . $APPDIR/locals/$TMPLANG 2> /dev/null

#find if browser is installed
BROWSINSTALLED=`grep "exec" /usr/local/bin/defaultbrowser|awk '{print $2}'`
#if [[ $BROWSINSTALLED = quickpet ]];then USEBROWSER="gtkmoz"
USEBROWSER="gtkmoz"
			
#fi
#is QP already running? need to refine as can run QP and wget concurrently #done
#RUNNING=`ps  | grep "wget" | grep -v "grep"`
RUNNING=`ps  | grep -w "quickpack" | grep -v "grep"`
if [[ "$RUNNING" != "" ]];then gtkdialog-splash -icon gtk-dialog-warning -timeout 5 -fontsize large -bg orange -close box  -text "$LOC_112"     #Xdialog --timeout 5 --msgbox "$LOC_112" 0 0 0 2>/dev/null #yaf-splash -font "-misc-dejavu sans-bold-r-normal--16-0-0-0-p-0-iso10646-1" -timeout 6 -outline 0 -bg pink -text "$LOC_112" &
	exit
fi

#set repo
if [ $RADIO1 = "true" ];then URLREPO=$URL1
	elif [ $RADIO2 = "true" ];then URLREPO=$URL2
	elif [ $RADIO3 = "true" ];then URLREPO=$URL3
	elif [ $RADIO4 = "true" ];then URLREPO=$URL4
	elif [ $RADIO5 = "true" ];then URLREPO=$URL5
	elif [ $RADIO6 = "true" ];then URLREPO=$URL6
	elif [ $RADIO7 = "true" ];then URLREPO=$URL7
	elif [ $RADIO8 = "true" ];then URLREPO=$URL8
	elif [ $RADIO9 = "true" ];then URLREPO=$URL9
	elif [ $RADIO10 = "true" ];then URLREPO=$URL10
	elif [ $RADIO11 = "true" ];then URLREPO=$URL11
	elif [ $RADIO12 = "true" ];then URLREPO=$URL12  #new greek mirror, thx mavrothal
fi

#set incoming dir #not necessarily needed, but no harm to have it there
if [ ! -d $WORKDIR/Downloads ] ;then mkdir $WORKDIR/Downloads
fi

#check sfs loaded and adjust ### ~/.quickpet/Sfs-puppy-lucid-official
if [ -f $HOME/.quickpet/Sfs-puppy-lucid-official ];then
 if [[ $PUPMODE = 2 || $PUPMODE = 3 || $PUPMODE = 77 ]];then 
  rm -f /tmp/currently_loaded_sfs
  SFSLOADEDFULL=`grep -v "#" /etc/sfs_downloaded.qp`
  for SFSLOADED in $SFSLOADEDFULL;do 
   echo "$SFSLOADED" >> /tmp/currently_loaded_sfs
   done
   else
   . /etc/rc.d/BOOTCONFIG
   SFSGOT=`tail -n1 /etc/rc.d/BOOTCONFIG | grep "EXTRASFSLIST"`
  if [[ "$SFSGOT" != "" ]];then Xdialog --timeout 5 -msgbox "$LOC_950" 0 0 0
  fi
   rm -f /tmp/currently_loaded_sfs
  if [[ "$EXTRASFSLIST" != "" ]];then
   for SFSLOADED in $EXTRASFSLIST;do
   echo "$SFSLOADED" >> /tmp/currently_loaded_sfs
   done
  fi
 fi
fi

#set sfs log file
if [[ -f /etc/sfs_downloaded.qp ]];then echo ok
  else touch /etc/sfs_downloaded.qp && echo -e "#sfs_downloaded" > /etc/sfs_downloaded.qp
fi

#DLDDIR="$WORKDIR/Downloads"
DLDDIR="/tmp"
#check to see if we are connected to the internet
function CHECKNET(){
	 wget -t 0 -4 -o /tmp/testcon --spider www.puppylinux.com
	 NOCON=`grep -w "failed" /tmp/testcon`
	 if [ "$NOCON" != "" ]; then #testnet &
#sleep 5
#kill `ps|grep "test_net"` 2>/dev/null #killall yaf-splash && yaf-splash -font "-misc-dejavu sans-bold-r-normal--16-0-0-0-p-0-iso10646-1" -timeout 6 -placement top -outline 0 -bg red -text "$LOC_101"
	 gtkdialog-splash -icon gtk-dialog-error -timeout 6 -fontsize large -bg hotpink -close box  -text "$LOC_101"
	 exit
	 fi
}
# lucid_pup_update-1.pet (or whatever VERSION number) is the current format for the update #scrapped
#lucidpuppyupdate is now just a news site with possible updates posted
#changed for version 4, more generic, goes to wiki if it's not lupu
function WIKI(){
	
	echo $USEBROWSER
	#ok, we can make the site a var, 
	NEWSSITE="http://www.murga-linux.com/puppy/viewtopic.php?t=80948&sid=088bfae345029aeac3b11b28381edfb0"   # was "http://www.diddywahdiddy.net/LupuNews"for lupu
	[[ $DISTRO_FILE_PREFIX = lupu || $DISTRO_FILE_PREFIX = luci || $DISTRO_FILE_PREFIX = luma ]]&& NEWSSITE="http://www.murga-linux.com/puppy/viewtopic.php?t=80948&sid=088bfae345029aeac3b11b28381edfb0"
	#[[ $DISTRO_FILE_PREFIX = lupu ]] && shino's site goes here, or can put diddywahdiddy, even make a wiki page
	CHECKNET
	
		$USEBROWSER $NEWSSITE &
}

function WARNINGINST(){
	Xdialog --title "$LOC_WARNING" --clear \
        --yesno "$THEPET $LOC_WARNINGINSTALL" 0 0 0
	case $? in 
	0) echo "Ok" ;;
	1) killall yaf-splash && exit ;;
	255) exit ;;
	esac
}

          ############################################################################################
          ###oooooooooooooooooooooo--------------------------------------oooooooooooooooooooooooooo###
          ######################### Main engine that downloads the goods #############################
          ###oooooooooooooooooooooo______________________________________oooooooooooooooooooooooooo###
          ###$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$###

function chooser(){
	echo $PETCHOICE > /tmp/petchoice
}
function GETPET(){
	#set -x
	 CHECKNET
	 gtkdialog-splash -icon gtk-dialog-warning -placement top -fontsize large -bg black -fg white -close box -text "$LOC_102" & #"please wait"
	 sleep 1
	 rm -f /tmp/docheck 2>/dev/null
	 THEPET=`cat /tmp/thepet`
	 #DLDPET=`grep "$THEPET" $WORKDIR/urls.conf | cut -d '=' -f2`
	 #GRABPET=`grep "$THEPET" $WORKDIR/petnames.conf | cut -d '=' -f2`
	 if  [[ `grep "#nvidialist" /tmp/conffile` = "" ]];then #only for nvidia drivers
		#ok, need some code which grabs the latest, or a choice of what we want
		GRABPET=`grep -i "$THEPET" $CONFFILE | cut -d '|' -f8`   #changed from grep -iw call #20101202 bigpup
		DEPS=`grep -iw "$THEPET" $CONFFILE | cut -d '|' -f9|sed 's/+//g'|tr ',' ' '` 2>/dev/null
		NVIDIA_DLG=""
		if [[ "$DEPS" != "" ]];then 
			Xdialog --title "Dependencies" --clear \
			--yesno "$LOC_360 $THEPET \n $DEPS \nContinue?" 0 0 0
			case $? in 
			0) echo "ok"&;;
			1) killall yaf-splash && exit ;;
			255) exit ;;
			esac
		fi
		echo "#list" > /tmp/conffile
		for i in $GRABPET;do echo $i >> /tmp/conffile
		done
		 else NVIDIA_DLG="<hbox><text><label>Click for Nvidia $LOC_HELP</label></text><button><input file stock=\"gtk-help\"></input><action>$USEBROWSER $WORKDIR/driverhelp.htm &</action></button></hbox> "
	 fi
	 export choice="<window title=\"Choose\">
   <vbox>
   $NVIDIA_DLG
    <tree>
     <label>Choose which version</label>
     <variable>PETCHOICE</variable>
     <input>grep -v '#' /tmp/conffile</input>
     <action signal=\"button-release-event\">chooser</action>
     <action signal=\"button-release-event\">exit:chosen</action>
    </tree>
   </vbox>
  </window>"
	 if [[ `wc -l /tmp/conffile|cut -d ' ' -f1` -gt 2 ]];then gtkdialog3 -p choice
	 GRABPET=`cat /tmp/petchoice`
	 #echo $GRABPET
	 unset choice
	 fi
	 rm -f /tmp/petchoice
	 rm -f /tmp/conffile 2>/dev/null
	 #nvidia/ati check (Lobster proofing)
	 if [[ `echo $GRABPET|grep -i nvidia` != "" || `echo $GRABPET|grep -i ati` != "" || `echo $GRABPET|grep -i xorg` != "" ]];then 
	  if [[ `pidof wget` != "" ]];then killall yaf-splash && sleep 1 && gtkdialog-splash -icon gtk-dialog-warning -timeout 5 -fontsize large -bg red -close box -text "$LOC_114" && exit
	   else gtkdialog-splash -icon gtk-dialog-warning -timeout 5 -fontsize large -bg orange -close box -text "$LOC_115"
	  fi
	 fi
	 if [ "$GRABPET" = "" ];then sleep 1 && killall yaf-splash && sleep 1 && gtkdialog-splash -icon gtk-dialog-warning -timeout 5 -fontsize large -bg red -close box -text "Your package was not found in the database" &
		exit
		fi
	 PKGSIZE=`grep -i "$GRABPET" $CONFFILE | cut -d '|' -f6|sed  's/[A-Z]//'`
	 if [ $PUPMODE = 3 ];then SAVESIZELEFT=`df -k | grep ' /initrd/pup_ro1$' | tr -s ' ' | cut -f4 -d ' '`
         elif [ $PUPMODE = 7 ];then SAVESIZELEFT=`df -k | grep ' /initrd/pup_ro1$' | tr -s ' ' | cut -f4 -d ' '`
         elif [ $PUPMODE = 13 ];then SAVESIZELEFT=`df -k | grep ' /initrd/pup_ro1$' | tr -s ' ' | cut -f4 -d ' '`
         elif [ $PUPMODE = 2 ];then SAVESIZELEFT=`df -k |  grep '/dev/root' | tr -s ' '| cut -f4 -d ' '`
         else SAVESIZELEFT=`df -k | grep ' /initrd/pup_rw$' | tr -s ' ' | cut -f4 -d ' '`
     fi
     PKGSIZEPLUS=`echo $(($PKGSIZE + 45000))`
     if [[ $PKGSIZEPLUS -gt $SAVESIZELEFT && $SAVESIZELEFT -gt $PKGSIZE ]];then WARNINGINST
		elif [[ $PKGSIZE -gt $SAVESIZELEFT ]];then killall yaf-splash &
		gtkdialog-splash -icon gtk-dialog-warning -timeout 5 -fontsize large -bg hotpink -close box -text "$LOC_CANTINSTALL" &
		exit
	 fi
	 kill `ps | grep -w "quickpack" | awk '{print $1}'` 2>/dev/null
	 kill `ps | grep -w "BWIZ" | awk '{print $1}'` 2>/dev/null
	 
	 gtkdialog-splash -icon gtk-info -timeout 5 -fontsize large -bg lightblue -close box -text "$LOC_106a $THEPET $LOC_106b" &
	 COUNT=0
	 until [ "`grep -w "Content-Length" /tmp/docheck`" ] || [ "`grep -w "exists" /tmp/docheck`" ] || [ "`grep -w "Login successful" /tmp/docheck`" ] || [ "`grep -w "broken link" /tmp/docheck`" ]  || [ "`grep -w "No such file" /tmp/docheck`" ]|| [[ "$COUNT" = 5 ]] 
		do echo "wget -S --spider -T 20 -4 $URLREPO/$GRABPET 2>/tmp/docheck" >/tmp/statcheck
		. /tmp/statcheck
	 COUNT=`expr $COUNT + 1`
	  sleep $SLEEP_SIZE
	 done
	 #if it fails try the main repo ###DEPRECATED in qp-4+
	 
	 if [ "`grep -w "Connection timed out" /tmp/docheck`" ];then
		gtkdialog-splash -icon gtk-dialog-warning -timeout 5 -fontsize large -bg hotpink -close box -text "$LOC_107" &
		exit
	 fi
	 #if not found
	 NOTFOUND=`grep -i "404 not found" /tmp/docheck`
	 if [[ $NOTFOUND != "" ]];then killall yaf-splash 2>/dev/null
	 gtkdialog-splash -icon gtk-dialog-warning -timeout 3 -fontsize large -bg red -close box -text "$LOC_116" &
	      exit
	 fi 
	 #integrity check
     PET_SIZE=`grep -w "Content-Length" /tmp/docheck|awk '{print $2}'`
	 if [ "$PET_SIZE" = "" ];then  #PET_SIZE=`grep -w -i $THEPET /tmp/docheck|grep -v Removed|grep -v exists|tail -n1|awk '{print $5}'` #ftp sites have changed header format! 20101118
	  PET_SIZE=`grep "rw" /tmp/docheck|grep "$GRABPET" |awk '{print $5}'`
	 fi
	 echo $PET_SIZE
	 #echo $PET_SIZE >/tmp/petsize
	 killall yaf-splash
	 echo "eval rxvt -background lightblue -title "$PROGNAME" -e wget -t 0 -c -4 -P $DLDDIR $URLREPO/$GRABPET" > /tmp/quickpet-get
	 . /tmp/quickpet-get 
	 
	 
	 rm -f /tmp/integrity-check 2>/dev/null
	 if [[ $PET_SIZE = $(stat -c %s  /tmp/$GRABPET) ]] ;then petget +$DLDDIR/$GRABPET	
	     else 
	 gtkdialog-splash -icon gtk-dialog-warning -timeout 4 -fontsize large -bg red -close box -text "$LOC_108" &
		sleep 8 && exit
	 fi
	 cd $HOME
	 sleep 1
	 #ls $HOME/.packages > /tmp/quinstpacks
	 INST_SUCCESS=`grep -i $THEPET $HOME/.packages/user-installed-packages`
	 if [ "$INST_SUCCESS" = "" ] ;then
	 . gtkdialog-splash -icon gtk-dialog-warning -timeout 4 -fontsize large -bg red -close box -text "$LOC_108" &
	 rm -f $GRABPET	
	 sleep 8 && exit	
		else
	   . gtkdialog-splash -icon gtk-apply -timeout 4 -fontsize large -bg green -close box -text "$LOC_110a $THEPET $LOC_110b" &
	   [ -x /pinstall.sh ] && rm -f /pinstall.sh 2>/dev/null #hmm this seems to be a bug in lupu
	     if [ $CHKBOX = "false" ];then 
           cp -f  $DLDDIR/$GRABPET $WORKDIR/Downloads/$GRABPET
         fi
       sync #added for 4
	   sleep 8 && exit	  
	 fi
}
### END MAIN FUNCTION ###

#help and info
function INFO(){
	Xdialog --title $LOC_INFO --msgbox "$LOC_202" 0 0 0

}

# make PuppyBrowser default(or whatever is generic browser)
function CHANGE(){
	#CHANGE_DEFAULT=`grep "exec" /usr/local/bin/defaultbrowser` #changed in case old entry is commented
	CHANGE_DEFAULT=`grep -v "#" /usr/local/bin/defaultbrowser`
	
	#new engine to find installed browsers from *.desktop files
rm -rf /tmp/tmpbrs
mkdir /tmp/tmpbrs
grep -i "browser" /usr/share/applications/*.desktop|cut -d ':' -f1|tr '/' ' '|awk '{print $4}'>/tmp/browserlist
echo '#browsers' >/tmp/installed-browsers
INSTALLED_BROWSERS=`cat /tmp/browserlist`
for i in $INSTALLED_BROWSERS;do grep 'Exec=' /usr/share/applications/$i|cut -d '=' -f2|sed 's/ \%U$//g'|sed s'/\// /'g | tr " '" '\n' | tail -n1>/tmp/tmpbrs/$i
	#cat /tmp/tmpbrs/$i>>/tmp/browserexecs
done 
BROWSE=`ls /tmp/tmpbrs`
for b in $BROWSE;do cat /tmp/tmpbrs/$b>>/tmp/installed-browsers
done
     NEW_BROWSER=`grep -v '#' /tmp/installed-browsers|head -n1`
     if [[ "$NEW_BROWSER" = "midori" ]];then NEW_BROWSER="midori-wrapper"
	fi
     NEW_DEFAULT="exec $NEW_BROWSER \"\$@\""
	echo "sed -i 's/$CHANGE_DEFAULT/$NEW_DEFAULT/' /usr/local/bin/defaultbrowser" >/tmp/chgbrs
	. /tmp/chgbrs
	#puppybrs &
	 #sleep 5
	 #kill `ps|grep "puppy_brs"` 2>/dev/null
	#yaf-splash -font "-misc-dejavu sans-bold-r-normal--16-0-0-0-p-0-iso10646-1" -timeout 4 -placement top -outline 0 -bg green -text "$LOC_111" & 
	gtkdialog-splash -icon gtk-dialog-info -timeout 5 -fontsize large -bg green -close box -text "$NEW_BROWSER""$LOC_111" &
}

#readme
function README(){
	Xdialog --title $LOC_308 --msgbox "$LOC_203" 0 0 0
}

#help menu
function HELP(){
	Xdialog --title $LOC_HELP --msgbox "$LOC_204" 0 0 0
}

#nvidia driver grab
function NVIDIA(){
echo "nvidia" > /tmp/thepet
KERNEL_VER=`uname -r`
NVIDDRIVER=`grep -i "nvidia" $CONFFILE|grep $KERNEL_VER| cut -d '|' -f8`
if [ "$NVIDDRIVER" = "" ];then xmessage "sorry no nvidia driver is in the repo to suit your card"
fi
echo "#nvidialist" > /tmp/conffile
for n in $NVIDDRIVER ;do echo $n >> /tmp/conffile
done
GETPET
}
#clear downloads
function CLEAR(){
Xdialog --title "$LOC_801" --clear \
        --yesno "$LOC_802 " 0 0 0
case $? in 
0) rm -f $HOME/.quickpet/Downloads/* ;;
1) exit ;;
255) exit ;;
esac	
}

#reset after change prefs
function RESET(){
	echo "SLEEP_SIZE=$SLEEP_SIZE" > $WORKDIR/sleeprc
	kill `ps | grep -w "quickpack" | awk '{print $1}'` 2>/dev/null
	quickpet &
}

#preferences
function PREFS(){
#read sleep config
. $WORKDIR/sleeprc
SLEEP_SIZE_ITEMS="<item>$SLEEP_SIZE</item>"
for I in 2 4 6 8 10 12 14 16 18 20; do SLEEP_SIZE_ITEMS=`echo "$SLEEP_SIZE_ITEMS<item>$I</item>"`; done

export qpprefs="
<window title=\"$PROGNAME - Options\">
 <vbox>
    <text><label> $LOC_301</label></text>
    <text use-markup=\"true\"><label>\"<b>$LOC_302 </b>\"</label></text>
	<text use-markup=\"true\"><label>\"<b>$LOC_298 </b>\"</label></text>
	<checkbox>
     <label>$LOC_299</label>
	  <variable>CHKBOX</variable>
	  <action>if true sed -i 's/CHKBOX=[a-z]*[a-z]/CHKBOX=true/' $WORKDIR/prefs.conf</action>
	  <action>if false sed -i 's/CHKBOX=[a-z]*[a-z]/CHKBOX=false/' $WORKDIR/prefs.conf</action>
	  <default>$CHKBOX</default>
	</checkbox>
	<text use-markup=\"true\"><label>\"<b>$LOC_303</b>\"</label></text>
	<radiobutton tooltip-text=\"North America\">
	<label>\"diddywahdiddy.net\"</label>
	<variable>RADIO1</variable>
	<action>if true sed -i 's/RADIO1=[a-z]*[a-z]/RADIO1=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO1=[a-z]*[a-z]/RADIO1=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO1</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"North America\">
	<label>\"ibiblio.org\"</label>
	<variable>RADIO2</variable>
	<action>if true sed -i 's/RADIO2=[a-z]*[a-z]/RADIO2=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO2=[a-z]*[a-z]/RADIO2=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO2</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"Croatia\">
	<label>\"ftp.linux.hr\"</label>
	<variable>RADIO3</variable>
	<action>if true sed -i 's/RADIO3=[a-z]*[a-z]/RADIO3=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO3=[a-z]*[a-z]/RADIO3=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO3</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"North America\">
	<label>\"ftp.lug.udel.edu\"</label>
	<variable>RADIO4</variable>
	<action>if true sed -i 's/RADIO4=[a-z]*[a-z]/RADIO4=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO4=[a-z]*[a-z]/RADIO4=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO4</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"Netherlands\">
	<label>\"ftp.nluug.nl\"</label>
	<variable>RADIO5</variable>
	<action>if true sed -i 's/RADIO5=[a-z]*[a-z]/RADIO5=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO5=[a-z]*[a-z]/RADIO5=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO5</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"Czech Republic\">
	<label>\"ftp.sh.cvut.cz\"</label>
	<variable>RADIO6</variable>
	<action>if true sed -i 's/RADIO6=[a-z]*[a-z]/RADIO6=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO6=[a-z]*[a-z]/RADIO6=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO6</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"Germany\">
	<label>\"ftp.tu-chemnitz.de\"</label>
	<variable>RADIO7</variable>
	<action>if true sed -i 's/RADIO7=[a-z]*[a-z]/RADIO7=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO7=[a-z]*[a-z]/RADIO7=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO7</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"North America\">
	<label>\"ftp.ussg.iu.edu\"</label>
	<variable>RADIO8</variable>
	<action>if true sed -i 's/RADIO8=[a-z]*[a-z]/RADIO8=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO8=[a-z]*[a-z]/RADIO8=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO8</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"Australia\">
	<label>\"mirror.aarnet.edu.au\"</label>
	<variable>RADIO9</variable>
	<action>if true sed -i 's/RADIO9=[a-z]*[a-z]/RADIO9=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO9=[a-z]*[a-z]/RADIO9=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO9</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"North America\">
	<label>\"ftp.oss.cc.gatech.edu\"</label>
	<variable>RADIO10</variable>
	<action>if true sed -i 's/RADIO10=[a-z]*[a-z]/RADIO10=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO10=[a-z]*[a-z]/RADIO10=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO10</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"Australia\">
	<label>\"mirror.internode.on.net\"</label>
	<variable>RADIO11</variable>
	<action>if true sed -i 's/RADIO11=[a-z]*[a-z]/RADIO11=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO11=[a-z]*[a-z]/RADIO11=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO11</default>
	</radiobutton>
	
	<radiobutton tooltip-text=\"Greece\">
	<label>\"ftp.cc.uoc.gr\"</label>
	<variable>RADIO12</variable>
	<action>if true sed -i 's/RADIO12=[a-z]*[a-z]/RADIO12=true/' $WORKDIR/prefs.conf</action>
	<action>if false sed -i 's/RADIO12=[a-z]*[a-z]/RADIO12=false/' $WORKDIR/prefs.conf</action>
	<default>$RADIO12</default>
	</radiobutton>
	
	<text use-markup=\"true\"><label>\"<b>Increase this Value</b>\"</label></text>
   <hbox homogeneous=\"true\">
	 <text><label>\"If you are having Timeout errors\"</label></text>
    <combobox width-request=\"50\">
     <variable>SLEEP_SIZE</variable>
$SLEEP_SIZE_ITEMS
	</combobox>
   </hbox> 
   
   <hbox>
    <button> 
     <label>$LOC_OK</label>
     <input file stock=\"gtk-ok\"></input> 
     <action>RESET &</action>
     <action>EXIT:exit</action>
    </button>
   </hbox>
    
  </vbox>
</window>	
"
gtkdialog3 -p qpprefs
unset qpprefs
}

function ABOUT(){

export qabout="
<window title=\"$PROGNAME - About\"icon-name=\"gtk-about\" resizable=\"false\">
 <vbox>
	<hbox homogeneous=\"true\">
	<pixmap>
    <input file>/usr/share/doc/puppylogo48.png</input>
    </pixmap>
    </hbox>
    <hbox>
    <vbox>
    <frame>
    <text use-markup=\"true\"><label>\"<b>Author </b>\"</label></text>
	<text><label>Michael Amadio - 01micko</label></text>
	<text use-markup=\"true\"><label>\"<b>Concept</b>\"</label></text>
	<text><label>Larry Short - playdayz</label></text>
	<text><label>\" \"</label></text>
	<text use-markup=\"true\"><label>\"<b>Contributors</b>\"</label></text>
	<text><label>Sigmund Berglund - zigbert</label></text>
	<text><label>Barry Kauler - BarryK</label></text>
	<text><label>Ed Jason - Lobster</label></text>
	</frame>
	</vbox>
	<vbox>
	<frame>
	<text use-markup=\"true\"><label>\"<b>Translators</b>\"</label></text>
	<text><label>Dutch - Bert</label></text>
	<text><label>Swedish - MinHundHettePerro</label></text>
	<text><label>French - Alain Bernard -Tasgarth</label></text>
	<text><label>German - Markus Vedder -mave</label></text>
	<text><label>Italian - Daniel Bonanno - Jacopo</label></text>
	<text><label>Chinese - sasaqqdan</label></text>
	<text><label>Japanese - Norihiro Yoneda -YoN</label></text>
	<text><label>Japanese - himajin</label></text>
	<text><label>Russian - bit</label></text>
	<text><label>Spanish - Pedro Worcel - droope</label></text>
	<text><label>Spanish - GustavoYz</label></text>
	</frame>
	</vbox>
	</hbox>
	<hbox>
	<text use-markup=\"true\"><label>\"<b>Licenced under the GPL 2010. No Warranty</b>\"</label></text>
    <button> 
     <label>$LOC_306</label>
     <input file stock=\"gtk-dnd\"></input> 
     <action>defaulthtmlviewer file:///root/puppy-reference/doc/legal/gpl-3.0.htm &</action>
    </button>
	</hbox>
	<hbox>
    <button> 
     <label>$LOC_OK</label>
     <input file stock=\"gtk-ok\"></input> 
    </button>
	</hbox>
  </vbox>
</window>	
"
gtkdialog3 -p qabout
unset qabout
}

#make html file out of "lupu recommends", execute browser, if installed
function LUPUREC(){
	#make a html page reflecting the video recommendation, opens in viewer if no browser/connection else browser
	#construct page in /tmp
	BODY="`cat /tmp/luci_recomend`"
	echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">' >/tmp/lupurec.htm
	echo '<html>' >>/tmp/lupurec.htm
	echo '<head>' >>/tmp/lupurec.htm
	echo '<title>' >>/tmp/lupurec.htm
	echo 'Puppy recommends' >>/tmp/lupurec.htm
	echo '</title>' >>/tmp/lupurec.htm
	echo '</head>' >>/tmp/lupurec.htm
	echo '<body>' >>/tmp/lupurec.htm
	echo '<H1>Puppy Recommends</H1>' >>/tmp/lupurec.htm
	echo '<br>' >>/tmp/lupurec.htm
	echo '<H2>Graphics Help</H2>' >>/tmp/lupurec.htm
	echo '<br>' >>/tmp/lupurec.htm
	if [[ "$USEBROWSER" = "gtkmoz" || "$USEBROWSER" = "midori-wrapper" ]];then echo "$LOC_970a" >>/tmp/lupurec.htm
		else echo "$LOC_970b" >>/tmp/lupurec.htm
	fi
	echo '<br>' >>/tmp/lupurec.htm
	echo '<hr>' >>/tmp/lupurec.htm
	echo '<br>' >>/tmp/lupurec.htm
	echo "$BODY and $PROGNAME" >>/tmp/lupurec.htm
	echo '</body>' >>/tmp/lupurec.htm
	echo '</html>' >>/tmp/lupurec.htm
	#execute page in browser or viewer
	$USEBROWSER /tmp/lupurec.htm &
}

#graphics test
function graphics(){
	#set -x
 /usr/local/graphics-test/graphix_test
DRVGRAB=`cat /tmp/graphic_driver_selection`
DRVTYPE=`echo $DRVGRAB|head -c3`


#####LOC_971a is for ati and nvidia success, LOC_971b, xorg success, LOC_972 failure 
case $DRVTYPE in   #20101200
Xor) BUTTONIMG="/root/.quickpet/icons/xorg.png"
     ICONIMGTXT="Xorg"
     HELPBTN=""
     UPGRADEBTN="<button tooltip-text=\"$LOC_962 $DRVGRAB\"> 
     <label>${ICONIMGTXT}</label>    
     <input file>$BUTTONIMG</input>
     <action>echo \"$DRVGRAB\" > /tmp/thepet</action>  
     <action>GETPET &</action>  
     <action>EXIT:driver</action>
    </button>"  
     if [[ "`grep Xorg_High $HOME/.packages/user-installed-packages 2>/dev/null`" != "" ]];then UPGRADEBTN=""
      UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_971b ${LOC_QUIT}!</label></text></hbox>"
     fi
;;
ATI) BUTTONIMG="/root/.quickpet/icons/ati.png"
     ICONIMGTXT="ATI"
     CURVIDEODRIVER="`grep '#card0driver' /etc/X11/xorg.conf | cut -f 2 -d '"'`" #'geany
     DRV_INST_ATI=`grep -i "fglrx" $HOME/.packages/user-installed-packages 2>/dev/null`
     HELPBTN="<button tooltip-text=\"$ICONIMGTXT opens $LOC_HELP in browser\"> 
     <label>${ICONIMGTXT} $LOC_HELP</label>    
     <input file stock=\"gtk-help\"></input>
     <action>$USEBROWSER $WORKDIR/driverhelp.htm &</action>
    </button>"
     UPGRADEBTN="<button tooltip-text=\"$LOC_962 $DRVGRAB\"> 
     <label>${ICONIMGTXT}</label>    
     <input file>$BUTTONIMG</input>
     <action>echo \"$DRVGRAB\" > /tmp/thepet</action>  
     <action>GETPET &</action>  
     <action>EXIT:driver</action>
    </button>"  
     if [[ "$CURVIDEODRIVER" = "fglrx" ]];then
     UPGRADEBTN=""
     UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_971a ${LOC_QUIT}!</label></text></hbox>"
       else
      if [[ "$CURVIDEODRIVER" != "fglrx" && "$DRV_INST_ATI" != "" ]];then 
       UPGRADEBTN=""
       UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_972 ${ICONIMGTXT} $LOC_HELP</label></text></hbox>"
      fi
     fi
;;
NVI|Luc) BUTTONIMG="/root/.quickpet/icons/nvidia.png"
     ICONIMGTXT="nVidia"
     CURVIDEODRIVER="`grep '#card0driver' /etc/X11/xorg.conf | cut -f 2 -d '"'`" #'geany
     DRV_INST_NVIDIA=`grep -i "nvidia" $HOME/.packages/user-installed-packages 2>/dev/null`
     HELPBTN="<button tooltip-text=\"$ICONIMGTXT opens $LOC_HELP in browser\"> 
     <label>${ICONIMGTXT} $LOC_HELP</label>    
     <input file stock=\"gtk-help\"></input>
     <action>$USEBROWSER $WORKDIR/driverhelp.htm &</action>
    </button>"
    UPGRADEBTN="<button tooltip-text=\"$LOC_962 $DRVGRAB\"> 
     <label>${ICONIMGTXT}</label>    
     <input file>$BUTTONIMG</input>
     <action>echo \"$DRVGRAB\" > /tmp/thepet</action>  
     <action>GETPET &</action>  
     <action>EXIT:driver</action>
    </button>"
     if [[ "$CURVIDEODRIVER" = "nvidia" ]];then
     UPGRADEBTN=""
     UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_971a ${LOC_QUIT}!</label></text></hbox>"
       else
      if [[ "$CURVIDEODRIVER" != "nvidia" && "$DRV_INST_NVIDIA" != "" ]];then 
       UPGRADEBTN=""
       UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_972 ${ICONIMGTXT} $LOC_HELP</label></text></hbox>"
      fi
     fi
;;
esac

#if [ "$DRVTYPE" = "ATI" ]; then BUTTONIMG="/root/.quickpet/icons/ati.png"
#       ICONIMGTXT="ATI"
# elif [ "$DRVTYPE" = "Xor" ]; then BUTTONIMG="/root/.quickpet/icons/xorg.png"
#       ICONIMGTXT="Xorg"
# elif [ "$DRVTYPE" = "Luc" ]; then BUTTONIMG="/root/.quickpet/icons/nvidia.png"
#       ICONIMGTXT="nVidia"
# elif [ "$DRVTYPE" = "NVI" ]; then BUTTONIMG="/root/.quickpet/icons/nvidia.png"
#       ICONIMGTXT="nVidia"
#fi
#if [ "$DRVTYPE" = "Xor" ]; then HELPBTN=""
#     else HELPBTN="<button tooltip-text=\"$ICONIMGTXT opens $LOC_HELP in browser\"> 
#     <label>${ICONIMGTXT} $LOC_HELP</label>    
#     <input file stock=\"gtk-help\"></input>
#     <action>$USEBROWSER $WORKDIR/driverhelp.htm &</action>
#    </button>"
#fi
#UPGRADEBTN="<button tooltip-text=\"$LOC_962 $DRVGRAB\"> 
#     <label>${ICONIMGTXT}</label>    
#     <input file>$BUTTONIMG</input>
#     <action>echo \"$DRVGRAB\" > /tmp/thepet</action>  
#     <action>GETPET &</action>  
#     <action>EXIT:driver</action>
#    </button>"
#UPGTXT="<hbox homogeneous=\"true\"><text><label>$LOC_961a ${ICONIMGTXT} $LOC_961b</label></text></hbox>"
#CURVIDEODRIVER="`grep '#card0driver' /etc/X11/xorg.conf | cut -f 2 -d '"'`" #'geany
#case $CURVIDEODRIVER in #20101206
#nvidia)
#UPGRADEBTN=""
#UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_971a ${LOC_QUIT}!</label></text></hbox>"
#;;
#fglrx)
#UPGRADEBTN=""
#UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_971a ${LOC_QUIT}!</label></text></hbox>"
#;;
#*) #####LOC_971a is for ati and nvidia success, LOC_971b, xorg success, LOC_972 failure
#if [[ "`grep Xorg_High $HOME/.packages/usr-installed-packages`" != "" ]];then UPGRADEBTN=""
#    UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_971b ${LOC_QUIT}!</label></text></hbox>"
#fi
#DRV_INST_NVIDIA=`grep -i "nvidia" $HOME/.packages/usr-installed-packages`
#if [[ "$DRV_INST_NVIDIA" = "" ]];then UPGRADEBTN=""
#    UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_972 ${ICONIMGTXT} $LOC_HELP</label></text></hbox>"
#fi
#DRV_INST_ATI=`grep -i "fglrx" $HOME/.packages/usr-installed-packages`
#if [[ "$DRV_INST_ATI" = "" ]];then UPGRADEBTN=""
#    UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} $LOC_972 ${ICONIMGTXT} $LOC_HELP</label></text></hbox>"
#fi
#;;
#esac
#if [[ "$CURVIDEODRIVER" = "nvidia" || "$CURVIDEODRIVER" = "fglrx" ]];then UPGRADEBTN="<button> 
#     <label>${ICONIMGTXT} upgrade done!</label>    
#     <input file>$BUTTONIMG</input>
#   </button>"
#   UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} upgrade ${LOC_OK}!</label></text></hbox>"
#   elif [[ "`grep Xorg_High $HOME/.packages/usr-installed-packages`" != "" ]];then UPGRADEBTN="<button> 
#     <label>${ICONIMGTXT} upgrade done!</label>    
#     <input file>$BUTTONIMG</input>
#   </button>"
#   UPGTXT="<hbox homogeneous=\"true\"><text><label>${ICONIMGTXT} upgrade ${LOC_OK}!</label></text></hbox>"
#  else UPGRADEBTN="<button tooltip-text=\"$LOC_962 $DRVGRAB\"> 
#     <label>${ICONIMGTXT}</label>    
#     <input file>$BUTTONIMG</input>
#     <action>echo \"$DRVGRAB\" > /tmp/thepet</action>  
#     <action>GETPET &</action>  
#     <action>EXIT:driver</action>
#   </button>"
#   UPGTXT="<hbox homogeneous=\"true\"><text><label>$LOC_961a ${ICONIMGTXT} $LOC_961b</label></text></hbox>"
#fi
DISPLAY_TEXT=`cat /tmp/luci_recomend`
export DISPLAY_TEXT
export grafix="
<window title=\"Graphics\" resizable=\"false\">	
 <vbox>
  <frame Puppy Recommends>
   <hbox width-request=\"420\">
   <vbox>
    <text width-request=\"400\"><label>\"${DISPLAY_TEXT} and $PROGNAME\"</label></text>
   </vbox>
   </hbox>
   <hbox width-request=\"420\">
   <text width-request=\"360\"><label>\"$LOC_705\"</label></text>
   <button tooltip-text=\"$LOC_706\">
    <input file stock=\"gtk-dialog-info\"></input>
    <action>LUPUREC &</action>
   </button>
   </hbox>
  </frame>
   $UPGTXT
   <hbox homogeneous=\"true\">
    <button tooltip-text=\"$LOC_960\">
     <input file stock=\"gtk-quit\"></input>
     <label>$LOC_QUIT</label>
    </button>
    $HELPBTN
    $UPGRADEBTN
   </hbox>
 </vbox> 
</window>
"
gtkdialog3 -p grafix -c
unset grafix
}

#report-video funtion
function REPVID(){
	report-video
	RPT=`cat /tmp/report-video`
	xmessage -timeout 20 -bg thistle -center -file /tmp/report-video -title "Report Video" &
	#/usr/X11R7/bin/yaf-splash -bg thistle -timeout 20 -outline 0 -margin 4 -text "$RPT" &
	#gtkdialog-splash -icon gtk-dialog-info -bg thistle -text "$RPT"
}
#sfs grab fn
function PROCESS(){
	if [[ $SFSLOADEDCOUNT -ge 6 ]];then gtkdialog-splash -icon gtk-dialog-warning -timeout 5 -fontsize large -bg orange -close box  -text "$LOC_117" &
	exit
	fi
	HAVESFS=`grep $SFSCHOICE /etc/sfs_downloaded.qp`
	SFSCHOICEGRAB=`grep $SFSCHOICE $WORKDIR/Sfs-puppy-lucid-official|cut -d '|' -f 8`
	SFSSIZE=`grep $SFSCHOICE $WORKDIR/Sfs-puppy-lucid-official|cut -d '|' -f 6|sed 's/K$//'`
	HOMESAVE=`echo $PUPSAVE|cut -d ',' -f1`
	case $PUPMODE in
	12|13|6|7)FREESIZEAVAIL=`df -k|grep $HOMESAVE|awk '{print $4}'` 
	if [[ "$HAVESFS" != "" ]];then Xdialog --timeout 5 -msgbox "$LOC_951 $SFSCHOICE \n $LOC_952" 0 0 0 &
	 exit
	fi
	[[ $FREESIZEAVAIL -lt $SFSSIZE ]] && Xdialog --timeout 5 -msgbox "$LOC_953 $SFSCHOICE \n $LOC_954..." 0 0 0 && exit ;;
	2|3)FREESIZEAVAIL=`df -k |  grep '/dev/root' | tr -s ' '| cut -f4 -d ' '` 
	SFSEXPANDED=`echo $(($SFSSIZE * 4))`
	[[ $FREESIZEAVAIL -lt $SFSEXPANDED ]] && Xdialog --timeout 5 -msgbox "$LOC_953 $SFSCHOICE \n $LOC_954..." 0 0 0 && exit ;;
	77)FREESIZEAVAIL=`free|grep -w "Mem"|awk '{print $4}'` 
	SFSEXPANDED=`echo $(($SFSSIZE * 4))`
	[[ $FREESIZEAVAIL -lt $SFSEXPANDED ]] && Xdialog --timeout 5 -msgbox "$LOC_955 $SFSCHOICE \n $LOC_954..." 0 0 0 && exit ;;
	esac
	echo "$URLREPO/${SFSCHOICEGRAB}" > /tmp/grabthesfs
	#grep -v ${SFSCHOICE} $WORKDIR/Sfs-puppy-lucid-official > /tmp/Sfs-puppy-lucid-official
	#mv -f /tmp/Sfs-puppy-lucid-official $WORKDIR/Sfs-puppy-lucid-official
	sleep 1
	exec sfs_installation.sh &
	Xdialog --timeout 5 --title "Sfs_grab" -msgbox "$LOC_956" 0 0 0 
	kill `ps | grep -w "quickpack" | awk '{print $1}'` 2>/dev/null
}
#update lupu PPM
PPMUPDATE(){
	rxvt -e wget -t3 -P /tmp http://distro.ibiblio.org/pub/linux/distributions/puppylinux/Packages-puppy-lucid-official 
	if [ -f /tmp/Packages-puppy-lucid-official ];then
    cp -f /tmp/Packages-puppy-lucid-official  $HOME/.packages/Packages-puppy-lucid-official 
    rm -f /tmp/Packages-puppy-lucid-official
	xmessage -c -bg green "Success, now reboot to activate update" 
	 else
	xmessage -c -bg red "Download failed, try again later"
	fi
}
case $1 in
	BI)
#browser-installer
. $WORKDIR/browsersrc 2>/dev/null

export BWIZ="
$BROWSELIST
"
gtkdialog3 -p BWIZ
unset BWIZ

	;;
	
	*)
#quickpet

##THE TABS
. $WORKDIR/guirc
if [[ $PUPMODE = 2 || $PUPMODE = 3 || $PUPMODE = 77 ]];then SFSLOADEDCOUNT="0"
 else SFSLOADEDCOUNT=`wc -l /tmp/currently_loaded_sfs|cut -f1 -d ' ' 2>/dev/null`
fi
cat $WORKDIR/Sfs-puppy-lucid-official|cut -d '|' -f 2,10 > /tmp/sfstreelist
 
SFSTREELIST="cat /tmp/sfstreelist"
if [[ -f $WORKDIR/sfs_grab ]];then . $WORKDIR/sfs_grab
fi
export SFSTREELIST
#drivers ###TO DO add support for ATI and Intel video drivers
if [[ $DISTRO_FILE_PREFIX = lupu || $DISTRO_FILE_PREFIX = luci || $DISTRO_FILE_PREFIX = luma || $DISTRO_FILE_PREFIX = lupq ]];then VIDDRIVE=$LOC_392x ##added lupq 20101229
			vidpet="Xorg_High"
		else
		VIDDRIVE=$LOC_392m
		vidpet="mesa"
fi
DRIVERS='<hbox homogeneous="true">
   <text><label>'"$LOC_390"'</label></text> 
 </hbox>
 <hbox>  
 <text><label>'"$LOC_392vid"'</label></text>        
   <button relief="2" tooltip-text='\"$LOC_392ttvid\"'>     
     <input file>/root/.quickpet/icons/display.png</input>
     <action>graphics</action>    
   </button>
 </hbox>
 <hbox>  
 <text><label>Nvidia Drivers -a Choice for older or newer cards</label></text>        
   <button relief="2" tooltip-text='\"$LOC_392tt\"'>     
     <input file>/root/.quickpet/icons/nvidia.png</input>
     <action>NVIDIA</action>     
   </button>
 </hbox>
 <hbox>
 <text><label>ATI Driver -Catalyst, for late model cards</label></text>        
   <button relief="2" tooltip-text='\"$LOC_392ttr\"'>     
     <input file>/root/.quickpet/icons/ati.png</input>
     <action>echo ATI_fglrx > /tmp/thepet</action> 
      <action>GETPET</action>   
   </button>
 </hbox>
 <hbox>  
 <text><label>'"$VIDDRIVE"'</label></text>        
   <button relief="2">     
     <input file>/root/.quickpet/icons/xorg.png</input>
     <action>echo '"$vidpet"' > /tmp/thepet</action>  
     <action>GETPET</action>  
   </button>
 </hbox>'
#news
case "${DISTRO_FILE_PREFIX}" in
lupu|luma|luci|lupq)  #$HOME/.quickpet/icons/lupu.png
   UPDATE="<vbox>
     <text><label>$LOC_315</label></text>
   <text use-markup=\"true\"><label>\"<b>${DISTRO_NAME} $LOC_315</b>\"</label></text>
 <hbox homogeneous=\"true\">
  <text><label>$LOC_500</label></text>
 </hbox>
 <button>  
   <label>${DISTRO_NAME} $LOC_315</label>                                             
   <input file>$HOME/.quickpet/icons/lupu.png</input>
   <action>WIKI</action>
  </button>
  </vbox>"
  ;;
qrky|qret)  
UPDATE="<vbox>
     <text><label>$LOC_315</label></text><text use-markup=\"true\"><label>\"<b>${DISTRO_NAME} $LOC_315</b>\"</label></text>
 <hbox homogeneous=\"true\">
  <text><label>$LOC_500B ${DISTRO_NAME}</label></text>
 </hbox>
 <button>  
   <label>${DISTRO_NAME} $LOC_315</label>                                             
   <input file>/usr/share/doc/puppylogo48.png</input>
   <action>WIKI</action>
  </button>
  </vbox>"
  ;;
*)
UPDATE="<vbox>
     <text><label>$LOC_315</label></text>
<text use-markup=\"true\"><label>\"<b>${DISTRO_NAME} $LOC_315</b>\"</label></text>
 <hbox homogeneous=\"true\">
  <text><label>$LOC_500B ${DISTRO_NAME}</label></text>
 </hbox>
 <button>  
   <label>${DISTRO_NAME} $LOC_315</label>                                             
   <input file>/usr/share/doc/puppylogo48.png</input>
   <action>WIKI</action>
  </button>
  </vbox>"
  ;;
esac
################### GUI ########################

export quickpack="
<window title=\"$PROGNAME v$VER\" icon-name=\"gtk-yes\">
 <vbox>
 <menubar>
    <menu>
         <menuitem icon=\"gtk-preferences\">
           <label>$LOC_304</label>
           <action>PREFS</action>
         </menuitem>
         <menuitem icon=\"gtk-quit\">
           <label>$LOC_QUIT</label>
           <action>exit:quit</action>
         </menuitem>
         <menuitem icon=\"gtk-directory\" tooltip-text=\"$LOC_353\">
           <label>$LOC_351</label>
           <action>rox /root/.quickpet/Downloads</action>
         </menuitem>
         <menuitem icon=\"gtk-clear\" tooltip-text=\"$LOC_354\">
           <label>$LOC_352</label>
           <action>CLEAR</action>
         </menuitem>
         <menuitem icon=\"gtk-properties\">
           <label>$LOC_356</label>
           <action>REPVID</action>
         </menuitem>
         <menuitem icon=\"gtk-about\">
           <label>$LOC_355</label>
           <action>ABOUT</action>
         </menuitem>
        <label>$LOC_FILE</label>
        </menu>    
        <menu>
         <menuitem icon=\"gtk-help\">
           <label>$LOC_HELP</label>
           <action>HELP</action>
         </menuitem>
         <menuitem icon=\"gtk-yes\">
           <label>Quickpet $LOC_305</label>
           <action>$USEBROWSER  http://puppylinux.org/wikka/LucidPuppyQuickpet &</action>
         </menuitem>
         <menuitem icon=\"gtk-dnd\">
           <label>$LOC_306</label>
           <action>defaulthtmlviewer file:///root/puppy-reference/doc/legal/gpl-3.0.htm &</action>
         </menuitem>
        <label>$LOC_307</label>
      </menu>    
      <menu>
		 <menuitem>
           <label>$LOC_300</label>
           <action>/usr/local/petget/pkg_chooser.sh &</action>
         </menuitem>
         <menuitem tooltip-text=\"reboot when downloaded\">
           <label>Update Lupu PPM</label>
           <action>PPMUPDATE</action>
         </menuitem>
         <menuitem>
           <label>$LOC_308</label>
           <action>README</action>
         </menuitem>
         <menuitem>
           <action>$USEBROWSER http://puppylinux.org/wikka/Compiling &</action>
           <label>Developer Module</label>
         </menuitem>
         <menuitem>
           <label>DuDE</label>
           <action>$USEBROWSER http://www.murga-linux.com/puppy/viewtopic.php?t=53680 &</action>
         </menuitem>
         <menuitem>
           <label>Firewallstate</label>
           <action>$USEBROWSER http://www.murga-linux.com/puppy/viewtopic.php?p=434498#434498 &</action>
         </menuitem>
         <menuitem>
           <label>Java</label>
           <action>$USEBROWSER http://puppylinux.org/wikka/JavaRuntimeEnvironment &</action>
         </menuitem>                    
         <menuitem>       
           <label>Open Office</label>
           <action>$USEBROWSER http://puppylinux.org/wikka/OpenOffice &</action>  
           <action>yaf-splash -font \"-misc-dejavu sans-bold-r-normal--16-0-0-0-p-0-iso10646-1\" -timeout 10 -placement top -outline 0 -bg lightgreen -text \"Note: This package installs to /mnt/home, you need to install Puppy first\" &</action>        
         </menuitem>
         <menuitem>       
           <label>precord</label>
           <action>$USEBROWSER http://murga-linux.com/puppy/viewtopic.php?t=49907 &</action>         
         </menuitem>
         <menuitem>
            <label>Snap2 Backup</label>
			<action>$USEBROWSER http://www.murga-linux.com/puppy/viewtopic.php?p=374387#374387 &</action>
          </menuitem> 
          <menuitem>       
             <label>Startmount</label>
             <action>$USEBROWSER http://www.murga-linux.com/puppy/viewtopic.php?t=50845 &</action>         
          </menuitem>              
          <menuitem>       
             <label>Sunbird</label>
             <action>$USEBROWSER http://www.murga-linux.com/puppy/viewtopic.php?p=409050#409050 &</action>         
          </menuitem>         
        <label>$LOC_350</label>
      </menu>
     
      <menu>
         <menuitem tooltip-text=\"Another window will open allowing you to copy and paste a remote sfs from the web or drag and drop a local sfs on your computer\">
           <label>Sfs_grabber</label>
           <action>sfs_grabber &</action>
         </menuitem>
         <menuitem>
           <label>SFS $LOC_307</label>
           <action>$USEBROWSER http://puppylinux.org/wikka/LucidPuppySFS &</action>
         </menuitem>
         <menuitem>
           <label>Edit SFS</label>
           <action>$USEBROWSER http://www.murga-linux.com/puppy/viewtopic.php?p=408314#408314 &</action>
         </menuitem>
         <menuitem tooltip-text=\"$LOC_357\">
           <label>sfs_linker</label>
           <action>$USEBROWSER http://www.murga-linux.com/puppy/viewtopic.php?p=352836#352836 &</action>
         </menuitem>  
     <label>SFS</label>
   </menu>
   
 </menubar>
  <hbox>
   <vbox>
    <pixmap>
    <input file>/usr/share/doc/puppylogo48.png</input>
    </pixmap>
   </vbox>
   <vbox>
    <text use-markup=\"true\" width-request=\"300\"><label>\"<b>$LOC_309 $PROGNAME</b>\"</label></text>
     <text width-request=\"350\"><label>$LOC_310</label></text>
   </vbox> 
  </hbox> 
     <notebook labels=\"${NOTEBOOK_LABELS}${LOC_314}|${LOC_315}\">
   
$PETLIST
$NETLIST
$MOREPETS
$SFSGUI
    
    <vbox>
     <text><label>$LOC_319</label></text>
$DRIVERS
    </vbox>
    
${UPDATE}
    
    </notebook>
   <hbox>
    <button>
     <label>$LOC_INFO</label>
     <input file stock=\"gtk-info\"></input>
     <action>INFO</action>
    </button>
    <button>
    <input file stock=\"gtk-ok\"></input>
    <label>$LOC_OK</label>
    </button>
   </hbox>
 </vbox>
 <action signal=\"hide\">exit:Exit</action>
</window>"

gtkdialog3 -p quickpack

unset quickpack

	;;
esac
exit

###END###
