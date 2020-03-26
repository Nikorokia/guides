# Config Notes
I feel like I forget everything if I put my laptop down for an hour. It's ridiculous!

## Useful Commands
Things built into my setup that I don't want to forget how to do.

### Package Management
``` bash
$ pacman -Syu           #update everything
$ pacman -S [package]   #install
$ pacman -Ss [term]     #search
$ pacman -Rsn [package] #removal:
                        #  -R    Remove package
                        #  -s    Remove unnecessary dependancies
                        #  -n    Remove leftover config files
```

### Screen Brightness
``` bash
$ xbacklight -set .01
```
- **Do not set to zero!** Screen will turn off!

### Audio Control
``` bash
$ alsamixer
```
- Arrow key navigation, use **m** to un/mute.

### Disable screensaver/screen poweroff
Good for movie watching.
``` bash
$ xset s 0 #disable screensaver. increments in seconds.
$ xset -dpms #disable screen power management. reenable with +dpms.
```
-  Get current settings with `xset q`

### Disable keyboard key repeat
``` bash
$ xset r off
```

### SSH
``` bash
$ sudo systemctl start sshd
```
Until I need it on all the time.

## Useful files and directoriesrt.
- `~/.fluxbox/startup`: Things for Fluxbox to do on start.
- `~/.fluxbox/keys`: Fluxbox keyboard shortcut config.
- `~/.fluxbox/menu`: main menu config.
- `/etc/netctl`: wireless network configs and profiles.

## Installed software
- `xorg-server`, `xorg-xinit`: Xorg/X11.
- `xorg-twm`, `xorg-xclock`, `xterm`: X basic default window manager, clock, and terminal.
- `xorg-xbacklight`: Backlight control.
- `xorg-xdpyinfo`: graphics info.
- `xorg-xrandr`: graphics control.
- `onboard`: On-screen virtual keyboard.
- `firefox`: The best.
- `git`: priceless.
- `glibc`: C-related.
- `read-edid`: reading monitor codes.
- `cbatticon`: battery icon in [fluxbox] system tray.
- `feh`: setting background wallpaper.
- `alsa-utils`, `alsa-plugins`, `alsa-oss`: audio control.
- `hicolor-icon-theme`: icons that programs rely on.
- `sddm`: display manager, for handling logins.
- `qt5-virtualkeyboard`: on-screen virtual keyboard for sddm.
- `qt5-quickcontrols2`, `qt5-graphicaleffects`: virtual keyboard manual dependancies.
- `wpa-supplicant`: support for wifi routing via netctl.
- `xf86-video-intel`: intel video driver.
- `xf86-input-synaptics`: synaptics touchpad driver.
### Fonts
- `adobe-source-sans-pro-fonts`
- `adobe-source-code-pro-fonts`
- `ttf-dejavu`
### AUR (Arch User Repo)
- [https://aur.archlinux.org/edid-decode-git.git](https://aur.archlinux.org/edid-decode-git.git)

**Not listed:** Dependancies.
