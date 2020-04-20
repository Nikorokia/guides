# Catalina on my Dell Inspiron 7378
Welcome to.....THE NEW WAY!  

After creating my previous guide to installing Sierra on this laptop, I discovered that with a few tweaks I was able to upgrade all the way to Catalina! That's great and all, but I don't like dirty system upgrades (I prefer fresh installs whenever possible), and I hate even more not knowing/remembering what's going on with my system. So, here is the work-in-progress guide to try to get back to where I am from scratch, while also using the new technologies discovered along the way.

**What's New:** Compared to the original guide, the biggest changes here are switching from FakeSMC to VirtualSMC, and using the latest versions of Lilu and WhateverGreen to handle all graphics fixups.

<details>
    <summary>Recent Changes to My System</summary>
  
  Top is most Recent.
  
  - dropped down to just `AAPL,ig-platform-id > 00001659` in config.plist>Devices>Properties>PciRoot(etc).  
    HDMI port still works! Planning to disable unused port.
  - Upgraded to Clover r5107.
  - Reverted to using RehabMan's VooDooPS2Controller.kext (personal issues with Force Touch and tap-clicking in latest version)
  - Reverted to older `config.plist`: something I changed broke `ACPIBatteryManager.kext`. On the plus side, I have brightness keys back now.
  - Reverted to RehabMan's `SSDT-PNLF.aml` in ACPI/patched/ (for brightness keys).
  - ~~Issue: Clover r5107 broke "Minimalism" theme icons. Using Clover.app's theme "optimize" feature fixed them but made them hilariously huge. Somewhere in there is a fix.~~  
    thanks to pit512 [on GitHub](https://github.com/CloverHackyColor/CloverBootloader/issues/89), theme is back to normal. it seems currently icons need to be png files renamed as icns files.
  
</details>

**Disclaimer:** Apologies for the mess. Right now this is just a space for collecting information before it is fully organized and tested. Not all information is accurate, proceed with several grains of salt!

## Favorite Tools
- [Clover](https://github.com/CloverHackyColor/CloverBootloader): bootloader/patcher/identifier/god.  
- [ProperTree](https://github.com/corpnewt/ProperTree): the new favorite for editing properties list (plist) files.
- [Hackintool](https://www.tonymacx86.com/threads/release-hackintool-v3-x-x.254559/): kext installer, info viewer.  
- [iasl](https://github.com/RehabMan/Intel-iasl): ACPI DSDT/SSDT decompiler, use before MaciASL.  
- [MaciASL](https://github.com/acidanthera/MaciASL): ACPI DSDT/SSDT de/compiler.  
[RehabMan's version of MaciASL](https://github.com/RehabMan/OS-X-MaciASL-patchmatic) already contains his patches used below, but may be missing new fixes/features.  
- [IORegistryExplorer](https://www.tonymacx86.com/threads/guide-how-to-make-a-copy-of-ioreg.58368/): Apple Developer Tool for browsing osX's registry.  
**Important!** Use the version attached to the guide in the link! As of 3/24/20, the latest versions cause issues for others in the community.

### Other Tools
- [Clover Configurator](https://mackie100projects.altervista.org/download-clover-configurator/): the old favorite for editing Clover's `config.plist` file (see ProperTree above). CC has occasional issues with screwing up. Now's a better time than ever to learn deeper tools.  

## USB Installation Media

### Partition the USB drive  
1. Find the drive. In Terminal on Mac:
    ```
    diskuil list
    ```  
    
    <details>
        <summary>My output in Catalina</summary>

    ```
    /dev/disk0 (internal, physical):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:      GUID_partition_scheme                        *256.1 GB   disk0
       1:                        EFI EFI                     209.7 MB   disk0s1
       2:                 Apple_APFS Container disk1         255.9 GB   disk0s2

    /dev/disk1 (synthesized):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:      APFS Container Scheme -                      +255.9 GB   disk1
                                     Physical Store disk0s2
       1:                APFS Volume macOS - Data            45.6 GB    disk1s1
       2:                APFS Volume Preboot                 82.2 MB    disk1s2
       3:                APFS Volume Recovery                526.6 MB   disk1s3
       4:                APFS Volume VM                      1.1 MB     disk1s4
       5:                APFS Volume macOS                   10.9 GB    disk1s5

    /dev/disk3 (external, physical):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:     FDisk_partition_scheme                        *32.0 GB    disk3
       1:                 DOS_FAT_32 CLOVER EFI              209.7 MB   disk3s1
       2:                  Apple_HFS Install macOS Sierra    31.8 GB    disk3s2
    ```
    </details>
    
    I will be using `/dev/disk3` to create my USB.
    
2. Partition using MBR scheme, formats FAT32 for Clover/EFI and HFS+J for OS X.  
    In Terminal on Mac (note the `/dev/disk3`):
    ```
    diskutil partitionDisk /dev/disk3 2 MBR FAT32 "CLOVER EFI" 200Mi HFS+J "install_osx" R
    ```
    
    <details>
        <summary>My finished output on Catalina</summary>

    ```
    Started partitioning on disk3
    Unmounting disk
    Creating the partition map
    Waiting for partitions to activate
    Formatting disk3s1 as MS-DOS (FAT32) with name CLOVER EFI
    512 bytes per physical sector
    /dev/rdisk3s1: 403266 sectors in 403266 FAT32 clusters (512 bytes/cluster)
    bps=512 spc=1 res=32 nft=2 mid=0xf8 spt=32 hds=32 hid=2048 drv=0x80 bsec=409600 bspf=3151 rdcl=2 infs=1 bkbs=6
    Mounting disk
    Formatting disk3s2 as Mac OS Extended (Journaled) with name install_osx
    Initialized /dev/rdisk3s2 as a 30 GB case-insensitive HFS Plus volume with a 8192k journal
    Mounting disk
    Finished partitioning on disk3
    /dev/disk3 (external, physical):
       #:                       TYPE NAME                    SIZE       IDENTIFIER
       0:     FDisk_partition_scheme                        *32.0 GB    disk3
       1:                 DOS_FAT_32 CLOVER EFI              209.7 MB   disk3s1
       2:                  Apple_HFS install_osx             31.8 GB    disk3s2
    ```
    </details>
    
### Setup Clover on the USB device  
1. Download and run the Clover Installer pkg.  
    During Installation:
    - Click _Install Location_ and change to the `CLOVER EFI` partition.  
    - Click _Customize_ and check `Install for UEFI booting only`  
        (`Install Clover in the ESP` should automatically select too)

2. Configure Clover's `config.plist` using ProperTree (link at the top).  
    See this guide's [Summary](#Summary) for my current working `config.plist`.

2. Add essential kexts.  
    Place the most up-to-date versions of the following in  
    `(usb) EFI:/EFI/CLOVER/kexts/Other/`:
      - [Lilu.kext](https://github.com/acidanthera/Lilu/releases)
      - [USBInjectAll.kext](https://bitbucket.org/RehabMan/os-x-usb-inject-all/downloads/)
      - [VirtualSMC.kext](https://github.com/acidanthera/VirtualSMC/releases)
      - [VoodooPS2Controller.kext (Rehabman's version)](https://bitbucket.org/RehabMan/os-x-voodoo-ps2-controller/downloads/)
      - [WhateverGreen.kext](https://github.com/acidanthera/whatevergreen/releases)  

    While these shouldn't be used by MacOS (as installed in /L/E), they're necessary for OEM upgrades and recovery.
    
### Add the OS X installer to the drive.  
1. If you haven't done so, download the macOS installer (in this case, Catalina) from the Mac Store.
2. Copy the installer image using Terminal:
    ```
    sudo "/Applications/Install macOS Catalina.app/Contents/Resources/createinstallmedia" --volume  /Volumes/install_osx --nointeraction
    ```
3. Rename the partition:
    ```
    sudo diskutil rename "Install macOS Catalina" install_osx
    ```
  
### Clover Configuration: config.plist


## Post-Installation Configuration

### Extension (kext) Installation:
Use proper methods (either with Hackintool or the manual way) to install the most up-to-date versions of the following kexts in  
`(ssd) macOS:/Library/Extensions/`:
- VirtualSMC.kext
- Lilu.kext
- WhateverGreen.kext
- AppleALC.kext
- VoodooInput.kext
- VoodooPS2Controller.kext
- ACPIBatteryManager.kext
- USBInjectAll.kext

These are listed in order of importance:
- VirtualSMC.kext: primary enabler of macOS on unsupported hardware. (FakeSMC.kext is another, older option)
- Lilu.kext: multipurpose library of hardware enablers and fixups.
- WhateverGreen.kext: multipurpose graphics fixup library.  
  _depends on Lilu_.
- AppleALC.kext: multipurpose audio fixup library.  
  _depends on Lilu_.
- VoodooPS2Controller.kext: enables various PS2 keyboard/input devices.
- VoodooInput.kext: addon library, used herer for laptop touchpad input.  
  _depends on VoodooPS2Controller_.
- ACPIBatteryManager.kext: adds battery controller and reporting support.
- USBInjectAll.kext: enables all USB ports on device. Supposedly this is supposed to be just a temporary fix; I haven't gotten around to learning how to write a custom SSDT for my ports yet.


### Graphics Configuration

[This is the guide :musical_note: I've been waiting for, all of my li------ife! :musical_note:](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)

This laptop has an Intel Core i5-7200U (7th Gen) processor, with Intel HD 620 integrated graphics.  
According to [Intel Ark](https://ark.intel.com/content/www/us/en/ark/products/95443/intel-core-i5-7200u-processor-3m-cache-up-to-3-10-ghz.html), the graphics `Device ID` is `0x5916`.  

WhateverGreen defaults for laptops to using a different device id. I ensured it would use the correct one by adding `AAPL,ig-platform-id > 00001659` in config.plist>Devices>Properties>PciRoot(etc) (using ProperTree).

<details>
<summary>Spoiler: old config information</summary>


Crossreferencing with [Whatevergreen's supported list](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md#intel-hd-graphics-610-650-kaby-lake-processors), we get this extra information:
```
— 0x59160000 (mobile, 3 connectors, no fbmem, 35 MB)
```
and
```
ID: 59160000, STOLEN: 34 MB, FBMEM: 0 bytes, VRAM: 1536 MB, Flags: 0x00000B0B
TOTAL STOLEN: 35 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 103 MB, MAX OVERALL: 104 MB (109588480 bytes)
Model name: Intel HD Graphics KBL CRB
Camelia: CameliaDisabled (0), Freq: 1388 Hz, FreqMax: 1388 Hz
Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3
[0] busId: 0x00, pipe: 8, type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
[1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x00000187 - ConnectorDP
[2] busId: 0x04, pipe: 10, type: 0x00000800, flags: 0x00000187 - ConnectorHDMI
00000800 02000000 98000000
01050900 00040000 87010000
02040A00 00080000 87010000
```
Things to note here:  
`STOLEN: 34 MB`  
`FBMEM: 0 bytes`  

<details>
    <summary>Spoiler: Math!</summary>

According to [this forum](https://www.applelife.ru/threads/intel-hd-graphics-3000-4000-4400-4600-5000-5500-5600-520-530-630.1289648/page-169#post-750369) linked in the WhateverGreen guide, the equation for "max stolen" video memory is:  
    MAX STOLEN = 0x100000 + STOLEN * FBMemoryCount + FBMEM

  <details>
    <summary>Spoiler: Explanation Translation</summary>
  
  _vit9696's post from previous linked forum, Via Google Translate:_
  
  Regarding stolen memory in IntelFramebuffer.bt script for 010 Editor. Probably, it is necessary to explain what is going on there in general, and how the value is related to the settings in the BIOS.

  Here is an example frame 0x19160000 from Skylake.
  
  ```
  ID: 19160000, STOLEN: 34 MB, FBMEM: 21 MB, VRAM: 1536 MB, Flags: 0x0000090F
  TOTAL STOLEN: 56 MB, TOTAL CURSOR: 1 MB (1572864 bytes), MAX STOLEN: 124 MB, MAX OVERALL: 125 MB (131608576 bytes)
  Model name: Intel HD Graphics SKL CRB
  Camelia: CameliaDisabled (0), Freq: 1388 Hz, FreqMax: 1388 Hz
  Mobile: 1, PipeCount: 3, PortCount: 3, FBMemoryCount: 3
  [0] busId: 0x00, pipe: 8, type: 0x00000002, flags: 0x00000098 - ConnectorLVDS
  [1] busId: 0x05, pipe: 9, type: 0x00000400, flags: 0x00000187 - ConnectorDP
  [2] busId: 0x04, pipe: 10, type: 0x00000400, flags: 0x00000187 - ConnectorDP
  ```
  
  - Flags - framebuffer configuration as a bit mask
  - STOLEN - framebuffer-stolenmem from a patch of green (bare value)
  - FBMEM - framebuffer-fbmem from a patch of green (bare value)
  - TOTAL STOLEN - a calculated value that must be less than or equal to the one set in the BIOS
  - TOTAL CURSOR - calculated memory value for the hardware cursor on the screen
  - MAX STOLEN is TOTAL STOLEN, but if Flags has a configuration that is as memory-hungry as possible
  - MAX OVERALL is MAX STOLEN + TOTAL CURSOR
  - FBMemoryCount - the number of framebuffers available
  
  How is it considered?  
  MAX STOLEN = 0x100000 + STOLEN * FBMemoryCount + FBMEM  
  However, MAX STOLEN is precisely the maximum, the actual value (TOTAL STOLEN) is usually less and depends on the bits in the flags. Depending on their values, part of the parameters of the formula changes.  

  TOTAL STOLEN = 0x100000 + STOLEN * FBMemoryCount + FBMEM  
  If the 1st bit is set (0x02) - FBFramebufferCommonMemory, then FBMemoryCount is taken as 1.  
  If the 2nd bit (0x04) is NOT set - FBFramebufferCompression, then FBMEM is taken as 0.  
  Since both bits are set in the example above, the actual value is only 56 megabytes.  
  Correction: on Ivy Bridge TOTAL STOLEN = MAX STOLEN = FBMEM.  
  
  There is a check in Apple kexts that, after loading the framebuffer, checks that TOTAL STOLEN is less than or equal to the value from the Graphics and Memory Controller Hub for offset 0x50 according to the following formula: ((val << 17) & 0xFE000000) - 0x1000 (on older chipsets a little bit -other, but does not change the essence). This value should coincide with what the BIOS sets in the settings, but in general there are no guarantees, of course. Otherwise, panic.

  On most laptops, 32 is set, and the minimum value for a frame with connectors is usually 64. In most cases, the value can and should be changed in the BIOS settings. If there is no such option, then we use the IFR Extractor and, by analogy with CFG Lock, update the value directly through writing to the variable. There are people who suggested just removing this panic (using patches like this), but the only thing that will lead to this is glitches and panics in the most optimistic case, since the necessary magical memory in the region where the Intel driver will write, will not appear.

  If nothing at all (and the BIOS curve), you can <try> patch the framebuffer so that it consumes less memory in total. There are many options, and they are limited by your imagination.  
  - you can turn off compression and remove fbmem  
  - you can reduce both stolen / fbmem values ​​(for example, 19 and 9)  
  But in general, you need to understand that too small a memory value will not allow the use of high resolutions.  

  </details>

</details>


Unfortunately for me, Whatevergreen defaults to `device-id` `0x591B0000`, so per Whatevergreen's guide linked above, I have to set my `device-id` manually in my Clover `config.plist` to `1659000` (from info above, and bytes are written in reverse order for this part).  
![image from Whatevergreen guide](https://raw.githubusercontent.com/acidanthera/WhateverGreen/master/Manual/Img/kbl-r_igpu.png "image from Whatevergreen guide")  

**stolenmem**  
As noted above, I have STOLEN of 34mb.  
Converted to hex, that's 22.  
With a leading 0 (because macOS expects something like 128mb memory), that would be `02200000`.  
Clover wants the pairs in reverse order (don't ask me why), giving a final value of:  
`framebuffer-stolenmem: 00002002`

I'm currently testing the following values:
```
framebuffer-stolenmem    data    {length = 4, bytes = 00002002}
```
Old values:
```
framebuffer-stolenmem    data    {length = 4, bytes = 00003001}
framebuffer-fbmem        data    {length = 4, bytes = 00009000}
framebuffer-con1-pipe    data    {length = 4, bytes = 0x12000000}
```

All changes, in text mode (note, incomplete plist, only relevent section shown):
```
<dict>
<key>Devices</key>
    <dict>
        <key>Properties</key>
        <dict>
            <key>PciRoot(0)/Pci(0x02,0)</key>
            <dict>
                <key>device-id</key>
                <data>FlkAAA==</data>
            </dict>
        </dict>
    </dict>
</dict>
```

</details>

### HDMI / Sound over HDMI

[Excellent Guide](https://www.tonymacx86.com/threads/guide-general-framebuffer-patching-guide-hdmi-black-screen-problem.269149/#post-1886885)  
[OpenCore info](https://khronokernel.github.io/Opencore-Vanilla-Desktop-Guide/config.plist/kaby-lake.html)  

<details>
    <summary>Spoiler: old config</summary>

Add/uncomment these in `config.plist / Devices / [Properties]`:  

| Devices* | | Properties Key* | Properties Value | Value Type |
| :--- | --- | :--- | :--- | :--- |
| PciRoot(0)/Pci(0x02,0)  | ->  | AAPL,ig-platform-id | 00001659 (testing 00001b59) | DATA |
|                         |     | device-id | 16590000 | DATA |
|                         |     | framebuffer-con1-enable | 1 | NUMBER |
|                         |     | framebuffer-con1-pipe | 12000000 | DATA |
|                         |     | framebuffer-con1-type | 00080000 | DATA |
|                         |     | framebuffer-fbmem | 00009000 | DATA |
|                         |     | framebuffer-patch-enable | 1 | NUMBER |
|                         |     | framebuffer-stolenmem | 00003001 | DATA |

</details>

Sound over HDMI using WhateverGreen requires AppleALC.kext, which should've been installed with the other kext files as part of the beginning of this post-macOS-installation section.

HDMI-Specific Sources:  
[Reddit Thread](https://www.reddit.com/r/hackintosh/comments/8sbtrs/help_hdmi_output_make_high_sierra_to_crash/) (Gateway source)  
[RehabMan's Intel iGPU HDMI Patching Guide](https://www.tonymacx86.com/threads/guide-intel-igpu-hdmi-dp-audio-all-sandy-bridge-kaby-lake-and-likely-later.189495/) (Theoretical Solution)  
[Dell 7378 Troubleshooting Thread](https://www.tonymacx86.com/threads/solved-hackintosh-restarts-when-connecting-hdmi-cable.262080/page-3) (Personal Solution, use method to get proper `framebuffer-conX-enable`, etc. device)  
[Also Dell 7378 Troubleshooting](https://www.tonymacx86.com/threads/need-help-with-hdmi-output-solved.287923/page-2) (Auxiliary thread to previous link)  
[More Troubleshooting with different hardware](https://www.tonymacx86.com/threads/solved-hdmi-not-working-on-intel-hd4000-with-whatevergreen.263840/)  

### Onboard Audio

_[Insert section about AppleALC.kext, ALC id, and boot arg alcid=33.]

### USB ports (SSDT)

[Master guide by RehabMan](https://www.tonymacx86.com/threads/guide-creating-a-custom-ssdt-for-usbinjectall-kext.211311/) - [Supplementary guide by fidele007](https://github.com/fidele007/Asus-ROG-GL552VW-Hackintosh/wiki/Creating-a-Custom-SSDT-for-USB-Ports)

Ensure you have USBInjectAll.kext installed and these patches in Clover's config.plist/ACPI/Patches (these patches are system-specific):

Comment                                                         | Find      | Replace   | Notes
---                                                             | ---       | ---       | ---
change OSID to XSID (to avoid match against _OSI XOSI patch)    | 4F534944  | 58534944  | brightness control?
change _OSI to XOSI                                             | 5F4F5349  | 584F5349  | brightness control?
change GFX0 to IGPU                                             | 47465830  | 49475055  | brightness control?
change ECDV to EC                                               | 45434456  | 45435F5F  | macOS 10.14+ booting
change EHC1 to EH01                                             | 45484331  | 45483031  | added for USB patching
change EHC2 to EH02                                             | 45484332  | 45483032  | added for USB patching
change XHC1 to XHC                                              | 58484331  | 5848435F  | added for USB patching
change XHCI to XHC                                              | 58484349  | 5848435F  | added for USB patching

> _Note to Self:_ Eventually I want to bake these into the patched DSDT so they're not bootloader-specifc. This will require confirming which patches are **actually** necessary.

Procedure Overview:
1. Open IORegistryExplorer or [USBMap](https://github.com/corpnewt/USBMap).
2. Test all ports with USB 2.0 device.
    1. Obtain list of HSxx devices in use. **Note the port numbers.**
    2. Exclude HS ports with boot command, reboot.
3. Test all ports with USB 3.0 device.
    1. Obtain list of SSxx devices in use. **Note the port numbers.**
    2. Exclude SS ports with boot command, reboot.
4. Experiment with ports with all USR ports.
    1. Obtain list. **Note the port numbers.**
    2. Remove exclusion boot commands, reboot.
5. Build SSDT or kext with only in-use ports.

Boot args:  
- `-uia_exclude_hs` (exclude HSxx ports)  
- `-uia_exclude_ss` (exclude SSxx ports) 
- `uia_include=xxxx,xxxx` (include specific ports)
- `uia_exclude=xxxx,xxxx` (exlcude specific ports)
- **example:** `-uia_exclude_ss uia_exclude=USR1,USR2`  
- **example:** `-uia_exclude_hs uia_include=HS03`  

<details>
    <summary>Spoiler: My Obtained Information</summary>
    
```
USB 3.0 Bus PCI Device ID: 0x9d2f
USB 3.0 Bus PCI Vendor ID: 0x8086

In Use:
    name    port            notes
    HS01    <01 00 00 00>   USB-A Left Side, 2.0
    HS03    <03 00 00 00>   USB-A Right Side, 2.0
    HS04    <04 00 00 00>   USB-C, 2.0
    HS05    <05 00 00 00>   Internal: Integrated HD Webcam
    HS06    <06 00 00 00>   Internal: Bluetooth from PCIe Wifi port
    HS07    <07 00 00 00>   Internal: ELAN Touchscreen
    HS08    <08 00 00 00>   Internal: SD card reader
    SS01    <0d 00 00 00>   USB-A Left Side, 3.0
    SS04    <10 00 00 00>   USB-C, 3.0

Unknown/unused:
    HS02,HS09,HS10,SS02,SS03,SS05,SS06,USR1,USR2

Full List (discovered via exclusions):
MacBookPro14,1 > AppleACPIPlatformExpert > PCI0@0 > XHC@14
  XHC@14000000
    HS01 - USBA (Left Side)
    HS02
    HS03 - USBA (Right Side)
    HS04 - USBC
    HS05 - Webcam
    HS06 - Bluetooth
    HS07 - Touchscreen
    HS08 - SD card reader
    HS09
    HS10
    SS01 - USBA (Left Side)
    SS02
    SS03
    SS04 - USBC
    SS05
    SS06
    USR1
    USR2
```

</details>

Notes:
- Apple devices can only have a maximum of 15 USB ports (without external hubs). USBInjectAll obeys this, hence exluding port sections to discover all ports.
- USB 2.0 are usually named "HSxx" (High Speed), USB 3.0 are usually named "SSxx" (Super Speed).
- Since USB 3.0 ports are physically backwards compatible, they usually have both an "HSxx" entry and an "SSxx" entry. Both will need to be discovered using separate 2.0 and 3.0 -specific devices.
- Some USB-C ports will have multiple "SSxx" entries for their multiple orientations.
- Make sure to note down your USB Bus PCI Device and Vendor IDs for each Bus on the system (found via `Apple Logo` > `About This Mac` > `System Report` > `USB` > `USB 3.0 Bus` (etc) ).

##### Editing SSDT-UIAC.dsl

Grab a copy of [RehabMan's template](https://raw.githubusercontent.com/RehabMan/OS-X-USB-Inject-All/master/SSDT-UIAC-ALL.dsl). Open it up in a text editor.

Keep this part:
```
DefinitionBlock ("", "SSDT", 2, "hack", "_UIAC", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
```
modify these inner blocks (as below), and end with this part:
```
        })
    }
}
//EOF
```

Start by removing the large inner blocks that don't apply to the system. Got your USB Bus Device/Vendor IDs? These blocks can be mixed and matched depending on the busses present, but since I only have one (9d2f, as noted above) I just needed:
```
            "8086_9dxx", Package()  // examples: 0x9d2f, 0x9ded
            {
                "port-count", Buffer() { 18, 0, 0, 0 },
                "ports", Package()
                {
                    [...]
                },
            },
```

Now remove the smaller inner-inner blocks to match your list of discovered ports. Remember the 15-port limit, or research ways of getting around it.  
This is an example of a block I kept, with identifying comment added:
```
                    "HS01", Package() // USB-A Left Side, 2.0
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
```

Next, change the number on the "UsbConnector" line to reflect the type of port that specific one is. Per [fidele007](https://github.com/fidele007/Asus-ROG-GL552VW-Hackintosh/wiki/Creating-a-Custom-SSDT-for-USB-Ports),
- USB2 = 0
- USB3 = 3
- internal = 255
- USB type C ports can be either 9 or 10, which depends on how the hardware deals with the two possible orientations of a USB type C device/cable:
    - If a USB-C uses the same SSxx in both orientations, then it has an internal switch (UsbConnector=9).
    - If a USB-C uses a different SSxx in each orientation, then it has no switch (UsbConnector=10).

You shouldn't need to change the "port" layouts, but do verify they match the ones you recorded, adjusting for hex/decimal conversion: `{ 0d 00 00 00 }` = `{ 13, 0, 0, 0 }`, `{ 10, 00, 00, 00 }` = `{ 16, 0, 0, 0 }`, etc.

Finally, clean up the file: align indents, ensure commas and open/close brackets, etc.  
Also fix block match names to match your hardware: I used the "8086_9dxx" block, and so renamed it to "8086_9d2f".

##### Compile, load, and test

Open in MaciASL, save as `SSDT-UIAC.aml`, and place in `EFI:/EFI/CLOVER/ACPI/patched/`. Remove any added boot arguments from this section (excludes, includes, etc.).  
**Leave `USBInjectAll.kext` installed.** Everything we've created just tells the kext how to inject properly.  
Reboot and test (the part I haven't done yet).

### Patching DSDT.aml

Refer to my [ACPI Patching Guide](https://github.com/Nikorokia/guides/wiki/ACPI-Patching) on my wiki for dissassembling, patching, and reassembling the DSDT.aml file.

Apply the following patches to `DSDT.dsl` (uncompiled DSDT.aml):
- "Fix _WAK Arg0 v2”
- "Fix Mutex with non-zero SyncLevel”
- "RTC Fix”
- "Shutdown Fix v2"
- "USB3 _PRW 0x6D Skylake (Instant Wake)"

Additionally as part of keyboard brightness control, apply this custom patch from krosseyed ("BRT6 Backlight Key"): Paste the following code into the `Patch Text` field, wait for the changes to load, and then click "Apply".
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

If when clicking compile you get the errors below, replace a section [to fix them](https://www.tonymacx86.com/threads/solved-help-me-fix-dsdt-error.229025/):  
Errors:
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

### Backlight Brightness Control

Brightness Control in _System Preferences_>_Displays_>_Brightness_ is now enabled via WhateverGreen.
- **Method 1:** (Using Clover Configuration)  
  - Enable `AddPNLF` (`Boolean`>`True`) in `config.plist/ACPI/DSDT/Fixes/`.
  - Enable `SetIntelBacklight` and `SetIntelMaxBacklight` (`Boolean`>`True`) in `config.plist/Devices`.
- **Method 2:** (Using ACPI table)  
    Place an [updated `SSDT-PNLF.aml`](https://i.applelife.ru/2019/09/457190_SSDT-PNLF.aml.zip) in `EFI:/EFI/CLOVER/ACPI/patched`

Controlling the brightness with the Dell laptop's Fn keys is once again a work in progress.  
For now, use:  
- **Fn + S** for brightness **down**.
- **Fn + B** for brightness **up**.

<details>
  <summary>Previous Methods</summary>
  
##### Adding Support in System Preferences

> _"IntelBacklight.kext and ACPIBacklight.kext were broken by the [MacOS Sierra] 10.12.4 update." -[RehabMan](https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightfixup-kext.218222/)_

Per the thread in the quote, with WhateverGreen brightness control only needs [two things](https://bitbucket.org/RehabMan/applebacklightfixup/downloads/):
- `AppleBacklightFixup.kext`  
in `macOS:/Library/Extensions/`, and
- `SSDT-PNLF.aml`  
in `EFI:/EFI/CLOVER/ACPI/patched/` "to activate the [ . . . ] kext"

> _Note to Self:_ If using SortedOrder in config.plist SSDT-PNLF.aml, must be loaded after the OEM SSDTs.  
> _Note to Self:_ AppleBacklightFixup.kext requires Lilu.

##### Control with Dell laptop Fn keys

Following [this guide](https://noobsplanet.com/index.php?threads/brightness-keys-remapping-f11-and-f12-for-hackintosh.131/), you need:  
- the `change OSID to XSID` and `change _OSI to XOSI` patches in `config.plist>ACPI>DSDT>Patches`  
- the `SSDT-XOSI.aml` file in `EFI:/EFI/CLOVER/ACPI/patched/`  
- RehabMan's `SSDT-PNLF.aml` in `EFI:/EFI/CLOVER/ACPI/patched/`  
- a custom patch originally from [krosseyed](https://www.tonymacx86.com/threads/guide-dell-inspiron-13-5378-2-in-1-macos-10-12-6.230009/) ("BRT6 Backlight Key"): Paste the following code into the Patch Text field, wait for the changes to load, and then click "Apply".  
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

</details>

## Clover Options

Explanations for other Clover options I've discovered are necessary for this system.

### KernalAndKextPatches

##### KernelLapic

According to the [Clover Wiki](https://sourceforge.net/p/cloverefiboot/wiki/KernelAndKextPatches/#kernellapic):
> HP notebooks have lapic problems, which can be solved by using the boot parameter `cpus=1` or by using this option.

LAPIC, meaning Local Advanced Programmable Interrupt Controller. More info on [Wikipedia](https://en.wikipedia.org/wiki/Advanced_Programmable_Interrupt_Controller). Here, it solves issues using multiple cpu cores, especially on HP systems.

##### KernelPm

According to the [Clover Wiki](https://sourceforge.net/p/cloverefiboot/wiki/KernelAndKextPatches/#kernelpm):
> Kernel power management patch for Haswell with locked msrs. Works with 10.8.5 and 10.9 kernels.

but, per [this thread](https://www.reddit.com/r/hackintosh/comments/87n9u3/kernelpm_needed_for_kaby_lake/):
> KernelPm is not just for Haswell - it is for any system that uses XCPM and has MSR_PKG_CST_CONFIG_CONTROL locked.
>
> Starting with Haswell Macs, CPU power management functionality was moved into the kernel (known as XNU CPU Power Management). KernelPm patches the kernel to prevent writes to MSR_PKG_CST_CONFIG_CONTROL (MSR 0xE2), which is frequently locked on many systems (can usually be disabled by disabling the firmware option "CFG Lock"). Without this patch, you will encounter a kernel panic if MSR 0xE2 is locked (which appears to be the case for your system).

## Summary

PATCH YOUR OWN DSDT.aml FILE! This is a reminder to myself to not even upload my patched version. This file is specific to the hardware, and should be recompiled every time individually.  

**Most Important File:**  
`EFI:/EFI/CLOVER/config.plist`  

**Files in "EFI:/EFI/CLOVER/ACPI/patched/" folder:**  
`DSDT.aml` (patched), `SSDT-PNLF.aml`, `SSDT-XOSI.aml`  

**Extensions in "EFI:/EFI/CLOVER/kexts/other/" folder:**  
`Lilu.kext`, `USBInjectAll.kext`, `VirtualSMC.kext`, `VoodooPS2Controller.kext` (Rehabman's version), `WhateverGreen.kext`  

**Extensions installed in "macOS:/Library/Extensions/" folder:**
`ACPIBatteryManager.kext`, `AppleALC.kext`, `AppleBacklightFixup.kext`, `Lilu.kext`, `USBInjectAll.kext`, `VirtualSMC.kext`, `VoodooInput.kext`, `VoodooPS2Controller.kext`, `WhateverGreen.kext`

<details>
  <summary>Spoiler: My current working "config.plist"</summary>
  
  This should be able to be copied into TextEdit and saved as `config.plist`.
  
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>ACPI</key>
	<dict>
		<key>AutoMerge</key>
		<false/>
		<key>Comment-DisabledAML</key>
		<string>Disable other forms of CPU PM due to SSDT/Generate/PluginType=true</string>
		<key>DSDT</key>
		<dict>
			<key>DropOEM_DSM</key>
			<false/>
			<key>Fixes</key>
			<dict>
				<key>Comment-IRQ Fix</key>
				<string>The following fixes may be needed for onboard audio/USB/etc</string>
				<key>FixHPET</key>
				<false/>
				<key>FixIPIC</key>
				<false/>
				<key>FixRTC</key>
				<false/>
				<key>FixTMR</key>
				<false/>
			</dict>
			<key>Patches</key>
			<array>
				<dict>
					<key>Comment</key>
					<string>change OSID to XSID (to avoid match against _OSI XOSI patch)</string>
					<key>Disabled</key>
					<false/>
					<key>Find</key>
					<data>T1NJRA==</data>
					<key>Replace</key>
					<data>WFNJRA==</data>
				</dict>
				<dict>
					<key>Comment</key>
					<string>change _OSI to XOSI</string>
					<key>Disabled</key>
					<false/>
					<key>Find</key>
					<data>X09TSQ==</data>
					<key>Replace</key>
					<data>WE9TSQ==</data>
				</dict>
				<dict>
					<key>Comment</key>
					<string>change GFX0 to IGPU (brightness keys)</string>
					<key>Disabled</key>
					<false/>
					<key>Find</key>
					<data>R0ZYMA==</data>
					<key>Replace</key>
					<data>SUdQVQ==</data>
				</dict>
				<dict>
					<key>Comment</key>
					<string>change ECDV to EC</string>
					<key>Disabled</key>
					<false/>
					<key>Find</key>
					<data>RUNEVg==</data>
					<key>Replace</key>
					<data>RUNfXw==</data>
				</dict>
			</array>
		</dict>
		<key>FixHeaders</key>
		<false/>
		<key>SSDT</key>
		<dict>
			<key>DropOem</key>
			<false/>
			<key>Generate</key>
			<dict>
				<key>PluginType</key>
				<false/>
			</dict>
			<key>NoOemTableId</key>
			<false/>
		</dict>
	</dict>
	<key>Boot</key>
	<dict>
		<key>#DefaultVolume</key>
		<string>LastBootedVolume</string>
		<key>Arguments</key>
		<string>dart=0 alcid=33</string>
		<key>DefaultVolume</key>
		<string>LastBootedVolume</string>
		<key>NeverHibernate</key>
		<true/>
		<key>Secure</key>
		<false/>
		<key>Timeout</key>
		<integer>1</integer>
	</dict>
	<key>Comment</key>
	<string>This file is for 10.12.6+ with native KabyLake support</string>
	<key>Devices</key>
	<dict>
		<key>Audio</key>
		<dict>
			<key>Inject</key>
			<string>No</string>
			<key>ResetHDA</key>
			<false/>
		</dict>
		<key>FakeID</key>
		<dict>
			<key>#IntelGFX</key>
			<string>0x59168086</string>
			<key>#Kaby Lake-Comment</key>
			<string>To avoid automatic Clover fake device-id (Skylake) injection</string>
		</dict>
		<key>Properties</key>
		<dict>
			<key>PciRoot(0)/Pci(0x02,0)</key>
			<dict>
				<key>#AAPL,ig-platform-id</key>
				<data>AAAbWQ==</data>
				<key>AAPL,ig-platform-id</key>
				<data>AAAWWQ==</data>
				<key>device-id</key>
				<data>FlkAAA==</data>
				<key>framebuffer-con1-enable</key>
				<integer>1</integer>
				<key>framebuffer-con1-pipe</key>
				<data>EgAAAA==</data>
				<key>framebuffer-con1-type</key>
				<data>AAgAAA==</data>
				<key>framebuffer-fbmem</key>
				<data>AACQAA==</data>
				<key>framebuffer-patch-enable</key>
				<integer>1</integer>
				<key>framebuffer-stolenmem</key>
				<data>AAAwAQ==</data>
			</dict>
		</dict>
		<key>USB</key>
		<dict>
			<key>AddClockID</key>
			<false/>
			<key>FixOwnership</key>
			<false/>
			<key>Inject</key>
			<false/>
		</dict>
		<key>UseIntelHDMI</key>
		<false/>
	</dict>
	<key>GUI</key>
	<dict>
		<key>#ScreenResolution</key>
		<string>1920x1080</string>
		<key>Custom</key>
		<dict>
			<key>Entries</key>
			<array>
				<dict>
					<key>Disabled</key>
					<true/>
					<key>Hidden</key>
					<true/>
					<key>Ignore</key>
					<false/>
					<key>NoCaches</key>
					<false/>
					<key>Title</key>
					<string>Recovery</string>
					<key>Type</key>
					<string>OSXRecovery</string>
				</dict>
			</array>
		</dict>
		<key>Hide</key>
		<array>
			<string>Preboot</string>
		</array>
		<key>Mouse</key>
		<dict>
			<key>Enabled</key>
			<false/>
		</dict>
		<key>Scan</key>
		<dict>
			<key>Entries</key>
			<true/>
			<key>Legacy</key>
			<false/>
			<key>Linux</key>
			<true/>
			<key>Tool</key>
			<true/>
		</dict>
		<key>ScreenResolution</key>
		<string>1920x1080</string>
		<key>Theme</key>
		<string>Minimalism</string>
	</dict>
	<key>Graphics</key>
	<dict>
		<key>#EDID</key>
		<dict>
			<key>Inject</key>
			<false/>
		</dict>
		<key>#ig-platform-id</key>
		<string>0x591b0000</string>
		<key>Inject</key>
		<dict>
			<key>ATI</key>
			<false/>
			<key>Intel</key>
			<false/>
			<key>NVidia</key>
			<false/>
		</dict>
	</dict>
	<key>KernelAndKextPatches</key>
	<dict>
		<key>AppleRTC</key>
		<true/>
		<key>DellSMBIOSPatch</key>
		<false/>
		<key>ForceKextsToLoad</key>
		<array>
			<string>\System\Library\Extensions\IONetworkingFamily.kext</string>
		</array>
		<key>KernelLapic</key>
		<true/>
		<key>KernelPm</key>
		<true/>
	</dict>
	<key>RtVariables</key>
	<dict>
		<key>BooterConfig</key>
		<string>0x28</string>
		<key>CsrActiveConfig</key>
		<string>0x67</string>
	</dict>
	<key>SMBIOS</key>
	<dict>
		<key>ProductName</key>
		<string>MacBookPro14,1</string>
		<key>Trust</key>
		<true/>
	</dict>
	<key>SystemParameters</key>
	<dict>
		<key>InjectKexts</key>
		<string>Detect</string>
	</dict>
</dict>
</plist>
```

</details> 
