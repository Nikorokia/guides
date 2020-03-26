# X (server / Xorg / X11 / whatever)
_Okay. Fine. Poke the half-awake bear with a sharp stick._

## Start with the Wiki
By that I mean the [Arch Wiki](https://wiki.archlinux.org/index.php/Xorg#Installation)

### Driver Installation
``` bash
$ lspci | grep -e VGA -e 3D
```
I got:
``` none
00:02.0 VGA compatible controller: Intel Corporation HD Graphics 515 (rev 07)
00:13.0 Non-VGA unclassified device: Intel Corporation Sunrise Point-LP Integrated Sensor Hub (rev 21)
```

According to the wiki, I want the Intel driver:
``` bash
$ sudo pacman -S xf86-video-intel
```
The wiki also says something about `mesa` for OpenGL. I think that's significant.

### Xorg Pieces #1
Jumping back over to [n2lmt](https://n2lmt.blogspot.com/2012/09/archlinux-systemd-fluxbox-old-laptop.html), let's install some X stuff per #17:
``` bash
$ sudo pacman -S xorg-server xorg-xinit
```
`xorg-server-utils` wasn't found, `mesa` was up-to-date, and I held off on `mesa-demos` for now.  
I also specifically avoided installing straight-up `xorg`, per [this forum](https://bbs.archlinux.org/viewtopic.php?id=136514).

### Synaptics
Since I too am running on a laptop, I went ahead and followed n2lmt through #18, setting up the keyboard.
``` bash
$ sudo pacman -S xf86-input-synaptics
```
Then copying Archwiki's [sample config](https://wiki.archlinux.org/index.php/Touchpad_Synaptics#Frequently_used_options) to `/etc/X11/xorg.conf.d/10-synaptics.conf`:
``` none
Section "InputClass"
    Identifier "touchpad"
    Driver "synaptics"
    MatchIsTouchpad "on"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "VertEdgeScroll" "on"
        Option "VertTwoFingerScroll" "on"
        Option "HorizEdgeScroll" "on"
        Option "HorizTwoFingerScroll" "on"
        Option "CircularScrolling" "on"
        Option "CircScrollTrigger" "2"
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
        Option "CoastingSpeed" "0"
        Option "FingerLow" "30"
        Option "FingerHigh" "50"
        Option "MaxTapTime" "125"
EndSection
```
Also copying the following into `/etc/X11/xorg.conf.d/10-evdev.conf` (via [this link](http://pastebin.com/raw/4mPY35Mw)):
``` none
# Catchall classes for input devices
# We don't simply match on any device since that also adds accelerometers
# and other devices that we don't really want to use. The list below
# matches everything but joysticks.

Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev keyboard catchall"
        MatchIsKeyboard "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        
        # Keyboard layouts
        Option "XkbLayout" "us, bg"
        Option "XkbVariant" ", phonetic"
        Option "XkbOptions" "grp:alt_shift_toggle, grp_led:scroll, terminate:ctrl_alt_bksp"
EndSection

Section "InputClass"
        Identifier "evdev touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev tablet catchall"
        MatchIsTablet "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection

Section "InputClass"
        Identifier "evdev touchscreen catchall"
        MatchIsTouchscreen "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
EndSection
```

### Xorg Pieces #2
``` bash
$ sudo pacman -S xorg-twm xorg-xclock xterm
```

## Testing Xorg
Confirm there's no `.xinitrc` in the home directory...
``` bash
$ rm ~/.xinitrc
```
Then cross fingers, cross heart, pray to Cthulhu, and test.
``` bash
$ startx
```
. . .  

. . .  

. . .  

...and **it worked!!**  
I've never been so happy to see near-empty white boxes. No idea where the thrid one went to though.  
_Probably a sacrifice to Cthulhu._  
Moving on...

## Conclusion
Above and beyond, the mouse and keyboard work too!  

Weirdly, I found the third box: it's waaaaay over on the edge of my tiny 4K HiDPI laptop screen (more on that later) and so doesn't show up on the actually-legible HDMI monitor I'm using to set up the system. This part of the HiDPI screen wasn't (apparently) accessible before from the virtual console with the HDMI monitor plugged in, but it seems that X discovered the full bounds of the primary display and prioritized it----and yet also didn't bother to scale the text to a readable size.  
Huh.

Typing `exit` into all three boxes quit the X server and brought me back to the VT.

Time to work on installing Fluxbox.

## Xorg vs Wayland
With the goal of making the most-optimized, forward-thinking, "Arch-iest" system possible, I've been reading a lot on what might be the best courses of action.

Here's how I understand it: Xorg is the basis for Linux graphical user interfaces.  

Everything I've installed before Xorg was the Arch operating system, but in order to show graphics, there needs to be a GUI on top of it. That GUI consists of multiple parts: the average user typically interacts most with a desktop environment (like Gnome), which incorporates and sits on top of multiple parts including a window manager (like Fluxbox). Consistency-stuff is also present, like a display manager that handles GUI user logins, etc. These graphical parts then sit on top of Xorg, which sits on the operating system. Apparently Xorg is also massive and ancient (in technology years), and unoptimized because of backwards-compatibility issues.

Enter [Wayland](https://wiki.archlinux.org/index.php/Wayland) ([homepage](https://wayland.freedesktop.org/)). My understanding is that Wayland attempts to bundle, optimize, and reduce the whole tree above, reducing the number of parts required and updating the Linux GUI ecosystem to the common era. It sounds like it was made for the Arch mindset of minimalism. It's also very young with a much smaller development, and has had trouble with solid stability.  

[This is a great synopsis](https://www.phoronix.com/scan.php?page=article&item=x_wayland_situation&num=1) of everything Wayland has going for it, and [here](https://askubuntu.com/questions/11537/why-is-wayland-better) is some user discussion. There are a lot of great Reddit threads comparing the two, I found [this](https://www.reddit.com/r/archlinux/comments/7hbq9r/xorg_or_wayland_whats_your_findings/) and [this](https://www.reddit.com/r/archlinux/comments/5qfusz/do_you_even_wayland/) helpful.  

All that to say, I really wanted to start off with Wayland---and I may come back and try it in the future. But given how many issues I had trying to get Xorg working despite all the documentation of the vast internet, I feared Wayland would potentially have more issues with less help. There was also the fact that I plan to forgo a desktop environment for the sake of system resources and minimalism; there wasn't much documentation available on Wayland in such a setup.

So here we are, another victim of Xorg, and the wisdom of the internet has already used Xorg to correct the odd display of my laptop. Forward!
