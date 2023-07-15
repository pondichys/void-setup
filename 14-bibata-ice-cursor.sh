# Download latest release of Bibata-Modern-Ice cursor from Github
BIBATA_URL=https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.gz

cd ~/Downloads || exit
wget "${BIBATA_URL}"

tar -zxvf Bibata-Modern-Ice.tar.gz

sudo mv Bibata-* /usr/share/icons/
sudo mkdir -p /usr/share/icons/default/

cat <<EOF | sudo tee -a /usr/share/icons/default/index.theme
[Icon Theme]
Inherits=Bibata-Modern-Ice
EOF
