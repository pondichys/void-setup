# Keyboard layout
# Change it if you don't use a BE keyboard
KB=be

# Clone SDDM simplicity theme repository
cd ~/git && git clone https://gitlab.com/isseigx/simplicity-sddm-theme.git

# Copy the simplicity folder to /usr/share/sddm/themes
sudo cp -r ~/git/simplicity-sddm-theme/simplicity /usr/share/sddm/themes/

# Create default SDDM config file
sddm --example-config > ~/sddm.conf

# Set the theme to simplicity
sed -i 's/Current=/Current=simplicity/g' ~/sddm.conf

# Move the file to /etc
sudo mv ~/sddm.conf /etc/sddm.conf

# Set keyboard layout for SDDM
echo setxbmap "${KB}" | sudo tee -a /usr/share/sddm/scripts/Xsetup > /dev/null
