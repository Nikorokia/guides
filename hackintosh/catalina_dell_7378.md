# Catalina on my Dell Inspiron 7378
Welcome to.....THE NEW WAY!  

After creating my previous guide to installing Sierra on this laptop, I discovered that with a few tweaks I was able to upgrade all the way to Catalina! That's great and all, but I don't like dirty system upgrades (I prefer fresh installs whenever possible), and I hate even more not knowing/remembering what's going on with my system. So, here is the work-in-progress guide to try to get back to where I am from scratch, while also using the new technologies discovered along the way.

**What's New:** Compared to the original guide, the biggest changes here are switching from FakeSMC to VirtualSMC, and using the latest versions of Lilu and WhateverGreen to handle all graphics fixups.

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

### Graphics Configuration

[This is the guide :musical_note: I've been waiting for, all of my li------ife! :musical_note:](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md)

### Patching DSDT.aml

_[Insert section about setting up the tools and files to patch a DSDT. Leave in dsl format for now.]_  

> _Note to Self:_ This section's location is required for the Brightness Control section below.

### Extension (kext) Installation:
Use proper methods to install the most up-to-date versions of the following kexts in  
`(ssd) macOS:/Library/Extensions/`:
- ACPIBatteryManager.kext
- AppleALC.kext
- AppleBacklightFixup.kext
- Lilu.kext
- USBInjectAll.kext
- VirtualSMC.kext
- VoodooInput.kext
- VoodooPS2Controller.kext
- WhateverGreen.kext

### Backlight Brightness Control

Brightness Control in _System Preferences_>_Displays_>_Brightness_ is now enabled via WhateverGreen.
- **Method 1:** (Using Clover Configuration)  
  - Enable `AddPNLF` (`Boolean`>`True`) in `config.plist/ACPI/DSDT/Fixes/`.
  - Enable `SetIntelBacklight` and `SetIntelMaxBacklight` (`Boolean`>`True`) in `config.plist/Devices`.
- **Method 2:** (Using ACPI table)  
    Place an [updated `SSDT-PNLF.aml`](https://i.applelife.ru/2019/09/457190_SSDT-PNLF.aml.zip) in `EFI:/EFI/CLOVER/ACPI/patched`

Controlling the brightness with the Dell laptop's Fn keys is once again a work in progress.

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

### Onboard Audio

_[Insert section about AppleALC.kext, ALC id, and boot arg alcid=33.]

> _Note to Self:_ AppleALC requires Lilu.

### HDMI / Sound over HDMI
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

> _Note to Self:_ Sound over HDMI using WhateverGreen requires AppleALC (a previous section).

HDMI-Specific Sources:  
[Reddit Thread](https://www.reddit.com/r/hackintosh/comments/8sbtrs/help_hdmi_output_make_high_sierra_to_crash/) (Gateway source)  
[RehabMan's Intel iGPU HDMI Patching Guide](https://www.tonymacx86.com/threads/guide-intel-igpu-hdmi-dp-audio-all-sandy-bridge-kaby-lake-and-likely-later.189495/) (Theoretical Solution)  
[Dell 7378 Troubleshooting Thread](https://www.tonymacx86.com/threads/solved-hackintosh-restarts-when-connecting-hdmi-cable.262080/page-3) (Personal Solution, use method to get proper `framebuffer-conX-enable`, etc. device)  
[Also Dell 7378 Troubleshooting](https://www.tonymacx86.com/threads/need-help-with-hdmi-output-solved.287923/page-2) (Auxiliary thread to previous link)  
[More Troubleshooting with different hardware](https://www.tonymacx86.com/threads/solved-hdmi-not-working-on-intel-hd4000-with-whatevergreen.263840/)  

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
  <summary>My current working "config.plist"</summary>
  
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
