# WeatherApp
WeatherApp - это приложение для iOS, которое имитирует различные погодные условия с помощью динамической анимации и графики. Это приложение позволяет пользователям изучать различные погодные сценарии с помощью интерфейса UICollectionView, поддерживающего несколько языков.

## Особенности
Динамическая анимация погоды: Имитирует солнечные, ночные, дождливые, с молниями, облачные, штормовые, торнадо, снежные и ветреные погодные условия.
Интерактивный интерфейс: Пользователи могут выбирать погодные условия с помощью прокручиваемой коллекции.
Локализация: Поддерживается переключение языков между английским и русским.
Пользовательская анимация: Использует CAEmitterLayer для создания эффектов дождя, снега, ветра, молний и торнадо.

## Установка
Клонируйте репозиторий.
Откройте WeatherApp.xcodeproj в Xcode.
Создайте и запустите проект на симуляторе или физическом устройстве.
## Использование
Выберите погоду: Прокрутите список параметров погоды и выберите, чтобы просмотреть анимацию.
Переключение языка: Используйте кнопку со значком глобуса для переключения языков.
## Структура кода
Перечисление условий погоды: Определяет различные погодные условия и связанные с ними фоновые изображения.
Контроллер просмотра: управляет основным интерфейсом, управляя изменениями погодных условий и анимацией.
UICollectionView: Отображает параметры погоды в горизонтальном виде.
CAEmitterLayer: Управляет визуальными эффектами для анимации дождя, снега, ветра, молний и торнадо.
## Анимация погоды
Солнечно: Показывает движущееся солнце.
Ночь: Отображает луну.
Дождливый: Включает облака с эффектами дождя.
Молния: Имитирует вспышки молний.
Облачно: Анимирует облака на экране.
Штормовой: Сочетает в себе эффекты ветра и молнии.
Торнадо: Отображает анимацию торнадо.
Снежный: Показывает падающий снег.
Ветреный: Анимирует эффекты ветра.
## Локализация
Управление локализацией осуществляется с помощью строковых каталогов, что упрощает управление языком.
