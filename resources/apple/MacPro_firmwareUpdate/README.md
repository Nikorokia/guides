I recently had to flash a **Mac Pro (Early 2009)** from `4,1` to `5,1`. These were the necessary files.

A copy of the procedure may be in the Wiki. [Original guide](https://www.ifixit.com/Guide/How+to+Upgrade+the+Firmware+of+a+2009+Mac+Pro+41/98985).

The firmware tool is from the [original forum post](http://forum.netkas.org/index.php/topic,852.0.html) detailing the initial procedure.

The Mac Pro firmware is from [Apple's website](https://support.apple.com/kb/dl1321?locale=en_US).

Both are archived here for posterity.

**Basic Procedure Overview:**

The firmware file must be mounted for the firmware tool to find and apply it. SIP must first be disabled in recovery (reboot while holding `CMD`+`R`) from Terminal using `csrutil disable`.

After disabling SIP and running the tool, flash the firmware by fully shutting down, then holding the Mac Pro power button until the indicator light flashes rapidly or a monotone sounds.

After successfully flashing, reenable SIP in recovery with `csrutil enable`.

**Benefits**

`MacPro4,1` only supports up to El Capitan. However, it has most of the same internals as `MacPro5,1`, which supports up to Mojave. This will probably all be entirely obsolete in 5 years.
