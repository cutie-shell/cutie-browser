# Cutie Browser
The default brower for Cutie UI.

## Building and installing

```
qmake
make
sudo make install
```

## Running

After installation the app will show up in the shell's launcher. You may need to refresh the launcher by pulling down from the middle of the launcher.

## Troubleshooting

If you are on Droidian, you will have to add the following line to your apt sources:

```
deb droidian-libhybris.repo.droidian.org/bullseye-glvnd/ bullseye main
```

After adding the line, run `sudo apt update && sudo apt upgrade` and reboot your device.