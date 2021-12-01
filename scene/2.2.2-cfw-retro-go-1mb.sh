#!/bin/bash
#By julenvitoria

INPUT=/tmp/$MENU.sh.$$
usuario="kde"
consola="mario"
proc="2"

dialog --backtitle "G&W $consola - Utilidades de flasheo" \
--title "G&W menu de flasheo $consola original 1MB" \
--ok-label Apply \
--cancel-label Exit \
--menu "Selecciona con las flechas la opcion deseada:" 12 120 15 \
   1 "CFW con los parametros para 1MB" \
   2 "Retro-Go con los parametros para 1MB" \
   3 "Hacer un \"clean\" del directorio de Retro-Go (se comprimiran de nuevo las roms cuando lances la opcion 2)" \
   4 "CFW + Retro-Go (solo un paso pero menos seguro): roms en /home/$usuario/game-and-watch-retro-go/roms/" 2>"${INPUT}"
menuitem=$(<"${INPUT}")
case $menuitem in
  1)clear
    dialog --backtitle "G&W $consola - Utilidades de flasheo" \
    --title "Instalar Retro-Go en consola G&W $consola con 1MB" \
    --yesno "Se recomienda realizar el proceso con la batería cargada al 100% para evitar problemas. Este proceso es solamente para una consola con el chip de 1MB instalado (chip original).\n\n¡¡¡ATENCION!!!\nSI SE TIENE DIFERENTE CANTIDAD DE MEMORIA CANCELAR EL PROCESO y una vez vuelto al menu seleccionar el correcto.\n\nSe flasheara un custom firmware que consta del menu original de la consola ademas del emulador Retro-Go. El emulador aparecera al realizar el combo de botones \"LEFT\" + \"GAME\". Las roms que existan en /home/$usuario/game-and-watch-retro-go/roms/ tambien se subiran a la consola ¿Deseas continuar?" 0 0
    ans=$?
    if [ $ans -eq 0 ]; then
        clear
        if [ -f /home/$usuario/gameandwatch/game-and-watch-backup/backups/flash_backup_$consola.bin ]; then
            echo "flash_backup_$consola.bin encontrado"
            sleep 0.5
            if [ -f /home/$usuario/gameandwatch/game-and-watch-backup/backups/internal_flash_backup_$consola.bin ]; then
                echo "internal_flash_backup_$consola.bin encontrado"
                sleep 0.5
                cp /home/$usuario/gameandwatch/game-and-watch-backup/backups/flash_backup_$consola.bin /home/$usuario/gameandwatch/game-and-watch-patch
                cp /home/$usuario/gameandwatch/game-and-watch-backup/backups/internal_flash_backup_$consola.bin /home/$usuario/gameandwatch/game-and-watch-patch
                echo " "
                echo "Se han copiado los archivos de la flash interna y externa"
                echo " "
                echo " "
                echo "Proceso 1/2 concluido."
                echo " "
                echo -e "\e[1;34mSi ya has ejecutado esta opcion anteriormente y algo ha salido mal desmonta la consola y vuelve a ejecutar esta\e[0m"
                echo -e "\e[1;34mopcion y, al llegar a este punto, desconecta la bateria y vuelve a conectarla antes de realizar lo siguiente.\e[0m"
                echo " "
                echo " "
                echo -e "\e[1;31mPulsa y manten pulsado el boton de encendido y justo despues pulsa cualquier tecla para continuar...\e[0m"
                read -n 1 -s -r -p ""
                clear
                cd /home/$usuario/gameandwatch/game-and-watch-patch
                make clean
                #make PATCH_PARAMS="--internal-only" flash_patched_int
                make PATCH_PARAMS="--device=$consola --internal-only" flash_patched
                cd -
                echo " "
                echo " "
                echo "Proceso 2/2 concluido."
                read -n 1 -s -r -p "Presiona cualquier tecla para continuar"
            else
                echo "No se ha encontrado internal_flash_backup_$consola.bin, cancelando..."
                sleep 2
            fi
        else
            echo "No se ha encontrado flash_backup_$consola.bin, cancelando..."
            sleep 2
        fi
        dialog --backtitle "G&W $consola - Utilidades de flasheo" \
        --title "Instalar firmware original + Retro-Go  en consola con 1MB" \
        --msgbox "Proceso realizado." 0 0
    else
            dialog --backtitle "G&W $consola - Utilidades de flasheo" \
            --title "Instalar firmware original + Retro-Go  en consola con 1MB" \
            --msgbox "Proceso cancelado." 0 0
    fi
    ./scene/2.2.2-cfw-retro-go-1mb.sh
    clear;;
  2)clear
    dialog --backtitle "G&W $consola - Utilidades de flasheo" \
    --title "Instalar solo Retro-Go" \
    --yesno "Se recomienda realizar el proceso con la batería cargada al 100% para evitar problemas. Se flasheara solamente el emulador Retro-Go por lo que no tendremos el menu original. Las roms que existan en /home/$usuario/game-and-watch-retro-go/roms/ tambien se subiran a la consola." 0 0
    ans=$?
    if [ $ans -eq 0 ]; then
        clear
        echo " "
        echo -e "\e[1;34mSi ya has ejecutado esta opcion anteriormente y algo ha salido mal desmonta la consola y vuelve a ejecutar esta\e[0m"
        echo -e "\e[1;34mopcion y, al llegar a este punto, desconecta la bateria y vuelve a conectarla antes de realizar lo siguiente.\e[0m"
        echo " "
        echo " "
        echo -e "\e[0;32mSi durante el siguiente proceso nos dice que ha fallado el flasheo, que no puede conectar y nos pregunta si\e[0m"
        echo -e "\e[0;32mvamos a hacer un power cycle (quitar bateria, reconectar y encender) pulsaremos el boton de encendido y lo \e[0m"
        echo -e "\e[0;32mmantendremos pulsado unos segundos, le diremos que si con \"y\" (yes), entonces el proceso continuara.\e[0m"
        echo -e "\e[1;31mPulsa y manten pulsado el boton de encendido y justo despues pulsa cualquier tecla para continuar...\nATENCION: No sueltes el boton al menos hasta que empiece a borrar la memoria externa (cuando pone \"Erasing xxxx bytes...\" en la pantalla)\e[0m"
        read -n 1 -s -r -p ""
        cd /home/$usuario/gameandwatch/game-and-watch-retro-go
        #make clean
        make -j$proc COMPRESS=lzma INTFLASH_BANK=2 flash
        cd -
        read -n 1 -s -r -p "Presiona cualquier tecla para continuar"
        dialog --backtitle "G&W $consola - Utilidades de flasheo" \
        --title "Instalar solo Retro-Go" \
        --msgbox "Proceso realizado." 0 0
    else
        dialog --backtitle "G&W $consola - Utilidades de flasheo" \
        --title "Instalar solo Retro-Go" \
        --msgbox "Proceso cancelado." 0 0
    fi
    ./scene/2.2.2-cfw-retro-go-1mb.sh
    clear;;
  3)clear
    dialog --backtitle "G&W $consola - Utilidades de flasheo" \
    --title "Realizar make clean en directorio Retro-Go" \
    --yesno "Si se realiza este proceso la proxima vez que se flashee Retro-Go se volvera a realizar el proceso de compresion de las roms por lo que tardara mas dependiendo del numero de roms." 0 0
    ans=$?
    if [ $ans -eq 0 ]; then
        clear
        cd /home/$usuario/gameandwatch/game-and-watch-retro-go
        make clean
        cd -
        echo " "
        echo " "
        read -n 1 -s -r -p "Proceso concluido. Presiona cualquier tecla para continuar."
        dialog --backtitle "G&W $consola - Utilidades de flasheo" \
        --title "Realizar make clean en directorio Retro-Go" \
        --msgbox "Proceso realizado." 0 0
    else
        dialog --backtitle "G&W $consola - Utilidades de flasheo" \
        --title "Instalar solo Retro-Go" \
        --msgbox "Proceso cancelado." 0 0
    fi
    ./scene/2.2.2-cfw-retro-go-1mb.sh
    clear;;
  4)clear
    dialog --backtitle "G&W $consola - Utilidades de flasheo" \
    --title "Instalar Retro-Go en consola G&W $consola con 1MB" \
    --yesno "Se recomienda realizar el proceso con la batería cargada al 100% para evitar problemas. Este proceso es solamente para una consola con el chip de 1MB instalado (chip original).\n\n¡¡¡ATENCION!!!\nSI SE TIENE DIFERENTE CANTIDAD DE MEMORIA CANCELAR EL PROCESO y una vez vuelto al menu seleccionar el correcto.\n\nSe flasheara un custom firmware que consta del menu original de la consola ademas del emulador Retro-Go. El emulador aparecera al realizar el combo de botones \"LEFT\" + \"GAME\". Las roms que existan en /home/$usuario/game-and-watch-retro-go/roms/ tambien se subiran a la consola ¿Deseas continuar?" 0 0
    ans=$?
    if [ $ans -eq 0 ]; then
        clear
        if [ -f /home/$usuario/gameandwatch/game-and-watch-backup/backups/flash_backup_$consola.bin ]; then
            echo "flash_backup_$consola.bin encontrado"
            sleep 1
            if [ -f /home/$usuario/gameandwatch/game-and-watch-backup/backups/internal_flash_backup_$consola.bin ]; then
                echo "internal_flash_backup_$consola.bin encontrado"
                sleep 1
                cp /home/$usuario/gameandwatch/game-and-watch-backup/backups/flash_backup_$consola.bin /home/$usuario/gameandwatch/game-and-watch-patch
                cp /home/$usuario/gameandwatch/game-and-watch-backup/backups/internal_flash_backup_$consola.bin /home/$usuario/gameandwatch/game-and-watch-patch
                echo " "
                echo "Se han copiado los archivos de la flash interna y externa"
                echo " "
                echo " "
                echo "Proceso 1/3 concluido."
                echo " "
                echo -e "\e[1;34mSi ya has ejecutado esta opcion anteriormente y algo ha salido mal desmonta la consola y vuelve a ejecutar esta\e[0m"
                echo -e "\e[1;34mopcion y, al llegar a este punto, desconecta la bateria y vuelve a conectarla antes de realizar lo siguiente.\e[0m"
                echo " "
                echo " "
                echo -e "\e[1;31mPulsa y manten pulsado el boton de encendido y justo despues pulsa cualquier tecla para continuar...\nATENCION: No sueltes el boton al menos hasta que empiece a borrar la memoria externa (cuando pone \"Erasing xxxx bytes...\" en la pantalla)\e[0m"
                read -n 1 -s -r -p ""
                clear
                cd /home/$usuario/gameandwatch/game-and-watch-patch
                make clean
                #make PATCH_PARAMS="--internal-only" flash_patched_int
                make PATCH_PARAMS="--device=$consola --internal-only" flash_patched
                cd -
                echo " "
                echo " "
                echo "Proceso 2/3 concluido."
                echo " "
                echo -e "\e[1;34mSi ya has ejecutado esta opcion anteriormente y algo ha salido mal desmonta la consola y vuelve a ejecutar esta\e[0m"
                echo -e "\e[1;34mopcion y, al llegar a este punto, desconecta la bateria y vuelve a conectarla antes de realizar lo siguiente.\e[0m"
                echo " "
                echo " "
                echo -e "\e[0;32mSi durante el siguiente proceso nos dice que ha fallado el flasheo, que no puede conectar y nos pregunta si\e[0m"
                echo -e "\e[0;32mvamos a hacer un power cycle (quitar bateria, reconectar y encender) pulsaremos el boton de encendido y lo \e[0m"
                echo -e "\e[0;32mmantendremos pulsado unos segundos, le diremos que si con \"y\" (yes), entonces el proceso continuara.\e[0m"
                echo -e "\e[1;31mPulsa y manten pulsado el boton de encendido y justo despues pulsa cualquier tecla para continuar...\e[0m"
                read -n 1 -s -r -p ""
                cd /home/$usuario/gameandwatch/game-and-watch-retro-go
                make clean
                make -j$proc COMPRESS=lzma INTFLASH_BANK=2 flash
                cd -
                echo " "
                echo " "
                read -n 1 -s -r -p "Proceso 3/3 concluido. Presiona cualquier tecla para continuar."
            else
                echo "No se ha encontrado internal_flash_backup_$consola.bin, cancelando..."
                sleep 2
            fi
        else
            echo "No se ha encontrado flash_backup_$consola.bin, cancelando..."
            sleep 2
        fi
        dialog --backtitle "G&W $consola - Utilidades de flasheo" \
        --title "Instalar firmware original + Retro-Go  en consola con 1MB" \
        --msgbox "Proceso realizado." 0 0
    else
            dialog --backtitle "G&W $consola - Utilidades de flasheo" \
            --title "Instalar firmware original + Retro-Go  en consola con 1MB" \
            --msgbox "Proceso cancelado." 0 0
    fi
    ./scene/2.2.2-cfw-retro-go-1mb.sh
    clear;;
esac
clear
