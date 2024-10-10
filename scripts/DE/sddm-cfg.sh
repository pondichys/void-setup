# Keyboard layout
# Change it if you don't use a BE keyboard
KB=be
theme_version="2.0.0"

# Get latest release of sddm-eucalyptus-drop
cd ~/Downloads
wget https://gitlab.com/api/v4/projects/37107648/packages/generic/sddm-eucalyptus-drop/${theme_version}/sddm-eucalyptus-drop-v${theme_version}.zip

# Copy the simplicity folder to /usr/share/sddm/themes
sudo  unzip ~/Downloads/sddm-eucalyptus-drop-v${theme_version}.zip -d /usr/share/sddm/themes/

# Create default SDDM config file
sddm --example-config >~/sddm.conf

# Set the theme to simplicity
sed -i 's/Current=/Current=eucalyptus-drop/g' ~/sddm.conf

# Move the file to /etc
sudo mkdir -vp /etc/sddm.conf.d
sudo mv ~/sddm.conf /etc/sddm.conf.d/sddm.conf
sudo chown root:root /etc/sddm.conf.d/sddm.conf

# Set keyboard layout for SDDM
echo setxbmap "${KB}" | sudo tee -a /usr/share/sddm/scripts/Xsetup >/dev/null
