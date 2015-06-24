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
<sup><strong> integration <a href="http://www.teamspeak.com/">TeamSpeak</a> pour  Arma 3. TFAR a gagne la 1ere (Addon) au concours <a href="http://makearmanotwar.com/entry/pMP8c7vSS4#.VA1em_nV9UD">Make Arma Not War</a> .</strong></sup>
</p>

###Installation
 1. Telecharger et  deziper le fichier [0.9.7.3 radio archive](https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7.3/0.9.7.3.zip).
 2. Copier le contenu du dossier TeamSpeak 3 Client dans le repertoire racine de TeamSpeak.
 3. Copier le contenu du dossier Arma 3 dans le repertoire du jeu – `...\SteamApps\common\Arma 3`.

> Chaque nouvelle version de [TFAR](http://radio.task-force.ru/en/) contient la plus recente version de [ÑBA](http://www.armaholic.com/page.php?id=18767) – Community Base Addons. Si vous avez deja installe CBA, mais que vous n'etes pas sur de la version, alors il vaut mieux laisser Windows remplacer le dossier existant.

###Configuration
 1. Assurez vous que <kbd>Caps Lock</kbd> (VERR MAJ) n'est pas utilise comme touche push-to-talk (appuyez pour parler)dans TeamSpeak.
 2. Dans les parametres du jeu, pour eviter un dedoublement de la voix, desactivez la fonction Voice Over Network (VON), ou changez la touche qui lui est assignee afin qu'elle ne soit pas <kbd>Caps Lock</kbd> (VERR MAJ).
 3. Ouvrez la liste des plugins dans TeamSpeak – `Settings> Plugins`.
  1. Activez `Task Force Arma 3 Radio`.
  2. Desactivez `ACRE` et tout autre plugin similaire de radio, si vous en avez, afin d'evier d'eventuels conflits.
  3. Cliquez sur  `Reload All` (en bas a gauche) pour redemarrer tous les plugins.
 4. Assurez vous que le volume des alertes n'est pas eteint dans TeamSpeak – Options> Payback> Sound Pack Volume – reglez une valeur positive.
 5. Demarrez le jeu en activant les deux addons @CBA_A3 & @task_force_radio. Vous pouvez le faire en ajoutant leur nom dans le raccourci,  – …\arma3.exe -mod=@CBA_A3;@task_force_radio. Toutefois, le menu du jeu lui-meme est une methode preferable (Settings> Expansions).
 6. Rejoignez le meme canal TeamSpeak que les autres joueurs utilisant la radio. Pendant un ejeu en mode serieux (serious mode),le serevur utilisera un canal appele TaskForceRadio, dans lequel tous les joueurs participant seront diriges automatiquement au depart d'une mission partagee.

> Pendant le jeu, TFAR changera votre surnom TeamSpeak pour le faire correspondre a l'indicatif de votre profil actuel dans le jeu. Assurez vous que votre indicatif en jeu comporte au moins 3 caracteres.
>
> Nous ne recommandons pas l'utilisation du plugin avec des connexions simultanees a plusieurs serveurs TeamSpeak.
>
> Nous recommandons de desactiver les sons d'alerte preconfigures utilises par TeamSpeak – Options> Notifications> Sound Pack: "Sounds Deactivated". pour appliquer ce changement, assurez vous de redemarrer TeamSpeak a l'issue.

###Controls
| Touche | Action |
| :--- | :--- |
| Push&#8288;-&#8288;to&#8288;-&#8288;talk&nbsp;hotkey&nbsp;in&nbsp;TS&nbsp;&nbsp;&nbsp; | Dialogue direct. |
| <kbd>Caps Lock</kbd> | Parler a la radio. |
| <kbd>Ctrl</kbd>+<kbd>Caps Lock</kbd> | Parler sur une radio longue portee. |
| <kbd>Ctrl</kbd>+<kbd>P</kbd> | Ouvre l'interface de la radio tenue en main (la radio doit etre dans l'emplacement de l'inventaire). Dans ce cas, si vous avez plusieurs radios, vous pouvez selectionner celle dont vous avez besoin. Il est ainsi possible d'activer la radio (celle qui sera utilisee pour la transmission). Ainsi il est possible de charger les reglages d'une autre radio avec le meme code de cryptage. |
| <kbd>Num [1-8]</kbd> | Selection rapide des canaux de radio ondes courtes. |
| <kbd>Alt</kbd>+<kbd>P</kbd> | Ouvre l'interface de la radio longue portee – pour que cette action fonctionne, cous devez soit avoir uen radio longue portee sur vous, soit etre dans un vehicule en tant que conducteur, tireur ou copilote. Si plusieurs radios sont disponibles, il vous sera demande d'en choisir une. Ainsi, une d'entre elles peut etre activee. De plus, il est possible de charger les reglages d'une autre radio avec le meme code de cryptage. |
| <kbd>Ctrl</kbd>+<kbd>Num [1-9]</kbd> | Selection rapide des canaux de radio longue portee. |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | Change le volume de dialogue direct. Vous pouvez : chuchoter, parler normalement ou crier. N'affecte pas le volume des transmissions radio. |
| <kbd>Shift</kbd>+<kbd>P</kbd> | Ouvre l'interface du transpondeur sous-marin (Vous devez porter un respirateur). |
| <kbd>Ctrl</kbd>+<kbd>~</kbd> | Parler sur le transpondeur sous-marin. |
| <kbd>Ctrl</kbd>+<kbd>]</kbd> | Selectionne la radio portable suivante. |
| <kbd>Ctrl</kbd>+<kbd>[</kbd> | Selectionne la radio portable precedente. |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>]</kbd> | Selectionne la radio longue portee suivante. |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>[</kbd> | Selectionne la radio longue portee precedente. |
| <kbd>Ctrl</kbd>+<kbd>[<,^,>]</kbd> | Change le mode stereo de la radio portable. |
| <kbd>Alt</kbd>+<kbd>[<,^,>]</kbd> | Change le mode stereo de la radio longue portee. |
| <kbd>T</kbd> | Transmet sur le canal additionnel de la radio du commandeur. |
| <kbd>Y</kbd> | Transmet sur le canal additionnel de la radio longue portee. |
| <kbd>Esc</kbd> | Sort de l'interface radio. |

###Radios
| Radio | Faction | Gamme /Portee |
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

> Les radio courte portee (portatives, de commandeur ou fantassin) et les radios longue portee (harnais dorsal, aeroportee ou montee dans les vehicules) de la meme faction sont configurees en utilisant un protocole commun, leur permettant de communiquer entre elles. Si la transmission est acheminee par l'utilisation d'une radio courte portee, le son sera en haute frequence. Dans le cas d'une transmission longue distance, il sera en basse frequence.

> La qualite du signal radio est affectee par la nature du terrain environnant. Pire scenario : vous etes au pied d'une colline abrupte. Si vous commencez a vous eloigner de la colline, en direction opposee au joueur emetteur, vous allez commencer a avoir une meilleure reception du signal. Meilleur scenario : une vue directe sur la source de transmission.

> Les radios de classe Commander et longue distance supportent la transmission et la reception sur deux canaux simultanement. Presser le bouton "Setup additional channel" marquera le canal radio actuellement selectionne  comme canal additionnel. Apres avoir bascule sur un autre canal, vous les entendrez les deux, canal actif et canal additionnel.

####Repartition
* Par defaut, une radio longue portee est donnee au chef d'escouade. Si un joueur donne est initialement equipe d'un sac a dos, ce dernier sera automatiquement depose sur le sol en echange d'une radio.

* Les radios courte portee sont donnees au joueurs qui ont ItemRadio dans leur inventaire. Au demarrage de la mission, le processus de distribution de radio peut prendre plusieurs secondes pour se completer - Notez le message de jeu apparaissant au centre de l'ecran.

####Dans les vehicules
* Une radio longue portee est disponible pour le conducteur,  le commandeur, le tireur et le copilote. Tous les vehicules ne sont pas equipes de radios.

* Chaque place dans le vehicule a sa propre radio qui doit etre configuree separement. Si vous envisagez de changer de place dans un vehicule, alors configurez la radio pour chaque place au prealable – par exemple, a la place conducteur et a la place tireur.

* Les vehicules sont classes en types ouverts ou fermes (isoles). Si vous etes a l'interieur d'un vehicule isole, vous entendrez difficilement les voix de l'exterieur ( et vice versa). Toutefois, quand il est arrete, vous serez capable d'entendre les voix des deux, interieur et exterieur  de votre vehicule.

####Interception
* Les radios peuvent etre prises sur les cadavres des joueurs et echangees entre les joueurs. dans ces cas, elles conservent tous leurs reglages (canaux, frequence, volume).
		
> Pour outrepasser le bien connu bug des objets qui disparaissent  et prendre une radio en securite, nous vous recommandons de le faire par le biais de la fenetre d'inventaire en vous tenant directement au dessus de sa position sur le sol.

* Les reglages configures pour les radios embarquees sont  aussi stockes de maniere persistante.
* Par defaut, toutes les radios utilisent un code de cryptage preinsere specifique a la faction pour la transmission. En pratique, cela signifie que meme si vous trouvez, d'une maniere ou d'une autre, la frequence radio de votre opposant, vous ne serez pas capable d'intercepter leurs communications simplement en basculant votre radio sur cette frequence. Pour pouvoir ecouter et parler sur la frequence ennemie, il vous faudra aussi avoir recupere une radio ennemie.

> Pendant l'interception des communications de vos ennemis au moyen d'une radio longue portee ennemie (manpack), il est preferable d'entrer et de rester dans un vehicule ami. De cette facon, vous serez en mesure d'ecouter les echanges ennemis et, en meme temps, vous pourrez transmettre a vos allies en utilisant la radio longue portee du vehicule comme la radio active.

####Plongeurs
* Vous ne pouvez pas parler sous l'eau (meme en combinaison de plongee). Toutefois, a courte distance, votre partenaire  de communication peut entendre une sort de discours indistinct (exception : si vous etes sous l'eau dans un vehicule isole).
* En etant sous l'eau, vous pouvez a peine entendre les voix etouffees de la surface.
* Utilisez un transpondeur sous-marin pour la communication entre plongeurs.
* Vous ne pouvez pas utiliser de communication radio sous l'eau (ni pour parler, ni pour ecouter). Si vous voulez passer un message, faites d'abord surface. Exception : en sous-marin, mettez vous a profondeur periscopique (a bord, les plongeurs peuvent utiliser une radio longue portee).

###Modes d'Operation
Le plugin supporte deux modes d'utilisation : serieux et allege – (**serious** et **lightweight**).

* **Lightweight** : Le mode allege est le mode par defaut. il est concu principalement pour les jeux cooperatifs (PvE). Sa caracteristique speciale est que les joueurs utilisant le plugin peuvent entendre les morts, les utilisateurs ne jouant pas, les joueurs jouant sur un autre serveur et les utilisateurs jouant sans le plugin evitant la radio (comme avec TeamSpeak). Cela rend le jeu contre des humains moins confortable, mais permet a vos amis de trouver facilement ou vous jouez, quelle est votre frequence, etc. Naturellement, ceux qui jouent sur le meme serveur  avec l'addo et le plugin actives s'entendront mutuellement selon les "regles de  radio" prenant en compte la frequence radio et la distance.
	
* **Serious** : Le mode serieux est concu pour les jeux organises en mode joueur contre joueur (PvP). Pour l'activer, l'administrateur TeamSpeak doit creer un canal nomme TaskForceRadio avec le mot de passe 123. Avant le jeu, les joueurs, au lancement de TS, activent le plugin radio, se separent en equipes, chacune occupant son propre canal de faction, puis, apres avoir rejoint le serveur de jeu, commencent un briefing sur leur mission. Pendant le chargement de la mission, en quelques secondes, les joueurs seront diriges vers le canal TaskForceRadio. La, les joueurs ne peuvent entendre que les autres joueurs vivants qui ont TFAR active, sont sur le meme serveur et dans la meme equipe. les joueurs morts ne peuvent communiquer qu'entre eux, mais une fois respawnes, ils seront a nouveau soumis aux restrictions precedentes. Apres la conclusion de mission, tous les participants seront transferes au canal utilise precedemment pour le briefing.

###Solutions aux Problemes 
* `Pipe error 230` – la plupart du temps, cela signifie que vous avez oublie d'activer le plugin dasn TeamSpeak.
* Si le plugin est inscrit en rouge dans TS et ne se charge pas - vous devrez probablement mettre a jour TeamSpeak.
* Si quelque chose ne fonctionne pas - commencez d'abord par re-telecharger le plugin.
* Les actions sur <kbd>Caps Lock</kbd> (VERR MAJ) ne fonctionnent pas - il s'agit d'un probleme commun lors de l'utilisation de claviers "special gaming" (dedies aux jeux), sur lesquels le codede la touche <kbd>Caps Lock</kbd> est different. Essayez de changer la programmation de vos touches (en editant <code>userconfig</code>).
* Si a cause d'une erreur, vous ne pouvez plus entendre les autres joueurs, meme hors du jeu, ouvrez `Setup 3D Sound`(parametre son 3D) dans TeamSpeak et cliquez sur `Center All`(centrer tout).
* Pour eliminer les erreurs possibles avec le plugin, les developpeurs peuvent avoir besoin de votre journal TeamSpeak. Pour le copier, selectionnez `Tools> Client Log`, cochez toutes les cases en haut et, en selectionnant tout le texte par le raccourci <kbd>Ctrl</kbd>+<kbd>A</kbd>, copiez le dans le presse-papier.
* Si TeamSpeak s'est arrete de fonctionner (Heaven forbid!) durant l'utilisation du plugin – un dialogue s'affichera avec les instructions pour trouver le fichier dump (information sur une erreur). J'apprecierais si vous joignez ce fichier a votre rapport de bug.

####Pour les administrateurs TS
To be on the safe side, reduisez la protection de niveau de flux (level of flood protection) – `cliquez droit sur server> Edit Virtual Server> More> Anti Flood` – reglez les valeurs a <code>30</code>, <code>300</code> et <code>3000</code> (depuis le haut).

####Pour les developeurs
Si jamais ce plugin devient populaire, ce serait bien si on pouvait eviter d'avoir des quantites de derives communautaires incompatibles. pour cette raison, si vous souhaitez contribuer au projet, contactez moi – il est tres probable que votre amelioration sera fusionnee a la branche principale. En attendant votre demande [pull requests](https://github.com/michail-nikolaev/task-force-arma-3-radio/pulls?q=is%3Apr+is%3Aclosed).

###Remerciements Speciaux
* [Task Force Arrowhead](http://forum.task-force.ru/) squad pour les tests, leur support, patience et toute l'aide.
* [MTF](http://forum.task-force.ru/index.php?action=profile;u=7) ([varzin](https://github.com/varzin)) pour l'aide avec les graphiques et la documentation.
* [Hardckor ](http://forum.task-force.ru/index.php?action=profile;u=14) pour l'aide avec les graphiques.
* [Shogun](http://forum.task-force.ru/index.php?action=profile;u=13) pour l'aide avec les graphiques.
* [Blender](http://arma3.ru/forums/index.php/user/41-blender/) pour les polices de caracteres.
* [vinniefalco](https://github.com/vinniefalco) pour [DSP Filter](https://github.com/vinniefalco/DSPFilters).
* [WOG](http://wogames.info/) et [TRUE](http://wogames.info/profile/TRUE/) personnellement, pour son aide avec QA.
* [Music DSP Collection](https://github.com/music-dsp-collection) pour le compresseur.
* [Avi](http://arma3.ru/forums/index.php/user/715-avi/) pour la revision des codes.
* [Vaulter](http://arma3.ru/forums/index.php/user/1328-vaulter/) ([GutHub](https://github.com/andrey-zakharov)) pour l'aide au developpement.
* Dina pour les traductions.
* [Zealot](http://forums.bistudio.com/member.php?125460-zealot111) ([GitHub](https://github.com/Zealot111)) pour l'aide au developpement et les scripts utiles.
* [NouberNou](http://forums.bistudio.com/member.php?56560-NouberNou) pour les conseils et la competition amicale.
* [Megagoth1702](http://forums.unitedoperations.net/index.php/user/2271-megagoth1702/) pour son ancien travail sur l'emulation des sons radio.
* [Naught](http://forums.unitedoperations.net/index.php/user/6555-naught/) pour la revision des codes.
* [Andy230](http://forums.bistudio.com/member.php?100692-Andy230) pour les traductions.
* [L-H](http://forums.bistudio.com/member.php?87524-LordHeart) ([GitHub](https://github.com/CorruptedHeart)) pour les changements dans le code.
* [NorX_Aengell](http://forums.bistudio.com/member.php?99450-NorX_Aengell) pour la traduction en francais.
* [lukrop](http://forums.bistudio.com/member.php?78022-lukrop) ([GitHub](https://github.com/lukrop)) pour les changements dans le code.
* [nikolauska](http://forums.bistudio.com/member.php?75014-nikolauska) ([GitHub](https://github.com/nikolauska)) pour ses ameliorations dans le code SQF.
* [Kavinsky](https://github.com/kavinsky) pour l'AN/PRC-154,le RF-7800S-TR et les autres radios.
* [JonBons](http://forums.bistudio.com/member.php?81374-JonBons) ([GitHub](https://github.com/JonBons)) pour les changemenst dans le code.
* [ramius86](https://github.com/ramius86) pour la traduction en Italien.
* Killzone Kid pour [tutorials](http://killzonekid.com/arma-scripting-tutorials-float-to-string-position-to-string/).
* [Krypto202](http://www.armaholic.com/users.php?m=details&id=45906&u=kripto202) ([GitHub](https://github.com/kripto202)) pour les sons.
* [pastor399](http://forums.bistudio.com/member.php?128853-pastor399) ([GitHub](https://github.com/pastor399)) pour les modeles dorsaux (backpack) et les textures.
* [J0nes](http://forums.bistudio.com/member.php?96513-J0nes) pour l'aide avec les modeles.
* [Raspu86](http://forums.bistudio.com/member.php?132083-Raspu86) ([GitHub](https://github.com/Raspu86)) pour les modeles dorsaux (backpack).
* [Gandi](http://forums.bistudio.com/member.php?111588-Gandi) pour les textures.
* [Pixinger](https://github.com/Pixinger) pour l'aide avec [Zeus](http://arma3.com/dlc/zeus).
* [whoozle](https://github.com/whoozle) pour le moteur sonore et son aide.
* [MastersDisaster](https://www.freesound.org/people/MastersDisaster/) pour le [Rotator switch sound](https://www.freesound.org/people/MastersDisaster/sounds/218115/).
* [CptDavo](http://forums.bistudio.com/member.php?75211-CptDavo) pour l'aide avec les textures.
* [KoffeinFlummi](https://github.com/KoffeinFlummi) pour l'aide avec le code.pour les textures de backpack.
* [Pomigit](http://forums.bistudio.com/member.php?97133-pomigit) pour les echantillons de textures.
* [Priestylive](https://plus.google.com/u/0/113553519889377947218/posts) pour les textures [BWMOD](http://bwmod.de/) .
* [Audiocustoms](http://forums.bistudio.com/member.php?98703-audiocustoms) ([SoundCloud](https://soundcloud.com/audiocustoms)) pour les sons radio.
* [EvroMalarkey](http://forums.bistudio.com/member.php?104272-EvroMalarkey) ([GitHub](https://github.com/evromalarkey)) pour la traduction en Tcheque.
* [Tourorist](https://github.com/Tourorist) pour l'aide avec la documentation.
* [ViperMaul](http://forums.bistudio.com/member.php?45090-ViperMaul) pour l'aide avec CBA.
* [Armatech](http://forums.bistudio.com/member.php?48510-armatech) pour l'aide avec CBA.
* [marc_book](https://github.com/MarcBook) pour les textures BWMOD.
* L'equipe de developpement de[RHS](http://www.rhsmods.org/), pour leur aide avec l'integration.
* Chacun de ceux qui ont fait des videos ou ont ecrit des articles de revue.
* Tous les joueurs qui utilisent TFAR, specialement ceux qui prennent de leur temps pour rapporter les bugs.
* Desole si j'ai oublie quelqu'un (faites-le moi savoir)!

