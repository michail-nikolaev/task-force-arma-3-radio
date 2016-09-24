<h1 align="center">Task Force Arrowhead Radio</h1>
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

###Contributors
See CONTRIBUTORS.md
