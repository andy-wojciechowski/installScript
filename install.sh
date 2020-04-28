#!/bin/bash
################################################################################
# Title:Install script for SSE Website
# Author(s): Jonathan Paulick
#
################################################################################
sudo_check() {
    if [[ $EUID -ne 0 ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️  You Must Execute as a SUDO USER (with sudo) or as ROOT!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
    exit 0
  fi
}

ubuntu_version_check() {
    versioncheck=$(cat /etc/*-release | grep "Ubuntu" | grep -E '19')
  if [[ "$versioncheck" == "19" ]]; then
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔ WOAH! ......  System OS Warning!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Supported: UBUNTU 16.xx - 18.10 ~ LTS/SERVER
This server may not be supported due to having the incorrect OS detected!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  exit 0
  else echo ""; fi
}


agree_base() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⛔️ READ THIS NOTE 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
What would you like to do now? Select from the two option below.
[ Y ] Yes, I want to install the dependencies for MSOE SSE Webite
[ N ] No, I do not want to install the dependencies for MSOE SSE Website
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[ Z ] EXIT
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
  read -p '↘️  Type Y | N or Z | Press [ENTER]: ' typed </dev/tty

  case $typed in
    Y) dependencies_install ;;
    y) dependencies_install ;;
    N) nope ;;
    n) nope ;;
    z) exit 0 ;;
    Z) exit 0 ;;
    *) bad_input ;;
  esac
}

main_start() {
tee <<-EOF
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌎  Dependencies to install: 
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
        ┌─────────────────────────────────────┐
        │ software-properties-common          │
        │ rvm                                 │
        │ ruby                                │
        │ yarn                                │
        │ nodejs                              │
        └─────────────────────────────────────┘
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
sleep 0.5
}

dependencies_install() {
    sudo apt-get install software-properties-common
    install_rvm
    install_ruby
    install_yarn
    install_nodejs
}

install_extras() {
    echo "not done yet"
}

#############################

install_rvm() {
    echo -e "${c}Installing RVM"; $r
    sudo apt-add-repository -y ppa:rael-gc/rvm
    sudo apt-get update
    sudo apt-get install rvm
    doneOkay
}

install_ruby() {
    echo -e "${c}Installing Ruby"; $r
    echo 'source "/etc/profile.d/rvm.sh"' >> ~/.bashrc
    source /etc/profile.d/rvm.sh
    rvm install ruby
    doneOkay
}

install_nodejs() {
    echo -e "${c}Installing NodeJS"; $r
    cd
    curl -sL https://deb.nodesource.com/setup_12.x | sudo bash - #Submit the version according to your need.
    sudo apt install -y nodejs
    ( set -x; nodejs -v )
    doneOkay
}

install_yarn() {
    echo -e "${c}Installing Yarn"; $r
    curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt-get update && sudo apt-get install yarn
    doneOkay
}


##############################

bad_input() {
  echo
  read -p '⛔️ ERROR - Bad Input! | Press [ENTER] ' typed </dev/tty
  agreeBase
}

nope() {
 echo
  exit 0
}

done_okay() {
 echo
  read -p 'Install Success | PRESS [ENTER] ' typed </dev/tty
}

#############################
sudo_check
ubuntu_version_check
sudo apt-get update
sudo apt-get upgrade
dependencies_install
done_okay