# Практическая работа №2 — решения

## Тема 1

### 1. Конвертер плотности

```java
public class DensityConverter {
    public static void main(String[] args) {
        double dp = 200;
        double dpi = 2.0;
        // Переводим dp в пиксели по формуле
        double resPx = dp * dpi;
        // System.out.println("Result: " + resPx);
        System.out.println(resPx);
    }
}
```

### 2. Парсинг таймстемпа

```java
public class TimestampParser {
    public static void main(String[] args) {
        long millis = 9125000;
        long totalSeconds = millis / 1000;
        long hours = totalSeconds / 3600;
        long minutes = (totalSeconds % 3600) / 60;
        long seconds = totalSeconds % 60;
        System.out.println(hours + ":" + minutes + ":" + seconds);
    }
}
```

### 3. Расход батареи

```java
public class BatteryLife {
    public static void main(String[] args) {
        double capacity = 4000;
        double network = 150;
        double display = 250;
        double hours = capacity / (network + display);
        System.out.println(hours);
    }
}
```

### 4. Валидатор диапазона координат

```java
public class CoordinateValidator {
    public static boolean isValid(double lat, double lon) {
        if (lat >= -90 && lat <= 90 && lon >= -180 && lon <= 180) {
            return true;
        } else {
            return false;
        }
    }

    public static void main(String[] args) {
        System.out.println(isValid(54.01, 38.29));
        System.out.println(isValid(200, 38.29));
    }
}
```

### 5. Побитовые флаги разрешений

```java
public class Permissions {
    public static final int CAMERA = 1;
    public static final int LOCATION = 2;
    public static final int STORAGE = 4;

    public static void main(String[] args) {
        int flags = 0;
        flags = flags | CAMERA;
        flags = flags | STORAGE;

        boolean hasCamera = (flags & CAMERA) != 0;
        boolean hasLocation = (flags & LOCATION) != 0;

        flags = flags & ~CAMERA;

        System.out.println(hasCamera);
        System.out.println(hasLocation);
        System.out.println(flags);
    }
}
```

---

## Тема 2

### 1. Определение ориентации экрана

```java
public class Orientation {
    public static String getOrientation(int width, int height) {
        if (width > height) {
            return "LANDSCAPE";
        } else if (height > width) {
            return "PORTRAIT";
        } else {
            return "SQUARE";
        }
    }

    public static void main(String[] args) {
        System.out.println(getOrientation(1080, 1920));
    }
}
```

### 2. Классификатор статуса HTTP-ответа

```java
public class HttpStatus {
    public static String classify(int code) {
        int group = code / 100;
        switch (group) {
            case 1: return "Информационный";
            case 2: return "Успешный";
            case 3: return "Перенаправление";
            case 4: return "Ошибка клиента";
            case 5: return "Ошибка сервера";
            default: return "Неизвестно";
        }
    }

    public static void main(String[] args) {
        System.out.println(classify(404));
    }
}
```

### 3. Симулятор backoff

```java
public class Backoff {
    public static void main(String[] args) {
        long delay = 1000;
        for (int i = 1; i <= 5; i++) {
            System.out.println("Попытка " + i + ", задержка " + delay + " мс");
            delay = delay * 2;
        }
    }
}
```

### 4. Пропуск повреждённых пакетов

```java
public class MessageLoop {
    public static void main(String[] args) {
        int[] ids = {5, 6, -1, 7, 0, 8};
        for (int id : ids) {
            if (id == -1) {
                continue;
            }
            if (id == 0) {
                break;
            }
            System.out.println("Сообщение " + id);
        }
    }
}
```

### 5. Контроль ввода пин-кода

```java
import java.util.Scanner;

public class PinCheck {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int correctPin = 1234;
        int attempts = 0;
        boolean success = false;

        do {
            System.out.println("Введите пин-код:");
            int input = scanner.nextInt();
            attempts++;
            if (input == correctPin) {
                success = true;
            }
        } while (!success && attempts < 3);

        System.out.println(success ? "Доступ разрешен" : "Доступ заблокирован");
    }
}
```

---

## Тема 3

### 1. Нормализация поискового запроса

```java
public class SearchNormalizer {
    public static String normalize(String query) {
        if (query == null) return "";
        String str = query.trim().toLowerCase();
        // Убираем двойные пробелы
        String result = str.replaceAll(" +", " ");
        return result;
    }

    public static void main(String[] args) {
        System.out.println(normalize("  Купить   Телефон  "));
    }
}
```

### 2. Реверс массива кадров

```java
public class ArrayReverse {
    public static void main(String[] args) {
        String[] frames = {"frame1", "frame2", "frame3", "frame4"};
        int left = 0;
        int right = frames.length - 1;

        while (left < right) {
            String temp = frames[left];
            frames[left] = frames[right];
            frames[right] = temp;
            left++;
            right--;
        }

        for (String f : frames) {
            System.out.println(f);
        }
    }
}
```

### 3. Маскирование номера карты

```java
public class CardMasker {
    public static String mask(String card) {
        String last4 = card.substring(card.length() - 4);
        return "**** **** **** " + last4;
    }

    public static void main(String[] args) {
        System.out.println(mask("1234567812345678"));
    }
}
```

### 4. Поиск пиковых значений акселерометра

```java
public class PeakFinder {
    public static void main(String[] args) {
        double[] values = {0.1, 0.5, 3.2, 0.4, 0.2, 5.6, 0.3};
        double maxDiff = 0;

        for (int i = 1; i < values.length; i++) {
            double diff = Math.abs(values[i] - values[i - 1]);
            if (diff > maxDiff) {
                maxDiff = diff;
            }
        }

        System.out.println(maxDiff);
    }
}
```

### 5. Генератор URL-параметров

```java
public class UrlParams {
    public static void main(String[] args) {
        String[] keys = {"id", "source", "page"};
        String[] values = {"452", "push", "2"};
        StringBuilder sb = new StringBuilder("?");

        for (int i = 0; i < keys.length; i++) {
            if (i > 0) {
                sb.append("&");
            }
            sb.append(keys[i]).append("=").append(values[i]);
        }

        System.out.println(sb.toString());
    }
}
```
## Тема 4

### 1. Перегрузка валидатора

```java
public class EmailValidator {
    public static boolean isValid(String email) {
        return email != null && email.contains("@");
    }

    public static boolean isValid(String email, boolean checkDomain) {
        if (!isValid(email)) {
            return false;
        }
        if (checkDomain) {
            return email.endsWith("@mail.ru") || email.endsWith("@gmail.com");
        }
        return true;
    }

    public static void main(String[] args) {
        System.out.println(isValid("test@mail.ru"));
        System.out.println(isValid("test@mail.ru", true));
    }
}
```

### 2. Форматирование валюты

```java
public class CurrencyFormatter {
    public static String format(double amount, String currencySymbol) {
        return String.format("%.2f %s", amount, currencySymbol);
    }

    public static void main(String[] args) {
        System.out.println(format(1500, "₽"));
    }
}
```

### 3. Калькулятор суммарного размера кэша

```java
public class CacheCalculator {
    public static double calculateCache(long... fileSizesInBytes) {
        long total = 0;
        for (long size : fileSizesInBytes) {
            total += size;
        }
        return total / (1024.0 * 1024.0);
    }

    public static void main(String[] args) {
        System.out.println(calculateCache(1048576, 2097152, 524288));
    }
}
```

### 4. Рекурсивный поиск вложений

```java
public class FolderCounter {
    public static int countItems(int[] folderSizes, int index) {
        if (index >= folderSizes.length) {
            return 0;
        }
        return folderSizes[index] + countItems(folderSizes, index + 1);
    }

    public static void main(String[] args) {
        int[] folders = {3, 5, 2, 7};
        System.out.println(countItems(folders, 0));
    }
}
```

### 5. Сравнение версий

```java
public class VersionComparator {
    public static int compareVersions(String v1, String v2) {
        String[] p1 = v1.split("\\.");
        String[] p2 = v2.split("\\.");
        int length = Math.max(p1.length, p2.length);

        for (int i = 0; i < length; i++) {
            int n1 = i < p1.length ? Integer.parseInt(p1[i]) : 0;
            int n2 = i < p2.length ? Integer.parseInt(p2[i]) : 0;
            if (n1 > n2) return 1;
            if (n1 < n2) return -1;
        }
        return 0;
    }

    public static void main(String[] args) {
        System.out.println(compareVersions("1.12.0", "1.9.4"));
    }
}
```

---

## Тема 5

### 1. Модель экрана настроек

```java
public class SettingsModel {
    private boolean isDarkMode;
    private int volumeLevel;
    private String appLanguage;

    public void setVolumeLevel(int volumeLevel) {
        if (volumeLevel < 0 || volumeLevel > 100) {
            throw new IllegalArgumentException("Громкость должна быть от 0 до 100");
        }
        this.volumeLevel = volumeLevel;
    }

    public int getVolumeLevel() {
        return volumeLevel;
    }

    public void setDarkMode(boolean isDarkMode) {
        this.isDarkMode = isDarkMode;
    }

    public void setAppLanguage(String appLanguage) {
        this.appLanguage = appLanguage;
    }
}
```

### 2. DTO корзины

```java
public record CartItem(String id, String title, double price, int count) {
    public double totalPrice() {
        return price * count;
    }
}
```

### 3. Счётчик непрочитанных пушей

```java
public class BadgeCounter {
    private int count;

    public void increment() {
        count++;
    }

    public void decrement() {
        if (count > 0) {
            count--;
        }
    }

    public int getCount() {
        return count;
    }
}
```

### 4. Инкапсулированный таймер сессии

```java
public class SessionTracker {
    private long lastActionTime;
    private static final long TIMEOUT_MS = 15 * 60 * 1000;

    public SessionTracker() {
        lastActionTime = System.currentTimeMillis();
    }

    public void updateAction() {
        lastActionTime = System.currentTimeMillis();
    }

    public boolean isExpired() {
        return System.currentTimeMillis() - lastActionTime > TIMEOUT_MS;
    }
}
```

### 5. Модель геопозиции

```java
public class GeoPoint {
    private final double latitude;
    private final double longitude;

    public GeoPoint(double latitude, double longitude) {
        if (latitude < -90 || latitude > 90) {
            throw new IllegalArgumentException("Некорректная широта");
        }
        if (longitude < -180 || longitude > 180) {
            throw new IllegalArgumentException("Некорректная долгота");
        }
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }
}
```

---

## Тема 6

### 1. Иерархия экранов приложения

```java
public abstract class BaseScreen {
    public void onOpen() {
        System.out.println("Экран открыт");
    }

    public void onClose() {
        System.out.println("Экран закрыт");
    }
}

public class LoginScreen extends BaseScreen {
    @Override
    public void onOpen() {
        System.out.println("Открыт экран входа");
    }
}

public class HomeScreen extends BaseScreen {
    @Override
    public void onOpen() {
        System.out.println("Открыт главный экран");
    }
}

public class SettingsScreen extends BaseScreen {
    @Override
    public void onOpen() {
        System.out.println("Открыт экран настроек");
    }
}
```

### 2. Полиморфный обработчик аналитики

```java
public abstract class AnalyticsEvent {
    public abstract void log();
}

public class ClickEvent extends AnalyticsEvent {
    @Override
    public void log() {
        System.out.println("Событие: клик");
    }
}

public class PurchaseEvent extends AnalyticsEvent {
    @Override
    public void log() {
        System.out.println("Событие: покупка");
    }
}

public class ScreenViewEvent extends AnalyticsEvent {
    @Override
    public void log() {
        System.out.println("Событие: просмотр экрана");
    }
}

public class AnalyticsService {
    public void track(AnalyticsEvent event) {
        event.log();
    }
}
```

### 3. Модели сенсоров смартфона

```java
public abstract class DeviceSensor {
    public abstract String readData();
}

public class GyroscopeSensor extends DeviceSensor {
    @Override
    public String readData() {
        return "Данные гироскопа";
    }
}

public class LightSensor extends DeviceSensor {
    @Override
    public String readData() {
        return "Данные датчика освещенности";
    }
}
```

### 4. Виджеты с кастомной отрисовкой

```java
import java.util.List;

public class ScreenDrawer {
    public void drawScreen(List<UiComponent> components) {
        for (UiComponent component : components) {
            component.render();
        }
    }
}
```

Используются классы `UiComponent`, `ButtonComponent`, `ImageComponent` — они уже даны в примере кода к теме 6 в самом задании, их менять не нужно.

### 5. Тарифные планы подписки

```java
public abstract class Subscription {
    public abstract double calculatePrice();
}

public class MonthlySubscription extends Subscription {
    @Override
    public double calculatePrice() {
        return 299;
    }
}

public class FamilySubscription extends Subscription {
    private int membersCount;

    public FamilySubscription(int membersCount) {
        this.membersCount = membersCount;
    }

    @Override
    public double calculatePrice() {
        return 199 * membersCount;
    }
}

public class AnnualDiscountSubscription extends Subscription {
    @Override
    public double calculatePrice() {
        return 299 * 12 * 0.8;
    }
}
```
## Тема 7

### 1. Контракт хранилища данных

```java
public interface KeyValueStorage {
    void save(String key, String value);
    String get(String key);
    void clear();
}
```

```java
import java.util.HashMap;
import java.util.Map;

public class MemoryStorage implements KeyValueStorage {
    private Map<String, String> data = new HashMap<>();

    @Override
    public void save(String key, String value) {
        data.put(key, value);
    }

    @Override
    public String get(String key) {
        return data.get(key);
    }

    @Override
    public void clear() {
        data.clear();
    }
}
```

### 2. Колбэк загрузки изображения

```java
public interface ImageLoadCallback {
    void onSuccess(String bitmapRef);
    void onError(Throwable error);
}
```

### 3. Слушатель жизненного цикла фоновой задачи

```java
public interface BackgroundTaskListener {
    default void onProgress(int percentage) {
        System.out.println("Прогресс: " + percentage + "%");
    }
}
```

### 4. Множественная реализация

```java
public interface Playable {
    void play();
    void stop();
}

public interface Shareable {
    void shareViaBluetooth();
}

public class MediaFile implements Playable, Shareable {
    @Override
    public void play() {
        System.out.println("Воспроизведение");
    }

    @Override
    public void stop() {
        System.out.println("Остановка");
    }

    @Override
    public void shareViaBluetooth() {
        System.out.println("Отправка по Bluetooth");
    }
}
```

### 5. Функциональный интерфейс для фильтрации

```java
@FunctionalInterface
public interface PredicateValidator<T> {
    boolean validate(T data);
}

public class ValidatorTest {
    public static void main(String[] args) {
        PredicateValidator<String> lengthCheck = data -> data.length() > 5;
        System.out.println(lengthCheck.validate("Привет"));
    }
}
```

---

## Тема 8

### 1. Удаление дубликатов контактов

```java
import java.util.LinkedHashSet;
import java.util.Set;

public class ContactDeduplicator {
    public static void main(String[] args) {
        String[] phones = {"+79990001122", "+79991112233", "+79990001122"};
        Set<String> unique = new LinkedHashSet<>();
        for (String phone : phones) {
            unique.add(phone);
        }
        System.out.println(unique);
    }
}
```

### 2. Очередь сетевых запросов

```java
import java.util.LinkedList;
import java.util.Queue;

public class SyncQueue {
    public static void main(String[] args) {
        Queue<String> queue = new LinkedList<>();
        queue.offer("Действие 1");
        queue.offer("Действие 2");
        queue.offer("Действие 3");

        while (!queue.isEmpty()) {
            System.out.println("Обработка: " + queue.poll());
        }
    }
}
```

### 3. Обобщённый ответ API

```java
public class ApiResponse<T> {
    private int statusCode;
    private T data;
    private String errorMessage;

    public ApiResponse(int statusCode, T data, String errorMessage) {
        this.statusCode = statusCode;
        this.data = data;
        this.errorMessage = errorMessage;
    }

    public boolean isSuccessful() {
        return statusCode >= 200 && statusCode < 300;
    }

    public T getData() {
        return data;
    }

    public String getErrorMessage() {
        return errorMessage;
    }
}
```

### 4. Сортировка товаров

```java
public class Product {
    private String name;
    private double price;
    private double rating;

    public Product(String name, double price, double rating) {
        this.name = name;
        this.price = price;
        this.rating = rating;
    }

    public double getPrice() {
        return price;
    }

    public double getRating() {
        return rating;
    }
}
```

```java
import java.util.Comparator;
import java.util.List;

public class ProductSorter {
    public static void sort(List<Product> products) {
        products.sort(Comparator.comparingDouble(Product::getPrice)
                .thenComparingDouble(Product::getRating));
    }
}
```

### 5. Кэш экранов

```java
import java.util.LinkedHashMap;
import java.util.Map;

public class ScreenCache extends LinkedHashMap<String, String> {
    private static final int MAX_SIZE = 5;

    public ScreenCache() {
        super(16, 0.75f, true);
    }

    @Override
    protected boolean removeEldestEntry(Map.Entry<String, String> eldest) {
        return size() > MAX_SIZE;
    }
}
```

---

## Тема 9

### 1. Пользовательское исключение отсутствия сети

```java
public class NoInternetException extends Exception {
    public NoInternetException(String message) {
        super(message);
    }
}

public class NetworkRequest {
    public static void makeRequest(boolean hasConnection) throws NoInternetException {
        if (!hasConnection) {
            throw new NoInternetException("Нет подключения к интернету");
        }
        System.out.println("Запрос выполнен");
    }
}
```

### 2. try-with-resources

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ConfigReader {
    public static String readConfig(String path) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
            return reader.readLine();
        }
    }
}
```

### 3. Парсинг JSON-поля возраста

```java
public class InvalidUserDataException extends RuntimeException {
    public InvalidUserDataException(String message) {
        super(message);
    }
}

public class AgeParser {
    public static int parseAge(String ageStr) {
        int age = Integer.parseInt(ageStr);
        if (age < 0 || age > 130) {
            throw new InvalidUserDataException("Некорректный возраст: " + age);
        }
        return age;
    }
}
```

### 4. Множественные блоки catch

```java
public class SafeAccess {
    public static void process(String[] data, int index) {
        try {
            String value = data[index];
            System.out.println(value.toUpperCase());
        } catch (NullPointerException e) {
            System.out.println("Значение пустое");
        } catch (IndexOutOfBoundsException e) {
            System.out.println("Неверный индекс");
        } catch (Exception e) {
            System.out.println("Неизвестная ошибка: " + e.getMessage());
        }
    }
}
```

### 5. Безопасное извлечение значения из Bundle

```java
import java.util.Map;

public class SafeBundleReader {
    public static String getString(Map<String, Object> bundle, String key, String defaultValue) {
        try {
            Object value = bundle.get(key);
            return (String) value;
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
```
---

## 50 практических заданий

### Блок 1

**1. Валидатор надежности пароля**

```java
public class PasswordValidator {
    public static boolean isStrong(String pass) {
        if (pass == null || pass.length() < 8) return false;

        boolean isUpper = false;
        boolean isDigit = false;
        boolean isSpec = false;
        String specSymbols = "!@#$%^&*";

        for (char c : pass.toCharArray()) {
            if (Character.isUpperCase(c)) isUpper = true;
            if (Character.isDigit(c)) isDigit = true;
            if (specSymbols.indexOf(c) >= 0) isSpec = true;
        }

        // System.out.println("upper: " + isUpper + " digit: " + isDigit);
        return isUpper && isDigit && isSpec;
    }
}
```

**2. Нормализатор телефонных номеров**

```java
public class PhoneNormalizer {
    public static String normalize(String phone) {
        String digits = phone.replaceAll("[^0-9]", "");
        if (digits.startsWith("8")) {
            digits = "7" + digits.substring(1);
        }
        return "+" + digits;
    }
}
```

**3. Генератор одноразового SMS-кода**

```java
import java.util.Random;

public class OtpGenerator {
    public static String generate() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }
}
```

**4. Проверка срока действия JWT-токена**

```java
public class TokenChecker {
    public static boolean isActive(long expiresAtSeconds) {
        long nowSeconds = System.currentTimeMillis() / 1000;
        return expiresAtSeconds > nowSeconds;
    }
}
```

**5. Маскировка персональных данных**

```java
public class EmailMasker {
    public static String mask(String email) {
        int at = email.indexOf("@");
        String name = email.substring(0, at);
        String domain = email.substring(at);

        if (name.length() <= 2) return email;

        StringBuilder masked = new StringBuilder();
        masked.append(name.charAt(0));
        for (int i = 1; i < name.length() - 1; i++) {
            masked.append("*");
        }
        masked.append(name.charAt(name.length() - 1));

        return masked + domain;
    }
}
```

**6. Блокировщик брутфорса**

```java
public class LoginThrottler {
    private int failedAttempts;
    private long blockedUntil;

    public boolean tryLogin(boolean correctPassword) {
        if (System.currentTimeMillis() < blockedUntil) {
            return false;
        }
        if (correctPassword) {
            failedAttempts = 0;
            return true;
        }
        failedAttempts++;
        if (failedAttempts >= 5) {
            blockedUntil = System.currentTimeMillis() + 60000;
        }
        return false;
    }
}
```

**7. Шифратор перестановкой для локальных заметок**

```java
public class SimpleCipher {
    private static final int SHIFT = 3;

    public static String encrypt(String text) {
        StringBuilder result = new StringBuilder();
        for (char c : text.toCharArray()) {
            result.append((char) (c + SHIFT));
        }
        return result.toString();
    }

    public static String decrypt(String text) {
        StringBuilder result = new StringBuilder();
        for (char c : text.toCharArray()) {
            result.append((char) (c - SHIFT));
        }
        return result.toString();
    }
}
```

**8. Проверка биометрической готовности**

```java
public class BiometricChecker {
    public static boolean isReady(boolean hasSensor, boolean hasPermission, boolean isEnrolled) {
        return hasSensor && hasPermission && isEnrolled;
    }
}
```

**9. Контроль сессии по тайм-ауту**

```java
public class SessionTimeoutChecker {
    public static boolean isTimedOut(long lastActionMillis) {
        long threeMinutes = 3 * 60 * 1000;
        return System.currentTimeMillis() - lastActionMillis > threeMinutes;
    }
}
```

**10. Валидатор промокода**

```java
public class PromoValidator {
    public static boolean isValid(String code) {
        return code.matches("[A-Z]{4}-[0-9]{4}");
    }
}
```

---

### Блок 2

**11. DiffUtil-компаратор элементов списка**

```java
import java.util.ArrayList;
import java.util.List;

public class NewsDiffChecker {
    public static List<Integer> getChangedIds(List<Integer> oldIds, List<Integer> newIds) {
        List<Integer> changed = new ArrayList<>();
        for (Integer id : oldIds) {
            if (!newIds.contains(id)) {
                changed.add(id);
            }
        }
        return changed;
    }
}
```

**12. Пагинация ленты новостей**

```java
import java.util.ArrayList;
import java.util.List;

public class PaginationHelper {
    private static final int PAGE_SIZE = 20;

    public static List<String> getPage(List<String> allNews, int page) {
        int from = page * PAGE_SIZE;
        if (from >= allNews.size()) {
            return new ArrayList<>();
        }
        int to = Math.min(from + PAGE_SIZE, allNews.size());
        return allNews.subList(from, to);
    }
}
```

**13. Группировка контактов по первой букве**

```java
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class ContactGrouper {
    public static Map<Character, List<String>> group(List<String> names) {
        Map<Character, List<String>> result = new TreeMap<>();
        for (String name : names) {
            char letter = Character.toUpperCase(name.charAt(0));
            result.computeIfAbsent(letter, k -> new ArrayList<>()).add(name);
        }
        return result;
    }
}
```

**14. Полнотекстовый фильтр списка**

```java
import java.util.ArrayList;
import java.util.List;

public class ProductFilter {
    public static List<String> filter(List<String> products, String query) {
        List<String> result = new ArrayList<>();
        String lowerQuery = query.toLowerCase();
        for (String product : products) {
            if (product.toLowerCase().contains(lowerQuery)) {
                result.add(product);
            }
        }
        return result;
    }
}
```

**15. Карусель промо-баннеров**

```java
public class BannerCarousel {
    public static int getNext(int currentIndex, int totalBanners) {
        return (currentIndex + 1) % totalBanners;
    }
}
```

**16. Подсчет суммарной стоимости корзины**

```java
public class CartCalculator {
    public static double calculateTotal(double[] prices, double[] discounts) {
        double total = 0;
        for (int i = 0; i < prices.length; i++) {
            total += prices[i] * (1 - discounts[i]);
        }
        return total;
    }
}
```

**17. Удаление свайпом с возможностью отмены**

```java
public class UndoDeleteBuffer {
    private String pendingItem;
    private long deletedAt;
    private static final long CONFIRM_DELAY = 5000;

    public void deleteItem(String item) {
        pendingItem = item;
        deletedAt = System.currentTimeMillis();
    }

    public boolean undo() {
        if (pendingItem != null && System.currentTimeMillis() - deletedAt < CONFIRM_DELAY) {
            pendingItem = null;
            return true;
        }
        return false;
    }
}
```

**18. Сортировка чатов по времени последнего сообщения**

```java
import java.util.Comparator;
import java.util.List;

public class Chat {
    private String name;
    private long lastMessageTime;

    public Chat(String name, long lastMessageTime) {
        this.name = name;
        this.lastMessageTime = lastMessageTime;
    }

    public long getLastMessageTime() {
        return lastMessageTime;
    }
}
```

```java
public class ChatSorter {
    public static void sortByLastMessage(List<Chat> chats) {
        chats.sort(Comparator.comparingLong(Chat::getLastMessageTime).reversed());
    }
}
```

**19. Поиск дубликатов в галерее**

```java
import java.util.ArrayList;
import java.util.List;

public class DuplicateFinder {
    public static List<String> findDuplicates(String[] names, long[] sizes) {
        List<String> duplicates = new ArrayList<>();
        for (int i = 0; i < names.length; i++) {
            for (int j = i + 1; j < names.length; j++) {
                if (names[i].equals(names[j]) && sizes[i] == sizes[j]) {
                    duplicates.add(names[i]);
                }
            }
        }
        return duplicates;
    }
}
```

**20. Ограничитель емкости кэша картинок**

```java
import java.util.LinkedList;

public class ImageCache {
    private LinkedList<Long> fileSizes = new LinkedList<>();
    private static final long MAX_BYTES = 100L * 1024 * 1024;
    private long currentSize;

    public void addImage(long sizeBytes) {
        fileSizes.addLast(sizeBytes);
        currentSize += sizeBytes;
        while (currentSize > MAX_BYTES && !fileSizes.isEmpty()) {
            currentSize -= fileSizes.removeFirst();
        }
    }
}
```
---

### Блок 3

**21. Парсер параметров диплинка**

```java
import java.util.HashMap;
import java.util.Map;

public class DeepLinkParser {
    public static Map<String, String> parse(String url) {
        Map<String, String> params = new HashMap<>();
        int questionIndex = url.indexOf("?");
        if (questionIndex == -1) return params;

        String query = url.substring(questionIndex + 1);
        String[] pairs = query.split("&");
        for (String pair : pairs) {
            String[] keyValue = pair.split("=");
            params.put(keyValue[0], keyValue[1]);
        }
        return params;
    }
}
```

**22. Симулятор Retry-политики**

```java
public class RetrySimulator {
    public static boolean makeRequest(boolean[] attemptsResults) {
        for (int i = 0; i < 3; i++) {
            System.out.println("Попытка " + (i + 1));
            if (i < attemptsResults.length && attemptsResults[i]) {
                System.out.println("Успех");
                return true;
            }
        }
        System.out.println("Все попытки исчерпаны");
        return false;
    }
}
```

**23. Очередь отложенных офлайн-действий**

```java
import java.util.LinkedList;
import java.util.Queue;

public class OfflineActionQueue {
    private Queue<String> actions = new LinkedList<>();

    public void addAction(String action) {
        actions.add(action);
    }

    public void sendAll(boolean hasConnection) {
        if (!hasConnection) return;
        while (!actions.isEmpty()) {
            System.out.println("Отправка: " + actions.poll());
        }
    }
}
```

**24. Слияние локальных данных с сервером**

```java
public class ConflictResolver {
    public static String resolve(long localUpdatedAt, long serverUpdatedAt, String localData, String serverData) {
        if (serverUpdatedAt > localUpdatedAt) {
            return serverData;
        }
        return localData;
    }
}
```

**25. Оценка скорости скачивания файла**

```java
public class SpeedCalculator {
    public static void calculate(long bytes, long millis) {
        double seconds = millis / 1000.0;
        double kbPerSecond = bytes / 1024.0 / seconds;
        double mbitPerSecond = bytes * 8 / 1_000_000.0 / seconds;
        System.out.println(kbPerSecond + " КБ/с");
        System.out.println(mbitPerSecond + " Мбит/с");
    }
}
```

**26. Парсинг заголовков пагинации сервера**

```java
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PaginationHeaderParser {
    public static int getNextPage(String header) {
        Pattern pattern = Pattern.compile("page=(\\d+)");
        Matcher matcher = pattern.matcher(header);
        if (matcher.find()) {
            return Integer.parseInt(matcher.group(1));
        }
        return -1;
    }
}
```

**27. Проверка актуальности кэша по ETag**

```java
public class ETagChecker {
    public static boolean isCacheValid(String savedTag, String receivedTag) {
        return savedTag != null && savedTag.equals(receivedTag);
    }
}
```

**28. Форматирование байтов в читаемый вид**

```java
public class ByteFormatter {
    public static String format(long bytes) {
        if (bytes >= 1024 * 1024) {
            return String.format("%.1f MB", bytes / (1024.0 * 1024.0));
        }
        if (bytes >= 1024) {
            return String.format("%.1f KB", bytes / 1024.0);
        }
        return bytes + " B";
    }
}
```

**29. Имитация веб-сокета для биржевого виджета**

```java
public interface PriceListener {
    void onPriceChanged(double newPrice);
}

public class PriceSimulator {
    public static void simulate(PriceListener listener) throws InterruptedException {
        double price = 100;
        for (int i = 0; i < 5; i++) {
            price += Math.random() * 2 - 1;
            listener.onPriceChanged(price);
            Thread.sleep(1000);
        }
    }
}
```

**30. Валидатор ответа API**

```java
import java.util.Map;

public class ProfileValidator {
    public static boolean isValid(Map<String, Object> profile, String[] requiredFields) {
        for (String field : requiredFields) {
            if (profile.get(field) == null) {
                return false;
            }
        }
        return true;
    }
}
```

---

### Блок 4

**31. Конечный автомат экрана загрузки**

```java
public class ScreenStateHandler {
    public enum ScreenState { LOADING, SUCCESS, EMPTY, ERROR }

    public static String getMessage(ScreenState state) {
        switch (state) {
            case LOADING: return "Загрузка...";
            case SUCCESS: return "Данные загружены";
            case EMPTY: return "Список пуст";
            case ERROR: return "Произошла ошибка";
            default: return "";
        }
    }
}
```

**32. Дебаунсер кликов**

```java
public class ClickDebouncer {
    private long lastClickTime;
    private static final long MIN_INTERVAL = 500;

    public boolean onClick() {
        long now = System.currentTimeMillis();
        if (now - lastClickTime < MIN_INTERVAL) {
            return false;
        }
        lastClickTime = now;
        return true;
    }
}
```

**33. Стек навигации экранов**

```java
import java.util.Stack;

public class BackStack {
    private Stack<String> screens = new Stack<>();

    public void push(String screen) {
        screens.push(screen);
    }

    public String pop() {
        if (!screens.isEmpty()) {
            return screens.pop();
        }
        return null;
    }

    public void popToRoot() {
        while (screens.size() > 1) {
            screens.pop();
        }
    }
}
```

**34. Моделирование темной и светлой темы**

```java
public class ThemePalette {
    public static String getBackgroundColor(boolean isDarkMode) {
        return isDarkMode ? "#121212" : "#FFFFFF";
    }

    public static String getTextColor(boolean isDarkMode) {
        return isDarkMode ? "#FFFFFF" : "#000000";
    }
}
```

**35. Расчет прогресса заполнения профиля**

```java
public class ProfileProgress {
    public static int calculate(boolean hasAvatar, boolean hasBio, boolean hasPhone, boolean hasEmail, boolean hasCity) {
        int total = 5;
        int filled = 0;
        if (hasAvatar) filled++;
        if (hasBio) filled++;
        if (hasPhone) filled++;
        if (hasEmail) filled++;
        if (hasCity) filled++;
        return filled * 100 / total;
    }
}
```

**36. Инвертор цвета текста для контрастности**

```java
public class ContrastCalculator {
    public static String getTextColor(int r, int g, int b) {
        double yiq = (r * 299 + g * 587 + b * 114) / 1000.0;
        return yiq >= 128 ? "black" : "white";
    }
}
```

**37. Форматирование счетчика лайков**

```java
public class LikesFormatter {
    public static String format(long count) {
        if (count >= 1_000_000) {
            return String.format("%.1fM", count / 1_000_000.0);
        }
        if (count >= 1000) {
            return String.format("%.1fK", count / 1000.0);
        }
        return String.valueOf(count);
    }
}
```

**38. Менеджер системных диалогов**

```java
import java.util.LinkedList;
import java.util.Queue;

public class DialogManager {
    private Queue<String> dialogs = new LinkedList<>();
    private boolean isShowing;

    public void showDialog(String message) {
        dialogs.add(message);
        showNext();
    }

    private void showNext() {
        if (!isShowing && !dialogs.isEmpty()) {
            isShowing = true;
            System.out.println("Показ: " + dialogs.poll());
        }
    }

    public void closeCurrent() {
        isShowing = false;
        showNext();
    }
}
```

**39. Валидатор состояния кнопки «Оплатить»**

```java
public class PayButtonValidator {
    public static boolean isEnabled(boolean cartNotEmpty, boolean paymentSelected, boolean addressConfirmed) {
        return cartNotEmpty && paymentSelected && addressConfirmed;
    }
}
```

**40. Транслятор ошибок для пользователя**

```java
import java.util.HashMap;
import java.util.Map;

public class ErrorTranslator {
    private static Map<String, String> messages = new HashMap<>();

    static {
        messages.put("TimeoutException", "Сервер не отвечает, попробуйте позже");
        messages.put("UnknownHostException", "Нет подключения к интернету");
    }

    public static String translate(String exceptionName) {
        return messages.getOrDefault(exceptionName, "Произошла неизвестная ошибка");
    }
}
```
---

### Блок 5

**41. Расчет расстояния между двумя GPS-точками**

```java
public class DistanceCalculator {
    public static double distanceInMeters(double lat1, double lon1, double lat2, double lon2) {
        double R = 6371000;
        double dLat = Math.toRadians(lat2 - lat1);
        double dLon = Math.toRadians(lon2 - lon1);
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(dLon / 2) * Math.sin(dLon / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    }
}
```

**42. Определитель вхождения в геозону**

```java
public class Geofence {
    public static boolean isInside(double lat, double lon, double centerLat, double centerLon, double radiusMeters) {
        double distance = DistanceCalculator.distanceInMeters(lat, lon, centerLat, centerLon);
        return distance <= radiusMeters;
    }
}
```

**43. Энергосберегающий планировщик геолокации**

```java
public class GpsScheduler {
    public static int getIntervalSeconds(int batteryPercent) {
        if (batteryPercent > 50) {
            return 5;
        }
        if (batteryPercent >= 15) {
            return 30;
        }
        return 300;
    }
}
```

**44. Детектор падения смартфона**

```java
public class FallDetector {
    public static boolean isFalling(double x, double y, double z, double threshold) {
        double magnitude = Math.sqrt(x * x + y * y + z * z);
        return magnitude > threshold;
    }
}
```

**45. Шагомер на основе пиковых амплитуд**

```java
public class StepCounter {
    public static int countSteps(double[] accelerationValues, double threshold) {
        int steps = 0;
        for (int i = 1; i < accelerationValues.length - 1; i++) {
            double prev = accelerationValues[i - 1];
            double current = accelerationValues[i];
            double next = accelerationValues[i + 1];
            if (current > prev && current > next && current > threshold) {
                steps++;
            }
        }
        return steps;
    }
}
```

**46. Контроллер яркости по датчику освещенности**

```java
public class BrightnessController {
    public static int getBrightnessPercent(double lux) {
        if (lux < 1) lux = 1;
        double percent = Math.log10(lux) * 25;
        if (percent > 100) percent = 100;
        if (percent < 0) percent = 0;
        return (int) percent;
    }
}
```

**47. Планировщик фоновой синхронизации данных**

```java
public class SyncScheduler {
    public static boolean canSync(boolean hasWifi, boolean isCharging) {
        return hasWifi && isCharging;
    }
}
```

**48. Монитор расхода мобильного трафика**

```java
public class TrafficMonitor {
    private long mobileBytes;
    private long wifiBytes;
    private static final long LIMIT = 5L * 1024 * 1024 * 1024;

    public void addMobileUsage(long bytes) {
        mobileBytes += bytes;
        checkLimit();
    }

    public void addWifiUsage(long bytes) {
        wifiBytes += bytes;
    }

    private void checkLimit() {
        if (mobileBytes >= LIMIT) {
            System.out.println("Превышен лимит мобильного трафика");
        }
    }
}
```

**49. Плеер аудиофайлов**

```java
public class AudioPlayer {
    public enum State { IDLE, INITIALIZED, PREPARED, PLAYING, PAUSED, STOPPED }

    private State currentState = State.IDLE;

    public void initialize() {
        if (currentState == State.IDLE) {
            currentState = State.INITIALIZED;
        }
    }

    public void prepare() {
        if (currentState == State.INITIALIZED) {
            currentState = State.PREPARED;
        }
    }

    public void play() {
        if (currentState == State.PREPARED || currentState == State.PAUSED) {
            currentState = State.PLAYING;
        }
    }

    public void pause() {
        if (currentState == State.PLAYING) {
            currentState = State.PAUSED;
        }
    }

    public void stop() {
        currentState = State.STOPPED;
    }
}
```

**50. Логгер крашей приложения**

```java
public class CrashLogger {
    public static String buildReport(String stackTrace, String androidVersion, String model, long freeSpaceMb) {
        StringBuilder report = new StringBuilder();
        report.append("Android версия: ").append(androidVersion).append("\n");
        report.append("Модель: ").append(model).append("\n");
        report.append("Свободно места: ").append(freeSpaceMb).append(" MB\n");
        report.append("Стектрейс:\n").append(stackTrace);
        return report.toString();
    }
}
```
