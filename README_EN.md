<<<<<<< HEAD
<h1 align="center">Task Force Arma 3 Radio</h1>
<p align="center">
<img src="https://raw.githubusercontent.com/Tourorist/TPS/master/tfar/tfar_manw.jpg"
     width="572px" /><br />
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki">
    <img src="https://img.shields.io/badge/TFAR-Wiki-orange.svg?style=flat"
         alt="Wiki" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases">
    <img src="http://img.shields.io/badge/Version-0.9.7.3-blue.svg?style=flat"
         alt="Version" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7/0.9.7.zip">
    <img src="http://img.shields.io/badge/Download-126_MB-green.svg?style=flat"
         alt="Download" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/issues">
    <img src="http://img.shields.io/github/issues-raw/michail-nikolaev/task-force-arma-3-radio.svg?label=Issues&style=flat"
         alt="Issues" />
  </a>
  <a href="http://forums.bistudio.com/showthread.php?169029-Task-Force-Arrowhead-Radio&p=2563136&viewfull=1#post2563136">
    <img src="https://img.shields.io/badge/BIF-Thread-lightgrey.svg?style=flat"
         alt="BIF Thread" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/LICENSE.md">
    <img src="http://img.shields.io/badge/License-APL--SA-red.svg?style=flat"
         alt="LLicense">
  </a>
  </p>
<p align="center">
<sup><strong><a href="http://www.teamspeak.com/">TeamSpeak</a> integration for Arma 3. TFAR won the 1st place (Addon) in <a href="http://makearmanotwar.com/entry/pMP8c7vSS4#.VA1em_nV9UD">Make Arma Not War</a> contest.</strong></sup>
</p>

###Installation
 1. Download and unzip the [0.9.7.3 radio archive](https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7.3/0.9.7.3.zip).
 2. Copy the contents of `TeamSpeak 3 Client` folder into the root folder of TeamSpeak.
 3. Copy the contents of `Arma 3` folder into game folder – `...\SteamApps\common\Arma 3`.

> Every release of [TFAR](http://radio.task-force.ru/en/) includes the most recent version of [СBA](http://www.armaholic.com/page.php?id=18767) – Community Base Addons. If you already have CBA installed, but uncertain about its version, then it's better to let Windows replace the existing folder.

###Configuration
 1. Make sure that <kbd>Caps Lock</kbd> is not used as the push-to-talk key in TeamSpeak.
 2. In the game settings, to avoid voice doubling, turn off Voice Over Network (VON), or change its assgined key to something other than <kbd>Caps Lock</kbd>.
 3. Open the plugin list in TeamSpeak – `Settings> Plugins`.
  1. Enable `Task Force Arma 3 Radio`.
  2. Disable `ACRE` and other similar radio plugins, if you have them, to avoid possible conflicts.
  3. Press the `Reload All` (bottom left) to restart all of the current plugins.
 4. Make sure the volume of alerts is not turned off in TeamSpeak – `Options> Payback> Sound Pack Volume` – set a positive value.
 5. Start the game with both `@CBA_A3` &amp; `@task_force_radio` addons enabled. You can do this by adding their names to the game shortcut, or right after the `exe` file – `…\arma3.exe -mod=@CBA_A3;@task_force_radio`. However, the game's own menu (`Settings> Expansions`) is a more preferable method of setup.
 6. Join the same TeamSpeak channel as other players using the radio. While playing in serious mode, the server will have a channel named `TaskForceRadio`, where all participating players will be navigated automatically at the start of a shared mission.

> During the game, TFAR will change your TeamSpeak nickname to match the one from your current game profile. Make sure your in-game nick is at least 3 characters long.
>
> We do not recommend using the plugin with simultaneous connections to multiple TeamSpeak servers.
>
> We recommend disabling the preconfigured alert sounds used by TeamSpeak – `Options> Notifications> Sound Pack: "Sounds Deactivated"`. To apply this change, make sure to restart TeamSpeak afterwards.

###Controls
| Keys | Action |
| :--- | :--- |
| Push&#8288;-&#8288;to&#8288;-&#8288;talk&nbsp;hotkey&nbsp;in&nbsp;TS&nbsp;&nbsp;&nbsp; | Direct Speech. |
| <kbd>Caps Lock</kbd> | To talk on a radio. |
| <kbd>Ctrl</kbd>+<kbd>Caps Lock</kbd> | To talk on a long range radio. |
| <kbd>Ctrl</kbd>+<kbd>P</kbd> | To open the handheld radio interface (the radio must be in the inventory slot). In that case, if you have a number of radios – you can select the one needed. It is also possible to set the radio as active (the one that will be used for transmission). Also it is possible to load radio settings from another radio with same encryption code. |
| <kbd>Num [1-8]</kbd> | Rapid switching of shortwave radio channels. |
| <kbd>Alt</kbd>+<kbd>P</kbd> | Opens the long range radio interface – for this action to work, you either have to have long range radio on you, or you have to be in a vehicle as a driver, gunner, or co-pilot. If a number of radios are available – you’ll be asked to choose one. Also, one of them can be set as active. Furthermore, it is possible to load radio settings from another radio with same encryption code. |
| <kbd>Ctrl</kbd>+<kbd>Num [1-9]</kbd> | Rapid switching of long range radio channels. |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | To change the direct speech volume. You can talk: Whispering, Normal or Yelling. Does not affect the signal volume in the radio transmission. |
| <kbd>Shift</kbd>+<kbd>P</kbd> | To open an underwater transceiver interface (you should be wearing a rebreather). |
| <kbd>Ctrl</kbd>+<kbd>~</kbd> | To talk on underwater transceiver. |
| <kbd>Ctrl</kbd>+<kbd>]</kbd> | Select next handheld radio. |
| <kbd>Ctrl</kbd>+<kbd>[</kbd> | Select previous handheld radio. |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>]</kbd> | Select next long range radio. |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>[</kbd> | Select previous long range radio. |
| <kbd>Ctrl</kbd>+<kbd>[←,↑,→]</kbd> | Change the stereo mode of handheld radio. |
| <kbd>Alt</kbd>+<kbd>[←,↑,→]</kbd> | Change the stereo mode of long range radio. |
| <kbd>T</kbd> | Transmit on additional channel of commander radio. |
| <kbd>Y</kbd> | Transmit on additional channel of long range radio. |
| <kbd>Esc</kbd> | To exit from the radio interface. |

###Radios
| Radio | Side | Range /Distance |
| :--- | :--- | :--- |
| <kbd>[AN/PRC-152](https://en.wikipedia.org/wiki/AN/PRC-152)</kbd><br><sup>(commander)</sup> | <span style="color:blue">BLUFOR</span> | 30–512 MHz<br>/5 km |
| <kbd>[RF-7800S-TR](http://rf.harris.com/capabilities/tactical-radios-networking/rf-7800s-tr.asp)</kbd><br><sup>(squadmate)</sup> | <span style="color:blue">BLUFOR</span> | 30–512 MHz<br>/2 km |
| <kbd>[RT-1523G (ASIP)](https://en.wikipedia.org/wiki/SINCGARS#Models)</kbd><br><sup>(manpack)</sup> | <span style="color:blue">BLUFOR</span> | 30–87 MHz<br>/20 km<br><sup>(30 km for [vehicle-mounted](https://en.wikipedia.org/wiki/Mobile_radio))</sup> |
| <kbd>[AN/ARC-210](http://www.rockwellcollins.com/~/media/Files/Unsecure/Products/Product%20Brochures/Communcation%20and%20Networks/Communication%20Radios/ARC-210%20Integrated%20Comm%20Systems%20white%20paper.aspx)</kbd><br><sup>(airborne)</sup> | <span style="color:blue">BLUFOR</span> | 30–87 MHz<br>/40 km |
| <kbd>[AN/PRC148-JEM](https://en.wikipedia.org/wiki/AN/PRC-148#AN.2FPRC-148_JTRS_Enhanced_MBITR_.28JEM.29)</kbd><br><sup>(commander)</sup> | <span style="color:green">Independent</span> | 30–512 MHz<br>/5 km |
| <kbd>[AN/PRC-154](http://www.gdc4s.com/anprc-154a-rifleman-radio.html)</kbd><br><sup>(squadmate)</sup> | <span style="color:green">Independent</span> | 30–512 MHz<br>/2 km |
| <kbd>[AN/PRC-155](http://www.gdc4s.com/anprc-155-2-channel-manpack.html)</kbd><br><sup>(manpack)</sup> | <span style="color:green">Independent</span> | 30–87 MHz<br>/20 km<br><sup>(30 km for vehicle-mounted)</sup> |
| <kbd>[AN/ARC-164](https://en.wikipedia.org/wiki/AN/ARC-164)</kbd><br><sup>(airborne)</sup> | <span style="color:green">Independent</span> | 30–87 MHz<br>/40 km |
| <kbd>[FADAK](http://www.military.com/video/forces/military-foreign-forces/iran-unveils-3-new-military-products/2363087176001/)</kbd><br><sup>(commander)</sup> | <span style="color:red">OPFOR</span> | 30–512 MHz<br>/5 km |
| <kbd>[PNR-1000A](http://elbitsystems.com/Elbitmain/files/Tadiran%20PNR1000A_2012.pdf)</kbd><br><sup>(squadmate)</sup> | <span style="color:red">OPFOR</span> | 30–512 MHz<br>/2 km |
| <kbd>[MR3000](http://www.rohde-schwarz.com/en/product/mr300xh-u-productstartpage_63493-10291.html)</kbd><br><sup>(manpack)</sup> | <span style="color:red">OPFOR</span> | 30–87 MHz<br>/20 km<br><sup>(30 km for vehicle-mounted)</sup> |
| <kbd>[MR6000L](http://www.rohde-schwarz.com/en/product/mr6000l-productstartpage_63493-9143.html)</kbd><br><sup>(airborne)</sup> | <span style="color:red">OPFOR</span> | 30–87 MHz<br>/40 km |
| <kbd>Transceiver</kbd><br><sup>(underwater)</sup> | All | 32–41 kHz<br>/70–300 m<br><sup>(depending on waves)</sup> |

> Short range (handheld, of commander or squadmate class) and long range radios (manpack, airborne, vehicle-mounted) of same faction are configured using a common protocol, allowing them to communicate with each other. If the transmission is carried out using a short range radio – the sound will be of high-frequency. In the case of a long range transmission – it will be of low-frequency.

> The quality of radio signal is affected by the nature of surrounding terrain. Worst case scenario – you are located at the edge of a steep hill. If you start moving away from the hill's edge, in direction opposite the transmitting player, you will start getting better signal reception. Best case scenario – a direct line of sight to the source of transmission.

> Commander and long range class of radios support transmitting and receiving on two channels simultaneously. Pressing the "Setup additional channel" switch will mark the currently selected radio channel as additional. After switching to another channel you will hear both – active and additional channels.

####Distribution
* By default, a long range radio is given out to squad leaders. If a given player is initialy wearing a backpack, it will be automatically discarded on the ground in exchange for a distributed radio.

* Short range radios are given out to players who have `ItemRadio` in their inventory. At mission start, the process of radio distribution may take up to a few seconds to fully complete – note the game messages appearing at the center of your screen.

####In vehicles
* A long range radio is available to driver, commander, gunner, and co-pilot. Not all vehicles support mounted radios.

* Every vehicle slot has its own radio, which has to be configured separately. If you plan to switch seats in a vehicle, then configure the radio for each seat beforehand – for example, at the driver and gunner positions.

* Vehicles are classified into open and closed (isolated) types. If you are in an isolated vehicle, you will barely hear any voices from the outside (and vice versa). However, when turned out, you will be able to hear voices from both, inside and outside of your vehicle.

####Interception
* Radios can be picked up from dead players, and exchanged between players. In doing so, they retain all their settings (channels, frequency, volume).

> To bypass the well-known game bug with disappearing world items and pick up a radio safely, we recommend you do so through the inventory screen while standing directly over its position on the ground.

* Settings configured for vehicle-mounted radios are also persistently stored.
* By default, all radios use an embedded faction-specific encryption code for transmission. In practice, this means that even if you somehow found out the radio frequency of your opponent you would still not be able to intercept their communication by simply switching to it on your own radio. To be able to listen and talk on enemy frequency, you will also need to have a captured enemy radio.

> While intercepting your opponent's communication using a captured manpack radio, it is preferable to get in and remain inside a friendly vehicle. This way, you'll be able to listen to the enemy chatter using manpack, while at the same time being able to broadcast to your allies using the vehicle-mounted radio as the active one.

####Divers
* You can not talk underwater (even while wearing a diving suit). However, at close distance your communication partner can hear some indistinct speech (exception: if you are underwater in an isolated vehicle).
* Being underwater, you can faintly hear muffled voices on land.
* Use an underwater transceiver for communication among divers.
* You can not use radio communication underwater (neither to talk nor to hear). If you want to pass some message – surface first. Exception: submersible at the periscope depth (divers can use a long range radio there).

###Operation modes
The plugin supports two operation modes – **serious** and a **lightweight** mode.

* **Lightweight** is the default mode. It is designed mainly for cooperative games (PvE). Its special feature is that using the plugin players can hear the dead, users not playing, users playing on a different server and users playing without the plugin avoiding the radio (just like with TeamSpeak). This makes games against people less convenient, but allows your friends to easily find out where you play, what's your frequency, etc. Naturally, those who play on the same server with activated addons and plugins will hear each other according to "radio laws": taking into account the radio frequency and distance.

* **Serious** is designed for organized games played in player versus player (PvP) modes. To enable it, TeamSpeak administrator has to create a channel called `TaskForceRadio` with the password of `123`. Before the game, players upon launching TS, enable the radio plugin, split into teams with each occupying its own side channel and then, after joining the game server commence a briefing on their forthcoming mission. As the mission loads, in a few seconds time, players will be forwarded to `TaskForceRadio` channel. Therein, players can hear only other live players that have TFAR enabled, are on the same server and the same team. Dead players can communicate only among themselves, but once respawned will again adhere to the aforementioned restrictions. After the played mission concludes, all participants are transferred back to the TS channel they used for briefing.

###Problem solving
* `Pipe error 230` – most likely, it means you forgot to enable the plugin in TeamSpeak.
* If the plugin is red-marked in TS and does not load – you will probably have to update TeamSpeak.
* If something doesn't work – try to reload the plugin first.
* <kbd>Caps Lock</kbd> actions aren't working – common issue with use of special gaming keyboards, where <kbd>Caps Lock</kbd> code is different. Try changing your key mapping (by editing the <code>userconfig</code>).
* If due to an error, you are no longer able to hear other players, even outside the game, open `Setup 3D Sound` in TeamSpeak and click `Center All`.
* To eliminate possible errors with the plugin, developers may require your TeamSpeak logs. To copy it, select `Tools> Client Log`, tick all checkboxes at the top and, by selecting all of the text with <kbd>Ctrl</kbd>+<kbd>A</kbd>, copy it to the clipboard.
* If TeamSpeak stopped working (Heaven forbid!) while using the plugin – it will show a dialog with instructions on where you can find the dump file (information about an error). I'd appreciate if you attached this file in your bug reports.

####For TS admins
To be on the safe side, reduce the level of flood protection – `right-click on server> Edit Virtual Server> More> Anti Flood` – set the values at <code>30</code>, <code>300</code> and <code>3000</code> (from the top).

####For developers
If this plugin ever becomes popular, it would be great if we could avoid having piles of incompatible community forks. For this reason, if you’d like to contribute to the project, contact me – it is very likely that your improvements will be merged into the main branch. Looking forward to your [pull requests](https://github.com/michail-nikolaev/task-force-arma-3-radio/pulls?q=is%3Apr+is%3Aclosed).

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
* [L-H](http://forums.bistudio.com/member.php?87524-LordHeart) ([GitHub](https://github.com/CorruptedHeart)) for changes to the code.
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
* [ViperMaul](http://forums.bistudio.com/member.php?45090-ViperMaul) for help with CBA.
* [Armatech](http://forums.bistudio.com/member.php?48510-armatech) for help with CBA.
* [marc_book](https://github.com/MarcBook) for BWMOD textures.
* [SzwedzikPL] (http://arma3coop.pl) or translation into Polish.
* [SniperOne] (http://steamcommunity.com/groups/SniperAliens-M18X/) for French translation.
* The development team of [RHS](http://www.rhsmods.org/), for their help with integration.
* Everyone who made videos or wrote review articles.
* All the players who use TFAR, especially those taking out their time to report bugs.
* Sorry if I missed anyone out (let me know)!
=======
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
| `ALT`&nbsp;+&nbsp;`Caps Lock` | To talk on underwater transceiver. |
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
* Everyone user (especially who report bugs).
* Sorry guys if I’ve forgot someone by chance.
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
