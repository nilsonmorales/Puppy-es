��             +         �     �     �  �   �     �  w   �              "     3  !   G  :   i  *   �     �     �  :   �  �   :  �        �     �  �  �     l      �     �  �   �     2  C   9     }  7  �  �  �  &  a  �  �  K  �      �  	   �  �   �  $   �  �   �  C  ]     �     �     �     �  ;   �  )   -     W     u  E   �  �   �  �   �  !  g     �  4  �     �  !   �       �     
   �  J   �     1   P  F   �  �!  0  w$  ^  �%                 	                  
                                                                                                             Ancient true-SCSI hard drive CONTINUE Extra note: Gparted may show invalid partitions on the drive, marked with a '!' icon -- delete it/them and recreate a partition (and make it bootable) Filesystem in partition IMPORTANT: If you use GParted, after creating the partition be sure to set the 'boot' flag (right-click: Manage flags). IMPORTANT: If you use GParted, after creating the partition be sure to set the 'boot' flag (right-click: Manage flags). Also, for a USB Flash drive choose fat16 filesystem as easier to boot from (than fat32) -- however a ext2 or ext3 partition will also work. INSTALL Install Puppy to Install/update GRUB Internal (IDE or SATA) hard drive Internal IDE/SATA Flash drive (ex: CF card in IDE adaptor) Internal USB Flash drive (ex: uDiskOnChip) Internal ZIP or LS120 drive Not yet implemented Nothing to choose. If a plugin device, did you plug it in? Oh dear, a 'sanity check' has failed.\nThis file: $SRCPATH/${DISTRO_PUPPYSFS}\ndoes not exist.\nThe above is supposed to be path-to-where-puppy-files-are/${DISTRO_PUPPYSFS}\nClick OK button to quit... Please find the latest Puppy files\nvmlinuz, initrd.gz and ${DISTRO_PUPPYSFS},\nTHEN HIGHLIGHT ANY ONE OF THEM\nand click the OK button Please insert the Puppy live-CD (if not already) into the drive.\nNote, in case your PC has two CD/DVD drives, Puppy is expecting\nthe live-CD to be inserted into $CDDRIVE, which is described as:\n $CDDRVINFO \n\nAfter inserting live-CD, click OK button... Puppy Universal Installer Puppy consists of 2 to 4 files:\nvmlinuz      The Linux kernel\ninitrd.gz    The initial ramdisk.\n${DISTRO_PUPPYSFS}  This has all the Puppy files (sometimes inside initrd.gz).\n             (if built inside initrd.gz then only initrd.gz is required)\n${DISTRO_ZDRVSFS} Extra kernel drivers and firmware (optional).\n             (most builds have a usable selection of drivers in ${DISTRO_PUPPYSFS})\nIf you booted Puppy from a live-CD, those files will be on it.\nOtherwise, they are in the .iso file and can be extracted -- in that\ncase, just click on the .iso file and it will be mounted (opened) in\na directory (do not forget to click on the file later to unmount it!)\n\nWhere are the Puppy files?... Puppy universal installer Puppy universal installer: ERROR QUIT Sorry, Puppy is not on the CD.\nPlease mount the CD using one of the mount programs\n(see File Managers menu) then click OK button... UPDATE USB CF Flash drive, later move CF card to IDE/SATA internal adaptor Universal Installer WARNING: NOT NORMALLY RECOMMENDED. Do you want to install Puppy in Superfloppy mode, that is, no MBR and no partitions? ...in that case, the drive will be accessed as /dev/$DRVSEL, without a partition number. This may be a good choice for booting USB Flash drive from PC with a quirky BIOS. Click button if yes: WARNING: Notice the filesystem in the intended destination, is that what you want? In particular, if the f.s. is 'vfat' or 'ntfs' you might want to replace these with a Linux ext2 or ext3 f.s. if the partition can be taken over totally for Puppy's use. If you are installing to an internal drive of a PC, it is highly recommended that the f.s. be a Linux ext2 or ext3. Puppy can install to vfat/ntfs but limited to 'frugal' with '${DISTRO_FILE_PREFIX}save' only. Ntfs is particularly limited, slow and also has severe bootup options, so get rid of it if at all possible. Click the button to run GParted, which will enable you to examine and modify the partitions. Welcome to the Puppy Universal Installer!\nIf you wish to install Puppy to a removable media, such as a USB Flash\nor hard drive, CD/DVD disc, Zip disk or LS-120 disk, please insert it\nright now, before proceeding.\n\nINSERT MEDIA NOW\nThen, choose the media that you want to install Puppy to: Your computer has these CD/DVD drives:\n$SELECTIONS \n\nHowever, you cannot install Puppy to a CD/DVD in the same way as a\nhard drive, USB Flash drive or Zip drive, as the CD/DVD is not\ndirectly writable. For the CD/DVD, you need to do what is called\n'remastering' and Puppy has a program for this, called 'Remaster\nPuppy live-CD', found in the Setup menu. This program enables\nyou to create your own custom live-CD/DVD.\nNote, you will need a new blank CD-R or DVD-R (not +R).\n\nClick button to quit... Project-Id-Version: PACKAGE VERSION
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2011-01-03 23:25+0900
PO-Revision-Date: 2012-10-20 06:28-0300
Last-Translator: Fabián H Bonetti <mama21mama@mamalibre.com.ar>
Language-Team: LANGUAGE <LL@li.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
 Ancient verdadero hard disk SCSI CONTINUAR Nota extra: Gparted puede mostrar las particiones no válidas en el disco, marcado con un '!' icono -- borrarlo/ellos y crear una partición (y que sea arrancable) Sistema de archivos en la partición IMPORTANTE: Si utiliza GParted, después de crear la partición asegúrese de ajustar el 'boot' flag (botón derecho del ratón: Gestionar las flags). IMPORTANTE: Si utiliza GParted, después de crear la partición asegúrese de ajustar el 'boot' flag (botón derecho del ratón: Gestionar las flags). Además, para una unidad USB Flash elegir sistema de archivos FAT16 como más fácil de arrancar (que fat32) -- sin embargo una partición ext2 o ext3 también funcionará. INSTALAR Instalar Puppy Instalar/actualizar GRUB Interno (IDE o SATA) hard disk Interno IDE/SATA Flash drive (ej: CF tarjeta adaptador IDE) Interno USB Flash drive (ej: uDiskOnChip) ZIP interna o la unidad LS120 Todavía no se ha implementado No hay nada que elegir. Si un dispositivo plug-in, lo que lo conecte? ¡Dios mío, una 'comprobación de validez' ha fallado.\nEste archivo: $SRCPATH/${DISTRO_PUPPYSFS}\nno existe.\nLo anterior se supone que es path-donde-puppy-archivos-esta/${DISTRO_PUPPYSFS}\nHaga clic en el botón OK para salir... Por favor, encontrar los últimos archivos de Puppy\nvmlinuz, initrd.gz y ${DISTRO_PUPPYSFS},\nA CONTINUACIÓN, RESALTE ALGUNO DE ELLOS\ny haga clic en el botón OK Por favor, inserte el Puppy live-CD (si no está ya) en la unidad.\nNota, en caso de que su PC dispone de dos unidades CD/DVD, Puppy está esperando\nel live-CD para ser insertado en $CDDRIVE, que se describe como\n $CDDRVINFO \n\nDespués de insertar live-CD, haga clic en el botón OK... Puppy Universal Instalador Puppy consta de 2 a 4 archivos:\nvmlinuz      El kernel Linux\ninitrd.gz    El disco de memoria inicial.\n${DISTRO_PUPPYSFS}  Esto tiene todos los archivos del Puppy (a veces dentro initrd.gz).\n             (si se construye dentro initrd.gz entonces sólo se requiere initrd.gz))\n${DISTRO_ZDRVSFS} Drivers del kernel adicionales y firmware (opcional)\n             (la mayoría de las versiones tienen una selección útil de los driver en ${DISTRO_PUPPYSFS})\nSi ha iniciado Puppy de un live-CD, los archivos estarán en ella.\nDe lo contrario, se encuentran en el archivo. Iso y se pueden extraer -- en el\ncaso, basta con hacer clic sobre el archivo. iso y será montado (abierto) en\nun directorio (no te olvides de hacer clic en el archivo para posteriormente desmontar!)\n\n¿Dónde están los archivos Puppy?... Puppy Universal Instalador Puppy Universal Instalador: ERROR SALIR Lo siento, Puppy no está en el CD.\nPor favor, montar el CD mediante uno de los programas mount\n(consulte la sección Menú Sistema de Archivos Pmount) y luego haga clic en el botón OK... ACTUALIZAR USB CF Flash drive, después mover tarjeta CF a IDE/SATA adaptador interno Instalador Universal ADVERTENCIA: NO SE RECOMIENDA NORMALMENTE. ¿Quieres instalar Puppy en modo Superfloppy, es decir, no MBR y no particiones? ...en ese caso, la unidad se acceden como /dev/$DRVSEL, sin un número de partición. Esto puede ser una buena opción para arrancar desde USB Flash Drive PC con un BIOS quirky. Haga clic en el botón en caso si: ADVERTENCIA: Observe el sistema de archivos en el destino deseado, es eso lo que quieres? En particular, si el s.a. es 'vfat' o 'ntfs' es posible que desee reemplazar éstos con una ext2 de Linux o ext3 s.a. si la partición puede ser asumida totalmente por el uso de Puppy. Si va a instalar una unidad interna de un PC, es muy recomendable que el sistema de archivo sea un Linux ext2 o ext3. Puppy puede instalar para vfat/ntfs, pero sin limitarse a 'frugal' con '${DISTRO_FILE_PREFIX}save' solamente. NTFS es particularmente limitado, lento y también tiene opciones de graves arranque, por lo que deshacerse de ella si es posible. Haga clic en el botón para ejecutar GParted, que le permitirá examinar y modificar las particiones. Bienvenido al Puppy Universal Instalador!\nSi desea instalar Puppy en un medio extraíble, como una memoria USB Flash\no el hard disk, CD/DVD, disco Zip o disco LS-120, por favor insertelo\nen este momento, antes de proceder.\n\nINSERTAR EL MEDIO AHORA\nLuego, escoja el medio que desee instalar Puppy a: El equipo consta de las siguientes unidades de CD/DVD:\n$SELECTIONS \n\nSin embargo, no se puede instalar Puppy en un CD/DVD en la misma forma que un\nhard disk, unidad flash USB o una unidad Zip, ya que el CD/DVD no es\ndirectamente de escritura. Para el CD / DVD, que tiene que hacer lo que se llama\n'remasterización' y Puppy tiene un programa para esto, llamado 'Remaster\nPuppy live-CD', que se encuentra en el menú de configuración. Este programa tr permite\ncrear tu propia live-CD/DVD.\nTenga en cuenta que se necesita un nuevo disco CD-R o DVD-R (no +R).\n\nHaga clic en el botón para salir... 