#!/bin/bash
clear
echo -e '\e[97mexlineal\n\t\e[97m1. Upload\n\t\e[97m2.\e[97m Update software\n\t\e[97m3. uninstall\n\n?:  \n\e[97m'
read choice
while [ "$choice" != 1 ] && [ "$choice" != 2 ] && [ "$choice" != 3 ]; do
	echo -e "\e[97mexlineal\n\t\e[97m1. Upload\n\t\e[97m2.\e[97m Update software\n\t\e[97m3. uninstall\n\n?:  \n\e[97m"
	read choice
done
if [ "$choice" = 1 ]; then
	exigen
elif [ "$choice" = 2 ]; then
	exiup
elif [ "$choice" = 3 ]; then
	exiout
fi