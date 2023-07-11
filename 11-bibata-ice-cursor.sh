# Download latest release of Bibata-Modern-Ice cursor from Github
BIBATA_URL=https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.gz

cd ~/Downloads || exit
wget "${BIBATA_URL}"

tar -zxvf Bibata-Modern-Ice.tar.gz
mkdir -p ~/.icons/default
mv Bibata-* ~/.icons/

cat <<EOF >~/.icons/default/index.theme
[Icon Theme]
Inherits=Bibata-Modern-Ice
EOF

# Make Bibata-Modern-Ice default cursor for all users
# Also needed to be available in SDDM
sudo mkdir -p /usr/share/icons/default/
sudo cp -R ~/.icons/Bibata-Modern-Ice /usr/share/icons/
sudo cp ~/.icons/default/index.theme /usr/share/icons/default/
