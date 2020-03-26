# Post-Installation
So GRUB showed up to work properly and so kindly booted you into a fresh installation of Arch Linux!  
Congrats!

Now we get to do some more-interesting administrative stuff!  

**Note:** I often use a signifier in brackets such as "[some_information]" to signify a place where "some_information" should be changed out for context-specific real information.  
TL;DR, use your own username in place of [myuser]!

Sources
- [OSTechNix](https://www.ostechnix.com/arch-linux-2016-post-installation/)
- [n3lmt](https://n2lmt.blogspot.com/2012/09/archlinux-systemd-fluxbox-old-laptop.html)

### Pre-post-installation
1. Log in with root and the password created for root.

1. Update Arch
    ``` none
    $ pacman -Syu
    ```

## User and Sudo
_Apparently being a god is a bad thing?_
1. Create your very own baked-at-home user, [myuser]!
    ``` none
    $ useradd -m -g users -G wheel,storage,power,audio,games,lp,optical,scanner,video,tty -s /bin/bash [myuser]
    ```
    Do we need to be part of all those groups? Probably not. But it'll help...hopefully.  
    
    **[Flags](http://www.tutorialspoint.com/unix_commands/adduser.htm):**
    - -m = create directory in /home
    - -g = specify initial group for user
    - -G = specify additional groups to be part of
    - -s = specify default shell for user
    
    A list of existing groups can be found with
    ``` none
    $ cat /etc/group
    ```
    
1. Set the new [myuser]'s password.
    ``` none
    $ passwd [myuser]
    ```

1. Install sudo if not installed.
    ``` none
    $ pacman -S sudo
    ```

1. Add [myuser] to the sudoers file via visudo.
    ``` none
    $ EDITOR=nano visudo
    ```
    _I like nano. Leave me be._
    
    Here there be dragons!  
    Find the section titled "`## User privilege specification`", and right below "`root ALL=(ALL) ALL`", add:
    ``` none
    [myuser] ALL=(ALL) ALL
    ```
    Save and exit with **CTRL+O** then **ENTER** then **CTRL-X**.
    
    Log out of root with `logout` or `exit`, and log in with your spankin'-new user!  
    
    Test your god-like power by disabling the root god!
    ``` none
    $ sudo passwd -d root
    ```
    Okay, specifically this removed root's password. I have an Ubuntu background, this feels more homey to me.  
    [Alternatively](https://www.maketecheasier.com/disable-root-account-linux/) you can lock the root account with `passwd --lock root`.


## WiFi
Having installed `wpa_supplicant` during setup, this should be fairly straightforward!....this time.  

Thankfully my machine has a recognized wifi adapter, so there was no need to install any drivers or such. I'm going to [learn how to] use `netctl` profiles, because again, as minimal as possible.

1. Get all recognized networking interfaces.
    ``` bash
    $ ip link
    ```
    My adapter-of-interest is called `wlp108s0`. But I'll use [myitrf].

1. Ensure the adapter is not currently taken.
    ``` bash
    $ sudo ip link set [myitrf] down
    ```

1. Copy an example wifi profile to the `netctl` directory.
    ``` bash
    $ cd /etc/netctl
    $ cp examples/wireless-wpa [myprofilename]
    ```
    
1. Change the profile to work with your network. Remember to use `sudo`. It should look similar to this:
    ``` none
    Description='[mydescription]'
    Interface='[myitrf]'
    Connection=wireless
    
    Security=wpa
    IP=dhcp
    
    ESSID='[mywifinetworkname]'
    Key='[mywifipassword]'
    ```

1. Activate the profile.
    ``` bash
    $ sudo netctl start [myprofilename]
    ```
    **Note:** It is imperative to be in the `/etc/netctl` directory for activating the profile.

1. Test your wifi!
    ``` bash
    $ ping www.github.com
    ```
    Remember to unplug any other network connections. Stop the ping test with **CTRL+C**.
    
    Check for status and errors with
    ``` bash
    $ sudo systemctl status netctl@[myprofilename].service
    ```

## Conclusion
These are the basics. This next section was going to be about installing X server, but considering trying to install it from scratch already caused me an Arch reinstall, I figured I'd track my progress the next time in its own article.
