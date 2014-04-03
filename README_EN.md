Task Force Arma 3 radio
=======================

Arma 3 Team Speak Radio Plugin
_v0.8.3 (03-13-2014)_

**<font color="green">TeamSpeak 3.0.14 is supported</font>**

###Installation

* Download and unzip [0.8.3 radio archive](https://github.com/michail-nikolaev/task-force-arma-3-radio/raw/master/releases/0.8.3.zip).
* Copy `TeamSpeak 3 Client` folder content to the TeamSpeak root folder.
* Copy `Arma 3` folder content to the `...\SteamApps\common\Arma 3 folder`.

> TF Radio uses the CBA (Community Base Addons) latest version. Therefore, if you’ve already installed this mod, Windows will prompt you to replace the folder.


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
| `CTRL`&nbsp;+&nbsp;`P` | To open the personal radio interface (the radio must be in the inventory slot). In that case if you have a number of radios - you can select the one needed. It is also possible to set the radio as active (the one that will be used for transmission). |
| `CTRL`&nbsp;+&nbsp;+&nbsp;`[/]` | Cycle through available shortwave radios. | 
| `CTRL`&nbsp;+&nbsp;`Up/Left/Right Arrow` | Rapid switching of shortwave stereo mode. |
| `NUM[1-8]` | Rapid switching of shortwave radio channels. | 
| `ALT`&nbsp;+&nbsp;`P` | To open a long range radio interface (a long range radio must be put on your back, or you should be in a vehicle in a position of a driver, shooter, or pilot assistant). If a number of radios are available – you’ll be offered to choose one. Besides, one of them can be set as active. |
| `CTRL`&nbsp;+&nbsp;`ALT`&nbsp;+&nbsp;`[/]` | Cycle through available long range radios. | 
| `ALT`&nbsp;+&nbsp;`Up/Left/Right Arrow` | Rapid switching of long range stereo mode. |
| `CTRL`&nbsp;+&nbsp;`NUM[1-9]` | Rapid switching of long range radio channels. |
| `CTRL`&nbsp;+&nbsp;`TAB` | To change the direct speech volume. You can talk: Whispering, Normal or Yelling. Does not affect the signal volume in the radio transmission. |
| `SHIFT`&nbsp;+&nbsp;`P` | To open an underwater transceiver interface (you should be wearing a rebreather). | 
| `ALT`&nbsp;+&nbsp;`Caps Lock` | To talk on underwater transceiver. |
| `ESC` | To exit from the radio interface. |

> You can reconfigure the keys in the configuration file, which can be found in the game folder `...\Arma 3\userconfig\task_force_radio\radio_keys.hpp`. The file is edited in Notepad.

###Information

#####Radios

| Radio | Side | Range/Distance | How to use |
| --- | --- | --- | --- | 
| Radio [AN/PRC-152](http://en.wikipedia.org/wiki/AN/PRC-152) (personal) | <font color="blue">BLUEFOR<font> | 30-512Mhz / 3 km | To enter the frequency, press `CLR`, enter a value and press `ENT`. You can also switch the active radio channel by pressing the arrow keys (a total of 8 channels). You can change the reception volume pressing `PRE+` and `PRE-` keys. You can also change stereo setting by pressing `0`.| 
| Radio [RT-1523G (ASIP)](http://en.wikipedia.org/wiki/SINCGARS#Models) (long range) | <font color="blue">BLUEFOR<font> | 30-87Mhz / 20 km | To enter the frequency, press `MENU CLR`, enter a value and press `FREQ`. You can also switch the active radio channel by pressing the radio number buttons (a total of 9 channels). You can change the reception volume by `TIME` and `BATT CALL` keys. You can also change stereo setting by pressing `STO`.|
| Radio [AN/PRC148-JEM](https://www.thalescomminc.com/ground/anprc148-jem.asp) (personal) | <font color="green">INDEPENDENT</font> | 30-512Mhz / 3 km | To enter the frequency, press `ESC`, enter a value and press `ENT`. You can also switch the active radio channel by pressing the arrow keys (a total of 8 channels). You can change the reception volume by `MOD` and `GR` keys. You can also change stereo setting by pressing `ALT`.| 
| Radio [AN/PRC-155](http://www.gdc4s.com/anprc-155-2-channel-manpack.html) (long range)| <font color="green">INDEPENDENT</font> | 30-87Mhz / 20 km | To enter the frequency, press `ESC`, enter a value and press `MENU`. You can also switch the active radio channel by pressing the arrow keys (up & down). You can change the reception volume by the loudspeaker button. You can also change stereo setting by pressing `PRE`.| 
| Radio [FADAK](http://www.military.com/video/forces/military-foreign-forces/iran-unveils-3-new-military-products/2363087176001/) (personal) | <font color="red">OPFOR</font> | 30-512Mhz / 3 km | To enter the frequency, press `CLR`, enter a value and press `ENT`. You can also switch the active radio channel by pressing `SET` and `PWR` (a total of 8 channels). You can change the reception volume by `DATA` and `SEND` keys. You can also change stereo setting by pressing `0`.| 
| Radio [MR3000](http://www.railce.com/cw/casc/rohde/m3tr.htm) (long range) | <font color="red">OPFOR</font> | 30-87Mhz / 20 km | To enter the frequency, press `CLR ESC`, enter a value and press `ENT`. You can also switch the active radio channel by pressing the radio number buttons or horizontal arrow buttons (a total of 8 channels). You can change the reception volume by vertical arrow buttons. You can also change stereo setting by pressing `0`. | 
| Underwater transceiver | All | 32-41kHz / 70-300 m. (depending on waves) | To enter the frequency, press `MODE`, enter a value and press `ADV`. You can change the reception volume by the button on the right side of the device. | 


> Personal and long range radios of one faction support a single protocol, therefore they can communicate with each other. If the transmission is carried out from the personal one – the sound will be high-frequency. In the case of long range transmission – it’ll be low-frequency.

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

#####To Mapmakers
* The long range radio classes: `tf_rt1523g`,`tf_mr3000`,`tf_anprc155`. It’s possible to add it to a player using the editor initialization line roughly the following way: `this addBackpack "tf_rt1523g";`
* To disable the automatic distribution of long range radios, add the following line to `init.sqf`: `tf_no_auto_long_range_radio = true`
* To change the encryption codes used by factions (to allow multiple factions talking), add the following code: `tf_west_radio_code = "_bluefor";tf_east_radio_code = "_opfor"; tf_guer_radio_code = "_independent"; `. To allow two factions to contact one another by radio, they must have an identical encryption code (you'll need to change values).

* To set active radio frequency of the local player you may use: `"34.5" call tf_setLongRangeRadioFrequency"`, `"123.5" call tf_setPersonalRadioFrequency`.
* By default all players in the same group have equals frequencies. If you want to set equal frequencies for the faction: `tf_same_sw_frequencies_for_side = true;`.
* By default all players of faction have the same frequencies of long range radios. If you want to disable such feature (set the same LR frequencies for group only) use: `tf_same_lr_frequencies_for_side = false`.
* Using `call generateSwSetting` and `call generateLrSettings` you may generate random settings for personal and LR radios accordingly. Result is array: `[active_channel, volume, frequencies..of..channels, reserved, stereo_setting]`. Such arrays are used in functions below.
* Set values of `tf_freq_west`, `ft_freq_east` and `tf_freq_guer` together with `tf_same_sw_frequencies_for_side = true` to preset settings of personal radios for some faction. Similarly with  `tf_freq_west_lr`, `ft_freq_east_lr` and `ft_freq_east_lr` together with `tf_same_lr_frequencies_for_side = true`.
* Set values `(group _player) setVariable["tf_lr_frequency", _value, true]` together with `tf_same_lr_frequencies_for_side = false` to preset LR radio settings for the players of some group. Similarly `tf_sw_frequency` together with `tf_same_sw_frequencies_for_side = false`.
* `call tf_getTeamSpeakServerName` - get name of TeamSpeak server, `call tf_getTeamSpeakChannelName` - get name of TeamSpeak channel, `call tf_isTeamSpeakPluginEnabled` - is the TeamSpeak plugin active.
* `tf_radio_channel_name` и `tf_radio_channel_password` - change name and password for serious mode channel.
* To force vehicle side: `_vehicle setVariable ["tf_side", _value, true]`. Possible values: `"west"`, `"east"`, `"guer".

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
* [Kavinsky] ([GitHub](https://github.com/nikolauska)) for AN/PRC-154 and RF-7800S-TR.
* [JonBons](http://forums.bistudio.com/member.php?81374-JonBons) for code changes.
* Everyone user (especially who report bugs).
* [ramius86](https://github.com/ramius86) for Italian translation.
* KK for [tutorials](http://killzonekid.com/arma-scripting-tutorials-float-to-string-position-to-string/)
* [Krypto202](http://www.armaholic.com/users.php?m=details&id=45906&u=kripto202) for sounds.
* [pastor399](http://forums.bistudio.com/member.php?128853-pastor399) for backpacks model and textures.
* [J0nes](http://forums.bistudio.com/member.php?96513-J0nes) for help with models.
* Sorry guys if I’ve forgot someone by chance.
