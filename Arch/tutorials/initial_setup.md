# Initial Setup
After doing this twice already and needing to reference multiple guides both times, I decided to start keeping my own guide.

**Recovery Tip**: I'll post these in steps as I go to help streamline getting back into the fresh Arch install via rescue media (ex: the arch install media), should something go wrong in booting.

### Machine Configuration:
Dell Latitude 7275
- [Dell link](https://www.dell.com/en-us/work/shop/dell-laptops-and-notebooks/latitude-7275-2-in-1/spd/latitude-7275-laptop), [Techradar link](https://www.techradar.com/reviews/pc-mac/laptops-portable-pcs/dell-latitude-7275-1311441/review)
- 12" 4K Touchscreen with Wacom Stylus support
- Intel CORE m5
- Intel HD Graphics 515
- 8GB RAM (_confirm_)
- 250GB M.2 SSD (_confirm_)

### Goals:
- UEFI
- Single-boot (for now)
- Minimal install: groundwork for installing different window managers, etc.

## Create Install Media
Only done once so far.
1. Downloaded the [Arch iso via torrent](https://www.archlinux.org/download/).
1. Created USB media via [Rufus portable](https://rufus.ie/)

## Install to pc
Guides:
- [ArchWiki](https://wiki.archlinux.org/index.php/Installation_guide)
- [OSTechNix](https://www.ostechnix.com/install-arch-linux-latest-version/)
1. Boot into USB via boot menu (**F12** on Dell 7275).  

    **Recovery Tip**: Booting back into the USB is the first rescue step.
    
1. View drive configuration:
    ``` zsh
    $ fdisk -l
    ```
    
1. Modify drive with `cfdisk` and then quit cfdisk.  
    This laptop originally came with Windows 10 and had all the drivers for the Wacom support/etc installed. I didn't want to lose those drivers in case of reinstalling Windows down the road, so I left the recovery partitions alone (1st is Microsoft recovery, 2nd is vendor recovery).  
    My new drive layout:
    ``` none
    Device      Size  Type
    /dev/sda1   450M  Windows recovery environment
    /dev/sda2   100M  EFI System
    /dev/sda3    32G  Linux filesystem
    /dev/sda4   189G  Linux home
    /dev/sda5    16G  Linux swap
              [space]
    /dev/sda6   503M  Windows recovery environment
              [space]
    ```
    
1. Format partitions:
    ``` zsh
    $ mkfs.ext4 /dev/sda3
    $ mkfs.ext4 /dev/sda4     #first install only
    $ makeswap /dev/sda5      #first install only
    $ swapon /dev/sda5
    ```
    **Recovery Tip**: run the `swapon` during rescues, JIC.
    
1. Mount the system partition:
    ``` zsh
    $ mount /dev/sda3 /mnt
    $ mkdir /mnt/home
    $ mount /dev/sda4 /mnt/home
    ```
    **Recovery Tip**: perform these mounts too.
    
1. Install Arch (finally).
    ``` zsh
    $ pacstrap /mnt base base-devel
    ```
    This takes a frightfully long time on mobile internet. First-world problems.
    
1. Create the fstab file. I believe this is the record of how Arch should mount the partitions on boot.
    ``` zsh
    $ genfstab /mnt >> /mnt/etc/fstab
    ```
    Check the fstab with `cat /mnt/etc/fstab`.
    
1. Re-base into the new baby Arch installation. Aint it cute?
    ``` zsh
    $ arch-chroot /mnt
    ```
    
    **Recovery Tip**: This should be it, you should now have full root control of the Arch installation. Jump to the GRUB section for resources on troubleshooting startups.
    
1. Configure language, locale, and timezone.

    1. Uncomment `en_US.UTF-8 UTF-8` in the following file.
        ``` zsh
        $ nano /etc/locale.gen
        ```
        (nano is easier for forgetful saps like me.) Save and close nano with **CTRL+O** and then **CTRL+X**.  
        
    1. Put `LANG=en_US.UTF-8` in the new file:
        ``` zsh
        $ nano /etc/locale.conf
        ```
        Save and close.
        
    1. List timezones.
        ``` zsh
        $ ls /usr/share/zoneinfo/
        $ ls /usr/share/zoneinfo/US/
        ```
        I'm in **US/Eastern**, so I used:
        ``` zsh
        $ ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
        ```
        - **Note:** during a reinstall, Arch complained that a symbolic link couldn't be made because the file already exists. Just backup the old one, and run the previous `ln` command again.
            ``` zsh
            $ mv /etc/localtime /etc/localtime.bak
            $ ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime
            ```
            
    1. Generate new locales.
        ``` zsh
        $ locale-gen
        ```
        
    1. Set the standard time to UTC.
        ``` zsh
        $ hwclock --systohc --utc
        ```
        This one seemed strange to me, since I'm in EST. But it was in one of the guides, and I'll change it later and update this if the clock is wrong.
        
1. Network Configuration

    1. Put your computer's [myhostname] in the `hostname` file.
        ``` zsh
        $ nano /etc/hostname
        ```
        Save and quit.
        
    1. Put the following in `/etc/hosts`:
        ``` none
        127.0.0.1   localhost
        ::1         localhost
        127.0.1.1   [myhostname].localdomain  [myhostname]
        ```
        
    1. Enable dhcp to make networking easier.
        ``` zsh
        $ systemctl enable dhcpcd
        ```
        
    1. Now would be a very good time to install `wpa_supplicant` if you plan to use `netctl` for wireless features like I do.
        ``` zsh
        $ pacman -S wpa_supplicant
        ```
        
1. Set root password. While it's _very_ important to make this secure, I end up disabling root after creating my user later on.
    ``` zsh
    $ passwd
    ```
    Did you write down the password?
    
1. Install GRUB.  
    Congrats. You made it to the final boss. Please keep in mind that I am setting up for UEFI; GRUB install for BIOS looks very different!
    - Additional sources: [TecMint](https://www.tecmint.com/arch-linux-installation-and-configuration-guide/) and [Fasterland](http://fasterland.net/how-to-install-grub-on-arch-linux-uefi.html).
    
    1. Get GRUB.
        ``` zsh
        $ pacman -S grub os-prober
        ```
        One of the above guides also suggests installing `efibootmgr`,  `dosfstools`, and `mtools`.
        
    1. Mount the EFI partition. Note that per my drive setup above, my EFI partition is actually `/dev/sda2`
        ``` zsh
        $ mkdir /boot/EFI
        $ mount /dev/sda2 /boot/EFI
        ```
        
    1. _Actually_ install GRUB. 
        ``` zsh
        $ grub-install --target=x86_64-efi --efi-directory=/boot/EFI --bootloader-id=GRUB
        ```
        
    1. **Optional?** Running the following command supposedly makes GRUB auto-add other present operating systems to the list, such as dual-booting with Windows. This _probably_ means it's not necessary in my currently-single(heh)-boot case, but I ran it anyway:
        ``` zsh
        $ os-prober
        ```
        
    1. Create the GRUB config file.
        ``` zsh
        $ grub-mkconfig -o /boot/grub/grub.cfg
        ```
    . . .  
    That wasn't so bad...assuming the spell holds.  
    **Recovery Tip**: During a reinstall, even though I left the EFI and home partitions as-is, GRUB couldn't boot the new Arch install, and simply running `grub-mkconfig` from the recovery media didn't work. I ended up reinstalling GRUB when I reinstalled Arch, and that seemed to fix my situation even if it wasn't the "linux-way" I wanted it to be.
    
1. Reboot and test it out!
    ...and cross your fingers.
    ``` zsh
    $ exit
    $ reboot now
    ```
    Remove installation media as the computer restarts.  
    If you're lucky, GRUB will show up and offer to boot Arch Linux for you.  
    
    If you're unlucky, you'll just get a `grub>` or `grub recovery>` prompt.  
    
    If you're _super_ unlucky, you'll get something akin to `OS NOT FOUND`, or something in the above steps will go wrong for you.  
    
    If you ARE unlucky, plug the install media back in, boot back into it, follow the "**Recovery**" tips in the steps above to get back into your base system, and then use the linked resources and Google to get GRUB configured and pointing to your Arch install.
    
    
    
## Conclusion
Here's a helpful [link to jump straight to the post-installation](/configuration/post_install.md)!

[Faquir Foysol](https://faquirfoysol.blogspot.com/2019/01/arch-aint-arcane-chodna-faquirs-2019.html) has another fun take on installing a minimal Arch setup!
