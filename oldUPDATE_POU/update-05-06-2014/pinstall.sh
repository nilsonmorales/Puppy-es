#!/bin/sh
#Remueve script update y ipdate notify antiguo
rm /root/Startup/update_notify
chmod a+x /root/Startup/stay-connected.sh
rm /var/log/MD5sum_repo
rm /root/my-applications/bin/update
rm /root/my-applications/bin/update-es/update.desktop

#fin remocion

# Post-install script for POU (Puppy Online Updater)
# 20130610 by ASRI

# Get infos from DISTRO_SPECS and POU
. /etc/DISTRO_SPECS
. /usr/local/POU/update-url

# User infos
APPTITLE="POU (Puppy Online Updater)"
APPTITLESHORT="POU"
OSCOMPATIBILITYTRUETXT="Currently $APPTITLE utility is set to update the OS '$OSCOMPATIBILITY'.
Your current OS is '$DISTRO_NAME $DISTRO_VERSION'.
Therefore, $APPTITLESHORT is perfectly configured to update your OS!
Please restart X to complete the installation.

For more information, $APPTITLE forum is at your disposal.

------------------------

Actuellement l'utilitaire $APPTITLE est paramétré pour mettre à jour l'OS '$OSCOMPATIBILITY'.
Votre OS actuel est '$DISTRO_NAME $DISTRO_VERSION'.
Par conséquent, $APPTITLESHORT est parfaitement configuré pour mettre à jour votre OS !
Veuillez relancez X pour finaliser l'installation.

Pour obtenir des informations complémentaires, le forum $APPTITLE est à votre disposition."
OSCOMPATIBILITYFALSETXT="Currently $APPTITLE utility is set to update the OS '$OSCOMPATIBILITY'.
Therefore, setting $APPTITLESHORT does not seem appropriate to update your OS !
- If you want to download updates for another OS, then everything is ok.
- If you want to use $APPTITLESHORT to update your current OS, you must first check/change the file update-url.
Please restart X to complete the installation.

For more information, $APPTITLE forum is at your disposal.

------------------------

Actuellement l'utilitaire $APPTITLE est paramétré pour mettre à jour l'OS '$OSCOMPATIBILITY'.
Votre OS actuel est '$DISTRO_NAME $DISTRO_VERSION'.
Par conséquent, le paramétrage de $APPTITLESHORT ne semble pas adapté pour mettre à jour votre OS !
- Si vous souhaitez télécharger des mises à jour destinées à un autre OS, alors tout est ok.
- Si vous souhaitez utiliser $APPTITLESHORT pour mettre à jour votre OS actuel ($DISTRO_NAME $DISTRO_VERSION), vous devez tout d'abord vérifier/modifier le fichier update-url.
Veuillez relancez X pour finaliser l'installation.

Pour obtenir des informations complémentaires, le forum $APPTITLE est à votre disposition."


# Test compatibility and user information
if [ "$OSCOMPATIBILITY" = "DISTRO_NAME $DISTRO_VERSION" ]; then
	Xdialog --title "$APPTITLE" --left --wrap --msgbox "$OSCOMPATIBILITYTXT $OSCOMPATIBILITYTRUETXT" 0 0
	else
	Xdialog --title "$APPTITLE" --left --wrap --msgbox "$OSCOMPATIBILITYTXT $OSCOMPATIBILITYFALSETXT" 0 0
fi

exit
