#!/bin/bash

##########################################
# Script Backup da pasta home            #
# Autor: Renato Amorim - SIECA           #
# E-mail: contato@sieca.net              #
##########################################


# Verificar se /mnt/backup está montado
if mount | grep -q /mnt/backup; then
    notify-send  "/mnt/backup está montado."
else
    notify-send  "/mnt/backup NÃO está montado."
    exit 1
fi

# Definindo variáveis
EXCLUIR=('.cache' '.anydesk' '.bash_history' '.bash_logout' '.bashrc' '.gitconfig' '.gitkraken' '.gk' '.gnupg' '.gtkrc-2.0' '.gtkrc-xfce' '.linuxmint' '.mozilla' '.pki' '.profile' '.ssh' '.sudo_as_admin_successful' '.vscode' '.Xauthority' '.xsession-errors' '.xsession-errors.old')
ORIGEM="/home/renato/"
DESTINO="/mnt/backup/renato"

# Construindo a lista de exclusões para o rsync
EXCLUDE_ARGS=""
for ITEM in "${EXCLUIR[@]}"; do
    EXCLUDE_ARGS+="--exclude=${ITEM} "
done

# Execute o rsync
killall -9 rsync # para o serviço se estiver em execução
rsync -avz $EXCLUDE_ARGS "$ORIGEM" "$DESTINO"

# Se o rsync for concluído com sucesso, envia uma notificação
if [ $? -eq 0 ]; then
    # Notificação via terminal
    echo "Processo concluído com sucesso!"

    # Notificação gráfica (no Linux, ambiente gráfico)
    notify-send "Rsync Concluído" "A transferência foi concluída com sucesso!"
else
    # Caso o rsync falhe
    echo "Erro na execução do rsync."
    notify-send "Rsync Falhou" "Houve um erro durante a transferência!"
fi
