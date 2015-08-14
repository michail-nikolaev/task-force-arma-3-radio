<h1 align="center">Task Force Arma 3 Radio</h1>
<p align="center">
<img src="https://raw.githubusercontent.com/Tourorist/TPS/master/tfar/tfar_manw.jpg"
     width=572 /><br />
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki">
    <img src="https://img.shields.io/badge/TFAR-Wiki-orange.svg?style=flat"
         alt="Wiki" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases">
    <img src="http://img.shields.io/badge/Verzia-0.9.7.3-blue.svg?style=flat"
         alt="Verzia" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7.3/0.9.7.3.zip">
    <img src="http://img.shields.io/badge/Stiahnuť-126_MB-green.svg?style=flat"
         alt="Stiahnuť" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/LICENSE.md">
    <img src="http://img.shields.io/badge/Licencie-APL--SA-red.svg?style=flat"
         alt="Licencie" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/issues">
    <img src="http://img.shields.io/github/issues-raw/michail-nikolaev/task-force-arma-3-radio.svg?label=Problémy&style=flat"
         alt="Problémy" />
  </a>
  <a href="http://forums.bistudio.com/showthread.php?169029-Task-Force-Arrowhead-Radio&p=2563136&viewfull=1#post2563136">
    <img src="https://img.shields.io/badge/BIF-Téma-lightgrey.svg?style=flat"
         alt="BIF Téma" />
  </a>
  </p>
<p align="center">
<sup><strong>Arma 3 <a href="http://www.teamspeak.com/">TeamSpeak</a> radio plugin. TFAR zvíťazil vo svojej kategórii v súťaži <a href="http://makearmanotwar.com/entry/pMP8c7vSS4#.VA1em_nV9UD">Make Arma Not War</a>.</strong></sup>
</p>

###Inštalácia
 1. Stiahnite si a rozbaľte [0.9.7.3 radio archív](https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7.3/0.9.7.3.zip).
 2. Skopírujte `TeamSpeak 3 Client` obsah adresára do hlavného adresára s nainštalovaným TeamSpeak klientom.
 3. Skopírujte `Arma 3` obsah adresára do – `...\SteamApps\common\Arma 3 adresára`.

> [TFAR](http://radio.task-force.ru/sk/) využíva [СBA](http://www.armaholic.com/page.php?id=18767) (Community Base Addons), ak už máte nainštalované CBA – Windows sa vás pri kopírovaní spýta na prepísanie adresára CBA.

###Konfigurácia
 1. Uistite sa že <kbd>Caps Lock</kbd> klávesu nepoužívate v TS3 klientovi ako "push-to-talk".
 2. Vypnite si v hre Arma 3 "voice over network" (VON), prípadne si zmeňte na niečo iné ako <kbd>Caps Lock</kbd> (aby ste sa vyvarovali duplicitnému prenosu hlasu).
 3. Otvorte si zoznam pluginov v TeamSpeak 3 klientovi– `Settings> Plugins`.
  1. Povoľte `Task Force Arma 3 Radio`.
  2. Doporučuje sa vypnúť `ACRE` a `radio ts ARMA3.ru` ak ich máte nainštalované, aby ste sa vyhli prípadným konfliktom s pluginmi.
  3. V každom prípade použite tlačidlo `Reload All` aby ste mohli reštartovať všetky pluginy.
 4. Uistite sa, že máte nastavenú hlasitosť upozornení v TS3 klientovi : `Options> Payback> Sound Pack Volume` — nastavte si "plusovú" hodnotu.
 5. Spustite hru s módmi `@CBA_A3` &amp; `@task_force_radio`. Môžete to spraviť tak, že si pridáte mená modov do zástupcu na ploche za EXE súbor `…\arma3.exe -mod=@CBA_A3;@task_force_radio`, prípadne si povolíte/zapnete dané mody v nastaveniach hry (`Settings> Expansions`).
 6. Pripojte sa na TS do rovnakého kanálu s ostanými hráčmi, prípadne budete autoamticky presunutí do kanálu `TaskForceRadio`, ak taký existuje na TS3 serveri, hneď po spustení hry a pripojení sa na server.

> Ak nepoužívate rovnaký "nick" v hre a na TS, plugin vám počas hry zmení nick na rovnaký ako máte v hre.
>
> Váš nick v hre musí obsahovať aspoň 3 znaky a nesmie obsahovať znak `@`.
>
> Nedoporučuje sa používať TS3 klienta na "multi-pripojenia" na viacero TS3 serverov súčasne.
>
> Doporučuje sa vypnúť v TS3 klientovi výstražné zvuky– `Options> Notifications> Sound Pack: "Sounds Deactivated"`. Aby sa zmeny prejavili je potrebné reštartovať TS3 klienta.

###Používanie
| Klávesy | Akcia |
| :--- | :--- |
| Push&#8288;-&#8288;to&#8288;-&#8288;talk&nbsp;klávesa&nbsp;v&nbsp;TS | Priame hovorenie. |
| <kbd>Caps Lock</kbd> | Hovorenie do vysielačky. |
| <kbd>Ctrl</kbd>+<kbd>Caps Lock</kbd> | Hovorenie do vysielačky s dlhým dosahom. |
| <kbd>Ctrl</kbd>+<kbd>P</kbd> | Otvorí rozhranie osobnej vysielačky (vysielačka musí byť v inventári). V prípade, že máte niekoľko vysielačiek v inventári — môžete si vybrať to ktoré potrebujete. Je tiež možné nastaviť vysielačku ako aktívnu (tú, ktorú budete používať). |
| <kbd>Num [1-8]</kbd> | Rýchle prepínanie kanálov na osobnej vysielačke. |
| <kbd>Alt</kbd>+<kbd>P</kbd> | Otvorí rozhranie vysielačky s dlhým dosahom (vysielačku s dlhým dosahom musíte mať na na chrbte namiesto batohu, alebo by ste mali byť vo vozidle v pozícii vodiča, strelca, pilota alebo pilota asistenta).  Ak je k dispozícii viacero vysielačiek — otvorí sa vám ponuka na výber jednej z nich, ktorú budete používať ako aktívnu. |
| <kbd>Ctrl</kbd>+<kbd>Num [1-9]</kbd> | Rýchle prepínanie kanálov na vysielačke dlhého dosahu. |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | Zmena hlasitosti priamej reči. Môžete hovoriť: šepkať, normálne alebo kričať. Nemá vplyv na hlasitosť signálu v rádiovom prenose. |
| <kbd>Shift</kbd>+<kbd>P</kbd> | Ak chcete otvoriť rozhranie vysielačky použiteľnej pod vodou (mali by ste mať na sebe dýchací prístroj). |
| <kbd>Alt</kbd>+<kbd>Caps Lock</kbd> | Hovorenie do vysielačky použiteľnej pod vodou. |
| <kbd>Esc</kbd> | Odísť z rozhrania vysielačky. |

> Môžete si nakonfigurovať klávesy v konfiguračnom súbore, ktorý možno nájsť v priečinku hry `...\Arma 3\userconfig\task_force_radio\radio_keys.hpp`. Tento súbor je editovateľný v Notepad-e.

###Vysielačky
| Vysielačka&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | Strana | Rozsah /Dosah | Návod na používanie |
| :--- | :--- | :--- | :--- |
| <kbd>[AN/PRC-152](https://en.wikipedia.org/wiki/AN/PRC-152)</kbd><br><sup>(osobná)</sup> | <span style="color:blue">BLUFOR</span> | 30-512 MHz<br>/5&nbsp;km | Ak chcete zmeniť frekvenciu, stlačte `CLR`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel so šipkami (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou `PRE+` a `PRE-` tlačítok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `0`.|
| <kbd>[RF-7800S-TR](http://rf.harris.com/capabilities/tactical-radios-networking/rf-7800s-tr.asp)</kbd><br><sup>(osobná)</sup> | <span style="color:blue">BLUFOR</span> | 30-512 MHz<br>/2&nbsp;km | [inštrukcie] |
| <kbd>[RT-1523G (ASIP)](https://en.wikipedia.org/wiki/SINCGARS#Models)</kbd><br><sup>(s dlhým dosahom)</sup> | <span style="color:blue">BLUFOR</span> | 30-87 MHz<br>/20&nbsp;km<br><sup>(30&nbsp;pre&nbsp;[autorádiá](https://en.wikipedia.org/wiki/Mobile_radio))</sup> | 20 km Ak chcete zmeniť frekvenciu, stlačte `MENU CLR`, zadajte hodnotu (na klávesnici) a potvrďte `FREQ`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel jednotlivých kanálov na vysielačke (celkovo 9 kanálov). Hlasitosť vysielačky môžete meniť pomocou `TIME` a `BATT CALL` tlačítok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `STO`.|
| <kbd>[AN/ARC-210](http://www.rockwellcollins.com/~/media/Files/Unsecure/Products/Product%20Brochures/Communcation%20and%20Networks/Communication%20Radios/ARC-210%20Integrated%20Comm%20Systems%20white%20paper.aspx)</kbd><br><sup>(palubné rádio)</sup> | <span style="color:blue">BLUFOR</span> | 30-87 MHz<br>/40&nbsp;km | [inštrukcie] |
| <kbd>[AN/PRC148-JEM](https://en.wikipedia.org/wiki/AN/PRC-148#AN.2FPRC-148_JTRS_Enhanced_MBITR_.28JEM.29)</kbd><br><sup>(osobná)</sup> | <span style="color:green">Nezávislé</span> | 30-512 MHz<br>/5&nbsp;km | Ak chcete zmeniť frekvenciu, stlačte `ESC`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel so šipkami (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou `MOD` a `GR` tlačítok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `ALT`.|
| <kbd>[AN/PRC-154](http://www.gdc4s.com/anprc-154a-rifleman-radio.html)</kbd><br><sup>(osobná)</sup> | <span style="color:green">Nezávislé</span> | 30-512 MHz<br>/2&nbsp;km | [inštrukcie] |
| <kbd>[AN/PRC-155](http://www.gdc4s.com/anprc-155-2-channel-manpack.html)</kbd><br><sup>(s dlhým dosahom)</sup> | <span style="color:green">Nezávislé</span>  | 30-87 MHz<br>/20&nbsp;km<br><sup>(30&nbsp;pre&nbsp;autorádiá)</sup> | Ak chcete zmeniť frekvenciu, stlačte `ESC`, zadajte hodnotu (na klávesnici) a potvrďte `MENU`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel so šípkami (hore & dole). Hlasitosť vysielačky môžete meniť pomocou tlačidla reproduktora. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `PRE`.|
| <kbd>[AN/ARC-164](https://en.wikipedia.org/wiki/AN/ARC-164)</kbd><br><sup>(palubné rádio)</sup> |  <span style="color:green">Nezávislé</span> | 30-87 MHz<br>/40&nbsp;km | [inštrukcie] |
| <kbd>[FADAK](http://www.military.com/video/forces/military-foreign-forces/iran-unveils-3-new-military-products/2363087176001/)</kbd><br><sup>(osobná)</sup> | <span style="color:red">OPFOR</span> | 30-512 MHz<br>/5&nbsp;km | Ak chcete zmeniť frekvenciu, stlačte `CLR`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel `SET` a `PWR` (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou `DATA` a `SEND` tlačidiel. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `0`.|
| <kbd>[PNR-1000A](http://elbitsystems.com/Elbitmain/files/Tadiran%20PNR1000A_2012.pdf)</kbd><br><sup>(osobná)</sup> | <span style="color:red">OPFOR</span> | 30-512 MHz<br>/2&nbsp;km | [inštrukcie] |
| <kbd>[MR3000](http://www.rohde-schwarz.com/en/product/mr300xh-u-productstartpage_63493-10291.html)</kbd><br><sup>(s dlhým dosahom)</sup> | <span style="color:red">OPFOR</span> | 30-87 MHz<br>/20&nbsp;km<br><sup>(30&nbsp;pre&nbsp;autorádiá)</sup> | Ak chcete zmeniť frekvenciu, stlačte `CLR ESC`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel jednotlivých kanálov alebo horizontálnych šípok (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou vertikálne umiestnených šipok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `0`.|
| <kbd>[MR6000L](http://www.rohde-schwarz.com/en/product/mr6000l-productstartpage_63493-9143.html)</kbd><br><sup>(palubné rádio)</sup> | <span style="color:red">OPFOR</span> | 30-87 MHz<br>/40&nbsp;km | [inštrukcie] |
| <kbd>Transceiver</kbd><br><sup>(podvodné)</sup> | Všetky | 32-41 kHz<br>/70-300&nbsp;m<br><sup>(závislá&nbsp;od&nbsp;vĺn)</sup> | Ak chcete zmeniť frekvenciu, stlačte `MODE`, zadajte hodnotu (na klávesnici) a potvrďte `ADV`. Hlasitosť vysielačky môžete meniť pomocou tlačidiel umiestných na pravej strane vysielačky. |

> Vysielačky krátkeho a dlhého dosahu jednotlivej frakcie podporujú rovnaký protokol, takže dokážu spolu komunikovať. Ak je prenos vysielaný z vysielačky s krátkym dosahom, zvuk je prenášaný na vysokej frekvencii. V prípade prenosu z vysielačky s dlhým prenosom, bude zvuk nízkofrekvenčný.

####Distribúcia
* Štandardne je vysielačka dlhého dosahu automaticky pridelená vedúcim družstiev namiesto batohu (squad leaderom). Ak má hráč na sebe batoh – ten je automaticky hodený na zem.

* Osobná vysielačka krátkeho dosahu je daná hráčom do výbavy ak majú `ItemRadio` v inventári. Distribúcia vysielačiek môže trvať niekoľko sekúnd (sledujte správy v strede obrazovky).

####Vozidlá
* Vysielačka s dlhým dosahom je k dispozícii pre vodiča, veliteľa, strelca, pilota a kopilota. Nie však všetky vozidlá podporujú zabudované vysielačky.

* Každý slot vo vozidle má vlastnú vysielačku, ktorá musí byť nakonfigurovaná samostatne. Ak plánujete meniť pozície vo vozidle — treba nakonfigurovať všetky vysielačky vo všetkých pozíciách dopredu (napr. na pozícii vodiča alebo strelca).

* Vozidlá sa delia na skupiny otovrené a uzavreté (izolované). Ak ste v izolovanom vozidle, nebudete počuť žiadne hlasy z vonku (a naopak). Avšak ak vystúpite z vozidla, budete počuť hlasy vonku a takisto aj z vozidla.

####Odpočúvanie
* Vysielačka môže byť zobratá a použitá z mŕtvol iných spoluhráčov. Všetky nastavenia na nej ostávajú uložené (kanály, frekvencie, hlasitosť) tak ako boli nastavené predtým iným spoluhráčom.

> Je doporučené nastavovať si vysielačky pri bedni kde sa nachádzajú (aby sa nestalo, že vám kvoli chybe hry zmizne z inventára).

* Nastavenie vysielačiek vo vozidlách sa takisto ukladá a zostáva zachované.
* V predvolenom nastavení vysielačiek každú frakcia používa svoje vlastné šifrovacie kódy, takže nebudete počuť nepriateľské vysielanie, takisto ani nezistíte nastavenie frekvencie nepriateľa. Ak chcete odpočúvať vysielanie nepriateľa (a vysielať na ich frekvencii) — e nutné akýmkoľvek spôsobom zmocniť sa vysielačky nepriateľa.

> Ak chcete odpočúvať vysielanie nepriateľa na zobratej vysielačke dlhého dosahu (batoh),  je doporučené byť vo vlastnom vozidle. V takomto prípade môžete odpočúvať nepriateľské vysielanie pomocou zabratej vysielačky (batoh) a zároveň používať svoju vlastnú vysielačku vo vozidle a komunikovať so svojimi spoluháčmi.

####Potápači
* Pod vodou nemôžete rozprávať (okre iného máte na sebe aj potápačský oblek). Avšak, v tesnej blízkosti váš spoločník môže počuť nejakú nezreteľnú reč (výnimka je — ak ste pod vodou v izolovanom vozidle — ponorke).
* Ak ste pod vodou, môžete slabo počuť tlmené hlasy zo súše.
* Použite vysielačky určené na použitie pod vodou pre komunikáciu medzi potápačmi.
* Pod vodou nie je možné používať štandardnú rádiovú komunikáciu (ani počúvať ani hovoriť). Ak chcete odvysielať nejakú správu na povrch — musíte tak spraviť nad hladinou. Výnimka je ponorka v hĺbke periskopu (potápači môžu použiť vysielačku s dlhým dosahom tam).

###Prevádzkové režimy
Plugin podporuje dva prevádzkové režimy — **reálny** a **jednoduchý** režim.

* **Jednoduchý** je predvolený režim. Je určený predovšetkým pre kooperatívne hry. Jeho zvláštnosťou je, že použitím pluginu v tomto režime hráči počujú tých ktorí sú mŕtvi, používateľov ktorí nehrajú, tých ktorí hrajú na inom serveri a takisto tých ktorí hrajú bez pluginu prípadne nechcú použivať vysielačky (používanie je rovnaké ako TeamSpeak). To robí hry proti ľuďom menej pohodlné, ale umožňuje vašim priateľom ľahko zistiť, kde hráte, aká je vaša frekvencia, atď. Samozrejme, že tí, ktorí hrajú na rovnakom serveri s aktivovanými addonmi a pluginom sa počujú navzájom v súlade s "rádioprotokolom" — s prihliadnutím na frekvenciu a vzdialenosti.

* **Reálny** režim určené pre hry, kde hráči vystupujú proti ostatným hráčom. Ak ho chcete aktivovať, musíte vytvoriť TeamSpeak kanál s názvom `TaskForceRadio` (heslo do kanálu – `123`). Hráči si musia zapnúť a povoliť plugin v TS3 klientovi tak ako bolo spomenuté vyššie v tomto návode. Na začiatku eventu alebo akcie na serveri sa dohodnú čo budú hrať a podobne a hneď po pripojení na herný server a zapojenia sa do hry budú pluginom automaticky prehodení do `TaskForceRadio` kanálu na TS. V prípade použitia tohoto režimu, bude počuť iba "živých" hráčov s povoleným pluginom a hrajúcich na rovnakom serveri. Mŕtvi hráči, naopak, môžu vzájomne komunikovať. V prípade respawnu mŕtveho hráča — bude tento počuť len živých hráčov znova. Po skončení hry budú automaticky hráči prehodení pluginom do kanálu na TeamSpeaku tak ako boli pred začatím misie.

###Riešenie problémov
* `Pipe error 230` — s najväčšou pravdepodobnosťou ste zabudli povoliť plugin v TeamSpeaku.
* V TS je plugin červený a nie je aktivovaný — je potrebné aktualizovať TeamSpeak klienta.
* Skúste znovu načítať (reload) plugin.
* <kbd>Caps Lock</kbd> nefunguje v hre — možno preto, že máte "hernú" klávesnicu, kde <kbd>Caps Lock</kbd> kód je iný. Skúste zmeniť kód alebo klávesu za inú (úpravovu `userconfig`).
* Ak kvôli nejakej chybe alebo niečomu inému nepočujete ostatných hráčov, aj mimo hru, otvorte si nastavenia TS3 klienta a nastavte si S`etup 3D Sound` a kliknite na `Center All`.
* Pre elimináciu možných chýb s pluginom, vývojári môžu potrebovať súbor logov z TeamSpeak klienta. Na to aby ste skopírovali súbor s logmi vyberte si v TS3 klientovi `Tools> Client Log`, zaškrtnite všetky políčka vyššie a vyberte všetko pomocou <kbd>Ctrl</kbd>+<kbd>A</kbd> a skopírujte to do schránky.
* Ak TeamSpeak prestane pracovať (Bože chráň!) pri používaní pluginu — zobrazí sa vo Windowse okno s popisom chyby a cestou ku dump súboru TS3 klienta. Boli by sme veľmi vďační za zaslanie tohoto súboru aby sme mohli pracovať na odstránení prípadných problémov.

####Pre tvorcov misií
* Triedy vysielačiek s dlhým dosahom: `tf_rt1523g`,`tf_mr3000`,`tf_anprc155`. Je možné pridať hráčom v editore týmto spôsobom: `this addBackpack "tf_rt1523g";`
* Ak chcete zakázať automatickú dostribúciu vysielačiek s dlhým dosahom, pridajte nasledujúci riadok do `init.sqf`: `tf_no_auto_long_range_radio = true`
* Ak chcete zmeniť šifrovacie kódy používané frakciami (aby viaceré frakcie mohli hovoriť), pridajte nasledujúci kód: `tf_west_radio_code = "_bluefor";tf_east_radio_code = "_opfor"; tf_guer_radio_code = "_independent"; `. Ak chcete povoliť dvom frakciám kontaktovať jeden druhého rádiom, musia mať rovnaký šifrovací kód (budete musieť zmeniť hodnoty).

* Ak chcete nastaviť hráčovi nejakú aktívnu frekvenciu vysielačky, môžete použiť : `"34.5" call tf_setLongRangeRadioFrequency"`, `"123.5" call tf_setPersonalRadioFrequency`.
* V predvolenom nastavení všetci hráči v rovnakej skupine majú rovnaké frekvencie. Ak chcete nastaviť rovnaké frekvencie pre frakcie: `tf_same_sw_frequencies_for_side = true;`.
* V predvolenom nastavení všetky hráči frakcie majú rovnaké frekvencie vysielačiek s dlhým dosahom. Ak chcete zakázať túto funkciu (nastavenie rovnakej frekvencie vysielačiek s dlhým dosahom iba pre skupiny) použite: `tf_same_lr_frequencies_for_side = false`.
* Použitím `call generateSwSetting` a `call generateLrSettings` môžete taktiež vygenerovať náhodné nastavenia pre osobné vysielačky aj vysielačky s dlhým dosahom. Výsledkom je pole: `[active_channel, volume, frequencies..of..channels, reserved, stereo_setting]`. Takéto polia sa používajú vo funkciách nižšie.
* Nastavte hodnoty `tf_freq_west`, `ft_freq_east` a `tf_freq_guer` spoločne s `tf_same_sw_frequencies_for_side = true` aby ste prednastavili osobné vysielačky pre frakciu. Podobne tiež  `tf_freq_west_lr`, `ft_freq_east_lr` a `ft_freq_east_lr` spolu s `tf_same_lr_frequencies_for_side = true`.
* Nastavte hodnoty `(group _player) setVariable["tf_lr_frequency", _value, true]` spolu s `tf_same_lr_frequencies_for_side = false` aby ste prednastavili vysielačky s dlhým dosahom pre nejakú skopinu. Podobne aj `tf_sw_frequency` spoločne s `tf_same_sw_frequencies_for_side = false`.
* `call tf_getTeamSpeakServerName` — nám dá meno TeamSpeak servera, `call tf_getTeamSpeakChannelName` — nám dá meno TeamSpeak kanála, `call tf_isTeamSpeakPluginEnabled` — je TeamSpeak plugin aktívny.
* `tf_radio_channel_name` a `tf_radio_channel_password` — zmena hesla a názvu kanálu pre použite pluginu v reálnom móde.
* Ak chcete vynútiť stranu pre vozidlo: `_vehicle setVariable ["tf_side", _value, true]`. Možné hodnoty: `"west"`, `"east"`, `"guer"`.

####Pre administrátorov TS
Ak chcete bezpečne používať plugin na TS3 serveri nastavte flood protection — `klik pravým tlačítkom myši na server> Edit Virtual Server> More> Anti Flood`, nastavte hodnoty `30`, `300`, `3000` (od hora dole).

####Pre vývojárov
Ak sa tato implementácia niekdy stane populárnou bolo by dobré, keby sa dokázalo zamedziť nekompatibilite. Z tohto dôvodu ak by niekto chcel prispieť do tohto projektu, kľudne ma kontaktujte — je veľmi pravdepodobné, že vaša implementácia bude začlenená spolu s ostatnými vylepšeniami. Tešíme na [prípadnú spoluprácu](https://github.com/michail-nikolaev/task-force-arma-3-radio/pulls?q=is%3Apr+is%3Aclosed).

###Veľká vďaka patrí
* [Task Force Arrowhead](http://forum.task-force.ru/) squad za testovanie, podporu, trpezlivosť a všetku pomoc.
* [MTF](http://forum.task-force.ru/index.php?action=profile;u=7) ([varzin](https://github.com/varzin)) za pomoc s grafikou a dokumentáciou.
* [Hardckor ](http://forum.task-force.ru/index.php?action=profile;u=14) za pomoc s grafikou.
* [Shogun](http://forum.task-force.ru/index.php?action=profile;u=13) za pomoc s grafikou.
* [Blender](http://arma3.ru/forums/index.php/user/41-blender/) za písma.
* [vinniefalco](https://github.com/vinniefalco) za  [DSP Filter](https://github.com/vinniefalco/DSPFilters).
* [WOG](http://wogames.info/) a [TRUE](http://wogames.info/profile/TRUE/) osobne za pomoc pri testovaní.
* [Music DSP Collection](https://github.com/music-dsp-collection) za kompresor.
* [Avi](http://arma3.ru/forums/index.php/user/715-avi/) za preskúmanie kódu.
* [Vaulter](http://arma3.ru/forums/index.php/user/1328-vaulter/) ([GitHub](https://github.com/andrey-zakharov)) za pomoc pri vývoji.
* Dina za preklad.
* [Zealot](http://forums.bistudio.com/member.php?125460-zealot111) ([GitHub](https://github.com/Zealot111)) za pomoc pri vývoji a užitočné skripty.
* [NouberNou](http://forums.bistudio.com/member.php?56560-NouberNou) za rady a súťaživosť.
* [Megagoth1702](http://forums.unitedoperations.net/index.php/user/2271-megagoth1702/) za jeho predchádzajúcu prácu - emuláciu zvukov z vysielačiek.
* [Naught](http://forums.unitedoperations.net/index.php/user/6555-naught/) za preskúmanie kódu.
* [Andy230](http://forums.bistudio.com/member.php?100692-Andy230) za preklad.
* [Tourorist](https://github.com/Tourorist) za pomoc s dokumentáciou.
* [marc_book](https://github.com/MarcBook)
* Každému kto robil video alebo článok s recenziou modu.
* Všetkým užívateľom (hlavne tým, ktorí hlásia chyby modu).
* Ospravedlňte ma, ak som niekho náhodou zabudol.
