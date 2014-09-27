Task Force Arma 3 radio
=======================

Arma 3 Team Speak Radio Plugin ([documentation](https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki))
_v0.9.1 (05-29-2014)_

#####Not compatible with 0.8.3, compatible with 0.9.0

###Installation

* Download and unzip [0.9.2 radio archive](https://github.com/michail-nikolaev/task-force-arma-3-radio/raw/master/releases/0.9.2.zip).
* Copy `TeamSpeak 3 Client` folder content to the TeamSpeak root folder.
* Copy `Arma 3` folder content to the `...\SteamApps\common\Arma 3 folder`.

> TFAR uses the CBA (Community Base Addons) latest version. Therefore, if you’ve already installed this mod, Windows will prompt you to replace the folder.


###Configuration

* Make sure `Caps Lock` key is not used for talking in TeamSpeak
* Turn off voice over network (VON) in ARMA 3 or change key to different than `Caps Lock` (to avoid voice doubling).
* Open the plugin list in Team Speak: `Settings > Plugins`.
  1. Enable `Task Force Arma 3 Radio`.
  2. Recommended to disable `ACRE` and `radio ts ARMA3.ru` version if they are installed, to avoid conflicts.
  3. Just in case – there is a `Reload All` button at the bottom left to restart all the plugins.
* Make sure the volume of alerts is not turned off in Team Speak: `Options > Payback > Sound Pack Volume` - set a positive value.
* Start the game with `@CBA_A3` & `@task_force_radio` add-ons (Community Base Addons: A3 Beta & Task Force Arrowhead Radio). It can be done by adding the mod names to the game shortcut after the EXE file `…\arma3.exe -mod=@CBA_A3;@task_force_radio`, however, it is recommended to enable the necessary mods in the game settings (`Settings -> Expansions`).
* Join the same channel with other players using the radio, or you will be navigated to the `TaskForceRadio` channel, if there is one at the start of a mission.

> If you’ve got the same nick both in the game profile and TeamSpeak - plugin will change your nickname in TS during the game.

> Make sure your game nickname contains at least 3 characters and doesn't contain `@`.

> It is not recommended to use the plugin with simultaneous connection to multiple servers in TeamSpeak.

> It is recommended to disable the TeamSpeak built-in alert sounds: `Options> Notifications> Sound Pack: "Sounds Deactivated"`. To use this option, restart TeamSpeak.


###Usage

| Keys | Action |
| --- | --- |
| Push-to-talk button in TeamSpeak | Direct Speech. |
| `Caps Lock` | To talk on a radio. |
| `CTRL`&nbsp;+&nbsp;`Caps Lock` | To talk on a long range radio. |
| `CTRL`&nbsp;+&nbsp;`P` | To open the personal radio interface (the radio must be in the inventory slot). In that case if you have a number of radios - you can select the one needed. It is also possible to set the radio as active (the one that will be used for transmission). Also it is possible to load radio settings from another radio with same encryption code. |
| `CTRL`&nbsp;+&nbsp;+&nbsp;`[/]` | Cycle through available shortwave radios. | 
| `CTRL`&nbsp;+&nbsp;`Up/Left/Right Arrow` | Rapid switching of shortwave stereo mode. |
| `NUM[1-8]` | Rapid switching of shortwave radio channels. | 
| `ALT`&nbsp;+&nbsp;`P` | To open a long range radio interface (a long range radio must be put on your back, or you should be in a vehicle in a position of a driver, shooter, or pilot assistant). If a number of radios are available – you’ll be offered to choose one. Besides, one of them can be set as active. Also it is possible to load radio settings from another radio with same encryption code. |
| `CTRL`&nbsp;+&nbsp;`ALT`&nbsp;+&nbsp;`[/]` | Cycle through available long range radios. | 
| `ALT`&nbsp;+&nbsp;`Up/Left/Right Arrow` | Rapid switching of long range stereo mode. |
| `CTRL`&nbsp;+&nbsp;`NUM[1-9]` | Rapid switching of long range radio channels. |
| `CTRL`&nbsp;+&nbsp;`TAB` | To change the direct speech volume. You can talk: Whispering, Normal or Yelling. Does not affect the signal volume in the radio transmission. |
| `SHIFT`&nbsp;+&nbsp;`P` | To open an underwater transceiver interface (you should be wearing a rebreather). | 
| `CTRL`&nbsp;+&nbsp;`~` | To talk on underwater transceiver. |
| `CTRL`&nbsp;+&nbsp;`]`| Select next personal radio. |
| `CTRL`&nbsp;+&nbsp;`[`| Select previous personal radio. |
| `CTRL`&nbsp;+&nbsp;`ALT`&nbsp;+&nbsp;`]`| Select next long range radio. |
| `CTRL`&nbsp;+&nbsp;`ALT`&nbsp;+&nbsp;`[`| Select previous long range radio. |
| `CTRL`&nbsp;+&nbsp;`[←,↑,→]`| Change personal radio stereo mode. |
| `ALT`&nbsp;+&nbsp;`[←,↑,→]`| Change long range radio stereo mode. |
| `T` | Transmit on additional channel of personal radio. |
| `Y` | Transmit on additional channel of long range radio. |
| `ESC` | To exit from the radio interface. |

> You can reconfigure the keys in the configuration file, which can be found in the game folder `...\Arma 3\userconfig\task_force_radio\radio_keys.hpp`. The file is edited in Notepad.

###Information

#####Radios

| Radio | Side | Range/Distance | How to use |
| --- | --- | --- | --- | 
| Radio [AN/PRC-152](http://en.wikipedia.org/wiki/AN/PRC-152) (personal) | <font color="blue">BLUEFOR<font> | 30-512Mhz / 5 km | To enter the frequency, press `CLR`, enter a value and press `ENT`. You can also switch the active radio channel by pressing the arrow keys (a total of 8 channels). You can change the reception volume pressing `PRE+` and `PRE-` keys. You can also change stereo setting by pressing `0`. Use switch at top of radio to setup additional channel. |
| Рация [RF-7800S-TR](http://rf.harris.com/capabilities/tactical-radios-networking/rf-7800s-tr.asp) (rifleman) | <font color="blue">BLUEFOR<font> | 30-512Mhz / 2 км | Frequency setup not supported on this radio, You can switch the active radio channel by pressing keys at the bottom (a total of 8 channels). You can change the reception volume pressing `VOL` keys. You can also change stereo setting by pressing `OK`.  | 
| Radio [RT-1523G (ASIP)](http://en.wikipedia.org/wiki/SINCGARS#Models) (long range) | <font color="blue">BLUEFOR<font> | 30-87Mhz / 20 km (30 for inbuilt) | To enter the frequency, press `MENU CLR`, enter a value and press `FREQ`. You can also switch the active radio channel by pressing the radio number buttons (a total of 9 channels). You can change the reception volume by `TIME` and `BATT CALL` keys. You can also change stereo setting by pressing `STO`. Use `ERF OFST` to setup additional channel.|
| Radio [AN/PRC-154](http://www.gdc4s.com/anprc-154a-rifleman-radio.html) (rifleman) | <font color="blue">BLUEFOR<font> | 30-512Mhz / 2 km |  Frequency setup not supported on this radio, You can switch the active radio channel by pressing keys `PRE FILL` and `PRE DIVE` (a total of 8 channels). You can change the reception volume pressing volume keys. You can also change stereo setting by pressing `STAT`. It is possible to select first channel by pressing `ZERO`. |
| Radio [AN/PRC148-JEM](https://www.thalescomminc.com/ground/anprc148-jem.asp) (personal) | <font color="green">INDEPENDENT</font> | 30-512Mhz / 5 km | To enter the frequency, press `ESC`, enter a value and press `ENT`. You can also switch the active radio channel by pressing the arrow keys (a total of 8 channels). You can change the reception volume by `MOD` and `GR` keys. You can also change stereo setting by pressing `ALT`. Use switch at top of radio to setup additional channel. | 
| Radio [AN/PRC-155](http://www.gdc4s.com/anprc-155-2-channel-manpack.html) (long range)| <font color="green">INDEPENDENT</font> | 30-87Mhz / 20 km (30 for inbuilt) | To enter the frequency, press `ESC`, enter a value and press `MENU`. You can also switch the active radio channel by pressing the arrow keys (up & down). You can change the reception volume by the loudspeaker button. You can also change stereo setting by pressing `PRE`. Use sun button to setup additional channel.| 
| Radio [FADAK](http://www.military.com/video/forces/military-foreign-forces/iran-unveils-3-new-military-products/2363087176001/) (personal) | <font color="red">OPFOR</font> | 30-512Mhz / 5 km | To enter the frequency, press `CLR`, enter a value and press `ENT`. You can also switch the active radio channel by pressing `SET` and `PWR` (a total of 8 channels). You can change the reception volume by `DATA` and `SEND` keys. You can also change stereo setting by pressing `0`. Use `ERF OFST` to setup additional channel.|
| Radio [PNR-1000A](http://elbitsystems.com/Elbitmain/files/Tadiran%2520PNR1000A_2012.pdf)  (rifleman) | <font color="blue">BLUEFOR<font> | 30-512Mhz / 2 km |  Frequency setup not supported on this radio, You can switch the active radio channel by pressing `CHAN` keys (a total of 8 channels). You can change the reception volume pressing `VOL` keys. You can also change stereo setting by pressing `MENU ENTR`. It is possible to select first channel by pressing button at the top. |
| Radio [MR3000](http://www.railce.com/cw/casc/rohde/m3tr.htm) (long range) | <font color="red">OPFOR</font> | 30-87Mhz / 20 km (30 for inbuilt) | To enter the frequency, press `CLR ESC`, enter a value and press `ENT`. You can also switch the active radio channel by pressing the radio number buttons or horizontal arrow buttons (a total of 8 channels). You can change the reception volume by vertical arrow buttons. You can also change stereo setting by pressing `0`. Use `RX/TX` switch to setup additional channel.| 
| Underwater transceiver | All | 32-41kHz / 70-300 m. (depending on waves) | To enter the frequency, press `MODE`, enter a value and press `ADV`. You can change the reception volume by the button on the right side of the device. | 

> Not all radios presented here, also next airborne 40km radios are supported : "AN/ARC-201", "AN-ARC-164", "MR6000L"

> Personal and long range radios of one faction support a single protocol, therefore they can communicate with each other. If the transmission is carried out from the personal one – the sound will be high-frequency. In the case of long range transmission – it’ll be low-frequency.

> Radio propagation is affected by terrain. Worst case - if you right behind the steep hill. If you go from hill edge into direction from transmitter you will get better signal propagation. Best case - line of sight.

> Personal and long range radios support transmitting and receiving on two channels simultaneously. By pressing "Setup additional channel" switch on radio current channel will be marked as additional. After switching to another channel you will hear both - active and additional channels. It is possible to setup different stereo modes for active and additional channels. Use 'T' to transmit on additional channel of personal radio, 'Y' - for long range radio.

#####Radios distribution
* By default, a long range radio is given to squad leaders. If a player is wearing a backpack – he will automatically put it on the ground.

* A short range radio is given to players who have `ItemRadio` in the inventory. Radio distribution may take a few seconds (follow messages in the center of the screen).

#####Vehicles
* A long range radio is available for a driver, commander, shooter, and pilot assistant. Not all the vehicles support built-in radios.

* Each vehicle slot has its own radio, which must be configured separately. If you plan to change the position in a vehicle – configure the radio in all the slots beforehand (for instance, on a driver or shooter slot).

* Vehicles are classified into open and closed (isolated). If you are in an isolated vehicle, you will not hear voices from outside (and vice versa). However, if you turn out of the vehicle, you will hear voices both from inside and outside.

#####Radio interception

* Radio can be taken from killed players, and given to each other. Thus, they retain all the settings (channels, frequency, volume).

> It is recommended to take radios opening the inventory at the place where it is (so that it is not lost because of the game bugs).

* In vehicles radio settings are also saved.
* By default, radios of each faction use their own encryption codes, so you will not hear enemy talks, even setting the enemy’s frequency. To listen to the enemy’s net (and talk on the air) - it’s necessary by any means to capture an enemy radio station. 

> To listen to an enemy’s long range radio (backpack) it is recommended to be in your own vehicle. In this case, you will be able to listen to the enemy’s net using a backpack and transmit broadcast to your allies using the radio in the vehicle as the active one.

#####Divers
* You can not talk underwater (even wearing a diving suit). However, at close distance your companion can hear some indistinct speech (exception - if you are underwater in an isolated vehicle).
* Being underwater, you can faintly hear muffled voices on land.
* Use an underwater transceiver for communication among divers.
* You can not use radio communication underwater (neither to talk nor to hear). If you want to pass some message on land - surface. Exception - submarine in the periscope depth (divers can use a long range radio there).

#####Plugin operation modes
The plugin supports two operation modes - **serious** and **lightweight modes**.

* **Lightweight mode** — is a default mode. It is designed mainly for cooperative games. Its special feature is that using the plugin players can hear the dead, users not playing, users playing on a different server and users playing without the plugin avoiding the radio (just like with TeamSpeak). This makes games against people less convenient, but allows your friend to easily find out where you play, what's your frequency, etc. Naturally, those who play on the same server with activated addons and plugins will hear each other according to "radio laws": taking into account the radio frequency and distance.

* **Serious mode** — designed for games, where players act against other players. To enable it, you need to create a TeamSpeak channel called `TaskForceRadio` (password – `123`). Players must enable the radio plugin, go to the server and plan the mission joining parties’ channels. At the start of the mission in a few seconds players will be directed to `TaskForceRadio` channel. In this case, players will hear only live players with the enabled plugin playing on the same server. Dead players, in turn, can communicate with each other. In case of a dead player respawn - he will hear only live players again. After the game ends, the players are transferred to the channel used for planning before the mission start.

#####Solving problems
* `Pipe error 230` - most likely you’ve forgot to enable the plugin in TeamSpeak.
* In TS the plugin is red and not loaded - most likely you will have to update TeamSpeak.
* Try to reaload plugin.
* `Caps Lock` actions aren’t working - perhaps because of gaming keyboards, where `Caps Lock` code is different. Try to change the active keys (by editing the `userconfig`).
* If due to an error or something else you cannot hear other players any more, even outside the game, open `Setup 3D Sound` in TeamSpeak and click `Center All`.
* To eliminate possible errors with the plugin, developers may need the TeamSpeak log. To copy it, select `Tools -> Client Log`, select all the checkboxes above and, selecting all the text by `CTRL A`, copy it to the clipboard.
* If TeamSpeak stops working (Heaven forbid!) using the plugin - it shows a window with a description where you can find a dump (the path to the file). I would be very grateful to receive this file.

#####To TeamSpeak servers admins
To be on the safe side, reduce the level of flood protection: `Right-click on the server> Edit Virtual Server> More> Anti Flood`, set 30, 300, 3000 values (top to bottom).


#####To Developers
If this implementation ever becomes popular, it’d be great to avoid piles of incompatible forks. For this reason, if you’d like to contribute to the project, contact me - it is very likely that your implementations will be merged to the main branch. Looking forward to your Pull Requests :)

#####Many Thanks to
* [Task Force Arrowhead](http://forum.task-force.ru/) squad for testing, support, patience and all the help.
* [MTF](http://forum.task-force.ru/index.php?action=profile;u=7) ([varzin](https://github.com/varzin)) for the help with graphics and documentation.
* [Hardckor ](http://forum.task-force.ru/index.php?action=profile;u=14) for the help with graphics.
* [Shogun](http://forum.task-force.ru/index.php?action=profile;u=13) for the help with graphics.
* [Blender](http://arma3.ru/forums/index.php/user/41-blender/) for the fonts.
* [vinniefalco](https://github.com/vinniefalco) for [DSP Filter](https://github.com/vinniefalco/DSPFilters).
* [WOG](http://wogames.info/) and [TRUE](http://wogames.info/profile/TRUE/) personally for the help in testing.
* [Music DSP Collection](https://github.com/music-dsp-collection) for the compressor.
* [Avi](http://arma3.ru/forums/index.php/user/715-avi/) for the code review.
* [andrey-zakharov](https://github.com/andrey-zakharov) ([Vaulter](http://arma3.ru/forums/index.php/user/1328-vaulter/)) for the help in development.
* Dina for translating.
* [Zealot](http://forums.bistudio.com/member.php?125460-zealot111) for the help in development and useful scripts.
* [NouberNou](http://forums.bistudio.com/member.php?56560-NouberNou) for advice and competition.
* [Megagoth1702](http://forums.unitedoperations.net/index.php/user/2271-megagoth1702/) for its old job of emulating the radio sound.
* [Naught](http://forums.unitedoperations.net/index.php/user/6555-naught/) for code review.
* [Andy230](http://forums.bistudio.com/member.php?100692-Andy230) for translating.
* [L-H](http://forums.bistudio.com/member.php?87524-LordHeart) for code changes.
* [NorX_Aengell](http://forums.bistudio.com/member.php?99450-NorX_Aengell) for French translation.
* [lukrop](http://forums.bistudio.com/member.php?78022-lukrop) for code changes.
* [nikolauska](http://forums.bistudio.com/member.php?75014-nikolauska) ([GitHub](https://github.com/nikolauska)) for sqf code improvements.
* [Kavinsky](https://github.com/kavinsky) for AN/PRC-154 and RF-7800S-TR and other radios.
* [JonBons](http://forums.bistudio.com/member.php?81374-JonBons) for code changes.
* [ramius86](https://github.com/ramius86) for Italian translation.
* KK for [tutorials](http://killzonekid.com/arma-scripting-tutorials-float-to-string-position-to-string/)
* [Krypto202](http://www.armaholic.com/users.php?m=details&id=45906&u=kripto202) for sounds.
* [pastor399](http://forums.bistudio.com/member.php?128853-pastor399) for backpacks model and textures.
* [J0nes](http://forums.bistudio.com/member.php?96513-J0nes) for help with models.
* [Raspu86](http://forums.bistudio.com/member.php?132083-Raspu86) for backpacks models.
* [Gandi](http://forums.bistudio.com/member.php?111588-Gandi) for textures
* [Pixinger] (https://github.com/Pixinger) for help with Zeus.
* [whoozle] (https://github.com/whoozle) for sound engine and help.
* Everyone user (especially who report bugs).
* Sorry guys if I’ve forgot someone by chance.