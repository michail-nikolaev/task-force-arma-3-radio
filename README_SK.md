Task Force Arma 3 radio
=======================

Arma 3 Team Speak Radio Plugin
_v0.9.1 (2014-05-05)_

**<font color="green">TeamSpeak 3.0.14 je podprt</font>**

###Inštalácia

* Stiahnite si a rozbaľte [0.9.2 radio archív](https://github.com/michail-nikolaev/task-force-arma-3-radio/raw/master/releases/0.9.2.zip).
* Skopírujte `TeamSpeak 3 Client` obsah adresára do hlavného adresára s nainštalovaným TeamSpeak klientom.
* Skopírujte `Arma 3` obsah adresára do `...\SteamApps\common\Arma 3 adresára`.    

> Task Force radio využíva CBA (Community Base Addons), ak už máte nainštalované CBA, Windows sa vás pri kopírovaní spýta na prepísanie adresára CBA.


###Konfigurácia

* Uistite sa že `Caps Lock` klávesu nepoužívate v TS3 klientovi ako "push-to-talk"      
* Vypnite si v hre Arma 3 "voice over network" (VON), prípadne si zmeňte na niečo iné ako `Caps Lock` (aby ste sa vyvarovali duplicitnému prenosu hlasu).       
* Otvorte si zoznam pluginov v TeamSpeak 3 klientovi:`Settings > Plugins`.
  1. Povoľte `Task Force Arma 3 Radio`.
  2. Doporučuje sa vypnúť `ACRE` a `radio ts ARMA3.ru` ak ich máte nainštalované, aby ste sa vyhli prípadným konfliktom s pluginmi.
  3. V každom prípade použite tlačidlo `Reload All` aby ste mohli reštartovať všetky pluginy.
* Uistite sa, že máte nastavenú hlasitosť upozornení v TS3 klientovi : `Options > Payback > Sound Pack Volume` - nastavte si "plusovú" hodnotu.
* Spustite hru s módmi `@CBA_A3` & `@task_force_radio`  (Community Base Addons: A3 Beta & Task Force Radio). Môžete to spraviť tak, že si pridáte mená modov do zástupcu na ploche za EXE súbor `…\arma3.exe -mod=@CBA_A3;@task_force_radio`, prípadne si povolíte/zapnete dané mody v nastaveniach hry (`Settings -> Expansions`).
* Pripojte sa na TS do rovnakého kanálu s ostanými hráčmi, prípadne budete autoamticky presunutí do kanálu `TaskForceRadio`, ak taký existuje na TS3 serveri, hneď po spustení hry a pripojení sa na server.

> Ak nepoužívate rovnaký "nick" v hre a na TS, plugin vám počas hry zmení nick na rovnaký ako máte v hre.

> Váš nick v hre musí obsahovať aspoň 3 znaky a nesmie obsahovať znak `@`.

> Nedoporučuje sa používať TS3 klienta na "multi-pripojenia" na viacero TS3 serverov súčasne.

> Doporučuje sa vypnúť v TS3 klientovi výstražné zvuky: `Options> Notifications> Sound Pack: "Sounds Deactivated"`. Aby sa zmeny prejavili je potrebné reštartovať TS3 klienta.


###Používanie

| Klávesy | Akcia |
| --- | --- |
| Push-to-talk klávesa v TS3 klientovi | Priame hovorenie. |
| `Caps Lock` | Hovorenie do vysielačky. |
| `CTRL`&nbsp;+&nbsp;`Caps Lock` | Hovorenie do vysielačky s dlhým dosahom. |
| `CTRL`&nbsp;+&nbsp;`P` | Otvorí rozhranie osobnej vysielačky (vysielačka musí byť v inventári). V prípade, že máte niekoľko vysielačiek v inventári - môžete si vybrať to ktoré potrebujete. Je tiež možné nastaviť vysielačku ako aktívnu (tú, ktorú budete používať). |
| `NUM[1-8]` | Rýchle prepínanie kanálov na osobnej vysielačke. | 
| `ALT`&nbsp;+&nbsp;`P` | Otvorí rozhranie vysielačky s dlhým dosahom (vysielačku s dlhým dosahom musíte mať na na chrbte namiesto batohu, alebo by ste mali byť vo vozidle v pozícii vodiča, strelca, pilota alebo pilota asistenta).  Ak je k dispozícii viacero vysielačiek - otvorí sa vám ponuka na výber jednej z nich, ktorú budete používať ako aktívnu. |
| `CTRL`&nbsp;+&nbsp;`NUM[1-9]` | Rýchle prepínanie kanálov na vysielačke dlhého dosahu. |
| `CTRL`&nbsp;+&nbsp;`TAB` | Zmena hlasitosti priamej reči. Môžete hovoriť: šepkať, normálne alebo kričať. Nemá vplyv na hlasitosť signálu v rádiovom prenose. |
| `SHIFT`&nbsp;+&nbsp;`P` | Ak chcete otvoriť rozhranie vysielačky použiteľnej pod vodou (mali by ste mať na sebe dýchací prístroj). | 
| `ALT`&nbsp;+&nbsp;`Caps Lock` | Hovorenie do vysielačky použiteľnej pod vodou. |
| `ESC` | Odísť z rozhrania vysielačky. |

> Môžete si nakonfigurovať klávesy v konfiguračnom súbore, ktorý možno nájsť v priečinku hry `...\Arma 3\userconfig\task_force_radio\radio_keys.hpp`. Tento súbor je editovateľný v Notepad-e.
  
###Informácie

#####Vysielačky

| Vysielačka | Strana | Rozsah/Dosah | Návod na používanie |
| --- | --- | --- | --- | 
| Vysielačka [AN/PRC-152](http://en.wikipedia.org/wiki/AN/PRC-152) (osobná) | <font color="blue">BLUEFOR<font> | 30-512Mhz / 3 km | Ak chcete zmeniť frekvenciu, stlačte `CLR`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel so šipkami (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou `PRE+` a `PRE-` tlačítok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `0`.| 
| Vysielačka [RT-1523G (ASIP)](http://en.wikipedia.org/wiki/SINCGARS#Models) (s dlhým dosahom) | <font color="blue">BLUEFOR<font> | 30-87Mhz / 20 km | 20 km	Ak chcete zmeniť frekvenciu, stlačte `MENU CLR`, zadajte hodnotu (na klávesnici) a potvrďte `FREQ`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel jednotlivých kanálov na vysielačke (celkovo 9 kanálov). Hlasitosť vysielačky môžete meniť pomocou `TIME` a `BATT CALL` tlačítok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `STO`.|
| Vysielačka [AN/PRC148-JEM](https://www.thalescomminc.com/ground/anprc148-jem.asp) (osobná) | <font color="green">INDEPENDENT</font> | 30-512Mhz / 3 km | Ak chcete zmeniť frekvenciu, stlačte `ESC`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel so šipkami (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou `MOD` a `GR` tlačítok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `ALT`.| 
| Vysielačka [AN/PRC-155](http://www.gdc4s.com/anprc-155-2-channel-manpack.html) (s dlhým dosahom)| <font color="green">INDEPENDENT</font>  | 30-87Mhz / 20 km | Ak chcete zmeniť frekvenciu, stlačte `ESC`, zadajte hodnotu (na klávesnici) a potvrďte `MENU`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel so šípkami (hore & dole). Hlasitosť vysielačky môžete meniť pomocou tlačidla reproduktora. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `PRE`.|
| Vysielačka [FADAK](http://www.military.com/video/forces/military-foreign-forces/iran-unveils-3-new-military-products/2363087176001/) (osobná) |  <font color="red">OPFOR</font> | 30-512Mhz / 3 km | Ak chcete zmeniť frekvenciu, stlačte `CLR`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel `SET` a `PWR` (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou `DATA` a `SEND` tlačidiel. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `0`.| 
| Vysielačka [MR3000](http://www.railce.com/cw/casc/rohde/m3tr.htm) (s dlhým dosahom) | <font color="red">OPFOR</font> | 30-87Mhz / 20 km | Ak chcete zmeniť frekvenciu, stlačte `CLR ESC`, zadajte hodnotu (na klávesnici) a potvrďte `ENT`. Takisto si môžete prepínať kanály na vysielačke pomocou tlačidiel jednotlivých kanálov alebo horizontálnych šípok (celkovo 8 kanálov). Hlasitosť vysielačky môžete meniť pomocou vertikálne umiestnených šipok. Môžete tiež zmeniť stereo nastavenie stlačením tlačidla `0`.| 
| Pod vodou použiteľná vysielačka | Všetky | 32-41kHz / 70-300 m. (závislá od veľkosti vĺn) | Ak chcete zmeniť frekvenciu, stlačte `MODE`, zadajte hodnotu (na klávesnici) a potvrďte `ADV`. Hlasitosť vysielačky môžete meniť pomocou tlačidiel umiestných na pravej strane vysielačky. | 


> Vysielačky krátkeho a dlhého dosahu jednotlivej frakcie podporujú rovnaký protokol, takže dokážu spolu komunikovať. Ak je prenos vysielaný z vysielačky s krátkym dosahom, zvuk je prenášaný na vysokej frekvencii. V prípade prenosu z vysielačky s dlhým prenosom, bude zvuk nízkofrekvenčný.

#####Distribúcia vysielačiek
* Štandardne je vysielačka dlhého dosahu automaticky pridelená vedúcim družstiev namiesto batohu (squad leaderom). Ak má hráč na sebe batoh – ten je automaticky hodený na zem.

* Osobná vysielačka krátkeho dosahu je daná hráčom do výbavy ak majú `ItemRadio` v inventári. Distribúcia vysielačiek môže trvať niekoľko sekúnd (sledujte správy v strede obrazovky).

#####Vozidlá
* Vysielačka s dlhým dosahom je k dispozícii pre vodiča, veliteľa, strelca, pilota a kopilota. Nie však všetky vozidlá podporujú zabudované vysielačky.

* Každý slot vo vozidle má vlastnú vysielačku, ktorá musí byť nakonfigurovaná samostatne. Ak plánujete meniť pozície vo vozidle - treba nakonfigurovať všetky vysielačky vo všetkých pozíciách dopredu (napr. na pozícii vodiča alebo strelca).

* Vozidlá sa delia na skupiny otovrené a uzavreté (izolované). Ak ste v izolovanom vozidle, nebudete počuť žiadne hlasy z vonku (a naopak). Avšak ak vystúpite z vozidla, budete počuť hlasy vonku a takisto aj z vozidla.

#####Odpočúvanie vysielačiek

* Vysielačka môže byť zobratá a použitá z mŕtvol iných spoluhráčov. Všetky nastavenia na nej ostávajú uložené (kanály, frekvencie, hlasitosť) tak ako boli nastavené predtým iným spoluhráčom.

> Je doporučené nastavovať si vysielačky pri bedni kde sa nachádzajú (aby sa nestalo, že vám kvoli chybe hry zmizne z inventára).

* Nastavenie vysielačiek vo vozidlách sa takisto ukladá a zostáva zachované.
* V predvolenom nastavení vysielačiek každú frakcia používa svoje vlastné šifrovacie kódy, takže nebudete počuť nepriateľské vysielanie, takisto ani nezistíte nastavenie frekvencie nepriateľa. Ak chcete odpočúvať vysielanie nepriateľa (a vysielať na ich frekvencii) - je nutné akýmkoľvek spôsobom zmocniť sa vysielačky nepriateľa. 

> Ak chcete odpočúvať vysielanie nepriateľa na zobratej vysielačke dlhého dosahu (batoh),  je doporučené byť vo vlastnom vozidle. V takomto prípade môžete odpočúvať nepriateľské vysielanie pomocou zabratej vysielačky (batoh) a zároveň používať svoju vlastnú vysielačku vo vozidle a komunikovať so svojimi spoluháčmi.

#####Potápači
* Pod vodou nemôžete rozprávať (okre iného máte na sebe aj potápačský oblek). Avšak, v tesnej blízkosti váš spoločník môže počuť nejakú nezreteľnú reč (výnimka je - ak ste pod vodou v izolovanom vozidle - ponorke).
* Ak ste pod vodou, môžete slabo počuť tlmené hlasy zo súše.
* Použite vysielačky určené na použitie pod vodou pre komunikáciu medzi potápačmi.
* Pod vodou nie je možné používať štandardnú rádiovú komunikáciu (ani počúvať ani hovoriť). Ak chcete odvysielať nejakú správu na povrch - musíte tak spraviť nad hladinou. Výnimka je ponorka v hĺbke periskopu (potápači môžu použiť vysielačku s dlhým dosahom tam).

#####Prevádzkové režimy pluginu
Plugin podporuje dva prevádzkové režimy - **reálny** a **jednoduchý režim**.

* **Jednoduchý režim** — je predvolený režim. Je určený predovšetkým pre kooperatívne hry. Jeho zvláštnosťou je, že použitím pluginu v tomto režime hráči počujú tých ktorí sú mŕtvi, používateľov ktorí nehrajú, tých ktorí hrajú na inom serveri a takisto tých ktorí hrajú bez pluginu prípadne nechcú použivať vysielačky (používanie je rovnaké ako TeamSpeak). To robí hry proti ľuďom menej pohodlné, ale umožňuje vašim priateľom ľahko zistiť, kde hráte, aká je vaša frekvencia, atď. Samozrejme, že tí, ktorí hrajú na rovnakom serveri s aktivovanými addonmi a pluginom sa počujú navzájom v súlade s "rádioprotokolom"  - s prihliadnutím na frekvenciu a vzdialenosti.

* **Reálny režim** — určené pre hry, kde hráči vystupujú proti ostatným hráčom. Ak ho chcete aktivovať, musíte vytvoriť TeamSpeak kanál s názvom `TaskForceRadio` (heslo do kanálu – `123`). Hráči si musia zapnúť a povoliť plugin v TS3 klientovi tak ako bolo spomenuté vyššie v tomto návode. Na začiatku eventu alebo akcie na serveri sa dohodnú čo budú hrať a podobne a hneď po pripojení na herný server a zapojenia sa do hry budú pluginom automaticky prehodení do `TaskForceRadio` kanálu na TS. V prípade použitia tohoto režimu, bude počuť iba "živých" hráčov s povoleným pluginom a hrajúcich na rovnakom serveri. Mŕtvi hráči, naopak, môžu vzájomne komunikovať. V prípade respawnu mŕtveho hráča - bude tento počuť len živých hráčov znova. Po skončení hry budú automaticky hráči prehodení pluginom do kanálu na TeamSpeaku tak ako boli pred začatím misie.

#####Riešenie problémov
* `Pipe error 230` - s najväčšou pravdepodobnosťou ste zabudli povoliť plugin v TeamSpeaku.
* V TS je plugin červený a nie je aktivovaný - je potrebné aktualizovať TeamSpeak klienta.
* Skúste znovu načítať (reload) plugin.
* `Caps Lock` nefunguje v hre - možno preto, že máte "hernú" klávesnicu, kde `Caps Lock` kód je iný. Skúste zmeniť kód alebo klávesu za inú (úpravovu `userconfig`).
* Ak kvôli nejakej chybe alebo niečomu inému nepočujete ostatných hráčov, aj mimo hru, otvorte si nastavenia TS3 klienta a nastavte si S`etup 3D Sound` a kliknite na `Center All`.
* Pre elimináciu možných chýb s pluginom, vývojári môžu potrebovať súbor logov z TeamSpeak klienta. Na to aby ste skopírovali súbor s logmi vyberte si v TS3 klientovi `Tools -> Client Log`, zaškrtnite všetky políčka vyššie a vyberte všetko pomocou `CTRL A` a skopírujte to do schránky.
* Ak TeamSpeak prestane pracovať (Bože chráň!) pri používaní pluginu - zobrazí sa vo Windowse okno s popisom chyby a cestou ku dump súboru TS3 klienta. Boli by sme veľmi vďační za zaslanie tohoto súboru aby sme mohli pracovať na odstránení prípadných problémov.

#####Pre tvorcov misií
* Triedy vysielačiek s dlhým dosahom: `tf_rt1523g`,`tf_mr3000`,`tf_anprc155`. Je možné pridať hráčom v editore týmto spôsobom: `this addBackpack "tf_rt1523g";`
* Ak chcete zakázať automatickú dostribúciu vysielačiek s dlhým dosahom, pridajte nasledujúci riadok do `init.sqf`: `tf_no_auto_long_range_radio = true`
* Ak chcete zmeniť šifrovacie kódy používané frakciami (aby viaceré frakcie mohli hovoriť), pridajte nasledujúci kód: `tf_west_radio_code = "_bluefor";tf_east_radio_code = "_opfor"; tf_guer_radio_code = "_independent"; `. Ak chcete povoliť dvom frakciám kontaktovať jeden druhého rádiom, musia mať rovnaký šifrovací kód (budete musieť zmeniť hodnoty).

* Ak chcete nastaviť hráčovi nejakú aktívnu frekvenciu vysielačky, môžete použiť : `"34.5" call tf_setLongRangeRadioFrequency"`, `"123.5" call tf_setPersonalRadioFrequency`.
* V predvolenom nastavení všetci hráči v rovnakej skupine majú rovnaké frekvencie. Ak chcete nastaviť rovnaké frekvencie pre frakcie: `tf_same_sw_frequencies_for_side = true;`.
* V predvolenom nastavení všetky hráči frakcie majú rovnaké frekvencie vysielačiek s dlhým dosahom. Ak chcete zakázať túto funkciu (nastavenie rovnakej frekvencie vysielačiek s dlhým dosahom iba pre skupiny) použite: `tf_same_lr_frequencies_for_side = false`.
* Použitím `call generateSwSetting` a `call generateLrSettings` môžete taktiež vygenerovať náhodné nastavenia pre osobné vysielačky aj vysielačky s dlhým dosahom. Výsledkom je pole: `[active_channel, volume, frequencies..of..channels, reserved, stereo_setting]`. Takéto polia sa používajú vo funkciách nižšie.
* Nastavte hodnoty `tf_freq_west`, `ft_freq_east` a `tf_freq_guer` spoločne s `tf_same_sw_frequencies_for_side = true` aby ste prednastavili osobné vysielačky pre frakciu. Podobne tiež  `tf_freq_west_lr`, `ft_freq_east_lr` a `ft_freq_east_lr` spolu s `tf_same_lr_frequencies_for_side = true`.
* Nastavte hodnoty `(group _player) setVariable["tf_lr_frequency", _value, true]` spolu s `tf_same_lr_frequencies_for_side = false` aby ste prednastavili vysielačky s dlhým dosahom pre nejakú skopinu. Podobne aj `tf_sw_frequency` spoločne s `tf_same_sw_frequencies_for_side = false`.
* `call tf_getTeamSpeakServerName` - nám dá meno TeamSpeak servera, `call tf_getTeamSpeakChannelName` - nám dá meno TeamSpeak kanála, `call tf_isTeamSpeakPluginEnabled` - je TeamSpeak plugin aktívny.
* `tf_radio_channel_name` a `tf_radio_channel_password` - zmena hesla a názvu kanálu pre použite pluginu v reálnom móde.
* Ak chcete vynútiť stranu pre vozidlo: `_vehicle setVariable ["tf_side", _value, true]`. Možné hodnoty: `"west"`, `"east"`, `"guer".

#####Pre administrátorov TeamSpeak serverov
Ak chcete bezpečne používať plugin na TS3 serveri nastavte flood protection: `Klik pravým tlačítkom myši na server> Edit Virtual Server> More> Anti Flood`, nastavte hodnoty 30, 300, 3000 (od hora dole).


#####Pre vývojárov
Ak sa tato implementácia niekdy stane populárnou bolo by dobré, keby sa dokázalo zamedziť nekompatibilite. Z tohto dôvodu ak by niekto chcel prispieť do tohto projektu, kľudne ma kontaktujte - je veľmi pravdepodobné, že vaša implementácia bude začlenená spolu s ostatnými vylepšeniami. Teším na prípadnú spoluprácu. :)

#####Veľká vďaka patrí
* [Task Force Arrowhead](http://forum.task-force.ru/) squad za testovanie, podporu, trpezlivosť a všetku pomoc.
* [MTF](http://forum.task-force.ru/index.php?action=profile;u=7) ([varzin](https://github.com/varzin)) za pomoc s grafikou a dokumentáciou.
* [Hardckor ](http://forum.task-force.ru/index.php?action=profile;u=14) za pomoc s grafikou.
* [Shogun](http://forum.task-force.ru/index.php?action=profile;u=13) za pomoc s grafikou.
* [Blender](http://arma3.ru/forums/index.php/user/41-blender/) za písma.
* [vinniefalco](https://github.com/vinniefalco) za  [DSP Filter](https://github.com/vinniefalco/DSPFilters).
* [WOG](http://wogames.info/) a [TRUE](http://wogames.info/profile/TRUE/) osobne za pomoc pri testovaní.
* [Music DSP Collection](https://github.com/music-dsp-collection) za kompresor.
* [Avi](http://arma3.ru/forums/index.php/user/715-avi/) za preskúmanie kódu.
* [andrey-zakharov](https://github.com/andrey-zakharov) ([Vaulter](http://arma3.ru/forums/index.php/user/1328-vaulter/)) za pomoc pri vývoji.
* Dina za preklad.
* [Zealot](http://forums.bistudio.com/member.php?125460-zealot111) za pomoc pri vývoji a užitočné skripty.
* [NouberNou](http://forums.bistudio.com/member.php?56560-NouberNou) za rady a súťaživosť.
* [Megagoth1702](http://forums.unitedoperations.net/index.php/user/2271-megagoth1702/) za jeho predchádzajúcu prácu - emuláciu zvukov z vysielačiek.
* [Naught](http://forums.unitedoperations.net/index.php/user/6555-naught/) za preskúmanie kódu.
* [Andy230](http://forums.bistudio.com/member.php?100692-Andy230) za preklad.
* Každému kto robil video alebo článok s recenziou modu.
* Všetkým užívateľom (hlavne tým, ktorí hlásia chyby modu).
* Ospravedlňte ma, ak som niekho náhodou zabudol.