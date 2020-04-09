# Useful Terminal Commands

### Mounting EFI Partition
Mount EFI partition (assuming only one currently on system):
```
sudo diskutil mount EFI
```
And unmount with (automatic on reboot):
```
sudo diskutil umount EFI
```

### macOS bootlog
Get the most recent [bootlog](https://www.tonymacx86.com/threads/where-can-i-find-clover-boot-logs.238039/), saved in a text file:
```
bdmesg > ~/Desktop/bootlog.txt
```
