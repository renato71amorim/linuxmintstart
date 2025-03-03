#!/usr/bin/env bash

##########################################
# Script de Pós-instalação do Linux Mint #
# Autor: Renato Amorim - SIECA           #
# E-mail: contato@sieca.net              #
##########################################

# Atualizar base de dados e pacotes
apt update -y
apt upgrade -y
apt remove --purge -y timeshift
apt install -y --fix-broken

# Instalar pacotes de fontes Microsoft
echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections
apt install -y ttf-mscorefonts-installer

# Atualizações
mintupdate-cli upgrade -r -y

# Instalar pacotes do repositório
apt install -y \
aspell-pt-br automake build-essential checkinstall clamav clamav-daemon clamtk curl firefox-locale-pt \
fonts-ibm-plex fonts-liberation2 fonts-noto-cjk fonts-noto-core fonts-open-sans gcc git gparted gpg gthumb \
gtk2-engines-murrine gtk2-engines-pixbuf htop hunspell-pt-br hyphen-pt-br ibrazilian inotify-tools \
language-pack-gnome-pt language-pack-pt libavcodec-extra libjpeg-dev libnotify-bin libreoffice-help-pt \
libreoffice-help-pt-br libreoffice-l10n-pt-br libreoffice-style-colibre libssl-dev numlockx p7zip-full \
python3-dev python3-smbc rar sassc screen software-properties-common ubuntu-restricted-extras ukui-greeter \
unar unrar unzip v4l2loopback-utils virtualbox virtualbox-dkms virtualbox-qt vlc vlc-data wbrazilian wget \
wmctrl wportuguese zip zlib1g-dev zstd breeze-cursor-theme breeze-icon-theme meld nmap remmina twinkle parcellite \
openssh-server sequeler notify-osd libnotify-bin screenfetch

# Add the AnyDesk GPG key
apt update -y
apt install -y ca-certificates curl apt-transport-https
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://keys.anydesk.com/repos/DEB-GPG-KEY -o /etc/apt/keyrings/keys.anydesk.com.asc
chmod a+r /etc/apt/keyrings/keys.anydesk.com.asc

# Add the AnyDesk apt repository
echo "deb [signed-by=/etc/apt/keyrings/keys.anydesk.com.asc] https://deb.anydesk.com all main" | tee /etc/apt/sources.list.d/anydesk-stable.list > /dev/null

# Update apt caches and install the AnyDesk client
apt update -y
apt install -y anydesk

# Remover pacotes desnecessários
apt remove --purge -y hexchat hypnotix orca rhythmbox warpinator
apt autoremove --purge -y

# Baixar pacotes .deb locais
cd /tmp/
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O google-chrome.deb
wget https://github.com/rustdesk/rustdesk/releases/download/1.3.7/rustdesk-1.3.7-x86_64.deb -O rustdesk.deb
wget https://download3.ebz.epson.net/dsc/f/03/00/15/15/02/013830cf5726b235f78da4a365f8c990a98d277f/epson-inkjet-printer-202101w_1.0.2-1_amd64.deb -O epson-printer.deb
wget https://dl.4kdownload.com/app/4kvideodownloader_4.20.0-1_amd64.deb?source=website -O 4kvideodownloader.deb
wget https://clockify.me/downloads/Clockify_Setup_x64.deb -O clockify.deb
wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/e54c774e0add60467559eb0d1e229c6452cf8447/code_1.97.2-1739406807_amd64.deb -O vscode.deb
wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.25.0-amd64.deb -O slack.deb
wget https://zoom.us/client/latest/zoom_amd64.deb -O zoom.deb
wget https://stable.dl2.discordapp.net/apps/linux/0.0.87/discord-0.0.87.deb -O discord.deb
wget https://go.skype.com/skypeforlinux-64.deb -O skype.deb

# Instalar pacotes .deb
dpkg -i *.deb
apt --fix-broken install -y

wget https://repo.protonvpn.com/debian/dists/stable/main/binary-all/protonvpn-stable-release_1.0.6_all.deb
dpkg -i ./protonvpn-stable-release_1.0.6_all.deb
apt update -y
echo "e5e03976d0980bafdf07da2f71b14fbc883c091e72b16772199742c98473002f protonvpn-stable-release_1.0.6_all.deb" | sha256sum --check -
apt install -y proton-vpn-gnome-desktop

curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
apt-get -y update 
apt-get -y install spotify-client

rm *.deb

# Configuração para exibir todos os aplicativos de inicialização
sed -i "s/NoDisplay=true/NoDisplay=false/g" /etc/xdg/autostart/*.desktop

# Habilitar firewall
if ! command -v ufw &> /dev/null; then
    apt install -y ufw
fi
systemctl enable ufw
ufw enable

# Ativar atualizações automáticas
mintupdate-automation upgrade enable
mintupdate-automation autoremove enable

# Configuração do ClamAV
systemctl stop clamav-freshclam
freshclam
systemctl enable --now clamav-freshclam
systemctl enable clamav-daemon
systemctl restart clamav-daemon
systemctl enable clamav-clamonacc.service
systemctl restart clamav-clamonacc.service

# Verificação final
apt update -y
apt upgrade -y
apt install -y --fix-broken
apt autoremove --purge -y

# Crie pastas exec e copia arquivos
mkdir /exec/
cp exec/*.* /exec/
cd /exec/
chmod +x *.sh
#sh add_task.sk

# Comunique a conclusão
notify-send "Atualização do Sistema Concluída" "O sistema foi atualizado, dedique um tempo para ver as mensagens do terminal para verificar se ocorrer algum erro."
