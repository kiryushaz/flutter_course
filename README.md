# CoffeeShopApp

**CoffeeShopApp** - приложение для кофейни. В приложении представлены: локация кофеини, категории и карточки кофе, сгруппированные по категориям. При нажатии на карточку с кофе, товар добавляется в корзину. Можно добавить в корзину максимум 10 штук данного товара. В правом нижнем углу есть кнопка, при нажатии на которой, отображается список добавленных товаров и суммарная стоимость. Пользователь может оформить заказ, тогда произойдет отправка POST-запроса, а на экране отобразится SnackBar с сообщением о успешном создании заказа. Пользователь может выбрать другой адрес кофейни. На карте будут отображаться маркеры, при нажатии на любой из них, отобразится адрес и кнопка "Выбрать". После выбора, пользователь возвращается на главный экран, выбранный адрес сохраняется после перезахода.

<br>

Для разработки используются следующие технологии:

* Flutter - фреймворк для разработки мобильных приложений на Android и iOS
* Dart - используемый язык программирования
* Dio - библиотека для получения данных из сети Интернет в формате json
* Drift - библиотека для создания базы данных и локального хранения данных в виде таблиц
* SharedPreferences - сохранение хранение данных
* BLoC - библиотека для управления состояниями
* geolocator - используется для получения геолокации пользователя
* yandex_mapkit - плагин для отображения карт, дает возможность ставить собственные метки на карту
* firebase_messaging и flutter_local_notifications - библиотеки для получения push-уведомлений

<br>

Инструкция по запуску приложения:

* Скачать APK-файл с данного репозитория GitHub в разделе Releases
* Разрешить установку из неизвестных источников, если требуется и начать установку
* После установки, открыть приложение

<br>

Скриншоты работы приложения:

позже

<br>

Возможные проблемы:

* Прогружаются товары только первой категории, для прогрузки остальных, нужно тапнуть на другие категории.
* Почему-то не отображается пуш-уведомление о успешном оформлении заказа.
