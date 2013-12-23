from    ubuntu:12.04
# make sure the package repository is up to date
run     echo "deb http://archive.ubuntu.com/ubuntu precise main universe multiverse" > /etc/apt/sources.list
run     apt-get update

# Install vnc, xvfb in order to create a 'fake' display and firefox
run     apt-get install -y x11vnc xvfb firefox wget

# install wine
run     apt-get install -y wine wine-gecko1.4

run     wget http://winetricks.org/winetricks
run     chmod +x winetricks

run     apt-get install -y fvwm

run     /winetricks -q --no-isolate autohotkey

run     apt-get install vim -y

# start window manager
run     bash -c 'echo "fvwm&" >> /.bashrc'

# copy msi to container
run    echo '#!/bin/bash' > install_softoken.sh
run    echo 'set -o verbose' >> install_softoken.sh
run    echo 'export DISPLAY=:1' >> install_softoken.sh
run    echo 'Xvfb $DISPLAY &' >> install_softoken.sh
run    echo 'wine msiexec /i /root/softoken-setup.msi /qn' >> install_softoken.sh
run    echo 'pgrep wineserver' >> install_softoken.sh
run    echo 'while [ $? = 0 ]; do' >> install_softoken.sh
run    echo 'sleep 1' >> install_softoken.sh
run    echo 'pgrep wineserver' >> install_softoken.sh
run    echo 'done' >> install_softoken.sh
run    echo 'kill `pgrep Xvfb`' >> install_softoken.sh

run    chmod u+x install_softoken.sh
run    wget -O /root/softoken-setup.msi https://github.com/softoken/softoken-docker/blob/master/softoken-setup.msi?raw=true
run    /install_softoken.sh

run    ln -s /.wine/drive_c/Program\ Files\ \(x86\)/Secure\ Computing/SofToken-II/

cmd    x11vnc -forever -create
