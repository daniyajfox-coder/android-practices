import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

// ============ ТЕМА 1. Классы, инкапсуляция, геттеры/сеттеры ============

// 1.1 Термостат
class Thermostat {
  double _temperatureCelsius;
  Thermostat([this._temperatureCelsius = 20]);

  double get temperatureCelsius => _temperatureCelsius;
  double get temperatureFahrenheit => _temperatureCelsius * 9 / 5 + 32;

  set temperatureCelsius(double value) {
    if (value < -50 || value > 100) {
      throw RangeError('Температура должна быть от -50 до 100 °C, получено $value');
    }
    _temperatureCelsius = value;
  }
}

// 1.2 Шагомер: шаги только растут
class Pedometer {
  int _steps = 0;
  int get steps => _steps;
  void addSteps(int count) {
    if (count <= 0) throw ArgumentError('Можно только увеличивать шаги');
    _steps += count;
  }
}

// 1.3 Книга: 1 страница = 2 минуты
class Book {
  final String title;
  final int pages;
  Book(this.title, this.pages);
  double get estimatedReadingHours => pages * 2 / 60;
}

// 1.4 Пароль: >= 8 символов, хранится псевдо-хэш
class UserCredentials {
  String _passwordHash = '';
  set password(String raw) {
    if (raw.length < 8) throw ArgumentError('Пароль должен быть не короче 8 символов');
    _passwordHash = _pseudoHash(raw);
  }

  bool check(String raw) => _passwordHash.isNotEmpty && _pseudoHash(raw) == _passwordHash;
  bool get hasPassword => _passwordHash.isNotEmpty;

  static String _pseudoHash(String s) {
    var h = 5381; // djb2
    for (final c in s.codeUnits) {
      h = ((h << 5) + h + c) & 0x7FFFFFFF;
    }
    return h.toRadixString(16);
  }
}

// 1.5 Статический счётчик сессий
class DeviceSession {
  static int activeSessionsCount = 0;
  final String device;
  DeviceSession(this.device) {
    activeSessionsCount++;
  }
}

// ============ ТЕМА 2. Конструкторы ============

// 2.1 Цвет: два именованных конструктора
class AppColor {
  final int r, g, b;
  final double opacity;
  const AppColor.fromRGBO(this.r, this.g, this.b, this.opacity);

  factory AppColor.fromHex(String hex) {
    var h = hex.replaceFirst('#', '');
    if (h.length != 6) throw FormatException('Ожидается HEX вида #RRGGBB: $hex');
    return AppColor.fromRGBO(
      int.parse(h.substring(0, 2), radix: 16),
      int.parse(h.substring(2, 4), radix: 16),
      int.parse(h.substring(4, 6), radix: 16),
      1.0,
    );
  }

  @override
  String toString() => 'rgba($r, $g, $b, $opacity)';
}

// 2.2 Константная точка
class Point2D {
  final double x, y;
  const Point2D(this.x, this.y);
}

// 2.3 Rectangle с assert в списке инициализации (assert работает в debug / с --enable-asserts)
class Rectangle {
  final double width, height;
  Rectangle(this.width, this.height) : assert(width > 0 && height > 0, 'Стороны должны быть > 0');
  double get area => width * height;
}

// 2.4 Фабричный синглтон
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  ApiClient._internal();
  factory ApiClient() => _instance;
}

// 2.5 Редирект-конструктор
class Circle {
  final double radius;
  Circle(this.radius);
  Circle.unit() : this(1.0);
}

// ============ ТЕМА 3. Наследование ============

// 3.1 Банковские карты
abstract class BankCard {
  final String number;
  double _balance;
  BankCard(this.number, double balance) : _balance = balance;
  double get balance => _balance;
  double get overdraftLimit;

  bool pay(double amount) {
    if (amount <= 0) return false;
    if (_balance + overdraftLimit >= amount) {
      _balance -= amount;
      return true;
    }
    return false;
  }
}

class DebitCard extends BankCard {
  DebitCard(super.number, super.balance);
  @override
  double get overdraftLimit => 0;
}

class CreditCard extends BankCard {
  final double limit;
  CreditCard(super.number, super.balance, {required this.limit});
  @override
  double get overdraftLimit => limit;
}

// 3.2 Экраны (из примера) + полиморфный список
abstract class BaseScreen {
  final String routeName;
  final bool requiresAuth;
  final List<String> log = [];
  BaseScreen({required this.routeName, this.requiresAuth = false});
  void onInit() => log.add('[$routeName] Инициализация базовых ресурсов экрана');
  void render();
}

class SettingsScreen extends BaseScreen {
  final bool isDarkModeEnabled;
  SettingsScreen({required this.isDarkModeEnabled}) : super(routeName: '/settings', requiresAuth: true);
  @override
  void onInit() {
    super.onInit();
    log.add('[SettingsScreen] Загрузка локальных предпочтений темы');
  }

  @override
  void render() => log.add('Отрисовка экрана настроек (Темная тема: $isDarkModeEnabled)');
}

class HomeScreen extends BaseScreen {
  HomeScreen() : super(routeName: '/home');
  @override
  void render() => log.add('Отрисовка главного экрана');
}

void renderAll(List<BaseScreen> screens) {
  for (final s in screens) {
    s.onInit();
    s.render(); // полиморфный вызов
  }
}

// 3.3 super-параметры
class Entity {
  final int id;
  final String? title;
  Entity({required this.id, this.title});
}

class Article extends Entity {
  final String body;
  Article({required super.id, super.title, this.body = ''});
}

// 3.4 covariant: сужение типа аргумента в наследнике
class Feed {
  String feed(Animal a) => 'Кормим ${a.name}';
}

class Animal {
  final String name;
  Animal(this.name);
}

class Dog extends Animal {
  Dog(super.name);
}

class DogFeed extends Feed {
  @override
  String feed(covariant Dog a) => 'Кормим собаку ${a.name} сухим кормом';
}

// 3.5 @nonVirtual: в Flutter-проекте импортируется из package:meta/meta.dart (или foundation.dart).
// Здесь — локальная аннотация-заглушка, чтобы файл запускался на чистом Dart без pub.
const nonVirtual = Object();

class LicensedApp {
  @nonVirtual
  bool checkLicense(String key) => key.startsWith('LIC-') && key.length == 12;
}

// ============ ТЕМА 4. Интерфейсы, sealed, модификаторы ============

// 4.1 Контракт хранилища
abstract interface class StorageService {
  void save(String key, String val);
  String? read(String key);
  void delete(String key);
}

class MemoryStorageService implements StorageService {
  final Map<String, String> _data = {};
  @override
  void save(String key, String val) => _data[key] = val;
  @override
  String? read(String key) => _data[key];
  @override
  void delete(String key) => _data.remove(key);
}

// 4.2 Множественная реализация
abstract interface class Displayable {
  String show();
}

abstract interface class NetworkConnectable {
  bool connect(String ssid);
}

class SmartTv implements Displayable, NetworkConnectable {
  String? connectedTo;
  @override
  String show() => 'Показываю картинку 4K';
  @override
  bool connect(String ssid) {
    connectedTo = ssid;
    return true;
  }
}

// 4.3 Sealed AuthState
class AuthUser {
  final String name;
  const AuthUser(this.name);
}

sealed class AuthState {}

class Unauthenticated extends AuthState {}

class Authenticating extends AuthState {}

class Authenticated extends AuthState {
  final AuthUser user;
  Authenticated(this.user);
}

class AuthFailed extends AuthState {
  final String reason;
  AuthFailed(this.reason);
}

String describeAuth(AuthState s) => switch (s) {
      Unauthenticated() => 'Войдите в аккаунт',
      Authenticating() => 'Проверяем данные...',
      Authenticated(:final user) => 'Привет, ${user.name}!',
      AuthFailed(:final reason) => 'Ошибка входа: $reason',
    };

// 4.4 base class: в ДРУГОЙ библиотеке можно только extends, implements запрещён.
// (Ограничения действуют между файлами; внутри одного файла компилятор их не применяет.)
base class Engine {
  final int horsePower;
  Engine(this.horsePower);
}

// 4.5 interface class: вне библиотеки можно implements, но не extends
interface class Printer {
  String print(String doc) => 'Печать: $doc';
}

// ============ ТЕМА 5. Миксины ============

// 5.1 JsonPrintable
mixin JsonPrintable {
  Map<String, Object?> toJson();
  String printAsJson() {
    final s = _encode(toJson());
    print(s);
    return s;
  }

  static String _encode(Object? v) {
    if (v == null || v is num || v is bool) return '$v';
    if (v is String) return '"${v.replaceAll('"', r'\"')}"';
    if (v is List) return '[${v.map(_encode).join(',')}]';
    if (v is Map) return '{${v.entries.map((e) => '${_encode('${e.key}')}:${_encode(e.value)}').join(',')}}';
    return _encode('$v');
  }
}

class Person with JsonPrintable {
  final String name;
  final int age;
  Person(this.name, this.age);
  @override
  Map<String, Object?> toJson() => {'name': name, 'age': age};
}

// 5.2 Мини-аналог Flutter ChangeNotifier (во Flutter он из package:flutter/foundation.dart)
class ChangeNotifier {
  final List<void Function()> _listeners = [];
  void addListener(void Function() l) => _listeners.add(l);
  void removeListener(void Function() l) => _listeners.remove(l);
  void notifyListeners() {
    for (final l in List.of(_listeners)) {
      l();
    }
  }

  void dispose() => _listeners.clear();
}

mixin AutoDisposer on ChangeNotifier {
  bool isDisposed = false;

  @override
  void notifyListeners() {
    if (isDisposed) return; // защита: после dispose уведомления игнорируются
    super.notifyListeners();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}

class CounterModel extends ChangeNotifier with AutoDisposer {
  int value = 0;
  void inc() {
    value++;
    notifyListeners();
  }
}

// 5.3 Трекер аналитики
mixin AnalyticsTracker {
  final List<String> trackedEvents = [];
  void trackEvent(String eventName) => trackedEvents.add(eventName);
}

class CustomButton with AnalyticsTracker {
  final String label;
  CustomButton(this.label);
  void onTap() => trackEvent('tap:$label');
}

// 5.4 Линеаризация: побеждает миксин, указанный ПРАВЕЕ (последний)
mixin MixinA {
  String execute() => 'A';
}

mixin MixinB {
  String execute() => 'B';
}

class WithAB with MixinA, MixinB {} // execute() -> 'B'

class WithBA with MixinB, MixinA {} // execute() -> 'A'

// super-цепочка показывает порядок выполнения
class Base {
  List<String> execute() => ['Base'];
}

mixin StepOne on Base {
  @override
  List<String> execute() => [...super.execute(), 'StepOne'];
}

mixin StepTwo on Base {
  @override
  List<String> execute() => [...super.execute(), 'StepTwo'];
}

class Pipeline extends Base with StepOne, StepTwo {}

// 5.5 Мемоизация
mixin MemoizationMixin {
  final Map<String, num> _memo = {};
  int memoHits = 0;

  num memoize(String key, num Function() compute) {
    if (_memo.containsKey(key)) {
      memoHits++;
      return _memo[key]!;
    }
    return _memo[key] = compute();
  }
}

class MathService with MemoizationMixin {
  int computations = 0;
  num factorial(int n) => memoize('fact:$n', () {
        computations++;
        return n <= 1 ? 1 : n * factorial(n - 1);
      });
}
// ============ 50 СМЕШАННЫХ ЗАДАНИЙ ПО ООП ============

// ---------- Блок 1: модели, DTO, конструкторы (1–10) ----------

// 1. Неизменяемая карточка товара
class Product {
  final int id;
  final String name;
  final double price;
  final double discountPercent;
  const Product({required this.id, required this.name, required this.price, this.discountPercent = 0})
      : assert(price >= 0, 'Цена не может быть отрицательной'),
        assert(discountPercent >= 0 && discountPercent <= 100);
  double get priceWithDiscount => price * (1 - discountPercent / 100);
}

// 2. User.fromJson с безопасными дефолтами
class User {
  final int id;
  final String name;
  final String? email;
  final bool isPremium;
  const User({required this.id, required this.name, this.email, this.isPremium = false});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
        name: json['name'] is String ? json['name'] as String : 'Гость',
        email: json['email'] is String ? json['email'] as String : null,
        isPremium: json['isPremium'] is bool ? json['isPremium'] as bool : false,
      );
}

// 3. Multiton локалей
class AppLocale {
  final String code;
  static final Map<String, AppLocale> _instances = {};
  AppLocale._(this.code);
  factory AppLocale(String code) => _instances.putIfAbsent(code, () => AppLocale._(code));
}

// 4. GeoPoint.fromString
class GeoPoint {
  final double lat, lon;
  const GeoPoint(this.lat, this.lon);
  factory GeoPoint.fromString(String s) {
    final p = s.split(',');
    if (p.length != 2) throw FormatException('Ожидается "lat, lon": $s');
    return GeoPoint(double.parse(p[0].trim()), double.parse(p[1].trim()));
  }
  @override
  String toString() => 'GeoPoint($lat, $lon)';
}

// 5. Визитка из записи БД
class ContactCard {
  final String fullName, phone;
  final String? company;
  ContactCard._(this.fullName, this.phone, this.company);
  factory ContactCard.fromDatabaseRecord(Map<String, Object?> row) => ContactCard._(
        '${row['first_name'] ?? ''} ${row['last_name'] ?? ''}'.trim(),
        (row['phone'] as String?) ?? '—',
        row['company'] as String?,
      );
}

// 6. copyWith
class UserModel {
  final String name;
  final String avatarUrl;
  const UserModel({required this.name, required this.avatarUrl});
  UserModel copyWith({String? name, String? avatarUrl}) =>
      UserModel(name: name ?? this.name, avatarUrl: avatarUrl ?? this.avatarUrl);
}

// 7. DateRange
class DateRange {
  final DateTime start, end;
  DateRange(this.start, this.end) : assert(!end.isBefore(start), 'Конец раньше начала');
  Duration get length => end.difference(start);
}

// 8. DTO транзакции
class TransactionDto {
  final String type;
  final double amount;
  final String? from, to;
  TransactionDto.deposit(this.amount, {required this.to})
      : type = 'deposit',
        from = null;
  TransactionDto.withdrawal(this.amount, {required this.from})
      : type = 'withdrawal',
        to = null;
  TransactionDto.transfer(this.amount, {required this.from, required this.to}) : type = 'transfer';
}

// 9. EnvConfig (значения задаются: dart run --define=API_URL=... --define=DEBUG=true)
class EnvConfig {
  final String apiUrl;
  final bool debug;
  const EnvConfig._(this.apiUrl, this.debug);
  factory EnvConfig.fromEnvironment() => const EnvConfig._(
        String.fromEnvironment('API_URL', defaultValue: 'https://api.example.com'),
        bool.fromEnvironment('DEBUG', defaultValue: false),
      );
}

// 10. == и hashCode
class CartItem {
  final int productId;
  final String selectedSize;
  final int qty;
  const CartItem(this.productId, this.selectedSize, [this.qty = 1]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem && other.productId == productId && other.selectedSize == selectedSize;
  @override
  int get hashCode => Object.hash(productId, selectedSize);
}

// ---------- Блок 2: наследование (11–20) ----------

// 11. Уведомления
abstract class InAppNotification {
  final String title;
  final Duration timeout;
  InAppNotification(this.title, this.timeout);
  String get color;
  String get icon;
  String describe() => '$icon [$color] $title (${timeout.inSeconds}с)';
}

class SuccessNotification extends InAppNotification {
  SuccessNotification(String title) : super(title, const Duration(seconds: 3));
  @override
  String get color => 'green';
  @override
  String get icon => '✔';
}

class WarningNotification extends InAppNotification {
  WarningNotification(String title) : super(title, const Duration(seconds: 5));
  @override
  String get color => 'orange';
  @override
  String get icon => '⚠';
}

class CriticalAlertNotification extends InAppNotification {
  CriticalAlertNotification(String title) : super(title, const Duration(seconds: 30));
  @override
  String get color => 'red';
  @override
  String get icon => '⛔';
}

// 12. Диалоги: шаблонный метод
abstract class BaseDialog {
  String get title;
  String buildBody();
  String buildFooter();
  String render() => '=== $title ===\n${buildBody()}\n${buildFooter()}';
}

class ConfirmActionDialog extends BaseDialog {
  final String message;
  ConfirmActionDialog(this.message);
  @override
  String get title => 'Подтверждение';
  @override
  String buildBody() => message;
  @override
  String buildFooter() => '[Подтвердить] [Отмена]';
}

// 13. Медиаплееры
abstract class MediaPlayer {
  bool isPlaying = false;
  Duration position = Duration.zero;
  void play() => isPlaying = true;
  void pause() => isPlaying = false;
  void seek(Duration to) => position = to < Duration.zero ? Duration.zero : to;
}

class AudioPlayer extends MediaPlayer {
  double volume = 1.0;
}

class HlsVideoPlayer extends MediaPlayer {
  String quality = 'auto';
  @override
  void play() {
    quality = 'auto';
    super.play();
  }
}

// 14. Сенсоры
abstract class HardwareSensor {
  final String name;
  HardwareSensor(this.name);
  String read();
}

class AccelerometerSensor extends HardwareSensor {
  final double x, y, z;
  AccelerometerSensor(this.x, this.y, this.z) : super('accelerometer');
  @override
  String read() => 'x=$x y=$y z=$z';
}

class BarometerSensor extends HardwareSensor {
  final double pressureHpa;
  BarometerSensor(this.pressureHpa) : super('barometer');
  @override
  String read() => '$pressureHpa гПа';
}

// 15. Тарифы подписки
abstract class SubscriptionPlan {
  final double basePrice;
  SubscriptionPlan(this.basePrice);
  double get totalPrice;
}

class MonthlyPlan extends SubscriptionPlan {
  MonthlyPlan(super.basePrice);
  @override
  double get totalPrice => basePrice;
}

class AnnualDiscountPlan extends SubscriptionPlan {
  AnnualDiscountPlan(super.basePrice);
  @override
  double get totalPrice => basePrice * 12 * 0.8; // скидка 20%
}

class FamilyPlan extends SubscriptionPlan {
  final int members;
  FamilyPlan(super.basePrice, this.members);
  @override
  double get totalPrice => basePrice * members;
}

// 16. Слои редактора
abstract class CanvasLayer {
  double opacity;
  bool visible;
  int zIndex;
  CanvasLayer({this.opacity = 1.0, this.visible = true, this.zIndex = 0});
  String get kind;
}

class VectorLayer extends CanvasLayer {
  VectorLayer({super.opacity, super.visible, super.zIndex});
  @override
  String get kind => 'vector';
}

class RasterBitmapLayer extends CanvasLayer {
  final int width, height;
  RasterBitmapLayer(this.width, this.height, {super.opacity, super.visible, super.zIndex});
  @override
  String get kind => 'raster ${width}x$height';
}

class TextLayer extends CanvasLayer {
  String text;
  TextLayer(this.text, {super.opacity, super.visible, super.zIndex});
  @override
  String get kind => 'text';
}

// 17. Платёжные шлюзы (защищённое логирование = приватный метод библиотеки)
abstract class PaymentGateway {
  final List<String> logs = [];
  void logEvent(String m) => logs.add('[${runtimeType}] $m');
  bool pay(double amount);
}

class SbpGateway extends PaymentGateway {
  @override
  bool pay(double amount) {
    logEvent('СБП: $amount ₽');
    return amount > 0 && amount <= 600000; // лимит СБП
  }
}

class BankCardGateway extends PaymentGateway {
  @override
  bool pay(double amount) {
    logEvent('Карта: $amount ₽');
    return amount > 0;
  }
}

// 18. Онбординг
abstract class OnboardingStep {
  final int index;
  bool skipped = false;
  OnboardingStep(this.index);
  String get illustration;
  void skip() => skipped = true;
}

class WelcomeStep extends OnboardingStep {
  WelcomeStep() : super(0);
  @override
  String get illustration => 'welcome.svg';
}

class PermissionsStep extends OnboardingStep {
  PermissionsStep() : super(1);
  @override
  String get illustration => 'lock.svg';
}

// 19. Кнопки
class WidgetButton {
  final String label;
  final Future<void> Function()? onPressed;
  WidgetButton(this.label, this.onPressed);
  Future<void> press() async => await onPressed?.call();
}

class AsyncLoadingButton extends WidgetButton {
  bool isLoading = false;
  AsyncLoadingButton(super.label, super.onPressed);
  @override
  Future<void> press() async {
    if (isLoading) return; // защита от двойного нажатия
    isLoading = true;
    try {
      await super.press();
    } finally {
      isLoading = false;
    }
  }
}

// 20. Логгеры
abstract class AppLogger {
  void log(String level, String message);
  void info(String m) => log('INFO', m);
  void error(String m) => log('ERROR', m);
}

class ConsoleLogger extends AppLogger {
  final List<String> out = [];
  @override
  void log(String level, String message) => out.add('[$level] $message');
}

class FileCrashLogger extends AppLogger {
  final List<String> fileLines = []; // имитация файла на диске
  @override
  void log(String level, String message) {
    if (level == 'ERROR') fileLines.add('${DateTime.now().toIso8601String()} $message');
  }
}

// ---------- Блок 3: контракты и репозитории (21–30) ----------

// 21. Repository
abstract interface class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product> getById(int id);
}

class MockProductRepository implements ProductRepository {
  final List<Product> _items = const [
    Product(id: 1, name: 'Телефон', price: 30000),
    Product(id: 2, name: 'Чехол', price: 500),
  ];
  @override
  Future<List<Product>> getAll() async => _items;
  @override
  Future<Product> getById(int id) async =>
      _items.firstWhere((p) => p.id == id, orElse: () => throw StateError('Товар $id не найден'));
}

class NetworkProductRepository implements ProductRepository {
  final Future<List<Map<String, dynamic>>> Function() fetcher; // внедряемый источник (имитация HTTP)
  NetworkProductRepository(this.fetcher);
  Product _map(Map<String, dynamic> j) => Product(
      id: j['id'] as int, name: j['name'] as String, price: (j['price'] as num).toDouble());
  @override
  Future<List<Product>> getAll() async => (await fetcher()).map(_map).toList();
  @override
  Future<Product> getById(int id) async => (await getAll()).firstWhere((p) => p.id == id);
}

// 22. Биометрия
abstract interface class BiometricAuthService {
  Future<bool> canAuthenticate();
  Future<bool> authenticate();
}

class FakeBiometricAuthService implements BiometricAuthService {
  final bool available, succeeds;
  FakeBiometricAuthService({this.available = true, this.succeeds = true});
  @override
  Future<bool> canAuthenticate() async => available;
  @override
  Future<bool> authenticate() async => available && succeeds;
}

// 23. Шифрование (учебный XOR+base64, НЕ настоящий AES — для настоящего нужен пакет encrypt/pointycastle)
abstract interface class CryptoService {
  String encrypt(String plainText);
  String decrypt(String cipherText);
}

class AesCryptoService implements CryptoService {
  final List<int> _key;
  AesCryptoService(String key) : _key = key.codeUnits {
    if (_key.isEmpty) throw ArgumentError('Ключ не может быть пустым');
  }
  List<int> _xor(List<int> data) => [for (var i = 0; i < data.length; i++) data[i] ^ _key[i % _key.length]];
  @override
  String encrypt(String plainText) => _b64(_xor(utf8Bytes(plainText)));
  @override
  String decrypt(String cipherText) => utf8Decode(_xor(_unb64(cipherText)));
}

List<int> utf8Bytes(String s) => Utf8Codec().encode(s);
String utf8Decode(List<int> b) => Utf8Codec().decode(b);
String _b64(List<int> b) => base64Encode(b);
List<int> _unb64(String s) => base64Decode(s);

// 24. Аналитика
abstract interface class AnalyticsProvider {
  void logEvent(String name, Map<String, Object> params);
}

class ConsoleAnalytics implements AnalyticsProvider {
  final List<String> events = [];
  @override
  void logEvent(String name, Map<String, Object> params) => events.add('$name $params');
}

class CompositeAnalyticsProvider implements AnalyticsProvider {
  final List<AnalyticsProvider> providers;
  CompositeAnalyticsProvider(this.providers);
  @override
  void logEvent(String name, Map<String, Object> params) {
    for (final p in providers) {
      try {
        p.logEvent(name, params);
      } catch (_) {/* сбой одного провайдера не должен ломать остальные */}
    }
  }
}

// 25. Геолокатор
abstract interface class LocationService {
  Future<GeoPoint> getCurrent();
  Stream<GeoPoint> get positionStream;
}

class FakeLocationService implements LocationService {
  @override
  Future<GeoPoint> getCurrent() async => const GeoPoint(55.75, 37.61);
  @override
  Stream<GeoPoint> get positionStream async* {
    for (var i = 0; i < 3; i++) {
      yield GeoPoint(55.75 + i * 0.001, 37.61 + i * 0.001);
    }
  }
}

// 26. Уведомления
abstract interface class NotificationSender {
  void sendNow(String title, String body);
  void schedule(String title, String body, DateTime at);
}

class InMemoryNotificationSender implements NotificationSender {
  final List<String> sent = [];
  final List<(DateTime, String)> scheduled = [];
  @override
  void sendNow(String title, String body) => sent.add('$title: $body');
  @override
  void schedule(String title, String body, DateTime at) => scheduled.add((at, '$title: $body'));
}

// 27. Синхронизатор
abstract class DataSyncEngine {
  Future<List<String>> fetchRemoteDelta();
  Future<void> applyLocalChanges(List<String> delta);
  Future<int> sync() async {
    final delta = await fetchRemoteDelta();
    await applyLocalChanges(delta);
    return delta.length;
  }
}

class ListSyncEngine extends DataSyncEngine {
  final List<String> local = [];
  @override
  Future<List<String>> fetchRemoteDelta() async => ['a', 'b'];
  @override
  Future<void> applyLocalChanges(List<String> delta) async => local.addAll(delta);
}

// 28. Сеть
abstract interface class ConnectivityService {
  bool get isOnline;
  Stream<bool> get onConnectionChanged;
}

class FakeConnectivityService implements ConnectivityService {
  final _c = StreamController<bool>.broadcast();
  bool _online = true;
  @override
  bool get isOnline => _online;
  @override
  Stream<bool> get onConnectionChanged => _c.stream;
  void setOnline(bool v) {
    _online = v;
    _c.add(v);
  }

  Future<void> dispose() => _c.close();
}

// 29. KeyValueStorage с generics
abstract interface class KeyValueStorage {
  T? read<T>(String key);
  Future<void> write<T>(String key, T value);
}

class InMemoryKeyValueStorage implements KeyValueStorage {
  final Map<String, Object?> _m = {};
  @override
  T? read<T>(String key) {
    final v = _m[key];
    return v is T ? v : null; // чужой тип -> null, а не TypeError
  }

  @override
  Future<void> write<T>(String key, T value) async => _m[key] = value;
}

// 30. Экспортёры отчётов
abstract interface class ReportExporter {
  String get extension;
  String export(List<Map<String, Object>> rows);
}

class PdfReportExporter implements ReportExporter {
  @override
  String get extension => 'pdf';
  @override
  String export(List<Map<String, Object>> rows) => '%PDF-1.4 stub, rows=${rows.length}';
}

class ExcelReportExporter implements ReportExporter {
  @override
  String get extension => 'csv';
  @override
  String export(List<Map<String, Object>> rows) {
    if (rows.isEmpty) return '';
    final keys = rows.first.keys.toList();
    return [keys.join(';'), ...rows.map((r) => keys.map((k) => '${r[k]}').join(';'))].join('\n');
  }
}

// ---------- Блок 4: миксины (31–40) ----------

// 31. Дебаунс клика
mixin DebounceMixin {
  final Map<String, DateTime> _last = {};
  bool debounced(String action, void Function() fn, {Duration gap = const Duration(milliseconds: 500)}) {
    final now = DateTime.now();
    final prev = _last[action];
    if (prev != null && now.difference(prev) < gap) return false;
    _last[action] = now;
    fn();
    return true;
  }
}

// 32. Восстановление состояния
mixin RestorationMixin {
  final Map<String, String> fields = {};
  static final Map<String, Map<String, String>> _storage = {};
  String get restorationId;
  void onAppPaused() => _storage[restorationId] = Map.of(fields);
  void onAppResumed() {
    final saved = _storage[restorationId];
    if (saved != null) fields..clear()..addAll(saved);
  }
}

class LoginScreenState with RestorationMixin {
  @override
  String get restorationId => 'login';
}

// 33. Проверка сети
class NoNetworkException implements Exception {
  @override
  String toString() => 'NoNetworkException: нет подключения к интернету';
}

mixin NetworkAwareMixin {
  bool get isOnline;
  Future<T> guardedRequest<T>(Future<T> Function() request) async {
    if (!isOnline) throw NoNetworkException();
    return request();
  }
}

class ProfilePresenter with NetworkAwareMixin {
  @override
  bool isOnline;
  ProfilePresenter(this.isOnline);
}

// 34. Форматирование денег
mixin CurrencyFormatterMixin {
  String formatMoney(num value, {String symbol = '₽'}) {
    final s = value.toStringAsFixed(2);
    final dot = s.indexOf('.');
    var ip = s.substring(0, dot);
    final neg = ip.startsWith('-');
    if (neg) ip = ip.substring(1);
    final b = StringBuffer();
    for (var i = 0; i < ip.length; i++) {
      if (i > 0 && (ip.length - i) % 3 == 0) b.write(' ');
      b.write(ip[i]);
    }
    return '${neg ? '-' : ''}$b${s.substring(dot)} $symbol';
  }
}

// 35. Периодическое обновление
mixin PeriodicRefreshMixin {
  Timer? _timer;
  Duration get refreshInterval => const Duration(seconds: 30);
  void onRefresh();
  void startRefreshing() {
    _timer?.cancel();
    _timer = Timer.periodic(refreshInterval, (_) => onRefresh());
  }

  void stopRefreshing() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isRefreshing => _timer != null;
}

class NewsScreen with PeriodicRefreshMixin {
  int refreshes = 0;
  Duration interval = const Duration(seconds: 30);
  @override
  Duration get refreshInterval => interval;
  @override
  void onRefresh() => refreshes++;
}

// 36. Паспорт РФ
mixin PassportValidationMixin {
  bool isValidSeries(String s) => RegExp(r'^\d{4}$').hasMatch(s);
  bool isValidNumber(String s) => RegExp(r'^\d{6}$').hasMatch(s);
  bool isValidDepartmentCode(String s) => RegExp(r'^\d{3}-\d{3}$').hasMatch(s);
  bool isValidPassport(String series, String number, String code) =>
      isValidSeries(series) && isValidNumber(number) && isValidDepartmentCode(code);
}

// 37. Анимация затухания
mixin FadeAnimationMixin {
  double _opacity = 0.0;
  double get opacity => _opacity;
  void fadeStep(double dt, {double durationSeconds = 1.0, bool fadeIn = true}) {
    final delta = dt / durationSeconds * (fadeIn ? 1 : -1);
    _opacity = (_opacity + delta).clamp(0.0, 1.0).toDouble();
  }
}

// 38. Тема
class ThemePalette {
  final String background, text;
  const ThemePalette(this.background, this.text);
  static const light = ThemePalette('#FFFFFF', '#000000');
  static const dark = ThemePalette('#121212', '#FFFFFF');
}

mixin ThemeAccessMixin {
  bool get isDarkTheme;
  ThemePalette get palette => isDarkTheme ? ThemePalette.dark : ThemePalette.light;
}

// 39. Deep links: myapp://product/42?ref=ad
mixin DeepLinkHandlerMixin {
  final List<String> openedScreens = [];
  bool handleDeepLink(String link) {
    final uri = Uri.tryParse(link);
    if (uri == null || uri.scheme != 'myapp') return false;
    final target = uri.host;
    final id = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
    switch (target) {
      case 'product' when id != null:
        openedScreens.add('ProductScreen($id)');
      case 'profile':
        openedScreens.add('ProfileScreen');
      default:
        return false;
    }
    return true;
  }
}

// 40. Аудит админа
class SecurityServer {
  final List<String> received = [];
  void send(String record) => received.add(record);
}

mixin AdminAuditMixin {
  SecurityServer get securityServer;
  String get adminId;
  void audit(String action, {Map<String, Object?> details = const {}}) =>
      securityServer.send('${DateTime.now().toIso8601String()} admin=$adminId action=$action $details');
}

class ModeratorPanel with AdminAuditMixin {
  @override
  final SecurityServer securityServer;
  @override
  final String adminId;
  ModeratorPanel(this.securityServer, this.adminId);
  void banUser(int userId) => audit('ban_user', details: {'userId': userId});
}

// ---------- Блок 5: sealed, модификаторы, паттерны (41–50) ----------

// 41. Состояние корзины
class Item {
  final String name;
  final double price;
  const Item(this.name, this.price);
}

sealed class CartState {}

class CartEmpty extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<Item> items;
  final double total;
  CartLoaded(this.items, this.total);
}

class CartCheckoutError extends CartState {
  final String error;
  CartCheckoutError(this.error);
}

String renderCart(CartState s) => switch (s) {
      CartEmpty() => 'Корзина пуста',
      CartLoading() => 'Загрузка корзины...',
      CartLoaded(:final items, :final total) => 'Товаров: ${items.length}, итого $total ₽',
      CartCheckoutError(:final error) => 'Ошибка оформления: $error',
    };

// 42. Result<T>
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final Exception exception;
  const Failure(this.exception);
}

Result<int> safeParseInt(String s) {
  final v = int.tryParse(s);
  return v == null ? Failure(FormatException('Не число: $s')) : Success(v);
}

String showResult<T>(Result<T> r) => switch (r) {
      Success(:final data) => 'OK: $data',
      Failure(:final exception) => 'Ошибка: $exception',
    };

// 43. События логина
sealed class LoginEvent {}

class LoginEmailChanged extends LoginEvent {
  final String email;
  LoginEmailChanged(this.email);
}

class LoginPasswordChanged extends LoginEvent {
  final String pass;
  LoginPasswordChanged(this.pass);
}

class LoginSubmitted extends LoginEvent {}

class LoginFormState {
  final String email, password;
  final bool submitted;
  const LoginFormState({this.email = '', this.password = '', this.submitted = false});
  LoginFormState reduce(LoginEvent e) => switch (e) {
        LoginEmailChanged(:final email) => LoginFormState(email: email, password: password),
        LoginPasswordChanged(:final pass) => LoginFormState(email: email, password: pass),
        LoginSubmitted() => LoginFormState(email: email, password: password, submitted: true),
      };
}

// 44. final class — нельзя extends/implements вне библиотеки
final class EncryptionKey {
  final List<int> bytes;
  const EncryptionKey(this.bytes);
}

// 45. interface class — вне библиотеки можно только implements
interface class PaymentTerminal {
  String charge(double amount) => 'Списано $amount ₽';
}

// 46. Типобезопасная навигация
sealed class AppRoute {
  const AppRoute();
}

class HomeRoute extends AppRoute {
  const HomeRoute();
}

class ProductRoute extends AppRoute {
  final int id;
  const ProductRoute(this.id);
}

class SettingsRoute extends AppRoute {
  const SettingsRoute();
}

String pathOf(AppRoute r) => switch (r) {
      HomeRoute() => '/',
      ProductRoute(:final id) => '/product/$id',
      SettingsRoute() => '/settings',
    };

// 47. Command + undo
abstract class Command {
  void execute();
  void undo();
}

class TextEditor {
  String text = '';
  final List<Command> _history = [];
  void run(Command c) {
    c.execute();
    _history.add(c);
  }

  bool undo() {
    if (_history.isEmpty) return false;
    _history.removeLast().undo();
    return true;
  }
}

class InsertTextCommand implements Command {
  final TextEditor editor;
  final String chunk;
  InsertTextCommand(this.editor, this.chunk);
  @override
  void execute() => editor.text += chunk;
  @override
  void undo() => editor.text = editor.text.substring(0, editor.text.length - chunk.length);
}

class DeleteLastCharsCommand implements Command {
  final TextEditor editor;
  final int count;
  String _removed = '';
  DeleteLastCharsCommand(this.editor, this.count);
  @override
  void execute() {
    final n = count.clamp(0, editor.text.length);
    _removed = editor.text.substring(editor.text.length - n);
    editor.text = editor.text.substring(0, editor.text.length - n);
  }

  @override
  void undo() => editor.text += _removed;
}

// 48. Builder
class AppNotification {
  final String title, body, icon;
  const AppNotification(this.title, this.body, this.icon);
}

class NotificationBuilder {
  String? _title, _body;
  String _icon = 'default';
  NotificationBuilder setTitle(String t) {
    _title = t;
    return this;
  }

  NotificationBuilder setBody(String b) {
    _body = b;
    return this;
  }

  NotificationBuilder setIcon(String i) {
    _icon = i;
    return this;
  }

  AppNotification build() {
    if (_title == null || _body == null) throw StateError('title и body обязательны');
    return AppNotification(_title!, _body!, _icon);
  }
}

// 49. EventBus
class EventBus {
  final Map<Type, List<void Function(Object)>> _handlers = {};

  void Function() on<T extends Object>(void Function(T) handler) {
    void wrapper(Object e) => handler(e as T);
    (_handlers[T] ??= []).add(wrapper);
    return () => _handlers[T]?.remove(wrapper); // вызов результата = отписка
  }

  void emit<T extends Object>(T event) {
    for (final h in List.of(_handlers[T] ?? const <void Function(Object)>[])) {
      h(event);
    }
  }
}

class UserLoggedIn {
  final String name;
  UserLoggedIn(this.name);
}

class CartChanged {
  final int count;
  CartChanged(this.count);
}

// 50. Заказ такси
sealed class TaxiOrderState {}

class SearchingCar extends TaxiOrderState {}

class CarAssigned extends TaxiOrderState {
  final String driver, plate;
  CarAssigned(this.driver, this.plate);
}

class RideInProgress extends TaxiOrderState {
  final double distanceKm;
  RideInProgress(this.distanceKm);
}

class RideFinished extends TaxiOrderState {
  final double fare;
  RideFinished(this.fare);
}

class RideCancelled extends TaxiOrderState {
  final String reason;
  RideCancelled(this.reason);
}

mixin LocationTrackingMixin {
  final List<GeoPoint> track = [];
  void recordPosition(GeoPoint p) => track.add(p);
  double get distanceKm {
    double d = 0;
    for (var i = 1; i < track.length; i++) {
      d += _haversineKm(track[i - 1], track[i]);
    }
    return d;
  }

  static double _haversineKm(GeoPoint a, GeoPoint b) {
    const r = 6371.0;
    double rad(double x) => x * math.pi / 180;
    final dLat = rad(b.lat - a.lat), dLon = rad(b.lon - a.lon);
    final h = math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(a.lat)) * math.cos(rad(b.lat)) * math.pow(math.sin(dLon / 2), 2);
    return 2 * r * math.asin(math.sqrt(h));
  }
}

mixin FareCalculationMixin {
  double get baseFare => 100;
  double get perKm => 25;
  double calculateFare(double km) => baseFare + perKm * km;
}

class TaxiOrder with LocationTrackingMixin, FareCalculationMixin {
  final int id;
  final GeoPoint from, to;
  final String? promoCode;
  TaxiOrderState state = SearchingCar();

  TaxiOrder._(this.id, this.from, this.to, this.promoCode)
      : assert(id > 0, 'id заказа должен быть положительным');

  factory TaxiOrder.economy(int id, GeoPoint from, GeoPoint to) => TaxiOrder._(id, from, to, null);
  factory TaxiOrder.withPromo(int id, GeoPoint from, GeoPoint to, String promo) =>
      TaxiOrder._(id, from, to, promo);

  @override
  double calculateFare(double km) {
    final fare = super.calculateFare(km);
    return promoCode == 'FIRST' ? fare * 0.9 : fare;
  }
}

class RideController {
  final TaxiOrder order;
  RideController(this.order);

  String describe() => switch (order.state) {
        SearchingCar() => 'Ищем машину...',
        CarAssigned(:final driver, :final plate) => 'Едет $driver ($plate)',
        RideInProgress(:final distanceKm) => 'В пути: ${distanceKm.toStringAsFixed(1)} км',
        RideFinished(:final fare) => 'Поездка завершена, к оплате ${fare.toStringAsFixed(0)} ₽',
        RideCancelled(:final reason) => 'Отменено: $reason',
      };

  void assign(String driver, String plate) {
    if (order.state is! SearchingCar) throw StateError('Нельзя назначить машину в состоянии ${order.state}');
    order.state = CarAssigned(driver, plate);
  }

  void start() {
    if (order.state is! CarAssigned) throw StateError('Сначала нужно назначить машину');
    order.state = RideInProgress(0);
  }

  void move(GeoPoint p) {
    if (order.state is! RideInProgress) return;
    order.recordPosition(p);
    order.state = RideInProgress(order.distanceKm);
  }

  void finish() {
    final s = order.state;
    if (s is! RideInProgress) throw StateError('Поездка не начата');
    order.state = RideFinished(order.calculateFare(s.distanceKm));
  }

  void cancel(String reason) {
    if (order.state is RideFinished) throw StateError('Поездка уже завершена');
    order.state = RideCancelled(reason);
  }
}
// ============ ПРОВЕРКИ И ДЕМО ============
int _ok = 0, _bad = 0;
void check(String name, Object? actual, Object? expected) {
  if (actual.toString() == expected.toString()) {
    _ok++;
  } else {
    _bad++;
    print('❌ $name: получено <$actual>, ожидалось <$expected>');
  }
}

void checkThrows(String name, void Function() f) {
  try {
    f();
    _bad++;
    print('❌ $name: исключение не выброшено');
  } catch (_) {
    _ok++;
  }
}

bool get assertsEnabled {
  var on = false;
  assert(on = true);
  return on;
}

Future<void> runTests() async {
  if (assertsEnabled) {
    checkThrows('2.3 assert', () => Rectangle(-1, 2));
    checkThrows('Б1.1 отриц. цена', () => Product(id: 1, name: 'x', price: -5));
    checkThrows('Б1.7 даты', () => DateRange(DateTime(2026, 2, 1), DateTime(2026, 1, 1)));
  } else {
    print('ℹ assert-проверки пропущены: запустите с флагом --enable-asserts');
  }
  // --- Тема 1 ---
  final t = Thermostat(25);
  check('1.1 F', t.temperatureFahrenheit, 77.0);
  checkThrows('1.1 range', () => t.temperatureCelsius = 150);
  final p = Pedometer()..addSteps(100);
  checkThrows('1.2 минус', () => p.addSteps(-5));
  check('1.2', p.steps, 100);
  check('1.3', Book('Dart', 300).estimatedReadingHours, 10.0);
  final cr = UserCredentials();
  checkThrows('1.4 короткий', () => cr.password = '123');
  cr.password = 'strongPass1';
  check('1.4 check', [cr.check('strongPass1'), cr.check('wrong')], [true, false]);
  DeviceSession('a');
  DeviceSession('b');
  check('1.5', DeviceSession.activeSessionsCount, 2);

  // --- Тема 2 ---
  check('2.1 hex', AppColor.fromHex('#FF5722'), 'rgba(255, 87, 34, 1.0)');
  check('2.2 identical', identical(const Point2D(1, 2), const Point2D(1, 2)), true);
  check('2.3 area', Rectangle(2, 3).area, 6.0);
  check('2.4', identical(ApiClient(), ApiClient()), true);
  check('2.5', Circle.unit().radius, 1.0);

  // --- Тема 3 ---
  final debit = DebitCard('1', 100), credit = CreditCard('2', 100, limit: 500);
  check('3.1', [debit.pay(200), credit.pay(200), credit.balance], [false, true, -100.0]);
  final screens = <BaseScreen>[SettingsScreen(isDarkModeEnabled: true), HomeScreen()];
  renderAll(screens);
  check('3.2', screens.map((s) => s.log.length).toList(), [3, 2]);
  check('3.3', Article(id: 1, title: 'T').title, 'T');
  check('3.4', DogFeed().feed(Dog('Рекс')), 'Кормим собаку Рекс сухим кормом');
  check('3.5', LicensedApp().checkLicense('LIC-1234567'.substring(0, 11) + '8'), true);

  // --- Тема 4 ---
  final st = MemoryStorageService()..save('k', 'v');
  check('4.1', [st.read('k'), (st..delete('k')).read('k')], ['v', null]);
  final tv = SmartTv();
  check('4.2', [tv.show(), tv.connect('home')], ['Показываю картинку 4K', true]);
  check('4.3', describeAuth(Authenticated(const AuthUser('Аня'))), 'Привет, Аня!');
  check('4.3b', describeAuth(AuthFailed('пароль')), 'Ошибка входа: пароль');
  check('4.4', Engine(150).horsePower, 150);
  check('4.5', Printer().print('x'), 'Печать: x');

  // --- Тема 5 ---
  check('5.1', Person('Аня', 20).printAsJson(), '{"name":"Аня","age":20}');
  final cm = CounterModel();
  var calls = 0;
  cm.addListener(() => calls++);
  cm.inc();
  cm.dispose();
  cm.notifyListeners();
  check('5.2', [calls, cm.isDisposed], [1, true]);
  final btn = CustomButton('Купить')..onTap();
  check('5.3', btn.trackedEvents, ['tap:Купить']);
  check('5.4', [WithAB().execute(), WithBA().execute()], ['B', 'A']);
  check('5.4 цепочка', Pipeline().execute(), ['Base', 'StepOne', 'StepTwo']);
  final ms = MathService();
  ms.factorial(10);
  final before = ms.computations;
  ms.factorial(10);
  check('5.5', [ms.factorial(5), ms.computations == before, ms.memoHits > 0], [120, true, true]);

  // --- Блок 1 ---
  check('Б1.1', const Product(id: 1, name: 'x', price: 200, discountPercent: 25).priceWithDiscount, 150.0);
  final u = User.fromJson({'id': '7', 'name': 5});
  check('Б1.2', [u.id, u.name, u.email, u.isPremium], [7, 'Гость', null, false]);
  check('Б1.3', identical(AppLocale('ru'), AppLocale('ru')) && !identical(AppLocale('ru'), AppLocale('en')), true);
  check('Б1.4', GeoPoint.fromString('55.751244, 37.618423'), 'GeoPoint(55.751244, 37.618423)');
  final cc = ContactCard.fromDatabaseRecord({'first_name': 'Иван', 'last_name': 'Петров', 'company': null});
  check('Б1.5', [cc.fullName, cc.phone, cc.company], ['Иван Петров', '—', null]);
  check('Б1.6', const UserModel(name: 'A', avatarUrl: 'u').copyWith(name: 'B').avatarUrl, 'u');
  check('Б1.8', TransactionDto.transfer(5, from: 'a', to: 'b').type, 'transfer');
  check('Б1.9', EnvConfig.fromEnvironment().apiUrl.isNotEmpty, true);
  check('Б1.10', [const CartItem(1, 'M') == const CartItem(1, 'M', 3), const CartItem(1, 'M') == const CartItem(1, 'L'),
      {const CartItem(1, 'M'), const CartItem(1, 'M', 9)}.length], [true, false, 1]);

  // --- Блок 2 ---
  check('Б2.11', SuccessNotification('ok').describe(), '✔ [green] ok (3с)');
  check('Б2.12', ConfirmActionDialog('Удалить?').render().contains('[Подтвердить] [Отмена]'), true);
  final ap = AudioPlayer()..play()..seek(const Duration(seconds: 5));
  check('Б2.13', [ap.isPlaying, ap.position.inSeconds], [true, 5]);
  check('Б2.14', [AccelerometerSensor(0, 0, 9.8).read(), BarometerSensor(1013).read()], ['x=0.0 y=0.0 z=9.8', '1013.0 гПа']);
  check('Б2.15', [MonthlyPlan(100).totalPrice, AnnualDiscountPlan(100).totalPrice, FamilyPlan(100, 3).totalPrice], [100.0, 960.0, 300.0]);
  check('Б2.16', [VectorLayer().kind, RasterBitmapLayer(10, 20).kind, TextLayer('a', zIndex: 3).zIndex], ['vector', 'raster 10x20', 3]);
  final sbp = SbpGateway();
  check('Б2.17', [sbp.pay(100), sbp.pay(700000), sbp.logs.length], [true, false, 2]);
  final w = WelcomeStep()..skip();
  check('Б2.18', [w.skipped, PermissionsStep().illustration], [true, 'lock.svg']);
  var presses = 0;
  final ab = AsyncLoadingButton('Go', () async {
    presses++;
    await Future.delayed(const Duration(milliseconds: 20));
  });
  final f1 = ab.press();
  final loadingDuring = ab.isLoading;
  await ab.press(); // второй вызов игнорируется
  await f1;
  check('Б2.19', [loadingDuring, ab.isLoading, presses], [true, false, 1]);
  final cl = ConsoleLogger()..info('a')..error('b');
  final fl = FileCrashLogger()..info('a')..error('b');
  check('Б2.20', [cl.out, fl.fileLines.length], [['[INFO] a', '[ERROR] b'], 1]);

  // --- Блок 3 ---
  final mock = MockProductRepository();
  check('Б3.21', [(await mock.getAll()).length, (await mock.getById(2)).name], [2, 'Чехол']);
  final net = NetworkProductRepository(() async => [{'id': 5, 'name': 'Кабель', 'price': 300}]);
  check('Б3.21 net', (await net.getById(5)).price, 300.0);
  check('Б3.22', [await FakeBiometricAuthService().authenticate(), await FakeBiometricAuthService(available: false).canAuthenticate()], [true, false]);
  final crypto = AesCryptoService('key');
  final enc = crypto.encrypt('Привет, мир');
  check('Б3.23', [enc != 'Привет, мир', crypto.decrypt(enc)], [true, 'Привет, мир']);
  final a1 = ConsoleAnalytics(), a2 = ConsoleAnalytics();
  CompositeAnalyticsProvider([a1, a2]).logEvent('buy', {'id': 1});
  check('Б3.24', [a1.events.length, a2.events.length], [1, 1]);
  check('Б3.25', (await FakeLocationService().positionStream.toList()).length, 3);
  final ns = InMemoryNotificationSender()..sendNow('a', 'b');
  check('Б3.26', ns.sent, ['a: b']);
  final se = ListSyncEngine();
  check('Б3.27', [await se.sync(), se.local], [2, ['a', 'b']]);
  final conn = FakeConnectivityService();
  final events = <bool>[];
  final sub = conn.onConnectionChanged.listen(events.add);
  conn.setOnline(false);
  await Future.delayed(Duration.zero);
  await sub.cancel();
  await conn.dispose();
  check('Б3.28', [events, conn.isOnline], [[false], false]);
  final kv = InMemoryKeyValueStorage();
  await kv.write<int>('n', 5);
  check('Б3.29', [kv.read<int>('n'), kv.read<String>('n'), kv.read<int>('zzz')], [5, null, null]);
  check('Б3.30', [ExcelReportExporter().export([{'a': 1, 'b': 2}, {'a': 3, 'b': 4}]), PdfReportExporter().extension], ['a;b\n1;2\n3;4', 'pdf']);

  // --- Блок 4 ---
  final deb = _Debouncer();
  var clicks = 0;
  check('Б4.31', [deb.debounced('x', () => clicks++), deb.debounced('x', () => clicks++), clicks], [true, false, 1]);
  final ls = LoginScreenState()..fields['email'] = 'a@b.ru';
  ls.onAppPaused();
  ls.fields.clear();
  ls.onAppResumed();
  check('Б4.32', ls.fields['email'], 'a@b.ru');
  check('Б4.33', await ProfilePresenter(true).guardedRequest(() async => 42), 42);
  try {
    await ProfilePresenter(false).guardedRequest(() async => 1);
    check('Б4.33 offline', 'нет исключения', 'NoNetworkException');
  } on NoNetworkException {
    _ok++;
  }
  check('Б4.34', [_Fmt().formatMoney(15400900.5), _Fmt().formatMoney(-1234)], ['15 400 900.50 ₽', '-1 234.00 ₽']);
  final ns2 = NewsScreen()..interval = const Duration(milliseconds: 20);
  ns2.startRefreshing();
  await Future.delayed(const Duration(milliseconds: 110));
  ns2.stopRefreshing();
  final r = ns2.refreshes;
  await Future.delayed(const Duration(milliseconds: 60));
  check('Б4.35', [r >= 3, ns2.refreshes == r, ns2.isRefreshing], [true, true, false]);
  final pv = _Passport();
  check('Б4.36', [pv.isValidPassport('4510', '123456', '770-001'), pv.isValidPassport('45', '123456', '770-001')], [true, false]);
  final fm = _Fade()..fadeStep(0.5);
  fm.fadeStep(2.0);
  check('Б4.37', [fm.opacity], [1.0]);
  check('Б4.38', [_Themed(true).palette.background, _Themed(false).palette.background], ['#121212', '#FFFFFF']);
  final dl = _DeepLinks();
  check('Б4.39', [dl.handleDeepLink('myapp://product/42?ref=ad'), dl.handleDeepLink('http://x.ru'), dl.openedScreens], [true, false, ['ProductScreen(42)']]);
  final srv = SecurityServer();
  ModeratorPanel(srv, 'adm1').banUser(9);
  check('Б4.40', [srv.received.length, srv.received.first.contains('ban_user')], [1, true]);

  // --- Блок 5 ---
  check('Б5.41', [renderCart(CartEmpty()), renderCart(CartLoaded(const [Item('a', 1)], 1))], ['Корзина пуста', 'Товаров: 1, итого 1.0 ₽']);
  check('Б5.42', [showResult(safeParseInt('12')), showResult(safeParseInt('x'))], ['OK: 12', 'Ошибка: FormatException: Не число: x']);
  final form = const LoginFormState().reduce(LoginEmailChanged('a@b.ru')).reduce(LoginPasswordChanged('123')).reduce(LoginSubmitted());
  check('Б5.43', [form.email, form.password, form.submitted], ['a@b.ru', '123', true]);
  check('Б5.44', const EncryptionKey([1, 2]).bytes, [1, 2]);
  check('Б5.45', PaymentTerminal().charge(10), 'Списано 10.0 ₽');
  check('Б5.46', [pathOf(const HomeRoute()), pathOf(const ProductRoute(5)), pathOf(const SettingsRoute())], ['/', '/product/5', '/settings']);
  final ed = TextEditor();
  ed.run(InsertTextCommand(ed, 'Привет'));
  ed.run(InsertTextCommand(ed, ', мир'));
  ed.run(DeleteLastCharsCommand(ed, 3));
  final s1 = ed.text;
  ed.undo();
  final s2 = ed.text;
  ed.undo();
  ed.undo();
  check('Б5.47', [s1, s2, ed.text, ed.undo()], ['Привет, ', 'Привет, мир', '', false]);
  final n = NotificationBuilder().setTitle('T').setBody('B').setIcon('i').build();
  check('Б5.48', [n.title, n.body, n.icon], ['T', 'B', 'i']);
  checkThrows('Б5.48 пустой', () => NotificationBuilder().setTitle('T').build());
  final bus = EventBus();
  final got = <String>[];
  final unsub = bus.on<UserLoggedIn>((e) => got.add(e.name));
  bus.on<CartChanged>((e) => got.add('cart${e.count}'));
  bus.emit(UserLoggedIn('Аня'));
  bus.emit(CartChanged(2));
  unsub();
  bus.emit(UserLoggedIn('Борис'));
  check('Б5.49', got, ['Аня', 'cart2']);

  final order = TaxiOrder.withPromo(1, const GeoPoint(55.75, 37.61), const GeoPoint(55.80, 37.65), 'FIRST');
  final rc = RideController(order);
  final d0 = rc.describe();
  rc.assign('Иван', 'А123БВ');
  rc.start();
  rc.move(const GeoPoint(55.75, 37.61));
  rc.move(const GeoPoint(55.76, 37.62));
  final inRide = rc.describe();
  rc.finish();
  check('Б5.50', [d0, inRide.startsWith('В пути'), order.state is RideFinished, rc.describe().startsWith('Поездка завершена')],
      ['Ищем машину...', true, true, true]);
  checkThrows('Б5.50 start без машины', () => RideController(TaxiOrder.economy(2, const GeoPoint(0, 0), const GeoPoint(0, 0))).start());
  check('Б5.50 promo', [TaxiOrder.economy(3, const GeoPoint(0, 0), const GeoPoint(0, 0)).calculateFare(10),
      TaxiOrder.withPromo(4, const GeoPoint(0, 0), const GeoPoint(0, 0), 'FIRST').calculateFare(10)], [350.0, 315.0]);

  print(_bad == 0 ? '✅ Пройдено проверок: $_ok' : '⚠ Пройдено: $_ok, провалено: $_bad');
}

// Мелкие хосты для миксинов
class _Debouncer with DebounceMixin {}

class _Fmt with CurrencyFormatterMixin {}

class _Passport with PassportValidationMixin {}

class _Fade with FadeAnimationMixin {}

class _Themed with ThemeAccessMixin {
  @override
  final bool isDarkTheme;
  _Themed(this.isDarkTheme);
}

class _DeepLinks with DeepLinkHandlerMixin {}

void _t(int topic, int n) => print('── Тема $topic · задание $n ──');
void _m(int n) => print('── Смешанное задание $n ──');
void show(String label, Object? v) => print('$label → $v');
Future<void> _w(int ms) => Future.delayed(Duration(milliseconds: ms));

Future<void> runDemo() async {
  // ---------------- Тема 1 ----------------
  _t(1, 1);
  final th = Thermostat(21.5);
  show('Thermostat(21.5): °C', th.temperatureCelsius);
  show('температура в °F', th.temperatureFahrenheit);
  try {
    th.temperatureCelsius = 150;
  } on RangeError catch (e) {
    show('сеттер: 150 °C', 'RangeError: ${e.message}');
  }
  _t(1, 2);
  final ped = Pedometer()..addSteps(100);
  show('addSteps(100) → steps', ped.steps);
  try {
    ped.addSteps(-5);
  } on ArgumentError catch (e) {
    show('addSteps(-5)', 'ArgumentError: ${e.message}');
  }
  _t(1, 3);
  show('Book(«Dart», 300 стр.).estimatedReadingHours', Book('Dart', 300).estimatedReadingHours);
  _t(1, 4);
  final cr = UserCredentials();
  try {
    cr.password = '123';
  } on ArgumentError catch (e) {
    show("password = '123'", 'ArgumentError: ${e.message}');
  }
  cr.password = 'strongPass1';
  show("check('strongPass1')", cr.check('strongPass1'));
  show("check('wrong')", cr.check('wrong'));
  _t(1, 5);
  DeviceSession('phone');
  DeviceSession('tablet');
  show('создано 2 сессии, activeSessionsCount', DeviceSession.activeSessionsCount);

  // ---------------- Тема 2 ----------------
  _t(2, 1);
  show("AppColor.fromHex('#1E88E5')", AppColor.fromHex('#1E88E5'));
  show('AppColor.fromRGBO(255, 0, 0, 0.5)', const AppColor.fromRGBO(255, 0, 0, 0.5));
  _t(2, 2);
  show('identical(const Point2D(1, 2), const Point2D(1, 2))', identical(const Point2D(1, 2), const Point2D(1, 2)));
  _t(2, 3);
  show('Rectangle(2, 3).area', Rectangle(2, 3).area);
  if (assertsEnabled) {
    try {
      Rectangle(-1, 2);
    } on AssertionError catch (e) {
      show('Rectangle(-1, 2)', 'AssertionError: ${e.message}');
    }
  } else {
    print('(assert отключён: запустите с флагом --enable-asserts)');
  }
  _t(2, 4);
  show('identical(ApiClient(), ApiClient())', identical(ApiClient(), ApiClient()));
  _t(2, 5);
  show('Circle.unit().radius', Circle.unit().radius);

  // ---------------- Тема 3 ----------------
  _t(3, 1);
  final debit = DebitCard('1111', 100), credit = CreditCard('2222', 100, limit: 500);
  show('дебетовая (100 ₽): pay(200)', debit.pay(200));
  show('кредитная (100 ₽, лимит 500): pay(200)', credit.pay(200));
  show('баланс кредитной после оплаты', credit.balance);
  _t(3, 2);
  final screens = <BaseScreen>[SettingsScreen(isDarkModeEnabled: true), HomeScreen()];
  renderAll(screens);
  for (final s in screens) {
    s.log.forEach(print);
  }
  _t(3, 3);
  final art = Article(id: 1, title: 'Заголовок', body: 'Текст');
  show('Article(id: 1, title: …).id / title / body', '${art.id} / ${art.title} / ${art.body}');
  _t(3, 4);
  show('DogFeed().feed(Dog(«Рекс»))', DogFeed().feed(Dog('Рекс')));
  _t(3, 5);
  show("LicensedApp().checkLicense('LIC-12345678')", LicensedApp().checkLicense('LIC-12345678'));
  show("LicensedApp().checkLicense('xxx')", LicensedApp().checkLicense('xxx'));

  // ---------------- Тема 4 ----------------
  _t(4, 1);
  final st = MemoryStorageService()..save('token', 'abc');
  show("read('token')", st.read('token'));
  st.delete('token');
  show("после delete → read('token')", st.read('token'));
  _t(4, 2);
  final tv = SmartTv();
  show('SmartTv.show()', tv.show());
  show("SmartTv.connect('home-wifi')", tv.connect('home-wifi'));
  show('SmartTv подключён к', tv.connectedTo);
  _t(4, 3);
  show('Unauthenticated', describeAuth(Unauthenticated()));
  show('Authenticating', describeAuth(Authenticating()));
  show('Authenticated(Аня)', describeAuth(Authenticated(const AuthUser('Аня'))));
  show('AuthFailed(неверный пароль)', describeAuth(AuthFailed('неверный пароль')));
  _t(4, 4);
  show('Engine(150).horsePower', Engine(150).horsePower);
  _t(4, 5);
  show("Printer().print('Отчёт')", Printer().print('Отчёт'));

  // ---------------- Тема 5 ----------------
  _t(5, 1);
  Person('Аня', 20).printAsJson();
  _t(5, 2);
  final cm = CounterModel();
  var calls = 0;
  cm.addListener(() => calls++);
  cm.inc();
  show('inc() → слушатель вызван раз', calls);
  cm.dispose();
  cm.notifyListeners();
  show('после dispose() → слушатель вызван раз', calls);
  show('isDisposed', cm.isDisposed);
  _t(5, 3);
  final btn = CustomButton('Купить')..onTap();
  show('CustomButton.onTap() → trackedEvents', btn.trackedEvents);
  _t(5, 4);
  show('with MixinA, MixinB → execute()', WithAB().execute());
  show('with MixinB, MixinA → execute()', WithBA().execute());
  show('Base with StepOne, StepTwo → execute()', Pipeline().execute());
  _t(5, 5);
  final ms = MathService();
  show('factorial(10)', ms.factorial(10));
  show('вычислений до повтора', ms.computations);
  ms.factorial(10);
  show('вычислений после повторного factorial(10)', ms.computations);
  show('попаданий в кэш', ms.memoHits);

  // ---------------- Блок 1 ----------------
  _m(1);
  const pr = Product(id: 1, name: 'Куртка', price: 200, discountPercent: 25);
  show('Product(price: 200, скидка 25%).priceWithDiscount', pr.priceWithDiscount);
  if (assertsEnabled) {
    try {
      Product(id: 2, name: 'x', price: -5);
    } on AssertionError catch (e) {
      show('Product(price: -5)', 'AssertionError: ${e.message}');
    }
  }
  _m(2);
  final u = User.fromJson({'id': '7', 'name': 5});
  show("User.fromJson({'id': '7', 'name': 5})", 'id=${u.id}, name=${u.name}, email=${u.email}, isPremium=${u.isPremium}');
  _m(3);
  show("identical(AppLocale('ru'), AppLocale('ru'))", identical(AppLocale('ru'), AppLocale('ru')));
  show("identical(AppLocale('ru'), AppLocale('en'))", identical(AppLocale('ru'), AppLocale('en')));
  _m(4);
  show("GeoPoint.fromString('55.751244, 37.618423')", GeoPoint.fromString('55.751244, 37.618423'));
  _m(5);
  final cc = ContactCard.fromDatabaseRecord({'first_name': 'Иван', 'last_name': 'Петров', 'company': null});
  show('ContactCard.fromDatabaseRecord(...)', 'fullName=${cc.fullName}, phone=${cc.phone}, company=${cc.company}');
  _m(6);
  const um = UserModel(name: 'Аня', avatarUrl: 'a.png');
  final um2 = um.copyWith(name: 'Борис');
  show('copyWith(name: «Борис»)', '${um2.name}, ${um2.avatarUrl}');
  _m(7);
  show('DateRange(1 янв — 31 янв).length', DateRange(DateTime(2026, 1, 1), DateTime(2026, 1, 31)).length);
  if (assertsEnabled) {
    try {
      DateRange(DateTime(2026, 2, 1), DateTime(2026, 1, 1));
    } on AssertionError catch (e) {
      show('DateRange(конец раньше начала)', 'AssertionError: ${e.message}');
    }
  }
  _m(8);
  final tr = TransactionDto.transfer(500, from: 'A', to: 'B');
  show('TransactionDto.transfer', 'type=${tr.type}, ${tr.from} → ${tr.to}, ${tr.amount}');
  show('TransactionDto.deposit', TransactionDto.deposit(100, to: 'A').type);
  show('TransactionDto.withdrawal', TransactionDto.withdrawal(50, from: 'A').type);
  _m(9);
  final env = EnvConfig.fromEnvironment();
  show('EnvConfig.fromEnvironment()', 'apiUrl=${env.apiUrl}, debug=${env.debug}');
  _m(10);
  show('CartItem(1, M) == CartItem(1, M, qty 3)', const CartItem(1, 'M') == const CartItem(1, 'M', 3));
  show('CartItem(1, M) == CartItem(1, L)', const CartItem(1, 'M') == const CartItem(1, 'L'));
  show('Set из двух одинаковых CartItem → длина', {const CartItem(1, 'M'), const CartItem(1, 'M', 9)}.length);

  // ---------------- Блок 2 ----------------
  _m(11);
  for (final n in <InAppNotification>[SuccessNotification('Сохранено'), WarningNotification('Мало места'), CriticalAlertNotification('Сбой сервера')]) {
    print(n.describe());
  }
  _m(12);
  print(ConfirmActionDialog('Удалить файл?').render());
  _m(13);
  final ap = AudioPlayer()..play()..seek(const Duration(seconds: 5));
  show('AudioPlayer: isPlaying / position', '${ap.isPlaying} / ${ap.position.inSeconds} с');
  final vp = HlsVideoPlayer()..play();
  show('HlsVideoPlayer: isPlaying / quality', '${vp.isPlaying} / ${vp.quality}');
  _m(14);
  show('AccelerometerSensor.read()', AccelerometerSensor(0, 0, 9.8).read());
  show('BarometerSensor.read()', BarometerSensor(1013).read());
  _m(15);
  show('MonthlyPlan(100).totalPrice', MonthlyPlan(100).totalPrice);
  show('AnnualDiscountPlan(100).totalPrice', AnnualDiscountPlan(100).totalPrice);
  show('FamilyPlan(100, 3 человека).totalPrice', FamilyPlan(100, 3).totalPrice);
  _m(16);
  for (final l in <CanvasLayer>[VectorLayer(), RasterBitmapLayer(10, 20, opacity: 0.5), TextLayer('Привет', zIndex: 3)]) {
    print('${l.kind}: opacity=${l.opacity}, visible=${l.visible}, zIndex=${l.zIndex}');
  }
  _m(17);
  final sbp = SbpGateway();
  show('СБП pay(100)', sbp.pay(100));
  show('СБП pay(700000) — выше лимита', sbp.pay(700000));
  sbp.logs.forEach(print);
  _m(18);
  final w = WelcomeStep()..skip();
  show('WelcomeStep: index / skipped', '${w.index} / ${w.skipped}');
  show('PermissionsStep.illustration', PermissionsStep().illustration);
  _m(19);
  var presses = 0;
  final ab = AsyncLoadingButton('Отправить', () async {
    presses++;
    await _w(20);
  });
  final f1 = ab.press();
  show('во время действия isLoading', ab.isLoading);
  await ab.press();
  await f1;
  show('после завершения isLoading', ab.isLoading);
  show('действие выполнено раз (второе нажатие проигнорировано)', presses);
  _m(20);
  final cl = ConsoleLogger()..info('Запуск')..error('Сбой');
  final fl = FileCrashLogger()..info('Запуск')..error('Сбой');
  show('ConsoleLogger', cl.out);
  show('FileCrashLogger — в «файл» попало записей', fl.fileLines.length);

  // ---------------- Блок 3 ----------------
  _m(21);
  final mock = MockProductRepository();
  show('Mock.getAll()', await mock.getAll());
  show('Mock.getById(2)', await mock.getById(2));
  final net = NetworkProductRepository(() async => [{'id': 5, 'name': 'Кабель', 'price': 300}]);
  show('Network.getById(5).price', (await net.getById(5)).price);
  _m(22);
  show('биометрия доступна: authenticate()', await FakeBiometricAuthService().authenticate());
  show('биометрия недоступна: canAuthenticate()', await FakeBiometricAuthService(available: false).canAuthenticate());
  _m(23);
  final crypto = AesCryptoService('key');
  final enc = crypto.encrypt('Привет, мир');
  show("encrypt('Привет, мир')", enc);
  show('decrypt(...)', crypto.decrypt(enc));
  _m(24);
  final a1 = ConsoleAnalytics(), a2 = ConsoleAnalytics();
  CompositeAnalyticsProvider([a1, _BrokenAnalytics(), a2]).logEvent('buy', {'id': 1});
  show('провайдер 1 получил', a1.events);
  show('провайдер 3 получил (второй провайдер упал, остальные работают)', a2.events);
  _m(25);
  final ls = FakeLocationService();
  show('getCurrent()', await ls.getCurrent());
  show('positionStream', await ls.positionStream.toList());
  _m(26);
  final ns = InMemoryNotificationSender()
    ..sendNow('Заказ', 'Принят')
    ..schedule('Напоминание', 'Оплатите заказ', DateTime(2026, 12, 1, 9));
  show('отправлено сразу', ns.sent);
  show('запланировано', ns.scheduled);
  _m(27);
  final se = ListSyncEngine();
  show('sync() — применено записей', await se.sync());
  show('локальные данные', se.local);
  _m(28);
  final conn = FakeConnectivityService();
  final events = <bool>[];
  final sub = conn.onConnectionChanged.listen(events.add);
  conn.setOnline(false);
  conn.setOnline(true);
  await _w(10);
  await sub.cancel();
  await conn.dispose();
  show('события сети', events);
  _m(29);
  final kv = InMemoryKeyValueStorage();
  await kv.write<int>('count', 5);
  show('read<int>(count)', kv.read<int>('count'));
  show('read<String>(count) — другой тип', kv.read<String>('count'));
  show('read<int>(нет такого ключа)', kv.read<int>('zzz'));
  _m(30);
  final rows = [{'товар': 'Телефон', 'цена': 30000}, {'товар': 'Чехол', 'цена': 500}];
  print('Excel/CSV:\n${ExcelReportExporter().export(rows)}');
  show('PDF', PdfReportExporter().export(rows));

  // ---------------- Блок 4 ----------------
  _m(31);
  final deb = _Debouncer();
  var clicks = 0;
  show('первый клик выполнен', deb.debounced('buy', () => clicks++));
  show('второй клик сразу — отброшен', deb.debounced('buy', () => clicks++));
  show('действие выполнено раз', clicks);
  _m(32);
  final lss = LoginScreenState()..fields['email'] = 'a@b.ru';
  lss.onAppPaused();
  lss.fields.clear();
  show('после сворачивания и очистки полей', lss.fields);
  lss.onAppResumed();
  show('после возврата в приложение', lss.fields);
  _m(33);
  show('онлайн: guardedRequest', await ProfilePresenter(true).guardedRequest(() async => 'профиль загружен'));
  try {
    await ProfilePresenter(false).guardedRequest(() async => 'x');
  } on NoNetworkException catch (e) {
    show('офлайн: guardedRequest', e);
  }
  _m(34);
  show('formatMoney(15400900.5)', _Fmt().formatMoney(15400900.5));
  show('formatMoney(-1234)', _Fmt().formatMoney(-1234));
  _m(35);
  final news = NewsScreen()..interval = const Duration(milliseconds: 20);
  news.startRefreshing();
  await _w(110);
  news.stopRefreshing();
  show('обновлений за 110 мс при интервале 20 мс', news.refreshes >= 3 ? '≥ 3 (таймер работает)' : news.refreshes);
  show('isRefreshing после stopRefreshing()', news.isRefreshing);
  _m(36);
  final pv = _Passport();
  show("паспорт 4510 / 123456 / 770-001", pv.isValidPassport('4510', '123456', '770-001'));
  show("паспорт 45 / 123456 / 770-001", pv.isValidPassport('45', '123456', '770-001'));
  _m(37);
  final fm = _Fade();
  fm.fadeStep(0.5);
  show('fadeStep(0.5 с) → opacity', fm.opacity);
  fm.fadeStep(2.0);
  show('fadeStep(2 с) → opacity (не больше 1)', fm.opacity);
  _m(38);
  show('тёмная тема: фон', _Themed(true).palette.background);
  show('светлая тема: фон', _Themed(false).palette.background);
  _m(39);
  final dl = _DeepLinks();
  show("handleDeepLink('myapp://product/42?ref=ad')", dl.handleDeepLink('myapp://product/42?ref=ad'));
  show("handleDeepLink('http://x.ru')", dl.handleDeepLink('http://x.ru'));
  show('открытые экраны', dl.openedScreens);
  _m(40);
  final srv = SecurityServer();
  ModeratorPanel(srv, 'adm1').banUser(9);
  show('на сервер безопасности отправлено', srv.received.length);
  show('запись содержит', srv.received.first.replaceFirst(RegExp(r'^\S+ '), '… '));

  // ---------------- Блок 5 ----------------
  _m(41);
  show('CartEmpty', renderCart(CartEmpty()));
  show('CartLoading', renderCart(CartLoading()));
  show('CartLoaded', renderCart(CartLoaded(const [Item('Чехол', 500)], 500)));
  show('CartCheckoutError', renderCart(CartCheckoutError('нет связи')));
  _m(42);
  show("safeParseInt('12')", showResult(safeParseInt('12')));
  show("safeParseInt('x')", showResult(safeParseInt('x')));
  _m(43);
  var form = const LoginFormState();
  for (final e in <LoginEvent>[LoginEmailChanged('a@b.ru'), LoginPasswordChanged('12345678'), LoginSubmitted()]) {
    form = form.reduce(e);
    print('${e.runtimeType} → email=${form.email}, password=${form.password}, submitted=${form.submitted}');
  }
  _m(44);
  show('EncryptionKey([1, 2]).bytes', const EncryptionKey([1, 2]).bytes);
  _m(45);
  show('PaymentTerminal().charge(10)', PaymentTerminal().charge(10));
  _m(46);
  show('HomeRoute', pathOf(const HomeRoute()));
  show('ProductRoute(5)', pathOf(const ProductRoute(5)));
  show('SettingsRoute', pathOf(const SettingsRoute()));
  _m(47);
  final ed = TextEditor();
  ed.run(InsertTextCommand(ed, 'Привет'));
  show('вставка «Привет»', ed.text);
  ed.run(InsertTextCommand(ed, ', мир'));
  show('вставка «, мир»', ed.text);
  ed.run(DeleteLastCharsCommand(ed, 3));
  show('удаление 3 символов', ed.text);
  ed.undo();
  show('undo', ed.text);
  ed.undo();
  show('undo', ed.text);
  _m(48);
  final n = NotificationBuilder().setTitle('Привет').setBody('Мир').setIcon('star').build();
  show('build()', '${n.title} / ${n.body} / ${n.icon}');
  try {
    NotificationBuilder().setTitle('Только заголовок').build();
  } on StateError catch (e) {
    show('build() без body', 'StateError: ${e.message}');
  }
  _m(49);
  final bus = EventBus();
  final got = <String>[];
  final unsub = bus.on<UserLoggedIn>((e) => got.add('вход: ${e.name}'));
  bus.on<CartChanged>((e) => got.add('корзина: ${e.count}'));
  bus.emit(UserLoggedIn('Аня'));
  bus.emit(CartChanged(2));
  unsub();
  bus.emit(UserLoggedIn('Борис'));
  show('полученные события (после отписки «Борис» не получен)', got);
  _m(50);
  final order = TaxiOrder.withPromo(1, const GeoPoint(55.75, 37.61), const GeoPoint(55.80, 37.65), 'FIRST');
  final rc = RideController(order);
  print(rc.describe());
  rc.assign('Иван', 'А123БВ');
  print(rc.describe());
  rc.start();
  rc.move(const GeoPoint(55.75, 37.61));
  rc.move(const GeoPoint(55.78, 37.64));
  print(rc.describe());
  rc.finish();
  print(rc.describe());
  try {
    rc.start();
  } on StateError catch (e) {
    show('start() после завершения', 'StateError: ${e.message}');
  }
}

class _BrokenAnalytics implements AnalyticsProvider {
  @override
  void logEvent(String name, Map<String, Object> params) => throw Exception('провайдер недоступен');
}


Future<void> main(List<String> args) async {
  if (args.contains('--test')) {
    await runTests();
  } else {
    await runDemo();
  }
}
