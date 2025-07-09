## Installation
> [!IMPORTANT]
> Do no install blindly! This is a personal repo which may not work on your computer, read before.

#### Works on: 
* Fedora 42
  
### Install Script
```bash
sh ~/.config/sway/install-programs.sh
```

### Setup vnc
> [!CAUTION]
> WIP
```
sudo dnf install tigervnc-server
vncpasswd
mkdir ~/.vnc/

echo -e '#!/bin/sh\n\nxrdb $HOME/.Xresources\nxsetroot -solid grey\n#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &\n#x-window-manager &\n#Fix to make GNOME work\nexport XKL_XMODMAP_DISABLE=1\n#/etc/X11/Xsession\ni3 &' > ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup

sudo bash -c 'echo -e "[Unit]\nDescription=remote desktop service (vnc)\nAfter=syslog.target network.target\n\n[Service]\nType=forking\nUser=rodhfr\n\n# Clean any existing files in /tmp/.x11-unix environment\nExecStartPre=/bin/sh -c \"/usr/bin/vncserver -kill %i > /dev/null 2>&1 || :\"\nExecStart=/usr/bin/vncserver -geometry 1920x1080 -depth 16 -dpi 120 -alwaysshared -localhost %i\nExecStop=/usr/bin/vncserver -kill %i\n\n[Install]\nWantedBy=multi-user.target" > /etc/systemd/system/vncserver@:1.service'

sudo systemctl daemon-reload
sudo systemctl enable vncserver@:1.service
```

### Setup Snapcast
> [!WARNING]
> WIP
 * there is a [copr repo](https://copr.fedorainfracloud.org/coprs/jwillikers/snapcast) there is also a was the second one in google search
 * there is a [pipewire module](https://docs.pipewire.org/page_module_snapcast_discover.html) that does everything  
 * this repo already have user config for the pipewire module

