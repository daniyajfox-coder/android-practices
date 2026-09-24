---
title: "Практическая работа №3: Конфигурирование AndroidManifest.xml — решения"
discipline: "Разработка мобильных приложений"
---

# Практическая работа №3. AndroidManifest.xml — выполненные задания

> Все 85 заданий (35 — «для закрепления» по темам 1–7, 50 — практический блок). 

---

## Тема 1: Корневая структура и тег `<manifest>`

### Задание 1

**Декларация пространств имен:** Добавьте в корневой тег пространство имен `xmlns:tools` для управления директивами переопределения конфликтов при слиянии библиотечных манифестов.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 2

**Исключение из слияния:** Используя атрибут `tools:node="remove"`, напишите директиву удаления нежелательного разрешения, добавляемого внешней сторонней библиотекой.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <!-- Удаление рекламного разрешения, вливаемого сторонней библиотекой -->
    <uses-permission
        android:name="com.google.android.gms.permission.AD_ID"
        tools:node="remove" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 3

**Разрешение конфликта атрибутов:** Примените `tools:replace="android:allowBackup"` для принудительной установки собственного флага бэкапа поверх значения зависимости.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <!-- Принудительное переопределение значения allowBackup поверх библиотек -->
    <application
        android:allowBackup="false"
        tools:replace="android:allowBackup"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 4

**Определение пространства имен кастомных атрибутов:** Напишите XML-блок манифеста с поддержкой разделяемого ID пользователя (`android:sharedUserId`, с учетом ограничений устаревания).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3"
    android:sharedUserId="com.example.task_3.shared.uid">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 5

**Проверка синтаксической валидности:** Составьте минимальный валидный каркас файла `AndroidManifest.xml`, готовый для успешной компиляции утилитой `aapt2`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

## Тема 2: Тег `<application>`: глобальные свойства приложения

### Задание 1

**Защита от утечки данных через бэкап:** Сконфигурируйте тег `<application>` для финансового приложения, полностью запретив бэкап и извлечение данных через утилиту ADB.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="false"
        android:fullBackupOnly="false"
        android:dataExtractionRules="@xml/data_extraction_rules"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 2

**Подключение SSL-Pinning конфига:** Добавьте атрибут `android:networkSecurityConfig` со ссылкой на XML-ресурс и составьте шаблон самого файла конфигурации безопасности.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:networkSecurityConfig="@xml/network_security_config"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 3

**Регистрация кастомного Application:** Зарегистрируйте класс `.MainApplication`, в котором будет происходить инициализация DI-контейнера и аналитики.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:name=".MainApplication"
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 4

**Локализация названия приложения:** Настройте атрибут `android:label` так, чтобы название бралось из строковых ресурсов с поддержкой динамической смены языка.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 5

**Поддержка больших куч памяти (Large Heap):** Добавьте атрибут `android:largeHeap="true"` для графического редактора и обоснуйте риски его бездумного использования.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:largeHeap="true"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

## Тема 3: Регистрация четырёх фундаментальных компонентов

### Задание 1

**Регистрация стартовой Activity:** Объявите экран `SplashScreenActivity` в качестве единственной стартовой точки запуска с главного экрана смартфона.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <!-- SplashScreenActivity выступает в роли единственной точки входа (Launcher) -->
        <activity
            android:name=".SplashScreenActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 2

**Изоляция служебного сервиса:** Опишите фоновый сервис синхронизации локальной базы данных, гарантировав невозможность его вызова из внешних приложений.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Изолированный сервис синхронизации базы данных -->
        <service
            android:name=".MyService"
            android:exported="false" />

    </application>

</manifest>
```

### Задание 3

**Блокировка пересоздания при повороте:** Сконфигурируйте для игровой Activity атрибут `android:configChanges="orientation|screenSize|keyboardHidden"`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:configChanges="orientation|screenSize|keyboardHidden"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 4

**Выбор режима запуска (launchMode):** Зарегистрируйте экран звонка `IncomingCallActivity` с режимом запуска `singleInstance`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <!-- Экран входящего звонка в отдельном инстансе (задаче) -->
        <activity
            android:name=".IncomingCallActivity"
            android:exported="false"
            android:launchMode="singleInstance" />

    </application>

</manifest>
```

### Задание 5

**Безопасная настройка FileProvider:** Напишите полную декларацию `FileProvider` для выдачи временного доступа камере к сохранению сделанного снимка.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Декларация FileProvider для безопасного обмена файлами с камерой -->
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="${applicationId}.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>

    </application>

</manifest>
```

## Тема 4: Механизм `<intent-filter>` и Deep Links (App Links)

### Задание 1

**Перехват функции "Поделиться" (Share Target):** Зарегистрируйте Activity, способную принимать изображения любого формата через системный диалог `ACTION_SEND`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">

            <!-- Точка входа приложения -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <!-- Фильтр для приёма изображений из внешних приложений -->
            <intent-filter>
                <action android:name="android.intent.action.SEND" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="image/*" />
            </intent-filter>

        </activity>

    </application>

</manifest>
```

### Задание 2

**Обработка звонковых ссылок:** Настройте фильтр для перехвата номеров телефонов со схемой `tel:`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">

            <!-- Точка входа приложения -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <!-- Фильтр для обработки звонковых ссылок tel: -->
            <intent-filter>
                <action android:name="android.intent.action.DIAL" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:scheme="tel" />
            </intent-filter>

        </activity>

    </application>

</manifest>
```

### Задание 3

**Диплинк с маской пути:** Напишите тег `<data>` с атрибутом `android:pathPattern`, фильтрующий только PDF-документы: `.*\\.pdf`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">

            <!-- Точка входа приложения -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <!-- Фильтр диплинков с фильтрацией по маске .pdf -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data
                    android:scheme="https"
                    android:host="example.com"
                    android:pathPattern=".*\\.pdf" />
            </intent-filter>

        </activity>

    </application>

</manifest>
```

### Задание 4

**Фильтрация по нескольким MIME-типам:** Сконфигурируйте интент-фильтр, принимающий текстовые файлы (`text/plain`) и веб-страницы (`text/html`).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">

            <!-- Точка входа приложения -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <!-- Фильтр для обработки типов text/plain и text/html -->
            <intent-filter>
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <data android:mimeType="text/plain" />
                <data android:mimeType="text/html" />
            </intent-filter>

        </activity>

    </application>

</manifest>
```

### Задание 5

**Настройка авто-верификации (App Link):** Добавьте директиву `android:autoVerify="true"` и опишите назначение связи с файлом `/.well-known/assetlinks.json`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">

            <!-- Точка входа приложения -->
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

            <!-- Фильтр для App Links с автоматической верификацией -->
            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.VIEW" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.BROWSABLE" />
                <data
                    android:scheme="https"
                    android:host="example.com" />
            </intent-filter>

        </activity>

    </application>

</manifest>
```

## Тема 5: Разрешения: `<uses-permission>` и модель безопасности

### Задание 1

**Разрешения для геолокационного трекера:** Объявите набор разрешений для непрерывного фонового трекинга: приблизительная геопозиция, точная геопозиция и фоновая геопозиция (`ACCESS_BACKGROUND_LOCATION`).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Приблизительная геопозиция -->
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <!-- Точная геопозиция -->
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <!-- Фоновая геопозиция (для трекинга в свернутом виде) -->
    <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 2

**Разрешение уведомлений:** Добавьте разрешение `POST_NOTIFICATIONS` с директивой поддержки обратной совместимости для старых версий ОС.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Запрос разрешения на отправку уведомлений (Android 13+) -->
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 3

**Защита собственного компонента:** Создайте кастомное разрешение с уровнем защиты `signature`, чтобы только приложения с тем же ключом подписи могли обращаться к сервису.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Декларация собственного разрешения с уровнем защиты signature -->
    <permission
        android:name="com.example.task_3.PERMISSION_SECURE_SERVICE"
        android:protectionLevel="signature" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 4

**Ограничение максимальной версии SDK:** Используя атрибут `android:maxSdkVersion`, ограничьте действие разрешения записи во внешнюю память (`WRITE_EXTERNAL_STORAGE`) версией Android 9 (API 28).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Запись во внешнюю память ограничивается API 28 -->
    <uses-permission
        android:name="android.permission.WRITE_EXTERNAL_STORAGE"
        android:maxSdkVersion="28" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 5

**Точные будильники (Exact Alarms):** Зарегистрируйте разрешение `SCHEDULE_EXACT_ALARM` и объясните строгие правила модерации Google Play для этого типа разрешений.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Разрешение для точных будильников.
         ОБЪЯСНЕНИЕ: Google Play строго модерирует это разрешение.
         Оно разрешено только приложениям, основная функция которых —
         будильник, календарь или таймер (начиная с Android 14+). -->
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

## Тема 6: Аппаратные фильтры `<uses-feature>` и видимость пакетов `<queries>`

### Задание 1

**Необязательный датчик отпечатка пальца:** Опишите фичу сканера отпечатков пальцев так, чтобы приложение могло устанавливаться на устройства без биометрии.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Декларация оборудования: сканер отпечатков (необязательно) -->
    <uses-feature
        android:name="android.hardware.fingerprint"
        android:required="false" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 2

**Фильтрация устройств с NFC:** Напишите манифест-декларацию для платежного стикера или терминала, требующую физического наличия чипа NFC.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Строгое требование наличия NFC-модуля для работы приложения -->
    <uses-feature
        android:name="android.hardware.nfc"
        android:required="true" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 3

**Декларация вызова сторонней навигации:** С помощью блока `<queries>` опишите возможность проверки наличия установленного приложения Яндекс Карты или 2ГИС.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Открытие видимости сторонних пакетов для Android 11+ -->
    <queries>
        <package android:name="ru.yandex.yandexmaps" />
        <package android:name="ru.dublgis.dgismobile" />
    </queries>

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 4

**Телефония и отправка SMS:** Задекларируйте признак `android.hardware.telephony` со значением `required="false"` для обеспечения совместимости приложения с планшетами без SIM-карт.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Указание, что функции телефонии (звонки, SMS) не являются обязательными -->
    <uses-feature
        android:name="android.hardware.telephony"
        android:required="false" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

### Задание 5

**Поддержка контроллеров:** Настройте фичу поддержки геймпадов для Android TV версии вашего приложения.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.task_3">

    <!-- Требование поддержки игровых контроллеров (геймпадов) -->
    <uses-feature
        android:name="android.hardware.gamepad"
        android:required="true" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:theme="@style/Theme.Task_3" />

</manifest>
```

## Тема 7: Метаданные `<meta-data>` и тонкая конфигурация окружения

### Задание 1

**Интеграция карт:** Добавьте тег метаданных для внедрения ключа Яндекс MapKit внутри элемента `<application>`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <!-- Ключ API для Яндекс Карт -->
        <meta-data
            android:name="com.yandex.android.mapkit.API_KEY"
            android:value="YOUR_YANDEX_API_KEY_HERE" />

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 2

**Конфигуратор смены языка внутри приложения:** Зарегистрируйте ресурс `LocaleConfig` для встроенного селектора языков в Android 13+.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <!-- Файл конфигурации мультиязычности (Per-App Language) -->
        <meta-data
            android:name="android.content.res.LocaleConfig"
            android:resource="@xml/locales_config" />

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 3

**Метаданные внутри конкретной Activity:** Привяжите системный поисковый конфигуратор (`android.app.searchable`) к конкретному экрану `SearchActivity`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <!-- Специфичная Activity для обработки системного поиска -->
        <activity
            android:name=".SearchActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.SEARCH" />
            </intent-filter>
            
            <!-- Метаданные привязаны строго к этому экрану -->
            <meta-data
                android:name="android.app.searchable"
                android:resource="@xml/searchable" />
        </activity>

    </application>

</manifest>
```

### Задание 4

**Отключение Startup-библиотеки:** Настройте метаданные для ручной инициализации библиотеки `androidx.startup`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <!-- Удаление авто-инициализатора androidx.startup для ручного запуска -->
        <provider
            android:name="androidx.startup.InitializationProvider"
            android:authorities="${applicationId}.androidx-startup"
            android:exported="false"
            tools:node="remove" />

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

### Задание 5

**Масштабирование экранов (High Refresh Rate):** Добавьте мета-параметры для активации поддержки частоты развертки дисплея 120 Гц.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <!-- OEM-метаданные для форсирования частоты обновления дисплея -->
        <meta-data
            android:name="android.vendor.display.supported_refresh_rate"
            android:value="120" />

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>

</manifest>
```

## Блок 1: Архитектура, слияние манифестов и запуск

### Задание 1

**Диагностика конфликта библиотек:** Внешняя библиотека объявляет `minSdkVersion="24"`, а ваш проект `minSdkVersion="21"`. Напишите директиву `tools:overrideLibrary`, разрешающую конфликт.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<uses-sdk tools:overrideLibrary="com.thirdparty.library" />
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 2

**Скрытие иконки приложения из лаунчера:** Сконфигурируйте Activity так, чтобы она была доступна только по вызову из другого приложения, но не отображалась в списке приложений смартфона.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<!-- Убрана категория LAUNCHER -->
<category android:name="android.intent.category.DEFAULT" />
</intent-filter>
</activity>
<activity android:name=".InternalToolActivity" android:exported="true">
<intent-filter>
<action android:name="com.university.app.ACTION_OPEN_TOOL" />
<category android:name="android.intent.category.DEFAULT" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 3

**Splash Screen в Android 12+:** Настройте метаданные и тему стартового экрана `Theme.SplashScreen` в блоке Activity в соответствии со стандартами Android Core Splashscreen.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.App.Starting">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 4

**Алиас Activity (activity-alias):** Создайте псевдоним `<activity-alias>` для динамической смены новогодней иконки приложения через `PackageManager`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity-alias
android:name=".NewYearIcon"
android:enabled="false"
android:icon="@mipmap/ic_launcher_newyear"
android:targetActivity=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity-alias>
</application>
</manifest>
```

### Задание 5

**Режим отображения "Картинка в картинке" (PiP):** Включите поддержку Picture-in-Picture (`android:supportsPictureInPicture="true"`) и настройте корректные флаги смены конфигураций экрана.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity
android:name=".VideoPlayerActivity"
android:supportsPictureInPicture="true"
android:configChanges="screenSize|smallestScreenSize|screenLayout|orientation"
android:exported="false" />
</application>
</manifest>
```

### Задание 6

**Многооконный режим (Multi-Window):** Ограничьте минимальные размеры плавающего окна приложения атрибутом `<layout android:minWidth="300dp" android:minHeight="450dp" />`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:resizeableActivity="true"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
<layout
android:minWidth="300dp"
android:minHeight="450dp"
android:defaultWidth="600dp"
android:defaultHeight="600dp" />
</activity>
</application>
</manifest>
```

### Задание 7

**Изоляция в отдельном процессе:** Настройте запуск фонового аудиосервиса в независимом системном процессе операционной системы с помощью атрибута `android:process=":playback_process"`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<service
android:name=".playback.AudioPlaybackService"
android:process=":playback_process"
android:foregroundServiceType="mediaPlayback"
android:exported="false" />
</application>
</manifest>
```

### Задание 8

**Исключение из меню недавних приложений (Recents):** Настройте атрибут `android:excludeFromRecents="true"` для экрана ввода мастер-пароля.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity
android:name=".MasterPasswordActivity"
android:excludeFromRecents="true"
android:exported="false" />
</application></manifest>
```

### Задание 9

**Защита от скриншотов и превью:** Объясните, какие настройки манифеста влияют на превью экрана в списке задач и как они соотносятся с программным флагом `FLAG_SECURE`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- 
            Обоснование:
            excludeFromRecents="true" исключает Activity из списка недавних приложений (Overview),
            благодаря чему система не сохраняет превью экрана в истории задач.
            Соотношение с FLAG_SECURE: excludeFromRecents защищает только снимки в меню многозадачности, 
            но НЕ запрещает делать ручной скриншот во время работы приложения. 
            Полную защиту от скриншотов и записи экрана дает программная установка window.setFlags(FLAG_SECURE).
        -->
        <activity
            android:name=".SecureActivity"
            android:excludeFromRecents="true"
            android:exported="false" />

    </application>
</manifest>
```

### Задание 10

**Кастомный класс TestInstrumentationRunner:** Задекларируйте тег `<instrumentation>` для запуска кастомного раннера UI-тестов.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<instrumentation
android:name=".CustomTestRunner"
android:targetPackage="com.example.task_3"
android:functionalTest="false" />
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
</application>
</manifest>
```

## Блок 2: Безопасность, шифрование и сетевой контур

### Задание 11

**Блокировка инъекции динамического кода:** Сконфигурируйте тег манифеста для защиты от динамической загрузки вредоносного байт-кода (`android:isolatedProcess="true"` для сервиса).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<service
android:name=".plugins.PluginHostService"
android:isolatedProcess="true"
android:exported="false" />
</application></manifest>
```

### Задание 12

**Разрешение локального HTTP для разработки:** Напишите XML-конфиг сетевой безопасности, разрешающий незашифрованный трафик исключительно для IP-адреса локального сервера `192.168.1.50` и блокирующий его для внешнего интернета.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:networkSecurityConfig="@xml/network_security_config_local"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 13

**Защита Content Provider от атак внедрения:** Спроектируйте объявление провайдера с раздельными правами на чтение и запись (`android:readPermission` и `android:writePermission`).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<permission android:name="com.example.task_3.permission.READ_NOTES"
android:protectionLevel="signature" />
<permission android:name="com.example.task_3.permission.WRITE_NOTES"
android:protectionLevel="signature" />
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<provider
android:name=".data.NotesProvider"
android:authorities="com.example.task_3.notes"
android:exported="true"
android:readPermission="com.example.task_3.permission.READ_NOTES"
android:writePermission="com.example.task_3.permission.WRITE_NOTES" /></application>
</manifest>
```

### Задание 14

**Декларация временных разрешений на URI:** Настройте тег `<grant-uri-permission android:pathPrefix="/shared_docs/" />` внутри безопасного провайдера данных.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<provider
android:name=".data.SecureDocsProvider"
android:authorities="com.example.task_3.docs"
android:exported="false"
android:grantUriPermissions="true">
<grant-uri-permission android:pathPrefix="/shared_docs/" />
</provider>
</application>
</manifest>
```

### Задание 15

**Запрет отладки приложения в продакшене:** Убедитесь в отсутствии уязвимости с помощью директивы `android:debuggable="false"` с механизмом принудительной замены сборщиком.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:debuggable="false"
tools:replace="android:debuggable"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity></application>
</manifest>
```

### Задание 16

**Защита BroadcastReceiver от поддельных широковещательных сообщений:** Закройте неэкспортированный ресивер системным разрешением уровня `signature`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<permission
android:name="com.example.task_3.permission.SEND_INTERNAL_BROADCAST"
android:protectionLevel="signature" />
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<receiver
android:name=".receivers.InternalEventReceiver"
android:exported="false"
android:permission="com.example.task_3.permission.SEND_INTERNAL_BROADCAST" />
</application>
</manifest>
```

### Задание 17

**Разграничение доступа через системные роли:** Ограничьте вызов Activity разрешением `android.permission.BIND_ACCESSIBILITY_SERVICE`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity><activity
android:name=".AccessibilitySettingsActivity"
android:exported="true"
android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE" />
</application>
</manifest>
```

### Задание 18

**Политика обработки резервных копий (Backup Rules):** Создайте файл `@xml/backup_rules` и привяжите его в манифесте через `android:fullBackupContent` и `android:dataExtractionRules`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:fullBackupContent="@xml/backup_rules"
android:dataExtractionRules="@xml/data_extraction_rules"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 19

**Защита от Overlay-атак (Tapjacking):** Сконфигурируйте фильтрацию входящих касаний для экрана подтверждения банковской транзакции.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- hideOverlayWindows="true" блокирует наложение сторонних окон и оверлеев поверх экрана -->
        <activity
            android:name=".PaymentActivity"
            android:exported="false"
            android:hideOverlayWindows="true" />

    </application>
</manifest>
```

### Задание 20

**Аудит манифеста утилитой Androbugs:** Выявите 3 критические уязвимости в представленном фрагменте манифеста с открытым `exported="true"` без разрешений.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <!-- 
        Исправление 3 уязвимостей, выявляемых Androbugs:
        1. android:debuggable="false" — запрет отладки в релизной сборке.
        2. android:usesCleartextTraffic="false" — запрет незашифрованного HTTP-трафика.
        3. android:exported="false" у внутренних компонентов — защита от вызова сторонними приложениями.
    -->
    <application
        android:allowBackup="false"
        android:debuggable="false"
        android:usesCleartextTraffic="false"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity
            android:name=".InternalDataActivity"
            android:exported="false" />

    </application>
</manifest>
```

## Блок 3: Интент-фильтры, интеграция и Deep Links

### Задание 21

**Интеграция с NFC-ридером (NFC Tag Dispatch):** Напишите интент-фильтр для перехвата смарт-карты стандарта Mifare: `android.nfc.action.TECH_DISCOVERED`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<uses-feature android:name="android.hardware.nfc" android:required="true" />
<uses-permission android:name="android.permission.NFC" />
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity><activity android:name=".NfcReaderActivity" android:exported="true">
<intent-filter>
<action android:name="android.nfc.action.TECH_DISCOVERED" />
</intent-filter>
<meta-data
android:name="android.nfc.action.TECH_DISCOVERED"
android:resource="@xml/nfc_tech_filter" />
</activity>
</application>
</manifest>
```

### Задание 22

**Открытие геопозиции на внешней карте:** Сконфигурируйте Activity, перехватывающую запросы по схеме `geo:0,0?q=`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity android:name=".MapViewerActivity" android:exported="true">
<intent-filter>
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<category android:name="android.intent.category.BROWSABLE" />
<data android:scheme="geo" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 23

**Обработка вложений электронной почты:** Настройте фильтр для открытия файлов расширения `.docx` и `.xlsx` с MIME-типом `application/*`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity android:name=".DocumentViewerActivity" android:exported="true">
<intent-filter>
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<data android:mimeType="application/vnd.openxmlformats-
officedocument.wordprocessingml.document" />
<data android:mimeType="application/vnd.openxmlformats-
officedocument.spreadsheetml.sheet" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 24

**Интеграция с Google Assistant / App Actions:** Задекларируйте файл шорткатов `<meta-data android:name="android.app.shortcuts" android:resource="@xml/shortcuts" />`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
<meta-data android:name="android.app.shortcuts" android:resource="@xml/shortcuts" />
</activity>
</application>
</manifest>
```

### Задание 25

**Глубокая ссылка интернет-магазина (Deep Link):** Задекларируйте фильтр, принимающий ссылку вида `https://marketplace.com/catalog/shoes?brand=nike` с верификацией домена.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3"><activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity android:name=".ProductActivity" android:exported="true">
<intent-filter android:autoVerify="true">
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<category android:name="android.intent.category.BROWSABLE" />
<data android:scheme="https" android:host="marketplace.com"
android:pathPrefix="/catalog/" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 26

**Перехват нажатия аппаратной кнопки гарнитуры:** Настройте BroadcastReceiver для приема события `android.intent.action.MEDIA_BUTTON`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<receiver android:name=".receivers.MediaButtonReceiver" android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MEDIA_BUTTON" />
</intent-filter>
</receiver>
</application>
</manifest>
```

### Задание 27

**Обработка системного поиска:** Зарегистрируйте компонент со специальным действием `android.intent.action.SEARCH`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity android:name=".SearchActivity" android:exported="true">
<intent-filter>
<action android:name="android.intent.action.SEARCH" />
</intent-filter>
<meta-data
android:name="android.app.searchable"
android:resource="@xml/searchable" />
</activity>
</application>
</manifest>
```

### Задание 28

**Открытие экрана создания SMS:** Напишите интент-фильтр со схемой `smsto:` для отправки сообщений.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity android:name=".SmsComposerActivity" android:exported="true">
<intent-filter>
<action android:name="android.intent.action.SENDTO" />
<category android:name="android.intent.category.DEFAULT" />
<data android:scheme="smsto" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 29

**Авторизация через OAuth (Custom Tab Callback):** Сконфигурируйте Activity для перехвата редиректа вида `org.example.app://oauth-callback`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity android:name=".OAuthCallbackActivity" android:exported="true">
<intent-filter>
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<category android:name="android.intent.category.BROWSABLE" />
<data android:scheme="org.example.app" android:host="oauth-callback" />
</intent-filter>
</activity>
</application>
</manifest>
```

### Задание 30

**Открытие файла конфигурации по кастомному расширению:** Сделайте так, чтобы файлы `.mycfg` открывались в вашей программе по умолчанию.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
xmlns:tools="http://schemas.android.com/tools"
package="com.example.task_3">
<application
android:allowBackup="true"
android:icon="@mipmap/ic_launcher"
android:label="@string/app_name"
android:roundIcon="@mipmap/ic_launcher_round"
android:supportsRtl="true"
android:theme="@style/Theme.Task_3">
<activity
android:name=".MainActivity"
android:exported="true">
<intent-filter>
<action android:name="android.intent.action.MAIN" />
<category android:name="android.intent.category.LAUNCHER" />
</intent-filter>
</activity>
<activity android:name=".ConfigViewerActivity" android:exported="true">
<intent-filter>
<action android:name="android.intent.action.VIEW" />
<category android:name="android.intent.category.DEFAULT" />
<data android:scheme="content" />
<data android:scheme="file" />
<data android:mimeType="*/*" android:pathPattern=".*\.mycfg" />
</intent-filter>
</activity></manifest>
```

## Блок 4: Сервисы, фоновые задачи и Android 14+ требования

### Задание 31

**Foreground Service типа "Микрофон":** Объявите сервис записи голосовых заметок с обязательным указанием `android:foregroundServiceType="microphone"` и соответствующим разрешением.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MICROPHONE" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Начиная с Android 14 обязателен атрибут foregroundServiceType -->
        <service
            android:name=".VoiceRecorderService"
            android:exported="false"
            android:foregroundServiceType="microphone" />

    </application>
</manifest>
```

### Задание 32

**Foreground Service типа "Геолокация":** Настройте сервис пешего курьера с типом `location` и правами фоновой геолокации.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Начиная с Android 14 обязателен атрибут foregroundServiceType -->
        <service
            android:name=".LocationTrackingService"
            android:exported="false"
            android:foregroundServiceType="location" />

    </application>
</manifest>
```

### Задание 33

**Сервис загрузки тяжелых файлов:** Задекларируйте Foreground Service типа `dataSync` с указанием таймаута выполнения.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <service
            android:name=".DataSyncService"
            android:exported="false"
            android:foregroundServiceType="dataSync" />

    </application>
</manifest>
```

### Задание 34

**Сервис стриминга видео на ТВ:** Сконфигурируйте сервис с типом `mediaProjection`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_MEDIA_PROJECTION" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Сервис захвата и трансляции экрана/видео на ТВ -->
        <service
            android:name=".TvStreamingService"
            android:exported="false"
            android:foregroundServiceType="mediaProjection" />

    </application>
</manifest>
```

### Задание 35

**Планировщик WorkManager:** Настройте системные компоненты библиотеки WorkManager через метаданные для отключения дефолтной авто-инициализации.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Отключение автоматической инициализации WorkManager для ручной настройки -->
        <provider
            android:name="androidx.startup.InitializationProvider"
            android:authorities="${applicationId}.androidx-startup"
            android:exported="false"
            tools:node="merge">
            <meta-data
                android:name="androidx.work.WorkManagerInitializer"
                android:value="androidx.startup"
                tools:node="remove" />
        </provider>

    </application>
</manifest>
```

### Задание 36

**Автозапуск сервиса после перезагрузки:** Соберите правильную комбинацию: разрешение `RECEIVE_BOOT_COMPLETED`, регистрация ресивера и вызов фоновой службы.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <receiver
            android:name=".BootReceiver"
            android:exported="false">
            <intent-filter>
                <action android:name="android.intent.action.BOOT_COMPLETED" />
            </intent-filter>
        </receiver>

    </application>
</manifest>
```

### Задание 37

**Контроль энергосбережения (Doze Mode):** Задекларируйте разрешение `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS` и укажите в комментариях риски блокировки в Google Play.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### Задание 38

**Служба специальных возможностей (Accessibility Service):** Напишите блок объявления службы спец. возможностей с файлом метаданных `accessibility_service_config`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <service
            android:name=".MyAccessibilityService"
            android:exported="true"
            android:permission="android.permission.BIND_ACCESSIBILITY_SERVICE">
            <intent-filter>
                <action android:name="android.accessibilityservice.AccessibilityService" />
            </intent-filter>
            <meta-data
                android:name="android.accessibilityservice"
                android:resource="@xml/accessibility_service_config" />
        </service>

    </application>
</manifest>
```

### Задание 39

**Служба синхронизации аккаунтов (SyncAdapter):** Опишите компонент службы синхронизации с метаданными `@xml/syncadapter`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <service
            android:name=".SyncService"
            android:exported="true"
            android:permission="android.permission.BIND_SYNC_ADAPTER">
            <intent-filter>
                <action android:name="android.content.SyncAdapter" />
            </intent-filter>
            <meta-data
                android:name="android.content.SyncAdapter"
                android:resource="@xml/syncadapter" />
        </service>

    </application>
</manifest>
```

### Задание 40

**Служба обоев (Live Wallpaper):** Зарегистрируйте `WallpaperService` с необходимым системным разрешением `android.permission.BIND_WALLPAPER`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <service
            android:name=".MyLiveWallpaperService"
            android:exported="true"
            android:permission="android.permission.BIND_WALLPAPER">
            <intent-filter>
                <action android:name="android.service.wallpaper.WallpaperService" />
            </intent-filter>
            <meta-data
                android:name="android.service.wallpaper"
                android:resource="@xml/wallpaper" />
        </service>

    </application>
</manifest>
```

## Блок 5: Аппаратные модули, экраны и адаптивность

### Задание 41

**Поддержка складных смартфонов (Foldables):** Объявите поддержку динамического изменения геометрии экрана и соотношений сторон через `android:maxAspectRatio` и `android:minAspectRatio`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:configChanges="screenSize|smallestScreenSize|screenLayout|orientation"
            android:exported="true"
            android:resizeableActivity="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### Задание 42

**Приложение для умных часов (Wear OS):** Настройте манифест с тегом `<uses-feature android:name="android.hardware.type.watch" />`.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-feature android:name="android.hardware.type.watch" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <meta-data
            android:name="com.google.android.wearable.standalone"
            android:value="true" />

        <activity
            android:name=".WearMainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### Задание 43

**Приложение для автомобильных медиасистем (Android Auto):** Добавьте дескриптор метаданных `com.google.android.gms.car.application` с конфигурацией автомобильного интерфейса.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <meta-data
            android:name="com.google.android.gms.car.application"
            android:resource="@xml/automotive_app_desc" />

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### Задание 44

**Приложение для умного ТВ (Android TV):** Настройте категорию `LEANBACK_LAUNCHER` и флаг отсутствия обязательного тачскрина (`android.hardware.touchscreen = false`).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-feature
        android:name="android.software.leanback"
        android:required="false" />
    <uses-feature
        android:name="android.hardware.touchscreen"
        android:required="false" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".TvActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LEANBACK_LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### Задание 45

**Поддержка стилуса и планшетного ввода:** Опишите требования к расширенному сенсорному экрану.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <!-- Отдельного uses-feature "для стилуса" в платформе нет: перо определяется в рантайме
         через MotionEvent.getToolType() == MotionEvent.TOOL_TYPE_STYLUS.
         Требование к точности ввода описывается через faketouch. -->
    <uses-feature
        android:name="android.hardware.faketouch"
        android:required="false" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

### Задание 46

**Режим высокой плотности пикселей (Density Independence):** Сконфигурируйте узел `<supports-screens>` для запрета работы приложения на устаревших экранах низкой плотности.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <!-- Запрет установки на устаревшие экраны низкой плотности -->
    <supports-screens
        android:requiresSmallestWidthDp="360"
        android:smallScreens="false"
        android:normalScreens="true"
        android:largeScreens="true"
        android:xlargeScreens="true" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

    </application>
</manifest>
```

### Задание 47

**Высокая частота опроса сенсоров:** Задекларируйте разрешение `HIGH_SAMPLING_RATE_SENSORS` для точного гироскопа в гоночной игре.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.HIGH_SAMPLING_RATE_SENSORS" />
    <uses-feature
        android:name="android.hardware.sensor.gyroscope"
        android:required="true" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

### Задание 48

**Интеграция с фонариком устройства:** Опишите признак вспышки камеры `android.hardware.camera.flash` как опциональный.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature
        android:name="android.hardware.camera"
        android:required="false" />
    <uses-feature
        android:name="android.hardware.camera.flash"
        android:required="false" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
```

### Задание 49

**Доступ к USB-аксессуарам (OTG):** Настройте интент-фильтр и метаданные для автоматического запуска приложения при подключении внешнего USB-устройства (`android.hardware.usb.action.USB_DEVICE_ATTACHED`).

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <uses-feature android:name="android.hardware.usb.host" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity
            android:name=".UsbAccessoryActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED" />
            </intent-filter>
            <meta-data
                android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED"
                android:resource="@xml/device_filter" />
        </activity>

    </application>
</manifest>
```

### Задание 50

**Комплексный production-манифест:** Соберите итоговый манифест защищенного финтех-приложения со стартовым экраном, FileProvider, тремя опасными разрешениями, App Link и строгой политикой сетевой безопасности.

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.task_3">

    <!-- Требования к аппаратным модулям -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
    <uses-permission android:name="android.permission.FOREGROUND_SERVICE_DATA_SYNC" />

    <application
        android:allowBackup="false"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher_round"
        android:supportsRtl="true"
        android:theme="@style/Theme.Task_3"
        android:usesCleartextTraffic="false">

        <!-- Точка входа в приложение -->
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:resizeableActivity="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <!-- Фоновый сервис фоновой синхронизации -->
        <service
            android:name=".DataSyncService"
            android:exported="false"
            android:foregroundServiceType="dataSync" />

    </application>
</manifest>
```
