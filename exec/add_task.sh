#!/bin/bash

# Defina a tarefa que você deseja adicionar (por exemplo, executar o script todo dia às 2:00 AM)
TAREFA="18 *    * * *   renato  /exec/backup_home.sh"

# Verifique se a tarefa já existe na crontab
crontab -l | grep -F "$TAREFA" > /dev/null

# Se a tarefa não existir, adicione-a
if [ $? -ne 0 ]; then
    (crontab -l; echo "$TAREFA") | crontab -
    echo "Tarefa adicionada à crontab."
else
    echo "A tarefa já existe na crontab."
fi