# Upstream code

The external components `components/nrf905` and `components/zehnder` (nRF905 driver and
Zehnder ComfoAir RF protocol) originate from
[Sanderhuisman/ESPHome-Zehnder-RF](https://github.com/Sanderhuisman/ESPHome-Zehnder-RF).
They reached this repository via the fork
[777Hwal/ESPHome-Zehnder-RF](https://github.com/777Hwal/ESPHome-Zehnder-RF), whose changes
are limited to porting to the modern ESPHome fan API plus small radio fixes (RF channel,
SPI setup order, a transmit delay).

Everything else in this repository (the ESPHome template, provisioning setup, CI, flash
page, documentation) is the work of Joost Buskermolen and is licensed under the MIT
license in [LICENSE](LICENSE).
