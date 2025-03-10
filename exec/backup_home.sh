#!/bin/bash

##########################################
# Script Backup da pasta home            #
# Autor: Renato Amorim - SIECA           #
# E-mail: contato@sieca.net              #
##########################################

ORIGEM="/home/renato/"
DESTINO="/tmp/backup/"
ARQUIVO_COMPRIMIDO="/tmp/backup.tar.gz"

killall -9 rsync

# Versão mais simples
rsync -r -t -p -o -g -v --progress -s --exclude .cache/ /home/renato/ /tmp/backup/ 





















