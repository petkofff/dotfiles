# Some Common Settings

## Swap <kbd>Esc</kbd> and <kbd>CapsLock</kbd>

GNOME: dconf-editor > org.gnome.desktop.input-sources.xkb-options > add caps:swapescape
Plasma: System Settings > Input Devices > Advanced > Caps Lock behavior > Swap

## Store docker containers on ~

`vim /etc/systemd/system/docker.service.d/docker.root.conf` and populate with:

```
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -g /home/<username>/.docker-root -H fd://
```

```
systemctl daemon-reload
systemctl restart docker
docker info # verify the root dir has updated
```

## Terminal theme

```
pip3 install --user pywal

# Add local 'pip' to PATH:
export PATH="${PATH}:${HOME}/.local/bin/"
```
