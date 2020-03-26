# Reading EDIDs
Thanks to [Joseph Lawson](https://joekiller.com/2019/04/13/edid-reading-on-arch-linux/) for the tutorial on `edid-decode-git`!

## Install Tools
``` bash
~$ sudo pacman -S git glibc read-edid
~$ git clone https://aur.archlinux.org/edid-decode-git.git
~$ cd edid-decode-git
edid-decode-git$ makepkg -si
edid-decode-git$ cd
```

## Read EDIDs
From [kodi](https://kodi.wiki/view/Creating_and_using_edid.bin_via_xorg.conf):
``` bash
# the integer after -m is the monitor id, starting from zero and incrementing by one.
sudo get-edid -m 0 > edid.bin

# View the output of this command and verify you have the right monitor.
# You can tell via the vendor, resolutions, serial number, all that jazz.
cat edid.bin | edid-decode
```

Output will look something like this:
``` none
EDID version: 1.4
Manufacturer: SHP Model 143d Serial Number 0
Made in week 34 of 2015
Digital display
8 bits per primary color channel
DisplayPort interface
Maximum image size: 28 cm x 16 cm
Gamma: 2.20
Supported color formats: RGB 4:4:4, YCrCb 4:4:4
Default (sRGB) color space is primary color space
First detailed timing includes the native pixel format and preferred refresh rate
Display x,y Chromaticity:
  Red:   0.6396, 0.3291
  Green: 0.2099, 0.7099
  Blue:  0.1494, 0.0595
  White: 0.3125, 0.3281
Established timings supported:
Standard timings supported:
Detailed mode: Clock 533.250 MHz, 276 mm x 156 mm
               3840 3888 3920 4000 hborder 0
               2160 2163 2168 2222 vborder 0
               -hsync -vsync
               VertFreq: 59 Hz, HorFreq: 133312 Hz
Dummy block
ASCII string: HGMJ6
Manufacturer-specified data, tag 0
Checksum: 0x26 (valid)
```

# Resources
I have uploaded to my resources what is supposedly my [Dell Inspiron 7275 4K EDID](/resources/Dell_7275_4K_EDID.bin).
