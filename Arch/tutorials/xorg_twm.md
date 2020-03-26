# Xorg and TWM
Wanna get the bare minimum running for some GUI applications on Arch? It doesn't get much more slim than this!

Start by installing Xorg via my former guide---which even comes with TWM, bless its heart!----and then come run some simple commands below!

## After installing Xorg
Let's get Xorg up and running!
``` bash
$ sudo xinit
```

You should now be looking at the barest form of a window in your upper-left screen. If your keyboard and mouse are set correctly, shaking your mouse and positioning it over the new terminal "window" should let you start typing.

- I may have mentioned that my laptop has some difficulty with resolutions. To get it in a readable state, I next ran:
    ``` bash
    xrandr --output eDP1 --mode 1920x1080
    ```
    `xorg-xrandr` can easily be installed with `pacman`, and running a solo `xrandr` in Xorg will present the connected monitors and their capable resolutions.

Try running basic `twm`:
```
$ twm &
```
The "`&`" here is magic: it tells Xorg to launch TWM in the background and then releases the terminal for typing more fun things!

- For me, I got the following error:
    ``` bash
    [root@[mypc] [myuser]]# twm
    twm:  unable to open fontset "-adobe-helvetica-bold-r-normal--*-120-*-*-*-*-*-*"
    ```
    Apparently this is a [fairly common problem](https://ubuntuforums.org/showthread.php?t=1596636)-----at least, for anyone who still works this way.  
    Per the linked suggestion, I fixed it with:
    ``` bash
    $ LANG=C twm &
    ```

That terminal window should now turn into a floating window that you can drag and move around! Fancy!

Want to open another window? If Firefox is installed, try out:
``` bash
$ firefox &
```
Ta-da! Very exciting!

Just don't close (or `exit`) that terminal, it's keeping the X session alive.
