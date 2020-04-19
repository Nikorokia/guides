// SSDT-UIAC.dsl USB port configuration for Dell Inspiron 13 7378
//     Configured by Nikorokia
//     Original by RehabMan
//
// Change the UsbConnector or portType as needed to match your
// actual USB configuration.
//
// Note:
// portType=0 seems to indicate normal external USB2 port (as seen in MacBookPro8,1)
// portType=2 seems to indicate "internal device" (as seen in MacBookPro8,1)
// portType=4 is used by MacBookPro8,3 (reason/purpose unknown)
//

DefinitionBlock ("SSDT-UIAC.aml", "SSDT", 2, "hack", "_UIAC", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            "8086_9d2f", Package()  // examples: 0x9d2f, 0x9ded
            {
                "port-count", Buffer() { 18, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package() // USB-A Left Side, 2.0
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS03", Package() // USB-A Right Side, 2.0
                    {
                        "UsbConnector", 0,
                        "port", Buffer() { 3, 0, 0, 0 },
                    },
                    "HS04", Package() // USB-C, 2.0
                    {
                        "UsbConnector", 9,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS05", Package() // Internal: Integrated HD Webcam
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HS06", Package() // Internal: Bluetooth from PCIe Wifi port
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 6, 0, 0, 0 },
                    },
                    "HS07", Package() // Internal: ELAN Touchscreen
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "HS08", Package() // Internal: SD card reader
                    {
                        "UsbConnector", 255,
                        "port", Buffer() { 8, 0, 0, 0 },
                    },
                    "SS01", Package() // USB-A Left Side, 3.0
                    {
                        "UsbConnector", 3,
                        "port", Buffer() { 13, 0, 0, 0 },
                    },
                    "SS04", Package() // USB-C, 3.0
                    {
                        "UsbConnector", 9,
                        "port", Buffer() { 16, 0, 0, 0 },
                    },
                },
            },
        })
    }
}
//EOF
