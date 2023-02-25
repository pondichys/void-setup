# Download latest release of Bibata-Modern-Ice cursor from Github
BIBATA_URL=https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.gz

cd ~/Downloads
wget "${BIBATA_URL}"

tar -zxvf Bibata-Modern-Ice.tar.gz
mkdir -p ~/.icons/default
mv Bibata-* ~/.icons/

cat << EOF > ~/.icons/default/index.theme
[Icon Theme]
Inherits=Bibata-Modern-Ice
EOF

