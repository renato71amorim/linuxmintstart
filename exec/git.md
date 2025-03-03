git config --global user.name "Renato Amorim"
git config --global user.email "contato@renatoamorim.com"
cat ~/.ssh/id_ed25519.pub

ssh -T git@github.com

rsync -r -t -p -o -g -v --progress -s --exclude .cache/ /home/renato /media/renato/backup1/renato
