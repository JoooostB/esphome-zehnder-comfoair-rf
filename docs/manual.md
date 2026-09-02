# Zehnder ComfoAir controller

Bedankt! Je hebt dit gekocht bij een eenmanszaak, niet bij een fabriek; elk board is
met de hand gebouwd en getest. Vragen of iets kapot? Open een issue op GitHub of stuur
me een bericht via Tindie. Joost (JoooostB)

**Eerst dit: plaatsing.** Het radiobereik van deze controller is erg klein. Leg hem
bovenop je Zehnder WTW-unit, zo dicht mogelijk bij het display. Elders in huis haalt
hij de unit vrijwel zeker niet; een radiobeperking, geen defect.

## Welke versie heb je?

- **Preprogrammed kit:** in elkaar gezet en geflasht. Ga direct naar Installatie.
- **Kit:** druk de ESP32 en nRF905 in hun headers, richting zoals op de PCB gedrukt
  (verkeerd om kan ze beschadigen). Flash daarna vanuit Chrome of Edge:
  <https://joooostb.github.io/esphome-zehnder-comfoair-rf/>
- **Kale PCB:** als Kit, plus zelf de headers solderen. Gebruik een 30-pins
  ESP32-devkit (CH340C) en een 868 MHz nRF905-module (geen 433 MHz). Voeding via de
  USB van de ESP32.

## Installatie

1. Leg de controller bovenop de WTW-unit, bij het display.
2. Zet de WTW in koppelstand: trek de stekker van de WTW eruit, wacht 5 seconden en
   steek hem er weer in. De WTW accepteert daarna 10 minuten lang nieuwe verbindingen.
3. Steek de USB-voeding van de controller erin. Hij koppelt binnen een minuut vanzelf
   en slaat de koppeling permanent op.
4. Open de Home Assistant-app, ga naar Instellingen en dan Apparaten en diensten, voeg
   de controller toe via Bluetooth en vul je Wi-Fi in. Geen Bluetooth? Verbind met het
   netwerk `zehnder-comfoair-xxxxxx`, dan opent een installatiepagina.
5. Home Assistant vindt de controller daarna op je netwerk. Voeg hem toe; beveiligen
   gaat automatisch, zonder sleutel.
6. Aangeraden: klik in het ESPHome-dashboard op Adopt, dan komen updates met één klik.
7. Probeer het: zet de ventilatiestand om vanuit Home Assistant.

## Als iets niet werkt

- **De ventilatie reageert niet:** zet de WTW opnieuw in koppelstand (stekker eruit,
  5 seconden, erin), herstart daarna ook de controller, of leg hem dichter bij het display.
- **Geen Bluetooth en geen `zehnder-comfoair`-netwerk:** het Wi-Fi-venster van de
  controller (10 minuten) is dicht. Stekker van de controller eruit en erin.
- **Flashen lukt niet:** Chrome of Edge met een datakabel. Hangt hij op "Connecting",
  houd BOOT ingedrukt bij Install. Geen poort te zien? Installeer de CH340-driver.
- **Andere Home Assistant-installatie?** Eerst Factory reset op de apparaatpagina,
  daarna opnieuw instellen.

Broncode en updates: <https://github.com/JoooostB/esphome-zehnder-comfoair-rf>

<div style="page-break-after: always;"></div>

---

# Zehnder ComfoAir controller (English)

Thank you! You bought this from a one-person workshop, not a factory; every board is
built and tested by hand. Questions or something broken? Open an issue on GitHub or
send me a message on Tindie. Joost (JoooostB)

**Before anything else: placement.** The radio range of this controller is very short.
Place it on top of your Zehnder ventilation unit (WTW), as close to the display panel
as possible. Anywhere else it will most likely not reach; a radio limitation, not a defect.

## Which version do you have?

- **Preprogrammed kit:** assembled and flashed. Skip straight to Setup.
- **Kit:** push the ESP32 and nRF905 into their headers, orientation as printed on
  the PCB (wrong way around can damage them). Then flash from Chrome or Edge:
  <https://joooostb.github.io/esphome-zehnder-comfoair-rf/>
- **Bare PCB:** as Kit, plus you solder the headers yourself. Use a 30 pin ESP32
  devkit (CH340C) and an 868 MHz nRF905 module (not 433 MHz). Power comes in through
  the ESP32's USB.

## Setup

1. Place the controller on top of the ventilation unit, near the display.
2. Put the ventilation unit in pairing mode: pull its mains plug, wait 5 seconds and
   plug it back in. It then accepts new connections for 10 minutes.
3. Plug in the controller's USB power. It pairs by itself within a minute and stores
   the pairing permanently.
4. Open the Home Assistant app, go to Settings, then Devices & services, add the
   controller via Bluetooth and enter your Wi-Fi. No Bluetooth? Join the network
   `zehnder-comfoair-xxxxxx` and a setup page opens.
5. Home Assistant then discovers the controller on your network. Add it; securing
   happens automatically, no key to type.
6. Recommended: click Adopt in the ESPHome dashboard to get updates with one click.
7. Try it: change the fan speed from Home Assistant.

## If something does not work

- **The fan does not respond:** put the ventilation unit in pairing mode again (plug
  out, 5 seconds, plug in), restart the controller too, or move it closer to the display.
- **No Bluetooth and no `zehnder-comfoair` network:** the controller's Wi-Fi window
  (10 minutes) has closed. Unplug and replug the controller.
- **Flashing does not start:** Chrome or Edge with a data cable. Stuck on "Connecting"?
  Hold BOOT while you click Install. No serial port? Install the CH340 driver.
- **Moving to a different Home Assistant installation?** Factory reset on the device
  page first, then set it up again.

Source and updates: <https://github.com/JoooostB/esphome-zehnder-comfoair-rf>
