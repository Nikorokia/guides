# Hackintosh
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
