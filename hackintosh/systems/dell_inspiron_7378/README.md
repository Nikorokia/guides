# Dell Inspiron 7378 Information

## File Explanations
- `SSDT-UIAC.dsl`: raw USB port injection map for `USBInjectAll.kext`
- `SSDT-UIAC.aml`: compiled map, for ACPI patching in bootloader.

## USB Port Layout

USB 3.0 Bus PCI Device ID: `0x9d2f`  
USB 3.0 Bus PCI Vendor ID: `0x8086`  

In Use:  

name    | port            | notes
:---    | :---            | :---
HS01    | <01 00 00 00>   | USB-A Left Side, 2.0
HS03    | <03 00 00 00>   | USB-A Right Side, 2.0
HS04    | <04 00 00 00>   | USB-C, 2.0
HS05    | <05 00 00 00>   | Internal: Integrated HD Webcam
HS06    | <06 00 00 00>   | Internal: Bluetooth from PCIe Wifi port
HS07    | <07 00 00 00>   | Internal: ELAN Touchscreen
HS08    | <08 00 00 00>   | Internal: SD card reader
SS01    | <0d 00 00 00>   | USB-A Left Side, 3.0
SS04    | <10 00 00 00>   | USB-C, 3.0


Unknown/unused: `HS02,HS09,HS10,SS02,SS03,SS05,SS06,USR1,USR2`

Full List (discovered via exclusions):
```
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
