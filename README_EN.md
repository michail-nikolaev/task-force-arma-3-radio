Task Force Arma 3 Radio
=======================
A [TeamSpeak](http://www.teamspeak.com/) radio plugin for Arma 3.
####[Documentation](https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki)&nbsp;&nbsp;&nbsp;&nbsp;[![](http://img.shields.io/badge/Version-0.9.7 from 26.10.2014-blue.svg?style=flat)](https://github.com/michail-nikolaev/task-force-arma-3-radio/releases)&nbsp;[![](http://img.shields.io/badge/License-APL--SA-red.svg?style=flat)](https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/LICENSE.md)

##Please support us on [Make Arma Not War](http://makearmanotwar.com/entry/pMP8c7vSS4#.VA1em_nV9UD)

###Installation
* Download and unzip the [0.9.7 radio archive](https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7/0.9.7.zip).
* Copy the contents of `TeamSpeak 3 Client` folder into the root folder of TeamSpeak.
* Copy the contents of `Arma 3` folder into your `...\SteamApps\common\Arma 3 folder`.

> [TFAR](http://radio.task-force.ru/en/) uses the latest version of [СBA](http://www.armaholic.com/page.php?id=18767) (Community Base Addons). Therefore, if you already have this mod installed, Windows will prompt you to overwrite its folder.

###Configuration
* Make sure `Caps Lock` key is not used for talking in TeamSpeak.
* Turn off voice over network (VON) in game, or change its assgined key to something other than `Caps Lock` (to avoid voice doubling).
* Open the plugin list in TeamSpeak: `Settings > Plugins`.
  1. Enable `Task Force Arma 3 Radio`.
  2. Disable `ACRE` and `radio ts ARMA3.ru` plugins, if they are installed, to avoid conflicts.
  3. Just in case – there is a `Reload All` button at the bottom left to restart all the plugins.
* Make sure the volume of alerts is not turned off in TeamSpeak: `Options > Payback > Sound Pack Volume` - set a positive value.
* Start the game with `@CBA_A3` & `@task_force_radio` add-ons (Community Base Addons: A3 Beta & Task Force Arrowhead Radio). It can be done by adding the associated mod names to your game shortcut, right after the EXE file `…\arma3.exe -mod=@CBA_A3;@task_force_radio`, though, it's always more preferable to configure mods from within game (`Settings -> Expansions`).
* Join the same channel with other players using the radio, or you will be navigated to the `TaskForceRadio` channel, if there is one at the start of a mission.

> You will get the same nick both in the game profile and TeamSpeak - plugin will change your nickname in TS during the game.

> Make sure your game nickname contains at least 3 characters.

> We do not recommend using the plugin with simultaneous connections to multiple TeamSpeak servers.

> We recommend disabling the preconfigured alert sounds used by TeamSpeak: `Options> Notifications> Sound Pack: "Sounds Deactivated"`. To apply this change, make sure to restart TeamSpeak afterwards.

###Controls
| Keys | Action |
| :--- | :--- |
| Push&#8288;-&#8288;to&#8288;-&#8288;talk&nbsp;hotkey&nbsp;in&nbsp;TS&nbsp;&nbsp;&nbsp; | Direct Speech. |
| `Caps Lock` | To talk on a radio. |
| `CTRL` + `Caps Lock` | To talk on a long range radio. |
| `CTRL` + `P` | To open the handheld radio interface (the radio must be in the inventory slot). In that case, if you have a number of radios - you can select the one needed. It is also possible to set the radio as active (the one that will be used for transmission). Also it is possible to load radio settings from another radio with same encryption code. |
| `NUM[1-8]` | Rapid switching of shortwave radio channels. | 
| `ALT` + `P` | Opens the long range radio interface - for this action to work, you either have to have long range radio on you, or you have to be in a vehicle as a driver, gunner, or co-pilot. If a number of radios are available – you’ll be asked to choose one. Also, one of them can be set as active. Furthermore, it is possible to load radio settings from another radio with same encryption code. |
| `CTRL` + `NUM[1-9]` | Rapid switching of long range radio channels. |
| `CTRL` + `TAB` | To change the direct speech volume. You can talk: Whispering, Normal or Yelling. Does not affect the signal volume in the radio transmission. |
| `SHIFT` + `P` | To open an underwater transceiver interface (you should be wearing a rebreather). | 
| `CTRL` + `~` | To talk on underwater transceiver. |
| `CTRL` + `]`| Select next handheld radio. |
| `CTRL` + `[`| Select previous handheld radio. |
| `CTRL` + `ALT` + `]`| Select next long range radio. |
| `CTRL` + `ALT` + `[`| Select previous long range radio. |
| `CTRL` + `[←,↑,→]`| Change the stereo mode of handheld radio. |
| `ALT` + `[←,↑,→]`| Change the stereo mode of long range radio. |
| `T` | Transmit on additional channel of handheld radio. |
| `Y` | Transmit on additional channel of long range radio. |
| `ESC` | To exit from the radio interface. |

###Radios
| Radio | Side | Range/Distance | 
| :--- | :--- | :--- |
| :radio: [AN/PRC-152](http://en.wikipedia.org/wiki/AN/PRC-152) (handheld) | <span style="color:blue">BLUFOR</span> | 30-512Mhz / 5 km |
| :radio: [RF-7800S-TR](http://rf.harris.com/capabilities/tactical-radios-networking/rf-7800s-tr.asp) (handheld) | <span style="color:blue">BLUFOR</span> | 30-512Mhz / 2 km |
| :radio: [RT-1523G (ASIP)](http://en.wikipedia.org/wiki/SINCGARS#Models) (long range) | <span style="color:blue">BLUFOR</span> | 30-87Mhz / 20 km<br />(30 km for [vehicle-mounted](http://en.wikipedia.org/wiki/Mobile_radio)) |
| :radio: [AN/ARC-210](http://www.rockwellcollins.com/~/media/Files/Unsecure/Products/Product%20Brochures/Communcation%20and%20Networks/Communication%20Radios/ARC-210%20Integrated%20Comm%20Systems%20white%20paper.aspx) (airborne) | <span style="color:blue">BLUFOR</span> | 30-87Mhz / 40 km |
| :radio: [AN/PRC148-JEM](https://www.thalescomminc.com/ground/anprc148-jem.asp) (handheld) | <span style="color:green">Independent</span> | 30-512Mhz / 5 km |
| :radio: [AN/PRC-154](http://www.gdc4s.com/anprc-154a-rifleman-radio.html) (handheld) | <span style="color:green">Independent</span> | 30-512Mhz / 2 km |
| :radio: [AN/PRC-155](http://www.gdc4s.com/anprc-155-2-channel-manpack.html) (long range)| <span style="color:green">Independent</span> | 30-87Mhz / 20 km<br />(30 km for vehicle-mounted) |
| :radio: [AN/ARC-164](https://en.wikipedia.org/wiki/AN/ARC-164) (airborne) |  <span style="color:green">Independent</span> | 30-87Mhz / 40 km |
| :radio: [FADAK](http://www.military.com/video/forces/military-foreign-forces/iran-unveils-3-new-military-products/2363087176001/) (handheld) | <span style="color:red">OPFOR</span> | 30-512Mhz / 5 km | 
| :radio: [PNR-1000A](http://elbitsystems.com/Elbitmain/files/Tadiran%2520PNR1000A_2012.pdf)  (handheld) | <span style="color:red">OPFOR</span> | 30-512Mhz / 2 km | 
| :radio: [MR3000](http://www.railce.com/cw/casc/rohde/m3tr.htm) (long range) | <span style="color:red">OPFOR</span> | 30-87Mhz / 20 km<br />(30 km for vehicle-mounted) | 
| :radio: [MR6000L](http://www.rohde-schwarz.com/en/product/mr6000l-productstartpage_63493-9143.html) (airborne) | <span style="color:red">OPFOR</span> | 30-87Mhz / 40 km | 
| :radio: Underwater transceiver | All | 32-41kHz / 70-300 m<br />(depending on waves) |

> Handheld and long range radios of one faction support a single protocol, therefore they can communicate with each other. If the transmission is carried out from the handheld radio – the sound will be high-frequency. In the case of long range transmission – it will be low-frequency.

> Radio propagation is affected by terrain. Worst case scenario - you are at the edge of a steep hill. If you start moving away from the hill's edge, in direction opposite the transmitting player, you will start getting better signal reception. Best case scenario - a direct line of sight to the transmitter.

> Handheld and long range radios support transmitting and receiving on two channels simultaneously. Pressing the "Setup additional channel" switch will mark the currently selected radio channel as additional. After switching to another channel you will hear both - active and additional channels.

####Distribution
* By default, a long range radio is given to squad leaders. If a player is wearing a backpack – he will automatically put it on the ground.

* A short range radio is given to players who have `ItemRadio` in their inventory. At mission start, distribution of radios may take a few seconds to complete (follow the instructions appearing at the center of your screen).

####In vehicles
* A long range radio is available to driver, commander, gunner, and co-pilot. Not all vehicles support mounted radios.

* Every vehicle slot has its own radio, which has to be configured separately. If you plan to switch seats in a vehicle – configure the radio for each seat beforehand (e.g., at the driver and gunner positions).

* Vehicles are classified into open and closed (isolated) types. If you are in an isolated vehicle, you will barely hear any voices from the outside (and vice versa). However, when turned out, you will be able to hear voices from both, inside and outside of your vehicle.

####Interception
* Radios can be picked up from dead players, and exchanged between players. In doing so, they retain all their settings (channels, frequency, volume).

> To bypass the well-known game bug with disappearing world items and pick up a radio safely, we recommend you do so through the inventory screen while standing directly over its position on the ground.

* Radio settings configured for vehicles are saved as well.
* By default, radios of each faction use unique encryption codes, so you would not be able hear enemy chatter, even by switching to a known enemy frequency. To intercept enemy communication (and be able to talk on their frequency) - first you have to capture an enemy radiotower, by any means available. 

> To listen to your enemy’s long range radio (backpack) it is preferable to remain inside your own vehicle. This way, you'd be able to listen to the comms of your enemy using backpack, while at the same time being able to broadcast to your allies using the vehicle radio as the active one.

####Divers
* You can not talk underwater (even while wearing a diving suit). However, at close distance your companion can hear some indistinct speech (exception - if you are underwater in an isolated vehicle).
* Being underwater, you can faintly hear muffled voices on land.
* Use an underwater transceiver for communication among divers.
* You can not use radio communication underwater (neither to talk nor to hear). If you want to pass some message on land - surface. Exception - submersible at the periscope depth (divers can use a long range radio there).

###Operation modes
The plugin supports two operation modes - **serious** and a **lightweight mode**.

* **Lightweight mode** — is the default mode. It is designed mainly for cooperative games. Its special feature is that using the plugin players can hear the dead, users not playing, users playing on a different server and users playing without the plugin avoiding the radio (just like with TeamSpeak). This makes games against people less convenient, but allows your friends to easily find out where you play, what's your frequency, etc. Naturally, those who play on the same server with activated addons and plugins will hear each other according to "radio laws": taking into account the radio frequency and distance.

* **Serious mode** — designed for games played in player versus player (PvP) modes. To enable it, you need to create a TeamSpeak channel called `TaskForceRadio` (password – `123`). Players enable the radio plugin, join a server and plan their game tactics on the channel of their side. At the start of a mission, in a few seconds time, players will be forwarded to `TaskForceRadio` channel. In this way, players can hear only other live players that have plugin enabled and are on the same server. Dead players, in turn, can communicate only with each other. After a dead player respawns - he will hear only live players again. After the game ends, the players are transferred to the channel they used for game tactics before mission start.

###Problem solving
* `Pipe error 230` - most likely, it means you forgot to enable the plugin in TeamSpeak.
* If the plugin is red-marked in TS and does not load - you will probably have to update TeamSpeak.
* If something doesn't work - try reaload the plugin first.
* `Caps Lock` actions aren’t working - common issue with use of special gaming keyboards, where `Caps Lock` code is different. Try changing your key mapping (by editing the `userconfig`).
* If due to an error, you are no longer able to hear other players, even outside the game, open `Setup 3D Sound` in TeamSpeak and click `Center All`.
* To eliminate possible errors with the plugin, developers may require your TeamSpeak logs. To copy it, select `Tools -> Client Log`, check all checkboxes at the top and, by selecting all of the text with `CTRL`&nbsp;+&nbsp;`A`, copy it to the clipboard.
* If TeamSpeak stopped working (Heaven forbid!) while using the plugin - it will show a dialog with instructions on where you can find the dump file (information about an error). I'd appreciate if you attached this file in your bug reports.

###For TS admins
To be on the safe side, reduce the level of flood protection: `Right-click on the server> Edit Virtual Server> More> Anti Flood`, set the values at 30, 300 and 3000 (from the top).

###For developers
If this plugin ever becomes popular, it would be great if we could avoid having piles of incompatible community forks. For this reason, if you’d like to contribute to the project, contact me - it is very likely that your improvements will be merged into the main branch. Looking forward to your [pull requests](https://github.com/michail-nikolaev/task-force-arma-3-radio/pulls?q=is%3Apr+is%3Aclosed). :smile:

###Special Thanks
* [Task Force Arrowhead](http://forum.task-force.ru/) squad for testing, support, patience and all the help.
* [MTF](http://forum.task-force.ru/index.php?action=profile;u=7) ([varzin](https://github.com/varzin)) for help with graphics and documentation.
* [Hardckor ](http://forum.task-force.ru/index.php?action=profile;u=14) for help with graphics.
* [Shogun](http://forum.task-force.ru/index.php?action=profile;u=13) for help with graphics.
* [Blender](http://arma3.ru/forums/index.php/user/41-blender/) for the fonts.
* [vinniefalco](https://github.com/vinniefalco) for [DSP Filter](https://github.com/vinniefalco/DSPFilters).
* [WOG](http://wogames.info/) and [TRUE](http://wogames.info/profile/TRUE/) personally, for helping with the QA.
* [Music DSP Collection](https://github.com/music-dsp-collection) for the compressor.
* [Avi](http://arma3.ru/forums/index.php/user/715-avi/) for the code review.
* [Vaulter](http://arma3.ru/forums/index.php/user/1328-vaulter/) ([GutHub](https://github.com/andrey-zakharov)) for the development help.
* Dina for translations.
* [Zealot](http://forums.bistudio.com/member.php?125460-zealot111) ([GitHub](https://github.com/Zealot111)) for the development help and useful scripts.
* [NouberNou](http://forums.bistudio.com/member.php?56560-NouberNou) for advice and friendly competition.
* [Megagoth1702](http://forums.unitedoperations.net/index.php/user/2271-megagoth1702/) for his old work on emulation of radio sounds.
* [Naught](http://forums.unitedoperations.net/index.php/user/6555-naught/) for the code review.
* [Andy230](http://forums.bistudio.com/member.php?100692-Andy230) for translations.
* [L-H](http://forums.bistudio.com/member.php?87524-LordHeart) for changes to the code.
* [NorX_Aengell](http://forums.bistudio.com/member.php?99450-NorX_Aengell) for translation into French.
* [lukrop](http://forums.bistudio.com/member.php?78022-lukrop) ([GitHub](https://github.com/lukrop)) for changes to the code.
* [nikolauska](http://forums.bistudio.com/member.php?75014-nikolauska) ([GitHub](https://github.com/nikolauska)) for improvements to SQF code.
* [Kavinsky](https://github.com/kavinsky) for AN/PRC-154, RF-7800S-TR and other radios.
* [JonBons](http://forums.bistudio.com/member.php?81374-JonBons) ([GitHub](https://github.com/JonBons)) for changes to the code.
* [ramius86](https://github.com/ramius86) for translation into Italian.
* Killzone Kid for [tutorials](http://killzonekid.com/arma-scripting-tutorials-float-to-string-position-to-string/).
* [Krypto202](http://www.armaholic.com/users.php?m=details&id=45906&u=kripto202) ([GitHub](https://github.com/kripto202)) for sounds.
* [pastor399](http://forums.bistudio.com/member.php?128853-pastor399) ([GitHub](https://github.com/pastor399)) for backpack models and textures.
* [J0nes](http://forums.bistudio.com/member.php?96513-J0nes) for help with the models.
* [Raspu86](http://forums.bistudio.com/member.php?132083-Raspu86) ([GitHub](https://github.com/Raspu86)) for backpack models.
* [Gandi](http://forums.bistudio.com/member.php?111588-Gandi) for textures.
* [Pixinger](https://github.com/Pixinger) for help with [Zeus](http://arma3.com/dlc/zeus).
* [whoozle](https://github.com/whoozle) for sound engine and help.
* [MastersDisaster](https://www.freesound.org/people/MastersDisaster/) for the [Rotator switch sound](https://www.freesound.org/people/MastersDisaster/sounds/218115/).
* [CptDavo](http://forums.bistudio.com/member.php?75211-CptDavo) for help with textures.
* [KoffeinFlummi](https://github.com/KoffeinFlummi) for help with the code.
* [R.m.K Gandi](http://steamcommunity.com/profiles/76561197984744647/) for backpack textures.
* [Pomigit](http://forums.bistudio.com/member.php?97133-pomigit) for texture patterns.
* [Priestylive](https://plus.google.com/u/0/113553519889377947218/posts) for [BWMOD](http://bwmod.de/) textures.
* [Audiocustoms](http://forums.bistudio.com/member.php?98703-audiocustoms) ([SoundCloud](https://soundcloud.com/audiocustoms)) for radio sounds.
* [EvroMalarkey](http://forums.bistudio.com/member.php?104272-EvroMalarkey) ([GitHub](https://github.com/evromalarkey)) for translation into Czech.
* [Tourorist](https://github.com/Tourorist) for help with documentation.
* The development team of [RHS](http://www.rhsmods.org/), for their help with integration.
* Everyone who made videos or wrote articles reviewing TFAR.
* All the players who use TFAR, especially those taking out their time to report bugs.
* Sorry if I missed anyone out (let me know)!
