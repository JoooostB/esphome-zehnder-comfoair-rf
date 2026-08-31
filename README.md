# Zehnder ComfoAir RF controller for Home Assistant

Control a Zehnder ComfoAir ventilation unit (RF / nRF905 remote versions) from Home
Assistant. ESP32 + nRF905 on a custom PCB, running ESPHome.

- No YAML, no toolchain: plug in, add via the Home Assistant app, done.
- Discovered automatically by Home Assistant; adopt in the ESPHome dashboard for updates.
- Speed 1/2/3, timed boost (10/30/120 min), wall-remote changes reflected in HA.
- Local only. No cloud, no account.

Hardware: https://www.tindie.com/products/joooostb/zehnder-comfoair-home-assistant-controller/

## Set up (preprogrammed board)

**Placement matters:** the nRF905 radio range is very short. Place the board on top of
your Zehnder ventilation unit, as close to its display panel as possible. Elsewhere in
the house it will likely not reach the unit.

1. Power the board. Wait 10 seconds.
2. Open the Home Assistant app → Settings → Devices & services. The board appears as
   **Zehnder ComfoAir**. Tap it and enter your Wi-Fi.
   No Bluetooth? Join the Wi-Fi network `zehnder-comfoair-xxxxxx` from your phone; a
   setup page opens.
3. Home Assistant shows "New device discovered". Add it.
4. Optional but recommended: in the ESPHome dashboard, click **Adopt** on the discovered
   device. You'll get updates from this repository with one click.

The setup window closes 10 minutes after power-on. Power-cycle to reopen it.

## Flash it yourself (kit / DIY)

Chrome or Edge, USB cable: https://joooostb.github.io/esphome-zehnder-comfoair-rf/

Wi-Fi setup happens in the same browser session.

## Reset

Home Assistant → device page → **Factory reset** button. Wi-Fi and API key are erased;
the device returns to setup mode.

## Pinout (DIY builds)

| Signal | GPIO |
|---|---|
| SPI CLK | 14 |
| SPI MOSI | 13 |
| SPI MISO | 12 |
| nRF905 CS | 15 |
| nRF905 CD | 33 |
| nRF905 CE | 27 |
| nRF905 PWR | 26 |
| nRF905 TXEN | 25 |

## Development

`dev.yaml` builds the same firmware from the local `components/` directory with your own
Wi-Fi from `secrets.yaml`. The release template `zehnder-comfoair-rf.yaml` must never
contain secrets or house-specific values; CI rejects it if it does.

Release: bump `project_version` in the template, tag `vX.Y.Z`, push. CI builds, publishes
the flash page, and attaches the firmware to a GitHub Release.

## Credits

nRF905 and Zehnder RF protocol implementation from
[Sanderhuisman/ESPHome-Zehnder-RF](https://github.com/Sanderhuisman/ESPHome-Zehnder-RF)
via [777Hwal](https://github.com/777Hwal/ESPHome-Zehnder-RF); provenance details in
LICENSE-UPSTREAM.md. Own work is MIT licensed (see LICENSE).
