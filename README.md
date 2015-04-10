<h1 align="center">Task Force Arma 3 Radio</h1>
<p align="center">
<img src="https://raw.githubusercontent.com/Tourorist/TPS/master/tfar/tfar_manw.jpg"
     width="572px" /><br />
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/wiki">
    <img src="https://img.shields.io/badge/TFAR-Вики-orange.svg?style=flat"
         alt="Вики" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases">
    <img src="http://img.shields.io/badge/Версия-0.9.7.1-blue.svg?style=flat"
         alt="Версия" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7.1/0.9.7.1.zip">
    <img src="http://img.shields.io/badge/Скачать-126_МБ-green.svg?style=flat"
         alt="Скачать" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/blob/master/LICENSE.md">
    <img src="http://img.shields.io/badge/Лицензия-APL--SA-red.svg?style=flat"
         alt="Лицензия" />
  </a>
  <a href="https://github.com/michail-nikolaev/task-force-arma-3-radio/issues">
    <img src="http://img.shields.io/github/issues-raw/michail-nikolaev/task-force-arma-3-radio.svg?label=Задачи&style=flat"
         alt="Задачи" />
  </a>
  <a href="http://forums.bistudio.com/showthread.php?169029-Task-Force-Arrowhead-Radio&p=2563136&viewfull=1#post2563136">
    <img src="https://img.shields.io/badge/BIF-Тема-lightgrey.svg?style=flat"
         alt="BIF Тема" />
  </a>
  </p>
<p align="center">
<sup><strong>Arma 3 аддон рации <a href="http://www.teamspeak.com/">Тимспика</a>. TFAR победил в своей категории на конкурсе <a href="http://makearmanotwar.com/entry/pMP8c7vSS4">Make Arma Not War</a>.</strong></sup>
</p>

###Установка
1. Скачайте [архив с рацией 0.9.7.1](https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.7.1/0.9.7.1.zip) и распакуйте его.
2. Скопируйте содержимое папки `TeamSpeak 3 Client` в корневую папку Тимспика.
3. Скопируйте содержимое папки `Arma 3` в папку с игрой — `...\SteamApps\common\Arma 3`.

> Все выпуски [TFAR](http://radio.task-force.ru/) содержат последнюю версию [СBA](http://www.armaholic.com/page.php?id=18767) — Community Base Addons. В случае если у вас CBA уже установлен, но вы не уверены какой версии, тогда лучше разрешить Windows заменить существующую папку.

###Настройка
1. Убедитесь, что Тимспик не использует клавишу <kbd>Caps Lock</kbd> для разговора.
2. В настройх игры, чтобы не двоиться, отключите разговор по внутренней связи (VON), или поменяйте его использование с <kbd>Caps Lock</kbd> на любую другую клавишу.
3. В Тимспике, откройте список плагинов – `Settings> Plugins`.
 1. Включите `Task Force Arma 3 Radio`.
 2. Отключите `ACRE` и другие подобные аддоны раций, если они у вас есть, чтобы избежать возможных конфликтов.
 3. Нажмите кнопку `Reload All` (внизу, слева) для перезагрузки всех текущих плагинов.
4. Убедитесь, что в Тимпсике не отключена громкость оповещений – `Options> Payback> Sound Pack Volume` – установите в положительное значение.
5. Запустите игру со включенными `@CBA_A3` и `@task_force_radio` аддонами. Это можно сделать прописав их названия в ярлык игры, либо сразу после `exe` файла — `…\arma3.exe -mod=@CBA_A3;@task_force_radio`. Тем не менее, собственное меню игры (`Settings> Expansions`) является более предпочтительным методом настройки.
6. В Тимспике, присоединяйтесь на тот же канал что и другие игроки с рацией. Играя в серьёзном режиме, на сервере будет канал под названием `TaskForceRadio`, куда по началу общей миссии все участвующие игроки будут переброшены автоматически.

> Во время игры, TFAR поменяет ваш никнейм в Тимспике на то же что и в текущем профиле игры. Убедитесь что ваш игровой ник имеет не менее 3-ех символов.
>
> TFAR не рекомендуется использовать при одновременном подключении к нескольким серверам Тимспика.
>
> Рекомендуется отключить встроенные в Тимспик звуки оповещений – `Options> Notifications> Sound Pack: «Sounds Deactivated»`. Для применения этой опции Тимспик необходимо перезапустить.

###Использование
| Клавиши | Действие |
| :--- | :--- |
| Кнопка&nbsp;разговора&nbsp;в&nbsp;ТС | Прямая речь. |
| <kbd>Caps Lock</kbd> | Разговор по рации ближней связи. |
| <kbd>Ctrl</kbd>+<kbd>Caps Lock</kbd> | Разговор по рации дальней связи. |
| <kbd>Ctrl</kbd>+<kbd>P</kbd> | Открыть интерфейс рации ближней связи (рация должна быть в слоте инвентаря). Если у вас в наличии несколько раций, то сперва появляется меню выбора. Также, есть возможность установить рацию как активную (ту, которая будет использоваться для передачи). Кроме того, существует возможность скопировать настройки для раций и другой радиостанции, если она использует аналогичный код шифрования.
| <kbd>Num [1-8]</kbd> | Быстрое переключение каналов рации ближней связи. |
| <kbd>Alt</kbd>+<kbd>P</kbd> | Открыть интерфейс рации дальней связи — она должна быть надета на спину, либо вы должны быть в технике за водителя, стрелка, командира или помощника пилота. Если доступно несколько раций, то сперва появляется меню выбора. Также, одну из них можно установить как активную. Кроме того, существует возможность скопировать настройки для раций и другой радиостанции, если она использует аналогичный код шифрования. |
| <kbd>Ctrl</kbd>+<kbd>Num [1-9]</kbd> | Быстрое переключение каналов рации дальней связи. |
| <kbd>Ctrl</kbd>+<kbd>Tab</kbd> | Изменить громкость прямой речи. Можно говорить шепотом (Whispering), нормально (Normal) и кричать (Yelling). Не влияет на громкость сигнала в радио передаче. |
| <kbd>Shift</kbd>+<kbd>P</kbd> | Открыть интерфейс переговорного устройства для водолазов (на вас должен быть надет ребризер). |
| <kbd>Ctrl</kbd>+<kbd>~</kbd> | Разговор по переговорному устройству для водолазов. |
| <kbd>Ctrl</kbd>+<kbd>]</kbd> | Следующая рация ближней связи. |
| <kbd>Ctrl</kbd>+<kbd>[</kbd> | Предыдущая рация ближней связи. |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>]</kbd> | Следующая рация дальней связи. |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>[</kbd> | Предыдущая рация дальней связи. |
| <kbd>Ctrl</kbd>+<kbd>[←,↑,→]</kbd> | Изменение стерео режима рации ближней связи. |
| <kbd>Alt</kbd>+<kbd>[←,↑,→]</kbd> | Изменение стерео режима рации дальней связи. |
| <kbd>T</kbd> | Передача на дополнительном канале рации командира. |
| <kbd>Y</kbd> | Передача на дополнительном канале рации дальней связи. |
| <kbd>Esc</kbd> | Выход из интерфейса рации. |

###Рации
| Рация | Сторона | Диапазон /Дальность |
| :--- | :--- | :--- |
| <kbd>[AN/PRC-152](https://ru.wikipedia.org/wiki/AN/PRC-152)</kbd><br><sup>(командира)</sup>  | <span style="color:blue">Синие</span> | 30-512 МГц<br>/5 км |
| <kbd>[RF-7800S-TR](http://rf.harris.com/capabilities/tactical-radios-networking/rf-7800s-tr.asp)</kbd><br /><sup>(бойца)</sup> | <span style="color:blue">Синие</span> | 30-512 МГц<br>/2 км |
| <kbd>[RT-1523G (ASIP)](https://en.wikipedia.org/wiki/SINCGARS#Models)</kbd><br><sup>(ранцевая)</sup> | <span style="color:blue">Синие</span> | 30-87 МГц<br>/20 км<br><sup>(30 км для бортовой)</sup> |
| <kbd>[AN/ARC-210](http://www.rockwellcollins.com/~/media/Files/Unsecure/Products/Product%20Brochures/Communcation%20and%20Networks/Communication%20Radios/ARC-210%20Integrated%20Comm%20Systems%20white%20paper.aspx)</kbd><br><sup>(авиационная)</sup> | <span style="color:blue">Синие</span> | 30-87 МГц<br>/40 км |
| <kbd>[AN/PRC148-JEM](https://en.wikipedia.org/wiki/AN/PRC-148#AN.2FPRC-148_JTRS_Enhanced_MBITR_.28JEM.29)</kbd><br><sup>(командира)</sup> | <span style="color:green">Независимые</span> | 30-512 МГц<br>/5 км |
| <kbd>[AN/PRC-154](http://www.gdc4s.com/anprc-154a-rifleman-radio.html)</kbd><br><sup>(бойца)</sup> | <span style="color:green">Независимые</span> | 30-512 МГц<br>/2 км |
| <kbd>[AN/PRC-155](http://www.gdc4s.com/anprc-155-2-channel-manpack.html)</kbd><br><sup>(ранцевая)</sup> | <span style="color:green">Независимые</span> | 30-87 МГц<br>/20 км<br><sup>(30 км для бортовой)</sup> |
| <kbd>[AN/ARC-164](https://ru.wikipedia.org/wiki/AN/ARC-164)</kbd><br><sup>(авиационная)</sup> | <span style="color:green">Независимые</span> | 30-87 МГц<br>/40 км |
| <kbd>[FADAK](http://www.iran.ru/news/politics/87228/Iran_prodemonstriroval_tri_novyh_obrazca_voennogo_naznacheniya)</kbd><br><sup>(командира)</sup> | <span style="color:red">Красные</span> | 30-512 МГц<br>/5 км |
| <kbd>[PNR-1000A](http://elbitsystems.com/Elbitmain/files/Tadiran%20PNR1000A_2012.pdf)</kbd><br><sup>(бойца)</sup> | <span style="color:red">Красные</span> | 30-512 МГц<br>/2 км |
| <kbd>[MR3000](http://www.rohde-schwarz.com/en/product/mr300xh-u-productstartpage_63493-10291.html)</kbd><br><sup>(ранцевая)</sup> | <span style="color:red">Красные</span> | 30-87 МГц<br>/20 км<br><sup>(30 км для бортовой)</sup> |
| <kbd>[MR6000L](http://www.rohde-schwarz.com/en/product/mr6000l-productstartpage_63493-9143.html)</kbd><br><sup>(авиационная)</sup> | <span style="color:red">Красные</span> | 30-87 МГц<br>/40 км |
| <kbd>Приемопередатчик</kbd><br><sup>(подводный)</sup> | Все | 32-41 кГц<br>/70-300 м<br><sup>(в&nbsp;зависимости&nbsp;от&nbsp;уровня&nbsp;волн)</sup> |

> Рации ближней связи (ручные, класса командира или бояца) и радиостанции дальнего вещания (ранцевые, бортовые, авиационные) одной фракции поддерживают единый протокол, поэтому могут связываться друг с другом. В случае если передача осуществляется по ближней – сигнал будет высокочастотным. В случае передачи по дальней – низкочастотным.

> На качество радио сигнала также влияет ландшафт местности. Наименее благоприятное положение – вы находитесь прямо за крутым холмом. Если вы начнете двигаться от края холма в направлении противоположном вещающему игроку — сигнал будет улучшаться. Наиболее благоприятная позиция — прямая видимость до или от объекта вещания.

> Рация командира и радиостанции дальней связи позволяют одновременно принимать и передавать два канала. Нажатие на рации «Настроить дополнительный канал» сделает текущий канал дополнительным. Переключившись на другой канал вы будет слышать два канала – активный и дополнительный.

####Распределение
* По умолчанию рация дальней связи выдается лидерам отрядов. Если у данного игрока изначально надет рюкзак, то он будет автоматически сброшен на землю при выдаче ему рации.

* Рация ближней связи выдается игрокам, у которых есть `ItemRadio` в инвентаре. Первоначальная раздача раций может потребовать нескольких секунд ожидания — следите за игровыми сообщениями в центре экрана.

####В технике
* Рация дальней связи доступна в технике водителю, командиру, стрелку и помощнику пилота. Не вся техника имеет бортовые радиостанции.

* У каждого слота техники своя рация, которая должна быть настроена отдельно. Если вы планируете пересаживаться с места на места в технике, то предварительно настройте рацию на всех слотах — например, на слоте водителя и на слоте стрелка.

* Техника делиться на открытую и закрытую (изолированную). Если вы находитесь в изолированной технике, то почти не будете слышать голоса снаружи (и наоборот). Однако, если вы выглянете из техники, то будете слышать как голоса внутри, так и снаружи.

####Радиоперехват
* Рации павших врагов можно подбирать и передавать союзникам. При этом, рации противника сохраняют все свои последние настройки (каналы, частоты, громкость).

> Во избежание бага с исчезновением игровых предметов, поднимать лежащие рации следует через экран инвентаря находяс прямо над их местоположением.

* Текущие настройки рации в технике также сохраняются.
* По умолчанию, все рации имеют встроенный код шифрования радиоэфира на уровне фракции. Это означает, что из-за несовместимости шифрования, настраивая даже уже известные частоты противника на собственную рацию не дает доступа к прослушке. Радиоперехват подразумевает как наличие актуальных частот противника, так и захваченную у них рацию.

> Прослушивая ранцевую радиостанцию противника предпочтительно находиться в своей технике. В таком распорядке, вы можете следить за эфиром противника через ранцевую, и передавать союзникам информацию используя бортовую радиостанцию в технике, как активную.

####Водолазам
* Вы не можете говорить голосом находясь под водой (даже в водолазном костюме). Однако на близком расстоянии ваш собеседник сможет расслышать что-либо очень невнятное (исключение: если вы под водой в изолированной технике).
* Находясь под водой, вы невнятно и слабо слышите голоса на суше.
* Для связи между водолазами используйте Переговорное устройство.
* Вы не можете пользоваться радио связью под водой (ни говорить, ни слышать). Если нужно что-то передать на сушу — всплывайте на поверхность. Исключение: подводный аппарат на перископной глубине, так как в нем водолазам можно использовать рацию дальней связи.

###Режимы работы плагина
Плагин поддерживает два режима работы — **серьезный** и **упрощенный**.

* **Упрощенный** используется по умолчанию и, по своим характеристикам, рассчитан на кооперативные игры (PvE). Его особенностью является то, что игроки с плагином и в игре слышат мертвых, не играющих, играющих на другом сервере и играющих без плагина игроков минуя рацию (просто как через Тимспик). Это делает менее удобным игры против людей, но позволяет вашему другу без проблем узнать, где вы играете, какая у вас частота и т. д. Разумеется, те кто играет на одном сервере со включенными аддонами и плагинами будут слышать друг друга по «законам» рации с учётом расстояния и частот.

* **Серьезный** предназначен в первую очередь для проведения организованных игр, где участники соперничают между собой (PvP) на уровне сторон. Чтобы включить данный режим, администратор Тимспика должен создать канал под названием `TaskForceRadio` с паролем `123`. Перед началом игры, зайдя в ТС, участники включают плагин рации, распределяются по каналам сторон и затем, присоединившись в лобби условленного сервера игры, проводят инструктаж по предстоящей миссии. Через несколько секунд после загрузки миссии, все участники будут переброшены в `TaskForceRadio` канал ТС. Находясь в котором, игроки слышат только живых игроков, со включённым плагином, играющих на том же сервере, за ту же сторону. Мёртвые игроки могут общаться только друг с другом, но при возрождении снова ограничиваются вышеуказанным образом. После окончания миссии, участники перебрасываются обратно в канал ТС где они ранее проходили инструктаж.

###Решение проблем
* `Pipe error 230` — вы скорее всего вы забыли включить плагин в Тимспике.
* Плагин в ТС показываться красным и не загружается — скорее всего, вам нужно обновить Тимспик.
* Если что-то поломалось — попробуйте перезапустить плагин.
* Функция по нажатию <kbd>Caps Lock</kbd> не работает — возможная причина в геймерской клавиатуре, где код данной клавишы отличается от стандартного. Попробуйте изменить используемые клавиши (путем редактирования <code>userconfig</code>).
* Если из-за ошибки или еще чего-то вы перестали слышать других игроков даже вне игры, в Тимспике откройте `Setup 3D Sound`и кликните `Center All`.
* Для устранения возможных ошибок с плагином разработчикам может потребоваться лог Тимспика. Чтобы его скопировать зайдите в `Tools> Client Log`, поставьте все галочки сверху и — выделив весь текст через <kbd>Ctrl</kbd>+<kbd>A</kbd> — скопируйте его в буфер обмена.
* Если Тимспик упал при использовании плагина, то он покажет окошко с описанием того где можно найти дамп (путь к файлу). Буду очень благодарен за этот файлик!

####Администраторам ТС
На всякий случай уменьшите уровень защиты от флуда — `правый клик по серверу> Edit Virtual Server> More> Anti Flood` — поставьте значения `30`, `300`, `3000` (сверху вниз).

####Разработчикам
Если данная разработка будет как-либо популярна, то хотелось бы избежать кучи несовместимых форков. По этой причине, в случае желания внесения изменений связывайтесь со мной - велика вероятность, что ваши разработки будут включены в главную ветку. Ждем [запросов на включение](https://github.com/michail-nikolaev/task-force-arma-3-radio/pulls?q=is%3Apr+is%3Aclosed) ваших изменений.

###Спасибки
* Отряду [Task Force Arrowhead](http://forum.task-force.ru/) за тестирование, поддержку, терпение и всяческую помощь.
* [MTF](http://forum.task-force.ru/index.php?action=profile;u=7) ([varzin](https://github.com/varzin)) за помощь с графикой и документацией.
* [Hardckor](http://forum.task-force.ru/index.php?action=profile;u=14) за помощь с графикой.
* [Shogun](http://forum.task-force.ru/index.php?action=profile;u=13) за помощь с графикой.
* [Блендеру](http://arma3.ru/forums/index.php/user/41-blender/) за шрифт.
* [vinniefalco](https://github.com/vinniefalco) за [DSP фильтры](https://github.com/vinniefalco/DSPFilters).
* [WOG](http://wogames.info/) и лично [TRUE](http://wogames.info/profile/TRUE/) за помощь в тестировании.
* [Music DSP Collection](https://github.com/music-dsp-collection) за компрессор.
* [Avi](http://arma3.ru/forums/index.php/user/715-avi/) за инспекцию кода.
* [Vaulter](http://arma3.ru/forums/index.php/user/1328-vaulter/) ([GitHub](https://github.com/andrey-zakharov)) за помощь в разработке.
* Дине за перевод.
* [Zealot](http://forums.bistudio.com/member.php?125460-zealot111) ([GitHub](https://github.com/Zealot111)) за помощь в разработке и полезные скрипты.
* [NouberNou](http://forums.bistudio.com/member.php?56560-NouberNou) за советы и конкуренцию.
* [Megagoth1702](http://forums.unitedoperations.net/index.php/user/2271-megagoth1702/) за свою давнюю работу по эмуляции звучания рации.
* [Naught](http://forums.unitedoperations.net/index.php/user/6555-naught/) за инспекцию кода.
* [Andy230](http://forums.bistudio.com/member.php?100692-Andy230) за перевод.
* [L-H](http://forums.bistudio.com/member.php?87524-LordHeart) ([GitHub](https://github.com/CorruptedHeart)) за помощь с кодом.
* [NorX_Aengell](http://forums.bistudio.com/member.php?99450-NorX_Aengell) за перевод на французский.
* [lukrop](http://forums.bistudio.com/member.php?78022-lukrop) ([GitHub](https://github.com/lukrop)) за помощь с кодом.
* [nikolauska](http://forums.bistudio.com/member.php?75014-nikolauska) ([GitHub](https://github.com/nikolauska)) за помощь с SQF кодом.
* [Kavinsky](https://github.com/kavinsky) за AN/PRC-154, RF-7800S-TR и другие рации.
* [JonBons](http://forums.bistudio.com/member.php?81374-JonBons) ([GitHub](https://github.com/JonBons)) за помощь с кодом.
* [ramius86](https://github.com/ramius86) за перевод на итальянский.
* Killzone Kid за [статьи](http://killzonekid.com/arma-scripting-tutorials-float-to-string-position-to-string/).
* [Krypto202](http://www.armaholic.com/users.php?m=details&id=45906&u=kripto202) ([GitHub](https://github.com/kripto202)) за звуки.
* [pastor399](http://forums.bistudio.com/member.php?128853-pastor399) ([GitHub](https://github.com/pastor399)) за модель рюкзаков и текстуры.
* [J0nes](http://forums.bistudio.com/member.php?96513-J0nes) за помощь с моделями.
* [Raspu86](http://forums.bistudio.com/member.php?132083-Raspu86) ([GitHub](https://github.com/Raspu86)) за модель рюкзаков.
* [Gandi](http://forums.bistudio.com/member.php?111588-Gandi) за текстуры.
* [Pixinger](https://github.com/Pixinger) за помощь с [Зевсом](http://arma3.com/dlc/zeus).
* [whoozle](https://github.com/whoozle) за звуковой движок и помощь.
* [MastersDisaster](https://www.freesound.org/people/MastersDisaster/) за [звук переключателя](https://www.freesound.org/people/MastersDisaster/sounds/218115/).
* [CptDavo](http://forums.bistudio.com/member.php?75211-CptDavo) за помощь с текстурами.
* [KoffeinFlummi](https://github.com/KoffeinFlummi) за помощь с кодом.
* [R.m.K Gandi](http://steamcommunity.com/profiles/76561197984744647/) за текстуры рюкзаков.
* [Pomigit](http://forums.bistudio.com/member.php?97133-pomigit) за паттерны текстур.
* [Priestylive](https://plus.google.com/u/0/113553519889377947218/posts) за текстуры для [BWMOD](http://bwmod.de/).
* [Audiocustoms](http://forums.bistudio.com/member.php?98703-audiocustoms) ([SoundCloud](https://soundcloud.com/audiocustoms)) за звуки раций.
* [EvroMalarkey](http://forums.bistudio.com/member.php?104272-EvroMalarkey) ([GitHub](https://github.com/evromalarkey)) за перевод на чешский.
* [Tourorist](https://github.com/Tourorist) за помощь с документацией.
* [ViperMaul](http://forums.bistudio.com/member.php?45090-ViperMaul) за помощь с CBA.
* [Armatech](http://forums.bistudio.com/member.php?48510-armatech) за помощь с CBA.
* Разработчикам [RHS](http://www.rhsmods.org/) за помощь в интеграции.
* [marc_book](https://github.com/MarcBook) за текстуры для BWMOD.
* Всем, кто делал видео и статьи с обзорами.
* Всем пользователям (особенно тем, что нашли баги).
* Извините, если кого-то случайно забыл.
