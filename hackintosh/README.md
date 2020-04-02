# Hackintosh
[Most Recent Build](catalina_dell_7378.md) ~ [Useful Commands](useful_commands.md)

My collection of resources for Apple fans without cash

_Author's note: I've discovered that despite the ubiquity of the internet, many of the resources I've used in the past are disappearing. This repo is another attempt at prolonging the life of the resources I can recover._

The building blocks of a vanilla Hackintosh consist of 4 pieces:
1. A bootable USB installer, created on a Mac from the macOS Installer app.
1. The Clover bootloader.
1. _kexts_, or drivers, that interface with the non-Apple system.
1. A custom `config.plist`, optimized for the non-Apple hardware.

There are more things that can be done to make the system more stable and properly utilize the hardware, such as patching DSDTs, but I haven't explored them in depth yet; getting a working system seems difficult enough.  

There are also "prebuilt" resources available: Unibeast and Multibeast from tonymacx86 try to make the process easier and broader through single-click installers. Niresh and others have entire modified OSX images ready to mount. However, in my own resources, I try to keep the OS as original as possible and also to stick to open-source tools. More on these points will eventually be in the [Commentary](#Commentary) section.

_This repo is in its early stages._

## Reference Systems
**Desktop**  
_Motherboard:_ MSI z97s SLI  
_Processor:_ Pentium G3258  
_Graphics Card:_ Sapphire RX 580 Pulse 8GB  

**Laptop**  
_System:_ Dell Inspiron 7378 [(cnet link)](https://www.cnet.com/products/dell-inspiron-13-7378-2-in-1-13-3-core-i5-7200u-8-gb-ram-256-gb-ssd-english-i73785564grypus/)  
_Processor:_  Intel Core i5 (7th Gen) 7200U / 2.5 GHz / 3.1 GHz / 2-core, 4-thread  
_Graphics:_ Intel HD 620  
_Audio:_ Realtek ALC3253  
_Equivalent Macbook Model:_ [MacBookPro14,1](https://everymac.com/systems/apple/macbook_pro/specs/macbook-pro-core-i5-2.3-13-mid-2017-retina-display-no-touch-bar-specs.html)

<details>
    <summary>Spoiler: Processor Information</summary>
    
From [Intel Ark](https://ark.intel.com/content/www/us/en/ark/products/95443/intel-core-i5-7200u-processor-3m-cache-up-to-3-10-ghz.html)  
Relevent info: `Device ID, 0x5916`

title                       | description
:---                        | :---
**Essentials**              | 
Product Collection          | 7th Generation Intel® Core™ i5 Processors
Code Name                   | Products formerly Kaby Lake
Vertical Segment            | Mobile
Processor Number            | i5-7200U
Status                      | Launched
Launch Date                 | Q3'16
Lithography                 | 14 nm
Recommended Customer Price  | $281.00  
[]()                            |  
**Performance**                 |
Number of Cores                 | 2
Number of Threads               | 4
Processor Base Frequency        | 2.50 GHz
Max Turbo Frequency             | 3.10 GHz
Cache                           | 3 MB Intel® Smart Cache
Bus Speed                       | 4 GT/s
TDP                             | 15 W
Configurable TDP-up Frequency   | 2.70 GHz
Configurable TDP-up             | 25 W
Configurable TDP-down Frequency | 800 MHz
Configurable TDP-down           | 7.5 W
[]()                            |  
**Supplemental Information**    |
Embedded Options Available      | No
[]()                            |  
**Memory Specifications**       |
Max Memory Size (dependent on memory type) | 32 GB
Memory Types | DDR4-2133, LPDDR3-1866, DDR3L-1600
Max # of Memory Channels | 2
Max Memory Bandwidth | 34.1 GB/s
ECC Memory Supported ‡ | No
[]()                            |  
**Processor Graphics** | 
Processor Graphics ‡ | Intel® HD Graphics 620
Graphics Base Frequency | 300 MHz
Graphics Max Dynamic Frequency | 1.00 GHz
Graphics Video Max Memory | 32 GB
Graphics Output | eDP/DP/HDMI/DVI
4K Support | Yes, at 60Hz
Max Resolution (HDMI 1.4)‡ | 4096x2304@24Hz
Max Resolution (DP)‡ | 4096x2304@60Hz
Max Resolution (eDP - Integrated Flat Panel)‡ | 4096x2304@60Hz
Max Resolution (VGA)‡ | N/A
DirectX* Support | 12
OpenGL* Support | 4.5
Intel® Quick Sync Video | Yes
Intel® Clear Video HD Technology | Yes
Intel® Clear Video Technology | Yes
Number of Displays Supported ‡ | 3
Device ID | 0x5916
[]()                            |  
**Expansion Options** |
PCI Express Revision | 3.0
PCI Express Configurations ‡ | 1x4, 2x2, 1x2+2x1 and 4x1
Max # of PCI Express Lanes | 12
[]()                            |  
**Package Specifications** |
Sockets Supported | FCBGA1356
Max CPU Configuration | 1
TJUNCTION | 100°C
Package Size | 42mm X 24mm
[]()                            |  
**Advanced Technologies** | 
Intel® Optane™ Memory Supported ‡ | Yes
Intel® Speed Shift Technology  | Yes
Intel® Turbo Boost Technology ‡ | 2.0
Intel® vPro™ Platform Eligibility ‡ | No
Intel® Hyper-Threading Technology ‡ | Yes
Intel® Virtualization Technology (VT-x) ‡ | Yes
Intel® Virtualization Technology for Directed I/O (VT-d) ‡ | Yes
Intel® VT-x with Extended Page Tables (EPT) ‡ | Yes
Intel® Transactional Synchronization Extensions | No
Intel® 64 ‡ | Yes
Instruction Set | 64-bit
Instruction Set Extensions | Intel® SSE4.1, Intel® SSE4.2, Intel® AVX2
Idle States | Yes
Enhanced Intel SpeedStep® Technology | Yes
Thermal Monitoring Technologies | Yes
Intel® Flex Memory Access | Yes
Intel® Identity Protection Technology ‡ | Yes
Intel® Stable Image Platform Program (SIPP) | No
Intel® Smart Response Technology | Yes
Intel® My WiFi Technology | Yes
[]()                            |  
**Security & Reliability** | 
Intel® AES New Instructions | Yes
Secure Key | Yes
Intel® Software Guard Extensions (Intel® SGX) | Yes with Intel® ME
Intel® Memory Protection Extensions (Intel® MPX) | Yes
Intel® Trusted Execution Technology ‡ | No
Execute Disable Bit ‡ | Yes
Intel® OS Guard | Yes
Intel® Boot Guard | Yes
[]() | 
‡ This feature may not be available on all computing systems. Please check with the system vendor to determine if your system delivers this feature, or reference the system specifications (motherboard, processor, chipset, power supply, HDD, graphics controller, memory, BIOS, drivers, virtual machine monitor-VMM, platform software, and/or operating system) for feature compatibility. Functionality, performance, and other benefits of this feature may vary depending on system configuration. | 
    
</details>

**Tablet**  
_System:_ Dell Latitude 7275 (T02H001)

## Desktop Resources
[z97s El Capitan](https://www.tonymacx86.com/threads/success-msi-z97s-sli-krait-edition-4690k-evga-gtx-960-el-capitan-clover.175301/)

## Laptop Resources
Some promising WiFi cards for mobile Hackintosh systems:  
- `BCM94352Z`: promising widely-available card with broad community support, requires lots of configuration to get working.  
    Start with [this tonymacx86 thread[(https://www.tonymacx86.com/threads/broadcom-wifi-bluetooth-guide.242423/).
- `BCM94360NG`: originally by "Fenvi", apparently supports WiFi, Bluetooth, AirDrop, and handoff out-of-box.  
    See [this github thread](https://github.com/osy86/HaC-Mini/issues/197), [this reddit thread](https://www.reddit.com/r/hackintosh/comments/fbtak5/is_anybody_using_wifi_adapter_bcm94360ng/), and [this product page](https://www.aliexpress.com/item/4000631796433.html).  
- OEM Apple WiFi card + NGFF adapter: ideal out-of-box support?  
    See [this tonymacx86 thread](https://www.tonymacx86.com/threads/100-working-12-6-pin-apple-wifi-bt-card-to-m-2-ngff-adapter-handoff-unlock-with-watch-uefi.215895/).

Reference System sources:  
[tonymacx86 #1](https://www.tonymacx86.com/threads/guide-dell-inspiron-13-5378-2-in-1-macos-10-12-6.230009/), [tonymacx86 #2](https://www.tonymacx86.com/threads/work-in-progress-installing-sierra-on-dell-inspiron-13-7378-kaby-lake-laptop.213855/), [insanelymac](https://www.insanelymac.com/forum/topic/304408-dell-inspiron-13-7000-2-in-1-model-7347-is-this-hardware-possible/), [redit user](https://www.reddit.com/r/hackintosh/comments/b5v5zm/how_stable_can_a_hackintosh_be/ejipyos/)  
[Promising-Looking Large Guides](https://osxlatitude.com/forums/topic/8506-dell-latitude-inspiron-precision-vostro-xps-clover-guide/?tab=comments#comment-54632)

## External Resources
- [https://www.tonymacx86.com/](https://www.tonymacx86.com/)
- [https://www.insanelymac.com/](https://www.insanelymac.com/)
- [VMware Workstation on Windows](https://www.insanelymac.com/forum/topic/309556-run-vanilla-os-x-el-capitan-sierra-high-sierra-or-mojave-in-vmware-workstation-on-a-windows-host/)

## Commentary
[This Reddit thread](https://www.reddit.com/r/hackintosh/comments/3c2wgy/guide_how_you_should_be_managing_your_hackintosh/) is an outdated but well-written commentary on the benefits of using Vanilla Hackintosh methods (pure Clover + MacOS + opensource extensions) over older closedsource tools like Uni/Multibeast or the Niresh builds. And [this thread](https://www.reddit.com/r/hackintosh/comments/5jl4u7/psa_dont_use_multibeast_and_dont_edit_your_clover/) is a gateway thread.  
[This repo guide](https://github.com/macfanatic77/hackintosh/blob/master/00_Basics%20of%20the%20Vanilla%20Method.md) looks like a good (though maybe already outdated) introduction to the Vanilla Hackintosh method.
