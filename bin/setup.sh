#!/bin/bash
clear
echo -e "\e[97mExlineal setup.\nCopyright © 2018 Wren.\n\nChecking for root...\n\e[0m"
rm -f setup.sh
echo &> 819989533091837.log >> /819989533091837_test.txt
if [ -e /819989533091837_test.txt ]; then
  echo -e "\e[32mRoot get success!\e[0m\n"
  rm -f /819989533091837_test.txt
  rm -f 819989533091837.log
else
  echo -e "\e[91mNo root. Run with sudo.\e[0m\n"
  rm -f /819989533091837_test.txt
  rm -f 819989533091837.log
  exit 1
fi
echo -e "\e[97mChecking dependencies...\e[0m\n"
function program_is_installed {
  local return_=1
  type "$1" >/dev/null 2>&1 || { local return_=0; }
  echo "$return_"
}
jq=$(program_is_installed jq)
curl=$(program_is_installed curl)
zip=$(program_is_installed 7z)
git=$(program_is_installed git)
mo=$(program_is_installed mo)
expect=$(program_is_installed expect)
uname=$(uname -a)
apt=$(program_is_installed apt)
brew=$(program_is_installed brew)
if [ "$jq" = 1 ] && [ "$curl" = 1 ] && [ "$zip" = 1 ] && [ "$git" = 1 ] && [ "$mo" = 1 ]; then
    echo -e "\e[32mDependencies installed\e[0m\n"; :
else
      if [ "$uname" = "Darwin*" ]; then
            if [ "$brew" = "1"]; then
                  echo -e "\e[31mMissing dependencies: \e[0m\n\n"
                  while [ "$jq" = 0 ]; do
                        echo -e "\e[31mjq\e[0m\n"; : 
                  done
                  while [ "$curl" = 0 ]; do
                        echo -e "\e[31mcurl\e[0m\n"; :
                  done
                  while [ "$zip" = 0 ]; do
                        echo -e "\e[31mp7-zip\e[0m\n\n"; :
                  done
                  while [ "$git" = 0 ]; do
                        echo -e "\e[31mgit\e[0m\n\n"; :
                  done
                  while [ "$mo" = 0 ]; do
                        echo -e "\e[31mmo\e[0m\n\n"; :
                  done
                  echo -e "\e[36mTry to auto-install missing? (y/n)\n?:"
                  read fixmissing
                  while [[ ( $fixmissing != "y" && $fixmissing != "n" ) ]]; do
                        echo -e "?:"
                        read fixmissing
                  done
                  echo -e "\e[0m"
                  if [ "$fixmissing" = "y" ]; then
                        echo -e "\e[37m"
                        while [ "$jq" = 0 ]; do
                              sudo wget -O /usr/bin/jq "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-osx-amd64" &> /dev/null; :
                        done
                        while [ "$zip" = 0 ]; do
                              sudo wget -O /usr/bin/7z "https://github.com/develar/7zip-bin/blob/master/mac/7za?raw=true" &> /dev/null; :
                        done
                        while [ "$curl" = 0 ]; do
                              brew install curl < /dev/null; :
                        done
                        while [ "$git" = 0 ]; do
                              brew install git < /dev/null
                        done
                        while [ "$mo" = 0 ]; do
                              curl -sSO https://raw.githubusercontent.com/tests-always-included/mo/master/mo; :
                              chmod +x mo
                              sudo mv mo /usr/bin/mo
                        done
                        echo -e "\e[0m"
                  else
                        echo -e "\e[35mSome dependencies missing... install and retry.\n\e[0m"
                        exit
                  fi
            fi
      elif [ "$uname" = "Linux*" ]; then
            echo -e "\e[31mMissing dependencies: \e[0m\n\n"
            while [ "$jq" = 1 ]; do
                  echo -e "\e[31mjq\e[0m\n"; :
            done
            while [ "$curl" = 1 ]; do
                  echo -e "\e[31mcurl\e[0m\n"; :
            done
            while [ "$zip" = 1 ]; do
                  echo -e "\e[31m7-zip\e[0m\n"; :
            done
            while [ "$git" = 1 ]; do
                  echo -e "\e[31mgit\e[0m\n"; :
            done
            while [ "$mo" = 1 ]; do
                  echo -e "\e[31mmo\e[0m\n"; :
            done
            while [ "$expect" = 1 ]; do
                  echo -e "\e[31mexpect\e[0m\n"; :
            done
            echo -e "\e[36mTry to auto-install missing? (y/n)\n?:"
            read fixmissing
            while [[ ( "$fixmissing" != "y" && "$fixmissing" != "n" ) ]]; do
                  echo -e "\e[36mTry to auto-install missing? (y/n)\n?:"
                  read fixmissing
            done
            echo -e "\e[0m"
            if [ "$fixmissing" = "y" ]; then
                  echo -e "\e[36m\nMethod to use?\n\t1. Apt (Debian-based)\n\t2. Linuxbrew (non-Debian-based) (1 or 2)\n?:"
                  read aptorbrew
                  while [[ ( "$aptorbrew" != 1 && "$aptorbrew" != 2 ) ]]; do
                        echo -e "Invalid.\n\nMethod to use?\n\t1. Apt (Debian-based)\n\t2. Linuxbrew (non-Debian-based) (1 or 2)\n?:"
                        read aptorbrew
                  done
                  if [ "$aptorbrew" = 1 ]; then
                        echo -e "\e[37m"
                        sudo apt-get -y update
                        wait
                        sudo apt-get -y upgrade
                        wait
                        while [ "$jq" = 1 ]; do
                              sudo apt-get install -y jq; :
                        done
                        while [ "$zip" = 1 ]; do
                              sudo apt-get install -y p7zip p7zip-full; :
                        done
                        while [ "$curl" = 1 ]; do
                              sudo apt-get install -y curl; :
                        done
                        while [ "$git" = 1 ]; do
                              sudo apt-get install -y git; :
                        done
                        while [ "$mo" = 1 ]; do
                              curl -sSO https://raw.githubusercontent.com/tests-always-included/mo/master/mo
                              chmod +x mo
                              mv mo /usr/bin/mo
                              :
                        done
                        echo -e "\e[0m"
                  else
                        echo -e "\e[37m"
                        while [ "$jq" = 1 ]; do
                              brew install jq; :
                        done
                        while [ "$zip" = 1 ]; do
                              brew install p7zip; :
                        done
                        while [ "$curl" = 1 ]; do
                              brew install curl; :
                        done
                        while [ "$git" = 1 ]; do
                              brew install git; :
                        done
                        while [ "$mo" = 0 ]; do
                              curl -sSO https://raw.githubusercontent.com/tests-always-included/mo/master/mo
                              chmod +x mo
                              mv mo /usr/bin/mo
                              :
                        done
                        echo -e "\e[0m"        
                  fi
            else
                  echo -e "\e[35mSome dependencies missing... install and retry.\n\e[0m"
                  exit
            fi
      else
            echo -e "\e[35mSystem not currently supported... please manually install dependencies and retry.\nPlease also contact with your system info so support can be added."
            exit
      fi
fi
if grep -Rq "OPENAPILOGIN" /etc/environment; then
      :
else
      echo -e "\e[97mPlease enter your Openload.co API login (you will need to register an account):\n\e[90m"
      read OPENAPILOGIN
      echo -e "\n\e[97mPlease enter your Openload.co API key:\n\e[90m"
      read OPENAPIKEY
      echo -e "\e[0m"
fi
sudo echo "OPENAPILOGIN=""$OPENAPILOGIN" >> /etc/environment
sudo echo "OPENAPIKEY=""$OPENAPIKEY" >> /etc/environment
source /etc/environment
echo -e "\e[97mInstalling Exlineal, please wait...\e[0m\n"
rm -rf /exlineal &> /dev/null
rm -f 1 &> /dev/null
mkdir /exlineal
mkdir /exlineal/templates
wget -O /exlineal/exlineal https://exlineal.cf/bin/exlineal.sh &> /dev/null
wget -O /exlineal/exigen https://exlineal.cf/bin/exigen.sh &> /dev/null
wget -O /exlineal/exremove https://exlineal.cf/bin/exremove.sh &> /dev/null
wget -O /exlineal/b64 https://exlineal.cf/bin/exigen.sh &> /dev/null
wget -O /exlineal/scrypt https://exlineal.cf/bin/scrypt &> /dev/null
wget -O /exlineal/xxd https://exlineal.cf/bin/xxd &> /dev/null
wget -O /exlineal/templates/temp_books.mo https://exlineal.cf/templates/temp_books.mo
wget -O /exlineal/templates/temp_games.mo https://exlineal.cf/templates/temp_games.mo
wget -O /exlineal/templates/temp_movie.mo https://exlineal.cf/templates/temp_movie.mo
wget -O /exlineal/templates/temp_music.mo https://exlineal.cf/templates/temp_music.mo
wget -O /exlineal/templates/temp_software.mo https://exlineal.cf/templates/temp_software.mo
wget -O /exlineal/templates/temp_tv.mo https://exlineal.cf/templates/temp_tv.mo
echo "PATH=""$PATH"":/exlineal" >> /etc/environment
source /etc/environment
echo -e "\e[32mDone. Run using '''exlineal''' command.\e[0m\n"
exit 0