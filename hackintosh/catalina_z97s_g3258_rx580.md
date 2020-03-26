# Catalina Vanilla Install
_System:_  

## Creating the USB

1. **[Create a bootable installer for macOS](https://support.apple.com/en-us/HT201372)**
    1. Download macOS (here, Catalina) from the Mac App Store, and quit the auto launcher.
    1. Connect the USB flash drive (+12GB) and format it for _Mac OS Extended_ and _GUID Partition Map_. Remember the name, but it will be changed shortly.
    1. Open Terminal and run the following command, replacing `MyVolume` with the USB name from the previous step.
        ```
        sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/MyVolume
        ```
        This will require the account's password and an acknowledgement ("y").  
        It will take awhile.
1. **Add the Clover bootloader**
    1. [Download Clover installer from the Github repository](https://github.com/CloverHackyColor/CloverBootloader/releases). (ex: Clover_v2.5k_r5104.pkg)
    1. Run the package, be sure to select the USB volume as the install location.
    1. I ended up needing to install in "UEFI-only mode", in the Advanced Options of the Clover installer; otherwise my z97s didn't recognize the drive as a valid boot device.
1. **Add kexts**  
    Start with only what you need to get the system booting. [include link to list of essential kexts]
    I added the following to my EFI/CLOVER/kexts/Other/:  
    - VirtualSMC and NullCPUPowerManagement as essentials (needs checking) (FakeSMC has been superceded by VirtualSMC)
    - RealtekRTL8111 and realtekALC as [necessary for the z97s mobo](https://www.tonymacx86.com/threads/success-msi-z97s-sli-krait-edition-4690k-evga-gtx-960-el-capitan-clover.175301/).
1. **Configure config.plist**  
    (shouldn't need too much initial fideling?)
1. **Add supporting software**  
  Having these on the USB drive means they'll be available before the internet connection is working.
    - [Clover Configurator](https://mackie100projects.altervista.org/download-clover-configurator/)
    - Wifi drivers  


## Sources
- [Vanillla Laptop Install Thread](https://www.tonymacx86.com/threads/guide-dell-latitude-e6540.291162/)
- [Vanilla Mojave Flash Drive](https://hackintosher.com/guides/how-to-make-a-macos-10-14-mojave-flash-drive-installer/)
