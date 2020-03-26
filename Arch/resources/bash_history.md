# .bash_history
A curated history of commands I've used to set up my system, with some explanations.

``` bash
# -------- 7/13/19 ------- #

# delete root password
sudo passwd -d root

# check network interfaces
ip link

# start wireless profile (from within /etc/netctl)
sudo netctl start [netprofile]

# check on wireless profile
sudo systemctl status netctl@[netprofile].service

# make sure interface accessible by netctl
sudo ip link set wlp108s0 down

# read-edid for monitor profiles
sudo pacman -S read-edid
sudo get-edid -m 0 > edid0.bin
cat edid0.bin
sudo pacman -S git glibc
git clone https://aur.archlinux.org/edid-decode-git.git
cd edid-decode-git/ && makepkg -si
cat edid0.bin | edid-decode >> decodedEdid0 && cat decodedEdid0

# setup ssh
sudo pacman -S openssh

# get display devices
lspci | grep -e VGA -e 3D

# Xorg setup
sudo pacman -S xf86-video-intel xorg-server xorg-xinit xf86-input-synaptics xorg-twm xorg-xclock xterm
# some config file manipulation. see my guide on setting up Xorg.
startx

# xrandr for setting display res
sudo pacman -S xorg-xrandr
xrandr --output ePD1 --mode 1920x1080
# VOILA! 4K laptop is actually legible. Need to add to a Xorg start script.

```
