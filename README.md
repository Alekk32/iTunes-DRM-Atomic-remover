# iTunes-DRM-Atomic-remover

EN

A script that allows you to remove from music tracks in m4a and m4v (music video) formats DRM-protected tags with personal data from the AppleID account from which these tracks were purchased or received through iTunes Match.
The script uses ffmpeg, but does not require its installation; you just need to place the executable file in the same folder with the script.

Since Apple has stated that music purchased and received through iTunes Match is always yours, there is a legal way to remove these DRM tags.
Such one is provided even by Apple itself. Select the required tracks, go to the File, Convert and select "Create a version in AAC format". The disadvantage is that during conversion, although very slightly, quality is lost.

How to use:

Windows:
1. Place the iTunes-DRM-Atomic-remover.bat and ffmpeg.exe files in the folder with your music collection.
2. Run iTunes-DRM-Atomic-remover.bat without administrator rights.

macOS:
1. Place the iiTunes-DRM-Atomic-remover.sh and ffmpeg files in the folder with your music collection.
2. Launch ffmpeg.
If you receive the message 'The file “ffmpeg” is a Unix application downloaded from the Internet. Are you sure you want to open it?' Click Cancel and go to step 3.
If you receive the message 'The application "ffmpeg" cannot be opened because the developer could not be verified.' Click Cancel. Go to Settings -> Privacy and Security, scroll down to the Security section and see the message “The application “ffmpeg” is blocked because its author is not an established developer.”. Click 'Confirm Login', and in the message that appears after - Cancel.
3. Open the terminal. Go to the folder with the music collection, where the script and ffmpeg are already located:
Type 'cd ' (with a space at the end, without quotes), drag the folder with your music collection into the terminal, and press enter.
Let's give the script permission to execute:
Type 'chmod +x iTunes-DRM-Atomic-remover.sh' without quotes.
Let's run the script:
Type 'sh iTunes-DRM-Atomic-remover.sh' without quotes.

All m4a and m4v files in the current folder and all subfolders will be processed.
Before processing each file, the script asks you to press enter. To continue processing all files without confirmation, type R and press enter.

If necessary, you can download fresh ffmpeg:
https://ffmpeg.org/download.html#build-windows (I used Windows builds by BtbN)
https://ffmpeg.org/download.html#build-mac



Why do you need it:
For users who store their own music collection locally, in standard Music applications on Mac or iOS, or iTunes on Windows, if this collection contains m4a and m4v format tracks purchased or received through iTunes Match not from your AppleID, who want to clear them of DRM tags containing information about this. Especially if these tracks are downloaded from third-party sources.

After all these manipulations, it is recommended to recreate the media library by adding all the tracks there again. For macOS users who want to transfer play counters, likes, and some other things to the new library, there is a solution https://github.com/Alekk32/iTunes-Medialib-XML-importer

There were only two cases where these tracks with DRM tags in the library caused problems:

The first case involves synchronizing the local Music library on macOS with Music on iOS. Synchronization occurred with a noticeable delay before starting, about 2 minutes via cable, and about 5 minutes via WiFi. It slowed down at the 4/4 stage, and only then began synchronization. And so on with each synchronization, even if only one new track was added. In total, there are about 6 thousand tracks in my library, of which about 4 thousand have such DRM tags, of course from a variety of sources. Most likely, during the synchronization process, each time DRM tags are checked in all tracks, and data about AppleID accounts from them is entered into the iIunes Store on the iPhone. Most likely because of this, what is described in the second case, which is discussed below, also occurs.
But more significant problems with synchronization began after updating to macOS Big Sur 11.3 (20E232). During the dulling process at the 4/4 stage, synchronization was simply interrupted before it had even begun, and the error “The iPhone "iPhone name" could not be synced because the sync session failed to finish” was displayed. After this macOS update, it was almost impossible to sync my library to my iPhone. But 1 out of 20-30 times a miracle happened, and synchronization still occurred. However, over time, problems appeared with displaying the library in Music on iPhone. Half of the albums did not display cover art, and for some artists, tracks were mixed up between albums, or were even displayed in separate “unknown albums”. This problem is described in more detail here https://discussions.apple.com/thread/255324218
The problem was completely resolved after cleaning all tracks with DRM tags with this script.

The second case is the process of restoring iPhone from iCloud backup. Let me remind you that it did not store any cloud media library, only iPhone settings and application data, but the media library stored local on the Mac.
So, after logging into your AppleID, but immediately before the recovery process from iCloud, the iPhone began requesting passwords from all AppleIDs contained in those DRM tags in a row! “This iCloud backup includes purchases from the iTunes Store that were made with a different Apple ID”. Although there were no tracks on either the iPhone or iCloud yet, because I synchronized the local music library with the Mac after the recovery. But data about DRM tags in iCloud seems to be saved every time the library is synchronized, most likely in the iTunes Store application, and, accordingly, remained from previous synchronizations. It is possible that after synchronizing the media library without DRM tags, this data will be deleted. Of course, all these password requests can be simply canceled, but it is not very convenient to cancel and confirm the cancellation of more than 40 requests. And the understanding that your iCloud stores information about all these “purchases from your iPhone” but not from your AppleID is somewhat annoying. You never know what other problems this might pop up in the future.



How does it work:
Using ffmpeg, the audio stream from m4a and video are repacked into a new container. The streams are not subject to any conversions or other changes; the original and resulting files are completely subtracted in antiphase, I personally checked it. It’s even more surprising that for some reason the bitrate changes from CBR 256 to VBR with some average value. Possible artificial display of the beautiful CBR 256 - Apple's perfectionist troubles.

All metadata and album covers are also transferred to the new container.

Firstly, the most important thing is not transferred - those same DRM tags (DRM atoms of the MPEG-4 AAC container), which are difficult to remove in the usual way, but which contain the same AppleID that caused the above-described requests for logging into accounts.

The following tags are also not transferred:
ITUNESACCOUNT
ITUNESADVISORY
ITUNESALBUMID
ITUNESARTISTID
ITUNESCATALOGID
ITUNESCOMPOSERID
ITUNESCOUNTRYID
ITUNESGAPLESS (still transferred)
ITUNESGENREID
ITUNESMEDIATYPE (still transferred)
ITUNESOWNER
ITUNESPURCHASEDATE
ITUNMOVI
ITUNNORM
ITUNSMPB
TVSHOWSORT
XID
WWW
cover for m4v (music videos)
It can be transferred manually in the iTunes or Music application by simply dragging it from “Get info” to any convenient folder, and from there by dragging the already cleared file back to “Get info”.

For some reason, ffmpeg cannot transfer all this data. But in our case, this is the benefit (only with covers for m4v it turned out annoyingly).



But even if it transferred all tags except DRM tags, this would not cause the problem described above with requests to log into accounts. And even iTunes or Music do not recognize files without DRM tags as purchased or received from iTunes Match. Although it is better to delete these tags, since they can also contain personal information about the owner’s AppleID account (email, first name, last name), date of purchase and some others.

This can be easily checked using mp3tag (https://www.mp3tag.de/en/download.html). It can delete all these tags and copy them to another file, but it cannot delete or even display DRM tags.
You can use it to remove all tags from the list above (press Alt+T to view them), and then add the cleaned file again to your iTunes or Music library. The "Get info" will still contain the label "Purchased AAC Audio file" or "Matched AAC Audio file" (and therefore DRM tags with the recipient's AppleID), although the owner's name and date of purchase will not be displayed if they were previously displayed.
Or you can do the opposite - copy all the tags from the source file into the files cleaned by this script using mp3tag. Simply press Ctrl+C on the original file and Ctrl+V on the cleaned one - this will copy all tags visible for mp3tag, including those from the list above, and even covers for m4v (but not DRM tags). In this files in iTunes or Music, the “Purchased AAC Audio file” or “Matched AAC Audio file” label will disappear in the “Get info”, and even the owner’s name and date of purchase will not be displayed, although these tags will be present in the file.


You can see this DRM tags in the HEX editor. They are located right in the second line, among the service characters there is text like nameNameLastName, not only in purchased audio files, but even in audio files from iTunes Match, in which personal data was never displayed in “Get info”. Surely an AppleID from which these tracks were received written down somewhere there, I was not deciphered it in more detail. And it is probably the one that causes the problem described above with requests to log into accounts.

These DRM tags are specifically protected from being easily removed. If you cut them in a HEX editor, no player will be able to play the file. And I couldn’t find any other method of removal this. Although this DRM only protects metadata with information about the AppleID account and does not in any way interfere with listening to the audio, nevertheless, such protection significantly complicates the removal of these DRM tags (that’s why it is DRM).

Discussion about this with the mp3tag developer
https://community.mp3tag.de/t/itunes-owner-tag-is-not-working-appears-another-name-owner/44099/7


RU

Скрипт позволяющий удалить из музыкальных треков формата m4a и m4v (music video) защищеные DRM теги с персональными данными аккаунта AppleID с которого были куплены или получены через iTunes Match эти треки. 
Скрипт использует ffmpeg, однако не требует его установки, исполнительный файл достаточно положить в ту же папку, что и скрипт.

Поскольку Apple заявила, что музыка, приобретенная и полученная через iTunes Match, всегда ваша, существует законный способ удалить эти теги DRM.
Такой способ предоставляется даже самой Apple. Выберите необходимые дорожки, перейдите в меню Файл, Конвертация и выберите "Создать версию в формате AAC". Недостатком является то, что во время преобразования, хотя и очень незначительно, качество теряется.

Как пользоваться:

Windows:
1. 	Кладем файлики iTunes-DRM-Atomic-remover.bat и ffmpeg.exe в папку с вашей музыкальной коллекцией. 
2.	Запускаем iTunes-DRM-Atomic-remover.bat без прав администратора.

macOS:	
1. 	Кладем файлики iiTunes-DRM-Atomic-remover.sh и ffmpeg в папку с вашей музыкальной коллекцией. 
2. 	Запускаем ffmpeg. 
		Если получаем сообщение 'Файл «ffmpeg» является Unix‑приложением, загруженным из интернета. Вы действительно хотите открыть его?' Нажимаем Отменить и переходим к пункту 3.
		Если получаем сообщение 'Приложение «ffmpeg» нельзя открыть, так как не удалось проверить разработчика.' Нажимаем Отменить. Переходим в Настройки -> Конфиденциальность и безопасность, спускаемся ниже к разделу Безопасность и видим сообщение "Приложение «ffmpeg» заблокировано, так как его автор не является установленным разработчиком.". Нажимаем 'Подтвердить вход', а в появившемся после сообщении - Отменить.
3.	Открываем терминал. Переходим в нем в папку с музыкальной коллекцией, где уже находятся скрипт и ffmpeg:
		Вводим 'cd ' (с пробелом в конце, без кавычек), перетаскиваем папку с музыкальной коллекцией в терминал, и жмем enter.
	Даем скрипту разрешение на исполнение:
		Вводим 'chmod +x iTunes-DRM-Atomic-remover.sh' без кавычек.
	Запускаем скрипт:
		Вводим 'sh iTunes-DRM-Atomic-remover.sh' без кавычек.
	
Будут обработаны все m4a и m4v файлы в текущей папке и во всех подпапках. 
Перед обработкой каждого файла скрипт просит нажать enter. Чтоб продолжить обработку всех файлов без подтверждения введите R и нажмите enter. 

Свежий ffmpeg можно при необходимости скачать:
https://ffmpeg.org/download.html#build-windows (я использовал Windows builds by BtbN)
https://ffmpeg.org/download.html#build-mac



Для чего нужно:
Для пользователей хранящих собственную музыкальную коллекцию локально, в стандартных приложениях Music на Mac или iOS, или iTunes на Windows, если в этой коллекции есть треки формата m4a и m4v, купленные или полученные через iTunes Match не с вашего AppleID, желающих очистить их от DRM тегов содержащих информацию об этом. Особенно, если эти треки скачаны из сторонних источников. 

После всех данных манипуляций рекомендуется пересоздать медиатеку добавив туда все треки заново. Для пользователей macOS, которые хотят перенести в новую медиатеку счетчики количества воспроизведений, лайки, и некоторое другое - есть решение https://github.com/Alekk32/iTunes-Medialib-XML-importer

Замечено всего два случая, когда эти треки с DRM тегами в медиатеке вызывали проблемы:

Первый случай связан с синхронизацией локальной медиатеки Music на macOS с Music на iOS. Синхронизация происходила с ощутимой задержкой перед началом, около 2-х минут через кабель, и около 5 минут по WiFi. Она тупила на этапе 4/4, и только потом начинала синхронизацию. И так при каждой синхронизации, даже если добавлялся всего один новый трек. Всего в моей медиатеке около 6 тыс треков, из них с такими DRM тегами около 4 тыс, естественно из самых разных источников. Вероятнее всего в процессе синхронизации каждый раз DRM теги проверяются во всех треках, и данные об аккаунтах AppleID из них заносятся в iIunes Store на iPhone. Скорее всего из-за этого происходит и описанное во втором случае, о котором ниже.
Но более существенные проблемы с синхронизацией начались после обновления на macOS Big Sur 11.3 (20E232). В процессе тупки на 4/4 этапе, синхронизация просто прерывалась еще толком не начавшись, и выдавала ошибку "iPhone "имя айфона" не удалось синхронизировать, так как сеанс синхронизации не удалось завершить". После этого обновления macOS синхронизировать мою медиатеку на iPhone было практически невозможно. Но на 1 из 20-30 раз случалось чудо, и синхронизация все же происходила. Однако со временем добавились проблемы с отображением медиатеки в Music на iPhone. У половины альбомов не отображалась обложка, а у некоторых исполнителей треки были перепутаны между альбомами, либо вообще отображались в отдельных "неизвестных альбомах". Подробнее эта проблема описана тут https://discussions.apple.com/thread/255324218?login=true&sortBy=best 
Проблема полностью решилась после очистки всех треков с DRM тегами данным скриптом.

Второй случай - это процесс восстановление iPhone из резервной копии iCloud. Напомню, в ней не хранилась никакая облачная медиатека, только настройки iPhone и данные приложений, а медиатека - локальная на Mac.
Так вот, после входа в свой AppleID, но непосредственно перед процессом восстановления из iCloud, iPhone начал усиленно запрашивать пароли ото всех AppleID содержащихся в тех DRM тегах подряд! Мол, у вас обнаружены покупки с других аккаунтов, извольте в них войти! Хотя ни на iPhone ни в iCloud никаких треков еще не было, я синхронизировал локальную медиатеку с Mac уже после восстановления. Но данные о DRM тегах в iCloud похоже таки сохраняются при каждой синхронизации медиатеки, вероятнее всего, в приложении iTunes Store, и соответственно, остались от предыдущих синхронизаций. Возможно, после синхронизации медиатеки уже без DRM тегов эти данные удалятся. Конечно, все эти запросы пароля можно просто отменить, но не слишком удобно отменять и подтверждать отмену более 40 запросов. Да и понимание того, что в твоем iCloud хранится информация обо всех этих "покупках с твоего iPhone" но не с твоего AppleID несколько напрягает. Никогда не угадаешь какими еще проблемами это может всплыть в будущем.



Как работает:
С помощью ffmpeg происходит перепаковка аудиопотока для m4a и видео вместе с аудиопотоком для m4v в новый контейнер. Сами потоки не подвергаются никаким конвертациям или другим изменениям, оригинальный и результирующий файл полностью вычитаются в противофазе, лично проверил. Тем более удивительно, но показатель битрейта почему-то меняется с CBR 256 на VBR с каким-то средним значением. Возможно искусственное отображение красивого CBR 256 - перфекционистские заморочки Apple.

В новый контейнер переносятся также и все метаданные, и обложки альбомов.

Не переносятся, во-первых самое главное - те самые DRM теги (DRM атомы контейнера MPEG-4 AAC), которые сложно удалить обычным способом, но в которых и содержится тот самый идентификатор AppleID вызывавший вышеописанные запросы на вход в аккаунты.

Также не переносятся следующие теги:
ITUNESACCOUNT
ITUNESADVISORY
ITUNESALBUMID
ITUNESARTISTID
ITUNESCATALOGID
ITUNESCOMPOSERID
ITUNESCOUNTRYID
ITUNESGAPLESS (все-таки переносится)
ITUNESGENREID
ITUNESMEDIATYPE (все-таки переносится)
ITUNESOWNER
ITUNESPURCHASEDATE
ITUNMOVI
ITUNNORM
ITUNSMPB
TVSHOWSORT
XID
WWW
обложка для m4v (музыкальных видео) 
Ее можно перенести вручную в приложении iTunes или Music простым перетаскиванием из "Сведений" в любую удобную папку, а оттуда таким же перетаскиванием обратно в "Сведения" уже очищенного файла.

Переносить все эти данные по каким-то причинам не умеет сам ffmpeg. Но в нашем случае в этом и заключается польза (только с обложками для m4v досадно получилось).



Но даже если бы он переносил все теги, кроме DRM тегов, это не вызвало бы вышеописаную проблему с запросами на вход в аккаунты. И даже iTunes или Music не распознают файлы без DRM тегов как купленные или полученные из iTunes Match. Хотя эти теги тоже лучше удалять, поскольку они тоже могут содержать персональную информацию об аккаунте AppleID владельца (email, first name, last name), дате покупки и некоторые другие. 

Это легко проверить с помощью mp3tag (https://www.mp3tag.de/en/download.html). Он умеет и удалять все эти теги, и копировать их в другой файл, но не умеет удалять и даже отображать DRM теги.
Можно удалить с его помощью все теги из списка выше (для их просмотра нажать Alt+T), после чего снова добавить очищенные файлы в медиатеку iTunes или Music. В "Сведениях" все равно останется метка "Купленное аудио AAC" или "Аудиофайл из iTunes Match" (а значит и DRM теги с идентификатором AppleID получателя), хоть и не будет отображаться имя владельца и дата покупки, если они ранее отображались. 
А можно наоборот - в файлы очищенные данным скриптом, скопировать все теги из исходного файла с помощью mp3tag. Достаточно просто нажать Ctrl+C на исходном файле и Ctrl+V на очищенном - это скопирует все видимые для mp3tag теги, в том числе и из списка выше, и даже обложки для m4v (но не DRM теги). В таких файлах в iTunes или Music в "Сведениях" исчезнет метка "Купленное аудио AAC" или "Аудиофайл из iTunes Match", и даже имя владельца и дата покупки отображаться не будет, хоть эти теги и будут присутствовать в файле.


Увидеть те самые DRM теги можно в HEX редакторе. Они находятся прямо во второй строчке, среди служебных символов есть текст вида nameИмяФамилия, причем не только в купленных аудиофайлах, но даже в аудиофайлах из iTunes Match, в которых персональные данные в "Сведениях" никогда не отображались. Наверняка где-то там записан и тот самый идентификатор AppleID с которого были получены эти треки, подробнее не расшифровывал. И наверняка именно он вызывает вышеописаную проблему с запросами на вход в аккаунты.

Эти DRM теги специально защищены от простого удаления. Если их вырезать в HEX редакторе - файл не сможет воспроизвести ни одни плеер. И иного способа удаления, кроме того, которому посвящено это описание, мне найти не удалось. Хоть этот DRM защищает только метаданные с информацией об аккаунте AppleID и никак не мешает прослушиванию самого аудио, тем не менее такая защита значительно осложняет удаление этих DRM тегов (на то они и DRM).

Дискуссия на эту тему с разработчиком mp3tag 
https://community.mp3tag.de/t/itunes-owner-tag-is-not-working-appears-another-name-owner/44099/7

