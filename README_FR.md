<h1 align="center">Task Force Arrowhead Radio</h1>
<p align="center">
<img src="https://raw.githubusercontent.com/Tourorist/TPS/master/tfar/tfar_manw.jpg"
     width="572px" /><br />
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki">
    <img src="https://img.shields.io/badge/TFAR-Wiki-orange.svg?style=flat"
         alt="Wiki" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases">
    <img src="http://img.shields.io/badge/Version-0.9.12-blue.svg?style=flat"
         alt="Version" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.12/0.9.12.zip">
    <img src="http://img.shields.io/badge/Download-124_MB-green.svg?style=flat"
         alt="Téléchargement" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/issues">
    <img src="http://img.shields.io/github/issues-raw/michail-nikolaev/task-force-arma-3-radio.svg?label=Issues&style=flat"
         alt="Soucis" />
  </a>
  <a href="http://forums.bistudio.com/showthread.php?169029-Task-Force-Arrowhead-Radio&p=2563136&viewfull=1#post2563136">
    <img src="https://img.shields.io/badge/BIF-Thread-lightgrey.svg?style=flat"
         alt="Forum BI" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/LICENSE.md">
    <img src="http://img.shields.io/badge/License-APL--SA-red.svg?style=flat"
         alt="License">
  </a>
  </p>
<p align="center">
<sup><strong>TFAR <a href="http://www.teamspeak.com/">TeamSpeak</a> pour Arma 3 a remporté la première place du concours <a href="http://makearmanotwar.com/entry/pMP8c7vSS4#.VA1em_nV9UD">Make Arma Not War</a> dans la catégorie Addons.</strong></sup>
</p>

###Installation
 1. Télécharger et décompresser l'archive [0.9.12](https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.12/0.9.12.zip).
 2. Copier le dossier `@task_force_radio` dans le dossier racine du jeu `...\SteamApps\common\Arma 3`.
 3. Installer le plugin Teamspeak en double-cliquant sur l'installateur dans le dossier `@task_force_radio\teamspeak`.

> [TFAR](http://radio.task-force.ru/en/) utilise la version la plus récente de [СBA](https://github.com/CBATeam/CBA_A3/releases) – Community Base Addons. Au besoin, il peut être téléchargé [ici] (https://github.com/CBATeam/CBA_A3/releases).


###Modus operandi
TFAR permet deux modes d'utilisation : sérieux et allégé (**serious** et **lightweight**).

* **Lightweight** : le mode allégé est le mode par défaut, il est conçu principalement pour le PvE. Sa particularité est que les joueurs utilisant le plugin peuvent entendre les morts, les utilisateurs ne jouant pas, les joueurs jouant sur un autre serveur et les utilisateurs jouant sans le plugin (comme avec TeamSpeak). Cela rend le jeu contre des humains moins confortable, mais permet de se retrouver facilement, de savoir quelle est votre fréquence, etc. Naturellement, ceux qui jouent sur le même serveur avec l'addon et le plugin activés s'entendront uniquement via les radios TFAR.

* **Serious** : le mode sérieux est conçu pour le PvP. Pour l'activer, l'administrateur TeamSpeak doit créer un canal nommé `TaskForceRadio` avec le mot de passe `123`. Avant le jeu, les joueurs, au lancement de TS, activent le plugin radio, s'organisent en équipes, chacune occupant son propre canal, puis, après avoir rejoint le serveur de jeu, commencent un briefing sur leur mission. Quelques secondes après le chargement de la mission, les joueurs seront basculés vers le canal `TaskForceRadio`. Là les joueurs ne peuvent entendre les autres joueurs vivants que par la radio. Les joueurs morts ne peuvent communiquer qu'entre eux, mais une fois réapparus, ils seront à nouveau soumis aux restrictions précédentes. Après la conclusion de mission, tous les participants seront basculés dans leur canal d'origine.

###Résolution des problèmes
* `Pipe error 230` la plupart du temps, cela signifie que vous avez oublié d'activer le plugin dans TeamSpeak. Si le plugin apparaît en rouge dans TS et ne se charge pas, vous devez probablement mettre à jour TeamSpeak. Essayez de recharger les compléments.
* Le raccourci <kbd>Caps Lock</kbd> (VERR MAJ) ne fonctionne pas - il s'agit d'un souci courant lors de l'utilisation de clavier "gamer" sur lesquels le code de la touche <kbd>Caps Lock</kbd> est différent. Essayez de réassigner les [raccourcis clavier] (https://github.com/CBATeam/CBA_A3/wiki/Keybinding).
* Si vous n'entendez les autres joueurs, même hors du jeu, ouvrez `Configurer les sons 3D` dans TeamSpeak et cliquez sur `Centrer tout`.
* Pour éliminer les soucis, les développeurs peuvent avoir besoin de votre journal TeamSpeak. Pour le copier, selectionnez `Outils> Journal du client`, cochez toutes les cases en haut et, en sélectionnant tout le texte par le raccourci <kbd>Ctrl</kbd>+<kbd>A</kbd>, copiez le dans le presse-papier.
* Si TeamSpeak cesse de fonctionner durant l'utilisation du plugin, un dialogue s'affichera avec les instructions pour trouver le fichier dump. J'apprécierais beaucoup que vous joigniez ce fichier à votre rapport de bug.

####Pour les administrateurs TS
Pour être sûr, adaptez l'Antiflooding en `cliquez droit sur le nom du serveur -> Modifier le serveur virtuel> Plus> Antiflooding` réglez les valeurs à <code>30</code>, <code>300</code> et <code>3000</code> (depuis le haut).

####Pour les développeurs
Si jamais ce plugin devenait populaire, ce serait bénéfique à tous si l'on pouvait éviter d'avoir un tas de dérivés incompatibles. Pour cette raison, si vous souhaitez contribuer au projet, contactez-moi. Il est très probable que votre amélioration sera fusionnée à la branche principale. J'attends votre [pull requests](https://github.com/michail-nikolaev/task-force-arma-3-radio/pulls).

###Contributeurs
Cf. CONTRIBUTORS.md
