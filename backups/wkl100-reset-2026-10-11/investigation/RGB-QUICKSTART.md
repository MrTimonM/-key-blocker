# Tested WKL-100 RGB control

USB effect switching was verified by settings readback and the user seeing effect 3 change to effect 11. The test ended with effect 3 restored. The keyboard layout was factory-reset by the user and confirmed normal.

PowerShell commands:

```powershell
python "C:\Users\Mahedi\Documents\K81-USB-Debug\wkl_control.py" rgb-effect 11
python "C:\Users\Mahedi\Documents\K81-USB-Debug\wkl_control.py" rgb-effect 3
python "C:\Users\Mahedi\Documents\K81-USB-Debug\wkl_control.py" restore-rgb
```

Each effect command reads the keyboard's current 128-byte settings block, saves it, changes only settings byte 10, writes that block, then verifies all 128 bytes by reading them back. The backup is replaced before each effect command; restore-rgb restores the state before the latest effect command.

Packet: report 09, opcode 04, header `09 04 00 00 01 00 80 00`, 128 settings bytes and 384 zero bytes. Effect selector: settings offset 10 / report offset 18, both zero based.

Modes 3 and 11 are the two modes observed and tested. The CLI deliberately limits selection to those values until additional modes are verified. Fixed RGB color and brightness fields have not yet been identified.

Hardware remapping: the 8->9 write was accepted, but the reference map shifted other keys. The keyboard's real model/layout is needed before a further map write. Both remap and reference restore are disabled; the reference restore is not a backup of this keyboard's factory map.
