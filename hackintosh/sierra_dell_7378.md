# Sierra Install on Dell Inspiron 7378

## Contents
- [Creating Installation Media](#Create-Installation-Drive)
- [Installing](#Installing-macOS-on-the-Laptop)
- [Post-Install](#Post-Install)

**Preamble:**  
The majority of this guide is simply a rewording of [krosseyed's fantastic personal experience](https://www.tonymacx86.com/threads/guide-dell-inspiron-13-5378-2-in-1-macos-10-12-6.230009/); their original thread has an amazing amount of TLC put into it and solving community issues. Since I learned so many things about the hackintosh community and techniques while working on this project, I tried to write this guide so that others as unfamiliar with the territory as I was would have another wording of the same principles.

_System Specs:_  

## Create Installation Drive
[RehabMan's Guide for Laptops](https://www.tonymacx86.com/threads/guide-booting-the-os-x-installer-on-laptops-with-clover.148093/) goes into much more detail, I've summarized below the steps I took.  
I plan to add my final configuration to a `resources` directory in this repo in case the linked resources below disappear.
1. Partition the Drive
    RehabMan recommends using `diskutil` for this, and going with MBR, FAT32 for Clover/EFI and HFS+J for OS X.
    1. In Terminal on Mac:
        ```
        diskutil list
        ```
        My output:
        ```
        /dev/disk0 (internal, physical):
           #:                       TYPE NAME                    SIZE       IDENTIFIER
           0:      GUID_partition_scheme                        *500.1 GB   disk0
           1:                        EFI EFI                     209.7 MB   disk0s1
           2:                  Apple_HFS macOS                   499.2 GB   disk0s2
           3:                 Apple_Boot Recovery HD             650.0 MB   disk0s3

        /dev/disk1 (external, physical):
           #:                       TYPE NAME                    SIZE       IDENTIFIER
           0:      GUID_partition_scheme                        *32.0 GB    disk1
           1:                        EFI EFI                     209.7 MB   disk1s1
           2:                  Apple_HFS Install macOS Mojave    31.7 GB    disk1s2
        ```
        So /dev/disk1 is the one we'll be wanting to (re-)format.
    1. In Terminal:
        ```
        diskutil partitionDisk /dev/disk1 2 MBR FAT32 "CLOVER EFI" 200Mi HFS+J "install_osx" R
        ```
        My output:
        ```
        Started partitioning on disk1
        Unmounting disk
        Creating the partition map
        Waiting for partitions to activate
        Formatting disk1s1 as MS-DOS (FAT32) with name CLOVER EFI
        512 bytes per physical sector
        /dev/rdisk1s1: 403266 sectors in 403266 FAT32 clusters (512 bytes/cluster)
        bps=512 spc=1 res=32 nft=2 mid=0xf8 spt=32 hds=32 hid=2 drv=0x80 bsec=409600 bspf=3151 rdcl=2 infs=1 bkbs=6
        Mounting disk
        Formatting disk1s2 as Mac OS Extended (Journaled) with name install_osx
        Initialized /dev/rdisk1s2 as a 30 GB case-insensitive HFS Plus volume with a 8192k journal
        Mounting disk
        Finished partitioning on disk1
        /dev/disk1 (external, physical):
           #:                       TYPE NAME                    SIZE       IDENTIFIER
           0:     FDisk_partition_scheme                        *32.0 GB    disk1
           1:                 DOS_FAT_32 CLOVER EFI              209.7 MB   disk1s1
           2:                  Apple_HFS install_osx             31.8 GB    disk1s2
        ```
1. Install Clove bootloader on the drive
    To get a working drive, I had to forgo the latest Clover (issues seeing the macOS installer later), and instead went with [RehabMan's personal fork](https://github.com/RehabMan/Clover).
    1. Install to the `CLOVER EFI` partition:
        1. Run the package installer (ex: `Clover_v2.4k_r4701.RM-4963.ca6cca7c.pkg`).
        1. `Continue`, `Continue`, and `Continue`. On the `Install` page, change the location to `CLOVER EFI` with the `Change Install Location` button (then `Continue`), then choose `Customize`.
        1. Check "Install for UEFI booting only", "Install Clover in the ESP" will automatically select
        1. Check "BGM" (Black Green Moody) from Themes (RehabMan's config.plist files use it)
        1. Choose `Install`, wait for the installer to finish, and close it.
    1. Download [HFSPlus.efi](https://github.com/JrCs/CloverGrowerPro/raw/master/Files/HFSPlus/X64/HFSPlus.efi) and place it in `"CLOVER EFI"/EFI/Clover/drivers64UEFI`.
    1. Place essential kexts in `"CLOVER EFI"/EFI/Clover/kexts/Other/` (I used RehabMan's personal builds when available to ensure consistency):
        - [FakeSMC.kext](https://github.com/RehabMan/OS-X-FakeSMC-kozlek)
        - [VoodooPS2Controller.kext](https://github.com/RehabMan/OS-X-Voodoo-PS2-Controller)
        - [USBInjectAll.kext](https://github.com/RehabMan/OS-X-USB-Inject-All)
        - [Lilu.kext](https://github.com/acidanthera/Lilu)
        - [WhateverGreen.kext](https://github.com/acidanthera/WhateverGreen)
    1. [Obtain a proper config.plist](https://github.com/RehabMan/OS-X-Clover-Laptop-Config). See RehabMan's guide for explanation.
        1. Since this system uses Intel HD620 graphics, I went with [config_HD615_620_630_640_650.plist](https://github.com/RehabMan/OS-X-Clover-Laptop-Config/blob/master/config_HD615_620_630_640_650.plist).
        1. Backup the current `"CLOVER EFI"/EFI/Clover/config.plist`,place the new one in the same directory, and rename it to `config.plist` (**important**).
1. Add the OS X installer to the drive.
    1. If you haven't done so, download the macOS installer (in this case, Mojave) from the Mac Store.
    1. Copy the installer image using Terminal:
        ```
        sudo "/Applications/Install macOS Sierra.app/Contents/Resources/createinstallmedia" --volume  /Volumes/install_osx --applicationpath "/Applications/Install macOS Sierra.app" --nointeraction
        ```
    1. Rename the partition:
        ```
        sudo diskutil rename "Install macOS Sierra" install_osx
        ```
1. Add any support software to the `install_osx` partition (wifi drivers, Clover Configurator, extra kexts, etc.). This will ensure they're available if the internet connection isn't.
    1. Copy the `/S/L/E` folder from [krosseyed's own files](https://www.tonymacx86.com/threads/guide-dell-inspiron-13-5378-2-in-1-macos-10-12-6.230009/). Having the `/EFI` folder available may be helpful too.

## Installing macOS on the Laptop
1. Ensure BIOS settings of the new system are ready:
    - "VT-d" (virtualization) should be **disabled** if possible
    - "DEP" (data execution prevention) should be **enabled** for OS X
    - "secure boot " should be **disabled**
    - "fast boot" (if available) should be **disabled**
    - "boot from USB" or "boot from external" **enabled**
    - SATA mode (if available) should be **AHCI**
    - TPM should be **disabled**
    - I disabled "legacy boot"
1. Boot into Clover (you may need to use `F12` on the keyboard to boot into the USB).
1. Select "Install macOS from install_osx" and perform a standard macOS install.
    1. Use Disk Utility to erase/format the partitions/disk used for installing to. I opted to erase the entire disk and use it for macOS.
    1. Go through the prompts.
        - For my own records, I got an error, "This copy of the Install macOS Sierra.app application is damaged, and can’t be used to install macOS." Apparently this has something to do with the [security certificate embedded in the software](https://www.tonymacx86.com/threads/this-copy-of-the-install-macos-mojave-app-application-is-damaged-and-cant-be-used-to-install-macos.285857/) (not surprising, I download and hoard software images, and it's my luck they would expire). The solution from the linked thread worked for me:  
            In Terminal ("Utilities > Terminal"),  
            ```
            date 030300002019
            ```
            Closing Terminal takes you back to the installer home, to carry on with life!
1. Reboot, booting into USB again if necessary. You may need to again choose "Install macOS from install_osx"; I actually had to go through the install process twice before it took.
1. Reboot, eventually you should get an option in Clover to boot macOS from the hard drive. There are plenty of guides booting in verbose mode and troubleshooting this section, many of them also written by the very knowledgeable RehabMan.
1. Boot the new macOS installation, finish setup, and if you've made it this far, breathe a sigh of relief!
1. **Important Step:** mount the hard drive's hidden EFI partition with a tool like Clover Configurator and copy the EFI partition from the bootable flashdrive. This lets you boot without the flashdrive, while also making the working flashdrive your untouched recovery tool in case something goes wrong.
    
## Post-Install
1. Disable Hibernate:
    ```
    sudo pmset -a hibernatemode 0
    sudo rm /var/vm/sleepimage
    sudo mkdir /var/vm/sleepimage
    ```
    You may want to head into Energy Saver and disable sleep, screen timeout, and hdd sleep for now as well, just to be safe.
    
1. [Patch DSDT and SSDTs](https://www.tonymacx86.com/threads/guide-patching-dsdt-ssdt-for-laptop-backlight-control.152659/).  
    _(dun dun duuuun)_  
    **Note:** Per RehabMan's advice, this entire process needs to be redone (save for redownloading programs) every time the hardware is changed (new hard drive, etc), the BIOS is updated, or even if the BIOS settings are changed.
    1. Use Clover to extract the system's current files
        1. Reboot
        1. At the Clover selection screen, press `F4` on the keyboard to extract the native ACPI files.  
            These files will be located in `EFI:EFI/CLOVER/ACPI/origin`.
    1. Disassemble the ACPI files
        1. Back in Mac, download [iasl](https://bitbucket.org/RehabMan/acpica/downloads), [MaciASL, and patchmatic](https://github.com/RehabMan/OS-X-MaciASL-patchmatic) (RehabMan's versions linked here).
        1. Copy `iasl` and `patchmatic` (unzipping first, if necessary) to /usr/bin/ to be used from Terminal.
            ```
            cd ~/Downloads
            
            unzip iasl.zip
            sudo cp iasl /usr/bin
            
            unzip patchmatic.zip
            sudo cp patchmatic /usr/bin
            ```  
            (Optional) Move MaciASL to your Applications folder.
        1. Mount the hidden EFI partition using a tool like Clover Configurator and copy the original ACPI files to a project folder (ex: Desktop/acpipatching/origin/). If there is only one EFI partition in the whole system (i.e., single-drive setups), you can use:
            ```
            sudo diskutil mount EFI
            ```
            And later unmount with:
            ```
            sudo diskutil umount EFI
            ```
            
        1. In Terminal, navigate to the project folder and disassemble the files.
            ```
            cd ~Desktop/acpipatching/origin/
            iasl -da -dl DSDT.aml SSDT*.aml
            ```
            Now we'll work will just the extracted *.dsl files.
            ```
            mkdir extracted_dsl
            mv *.dsl extracted_dsl/
            cd extracted_dsl
            ```
        1. Open the DSDT in MaciASL.
            1. Open the MaciASL.app.
            1. Choose "File > Open" and find the DSDT.dsl in your project folder.  
                (ex: `~Desktop/acpipatching/origin/extracted_dsl/DSDT.dsl`)
        1. Begin patching
            1. Click "Patch"
            1. For each of the following, find the same patch title in the left side of the focused dialog. Click the patch title, wait for it to load the anticipated changes, and then click "Apply". When the `Patch Text` field clears, move onto the next patch.
                - "Fix _WAK Arg0 v2”
                - "Fix Mutex with non-zero SyncLevel”
                - "RTC Fix”
                - "Shutdown Fix v2"
                - "USB3 _PRW 0x6D Skylake (Instant Wake)"
            1. Add a custom patch from krosseyed ("BRT6 Backlight Key"): Paste the following code into the `Patch Text` field, wait for the changes to load, and then click "Apply".
                ```
                into method label BRT6 replace_content
                begin
                    If (LEqual (Arg0, One))\n
                    {\n
                // Brightness Up\n
                        Notify (^^LPCB.PS2K, 0x0406)\n
                    }\n
                    If (And (Arg0, 0x02))\n
                    {\n
                // Brightness Down\n
                        Notify (^^LPCB.PS2K, 0x0405)\n
                    }\n
                end;
                ```
            1. Click "Compile"
                - If you get the errors I (and first, krosseyed) did below, replace a section [to fix them](https://www.tonymacx86.com/threads/solved-help-me-fix-dsdt-error.229025/):  
                    Error:
                    ```
                    Line  | Code | Message
                    4442    6126   syntax error, unexpected PARSEOP_IF, expecting PARSEOP_CLOSE_PAREN or ','
                    4446    6126   syntax error, unexpected PARSEOP_CLOSE_PAREN
                    10780   6126   syntax error, unexpected PARSEOP_SCOPE, expecting $end and premature End-Of-File
                    ```
                    Replace this section (Use "Edit > Find > Find..." to assist):
                    ```
                                    If (LEqual (PM6H, One))
                                    {
                                        CreateBitField (BUF0, \_SB.PCI0._Y0C._RW, ECRW)  // _RW_: Read-Write Status
                                        Store (Zero, ECRW (If (PM0H)
                                                {
                                                    CreateDWordField (BUF0, \_SB.PCI0._Y0D._LEN, F0LN)  // _LEN: Length
                                                    Store (Zero, F0LN)
                                                }))
                                    }
                    ```
                    With this:
                    ```
                                    If (LEqual (PM6H, One))
                                    {
                                        CreateBitField (BUF0, \_SB.PCI0._Y0C._RW, ECRW)  // _RW_: Read-Write Status
                                        Store (Zero, ECRW)
                                    }
                                    If (PM0H)
                                    {
                                        CreateDWordField (BUF0, \_SB.PCI0._Y0D._LEN, F0LN)  // _LEN: Length
                                        Store (Zero, F0LN)
                                    }
                    ```
                - Warnings (yellow triangle icon), remarks, and optimizations are okay. If you get errors (red circle icon), you may need to remove/comment out some lines.  
                    Errors like this one: `Name already exists in scope (IDPC)`, look for lines that begin with "External ([symbol]" (in this case, `External (IDPC` and remove them.  
                - You may need to build the latest version of iasl if the compilation still fails. RehabMan has a [guide covering this](https://www.tonymacx86.com/threads/guide-patching-laptop-dsdt-ssdts.152573/). Basic gist for reference, with Xcode installed :
                    ```
                    mkdir ~/Projects && cd ~/Projects
                    git clone https://github.com/RehabMan/Intel-iasl.git iasl.git
                    cd iasl.git
                    make
                    sudo make install
                    sudo cp /usr/bin/iasl /Applications/MaciASL.app/Contents/MacOS/iasl62
                    ```
            1. Save out the patched DSDT in MaciASL by choosing "File > Save As...", setting the File Format to "ACPI Machine Language Binary", and saving as "DSDT.aml" (Note: the file extension should be automatic for the file format) in a new location (ex: `~Desktop/acpipatching/patched/DSDT.aml`).
        1. Copy the newly-patched DSDT to `EFI:EFI/CLOVER/ACPI/patched/`.
        1. Reboot  
    [This is also a good introductory guide](https://hackintoshpro.com/patch-dsdt-hackintosh/) to patching DSDTs.

1. Install kexts.  
    Take lots of system backups during this process; I personally dump images to an external drive using Clonezilla.  
    1. Place non-Apple kexts in `/Library/Extensions`.  
        Start with kexts from krosseyed's /S/L/E folder, and eventually remove the same kext from `EFI:EFI/CLOVER/kexts/Other` if present. So far, I've had success with the following kexts placed in /L/E:
        - USBInjectAll
        - VoodooPS2Controller
        - ACPIBatteryManager
        - CodecCommander  
        
        However, **replacing OEM kexts with patched versions** must go in `/System/Library/Extensions`. Placing them in /L/E causes a kernel panic.  Make sure to take backups of the current kexts being replaced with patched versions. For me, so far this includes:
        - AppleHDA.kext  
        
        And these kexts I'm still working on implementing:
        - IOBluetoothFamily (patched)
        - BrcmFirmwareRepo
        - BrcmPatchRAM
        - FakePCIID
        - FakePCIId_Broadcom_Wifi
        - FakeSMC

        Since it's a system folder being copied to, Terminal and `sudo` must be used. `cd` to the directory of krosseyed's kexts, then in Terminal:
            ```
            sudo cp -R [kext_name].kext [additional_kexts] /Library/Extensions
            ```
        
    1. Rebuild the kexts cache by running the following commands one at a time:
        ```
        sudo chown -v -R root:wheel /System/Library/Extensions
        ```
        ```
        sudo touch /System/Library/Extensions
        ```
        ```
        sudo chmod -v -R 755 /Library/Extensions
        ```
        ```
        sudo chown -v -R root:wheel /Library/Extensions
        ```
        ```
        sudo touch /Library/Extensions
        ```
        ```
        sudo kextcache -i /
        ```
    - **Kext Installation Commentary:** The goal of this process is to reduce the amount of work Clover has to do at startup, and make the system more "Mac-Like". Kext injection via Clover is unnatural and has the potential to make the system unstable. Allowing macOS to load kexts itself after boot is the better alernative. Additionally, some kexts cannot be injected, such as patched OEM kexts for audio, etc. Obviously some kexts will need to remain in Clover to successfully boot the system, but ideally at the end of this process the number of kexts in `EFI:EFI/CLOVER/kexts/Other/` will be minimal.
    - **Kext Locations Commentary:** Older guides (including krosseyed's) say to put kexts in `/System/Library/Extensions`, but as of macOS 10.11, non-Apple kexts should go in `/Library/Extensions`. Functionally, either should work (but not both), but the new way should make the system more resiliant to OEM software updates. That said, sometimes OEM kexts need to be modified (such as AppleHDA.kext here for audio), and these may still need to go in `/System/Library/Extensions` so that macOS thinks they're real; obviously they will need to be verified as intact after OEM updates. [See this thread](https://www.tonymacx86.com/threads/what-is-different-between-system-library-extensions-library-extensions.183139/) for more information.

1. Reboot
