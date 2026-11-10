import 'dart:math' as math;

// ===================== ТЕМЫ 1–6 (30 заданий) =====================

// ---------- Тема 1. Числа ----------
// 1.1 Конвертер валют
String convertCurrency(int rub, double rate) => (rub / rate).toStringAsFixed(2);

// 1.2 Безопасный возраст
int parseAge(String input) => int.tryParse(input.trim()) ?? -1;

// 1.3 dp = px / density
double pxToDp(num px, double density) => px / density;
int pxToDpInt(int px, int density) => px ~/ density;

// 1.4 Побитовые флаги сенсоров
const int gps = 1 << 0, camera = 1 << 1, gyro = 1 << 2;
int encodeSensors({bool g = false, bool c = false, bool y = false}) =>
    (g ? gps : 0) | (c ? camera : 0) | (y ? gyro : 0);
bool hasSensor(int flags, int sensor) => (flags & sensor) != 0;

// 1.5 Чётность
bool isEven(int n) => (n & 1) == 0;

// ---------- Тема 2. Строки ----------
// 2.1 Маскирование email
String maskEmail(String email) {
  final parts = email.split('@');
  final name = parts[0];
  if (name.length <= 2) return email;
  return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}@${parts[1]}';
}

// 2.2 Безопасный протокол
bool isSecureUrl(String url) => url.startsWith('https://');

// 2.3 Монограмма
String monogram(String fullName) => fullName
    .trim()
    .split(RegExp(r'\s+'))
    .where((w) => w.isNotEmpty)
    .map((w) => w[0].toUpperCase())
    .join();

// 2.4 Разбор CSV-строки корзины
({String name, int qty, double price}) parseCartLine(String line) {
  final p = line.split(',');
  return (name: p[0], qty: int.parse(p[1]), price: double.parse(p[2]));
}

// 2.5 Реальная длина строки (кодовые точки)
int realLength(String s) => s.runes.length;

// ---------- Тема 3. bool ----------
// 3.1 Доступ к экрану
bool canAccess(bool authorized, bool emailVerified, bool blocked) =>
    authorized && emailVerified && !blocked;

// 3.2 isBlank
bool isBlank(String? input) => input == null || input.trim().isEmpty;

// 3.3 Тоггл
bool toggle(bool isDarkMode) => !isDarkMode;

// 3.4 Аренда авто
bool canRentCar(int age, int experienceYears) =>
    age >= 21 && experienceYears >= 2;

// 3.5 Баланс строго положителен
bool isPositiveBalance(num balance) => balance > 0;

// ---------- Тема 4. List ----------
// 4.1 Уникальные
List<int> unique(List<int> l) => l.toSet().toList(); // Set сохраняет порядок вставки

// 4.2 Пагинация (page начинается с 1)
List<T> getPage<T>(List<T> list, int page, int pageSize) {
  final start = (page - 1) * pageSize;
  if (start < 0 || start >= list.length) return [];
  final end = (start + pageSize).clamp(0, list.length);
  return list.sublist(start, end);
}

// 4.3 Сортировка по убыванию
List<double> sortDesc(List<double> prices) => [...prices]..sort((a, b) => b.compareTo(a));

// 4.4 Первое слово длиннее 8
String firstLong(List<String> words) =>
    words.firstWhere((w) => w.length > 8, orElse: () => 'не найдено');

// 4.5 List.generate
List<String> slots() => List.generate(10, (i) => 'Слот ${i + 1}');

// ---------- Тема 5. Set и Map ----------
// 5.1 Частота слов
Map<String, int> wordFreq(String text) {
  final m = <String, int>{};
  for (final w in text.toLowerCase().split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))) {
    if (w.isEmpty) continue;
    m[w] = (m[w] ?? 0) + 1;
  }
  return m;
}

// 5.2 Симметрическая разность
Set<String> symDiff(Set<String> a, Set<String> b) =>
    a.union(b).difference(a.intersection(b));

// 5.3 Безопасное извлечение настроек
String getSetting(Map<String, dynamic> json, String key, [String def = 'default']) {
  final v = json['settings']?[key];
  return v is String ? v : def;
}

// 5.4 Рубли -> доллары
Map<String, double> toUsd(Map<String, double> rub, double rate) =>
    rub.map((k, v) => MapEntry(k, v / rate));

// 5.5 Группировка по городу
Map<String, List<Map<String, dynamic>>> groupByCity(List<Map<String, dynamic>> users) {
  final res = <String, List<Map<String, dynamic>>>{};
  for (final u in users) {
    res.putIfAbsent(u['city'] as String, () => []).add(u);
  }
  return res;
}

// ---------- Тема 6. Null, Records, Patterns ----------
// 6.1 Центр экрана
(double x, double y) screenCenter(double w, double h) => (w / 2, h / 2);

// 6.2 bio
String displayBio(String? bio) => bio ?? 'Информация отсутствует';

// 6.3 Pattern matching над JSON
String checkPacket(Object? json) => switch (json) {
      {'id': int id} => 'Валидный объект, id=$id',
      {'error': String e} => 'Ошибка: $e',
      _ => 'Неизвестный формат',
    };

// 6.4 late final (вычисляется при первом обращении)
class Lazy {
  late final double expensiveCalculation = _calc();
  double _calc() {
    print('  (вычисляю...)');
    return 42.0 * 2;
  }
}

// 6.5 Безопасный поиск
int firstOrMinusOne(List<int>? numbers) => numbers?.firstOrNull ?? -1;
// вариант из задания: numbers?[0] ?? -1 (упадёт на пустом списке — поэтому firstOrNull надёжнее)
int firstOrMinusOneIdx(List<int>? numbers) =>
    (numbers != null && numbers.isNotEmpty) ? numbers[0] : -1;

void _t(int topic, int n) => print('── Тема $topic · задание $n ──');
void _m(int n) => print('── Смешанное задание $n ──');
void show(String label, Object? v) => print('$label → $v');

void runPart1() {
  _t(1, 1);
  show('convertCurrency(10000, 92.5)', convertCurrency(10000, 92.5));
  _t(1, 2);
  show("parseAge('25')", parseAge('25'));
  show("parseAge('abc')", parseAge('abc'));
  _t(1, 3);
  show('pxToDp(1080, 2.625)', pxToDp(1080, 2.625));
  show('pxToDpInt(1080, 3)', pxToDpInt(1080, 3));
  _t(1, 4);
  final f = encodeSensors(g: true, y: true);
  show('encodeSensors(GPS + гироскоп)', f);
  show('hasSensor(flags, gps)', hasSensor(f, gps));
  show('hasSensor(flags, camera)', hasSensor(f, camera));
  show('hasSensor(flags, gyro)', hasSensor(f, gyro));
  _t(1, 5);
  show('isEven(4)', isEven(4));
  show('isEven(7)', isEven(7));

  _t(2, 1);
  show("maskEmail('ivanov.flutter@gmail.com')", maskEmail('ivanov.flutter@gmail.com'));
  _t(2, 2);
  show("isSecureUrl('https://a.ru')", isSecureUrl('https://a.ru'));
  show("isSecureUrl('http://a.ru')", isSecureUrl('http://a.ru'));
  _t(2, 3);
  show("monogram('Александр Пушкин')", monogram('Александр Пушкин'));
  _t(2, 4);
  show("parseCartLine('Яблоко,3,150.5')", parseCartLine('Яблоко,3,150.5'));
  _t(2, 5);
  const s = 'Доставлен 🚀';
  show("s = '$s'; s.length", s.length);
  show('realLength(s) — по кодовым точкам (runes)', realLength(s));

  _t(3, 1);
  show('canAccess(авторизован, email подтверждён, не заблокирован)', canAccess(true, true, false));
  show('canAccess(авторизован, email подтверждён, заблокирован)', canAccess(true, true, true));
  _t(3, 2);
  show("isBlank('   ')", isBlank('   '));
  show('isBlank(null)', isBlank(null));
  show("isBlank('текст')", isBlank('текст'));
  _t(3, 3);
  show('toggle(true)', toggle(true));
  show('toggle(false)', toggle(false));
  _t(3, 4);
  show('canRentCar(возраст 21, стаж 2)', canRentCar(21, 2));
  show('canRentCar(возраст 20, стаж 5)', canRentCar(20, 5));
  _t(3, 5);
  show('isPositiveBalance(0)', isPositiveBalance(0));
  show('isPositiveBalance(150.5)', isPositiveBalance(150.5));

  _t(4, 1);
  show('unique([1, 2, 2, 3, 1])', unique([1, 2, 2, 3, 1]));
  _t(4, 2);
  show('getPage(список 0..24, страница 3, размер 10)', getPage(List.generate(25, (i) => i), 3, 10));
  _t(4, 3);
  show('sortDesc([10.5, 99.0, 3.2])', sortDesc([10.5, 99.0, 3.2]));
  _t(4, 4);
  show("firstLong(['кот', 'программирование'])", firstLong(['кот', 'программирование']));
  show("firstLong(['кот', 'пёс'])", firstLong(['кот', 'пёс']));
  _t(4, 5);
  show('List.generate(10, …)', slots());

  _t(5, 1);
  show("wordFreq('Привет мир, привет Dart')", wordFreq('Привет мир, привет Dart'));
  _t(5, 2);
  show("symDiff({'a','b'}, {'b','c'})", symDiff({'a', 'b'}, {'b', 'c'}));
  _t(5, 3);
  show("getSetting({'settings': {'theme': 'dark'}}, 'theme')", getSetting({'settings': {'theme': 'dark'}}, 'theme'));
  show("getSetting({}, 'theme', 'light')", getSetting({}, 'theme', 'light'));
  _t(5, 4);
  show("toUsd({'phone': 9250.0}, 92.5)", toUsd({'phone': 9250.0}, 92.5));
  _t(5, 5);
  show('groupByCity(...)', groupByCity([
    {'name': 'A', 'city': 'Москва'},
    {'name': 'B', 'city': 'Тула'},
    {'name': 'C', 'city': 'Москва'},
  ]));

  _t(6, 1);
  show('screenCenter(1080, 2400)', screenCenter(1080, 2400));
  _t(6, 2);
  show('displayBio(null)', displayBio(null));
  show("displayBio('Привет')", displayBio('Привет'));
  _t(6, 3);
  show("checkPacket({'id': 7})", checkPacket({'id': 7}));
  show("checkPacket({'error': 'boom'})", checkPacket({'error': 'boom'}));
  show('checkPacket(5)', checkPacket(5));
  _t(6, 4);
  final l = Lazy();
  print('объект создан, к полю ещё не обращались');
  show('l.expensiveCalculation (первое обращение)', l.expensiveCalculation);
  show('l.expensiveCalculation (второе — без пересчёта)', l.expensiveCalculation);
  _t(6, 5);
  show('firstOrMinusOne(null)', firstOrMinusOne(null));
  show('firstOrMinusOne([])', firstOrMinusOne([]));
  show('firstOrMinusOne([5])', firstOrMinusOne([5]));
}


// ===================== 50 СМЕШАННЫХ ЗАДАНИЙ =====================

// ---------- Блок 1: числа (1–10) ----------
// 1. Скидка 15%, но не более 500 ₽
double finalPrice(double total) => total - math.min(total * 0.15, 500.0);

// 2. Форматирование цены: 15400900.5 -> "15 400 900.50 ₽"
String formatPrice(double v) {
  final s = v.toStringAsFixed(2);
  final dot = s.indexOf('.');
  final intPart = s.substring(0, dot);
  final frac = s.substring(dot);
  final buf = StringBuffer();
  for (int i = 0; i < intPart.length; i++) {
    if (i > 0 && (intPart.length - i) % 3 == 0) buf.write(' ');
    buf.write(intPart[i]);
  }
  return '$buf$frac ₽';
}

// 3. Кешбэк: 1 балл за 100 ₽
int cashback(int receipt) => receipt ~/ 100;

// 4. Громкость 0.0..1.0
double clampVolume(double v) => v.clamp(0.0, 1.0).toDouble();

// 5. Байты -> МБ (1 знак)
String bytesToMb(int bytes) => (bytes / (1024 * 1024)).toStringAsFixed(1);

// 6. Прогресс 0.0..1.0
double progress(int current, int total) =>
    total <= 0 ? 0.0 : (current / total).clamp(0.0, 1.0).toDouble();

// 7. Округление вверх до десятка
int roundUp10(int n) => ((n + 9) ~/ 10) * 10;

// 8. Доставка: 200 + 30 за каждый км свыше 5
double deliveryCost(double km) => 200 + (km > 5 ? (km - 5) * 30 : 0);

// 9. Делимость на 1024
bool isMultipleOf1024(int size) => size % 1024 == 0;

// 10. Диапазон цен "1500 - 4500 руб"
(int min, int max)? parsePriceRange(String s) {
  final m = RegExp(r'(\d+)\s*-\s*(\d+)').firstMatch(s);
  if (m == null) return null;
  return (int.parse(m.group(1)!), int.parse(m.group(2)!));
}

// ---------- Блок 2: строки (11–20) ----------
// 11. Пароль: >=8, цифра, заглавная
bool validPassword(String p) =>
    RegExp(r'^(?=.*\d)(?=.*\p{Lu}).{8,}$', unicode: true).hasMatch(p);

// 12. Очистка поиска
String cleanSearch(String q) => q
    .replaceAll(RegExp(r'[#$%]'), '')
    .replaceAll(RegExp(r'\s+'), ' ')
    .trim()
    .toLowerCase();

// 13. "Иванов Иван Иванович" -> "Иванов И. И."
String shortName(String full) {
  final p = full.trim().split(RegExp(r'\s+'));
  if (p.length < 2) return full.trim();
  return '${p[0]} ${p.skip(1).map((w) => '${w[0].toUpperCase()}.').join(' ')}';
}

// 14. HEX -> int цвета
int hexToColor(String hex) {
  var h = hex.replaceFirst('#', '');
  if (h.length == 6) h = 'FF$h';
  return int.parse(h, radix: 16);
}

// 15. Таймер mm:ss
String formatTimer(int seconds) =>
    '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

// 16. Скрытие телефона
String maskPhone(String phone) {
  final d = phone.replaceAll(RegExp(r'\D'), ''); // 79991234567
  if (d.length != 11) return phone;
  return '+${d[0]} (${d.substring(1, 4)}) ***-**-${d.substring(9)}';
}

// 17. Есть ли кириллица (диапазон кодовых точек)
bool hasCyrillic(String s) => s.runes.any((r) => (r >= 0x0400 && r <= 0x04FF));

// 18. Slugify (транслитерация)
String slugify(String title) {
  const map = {
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'е': 'e', 'ё': 'e',
    'ж': 'zh', 'з': 'z', 'и': 'i', 'й': 'i', 'к': 'k', 'л': 'l', 'м': 'm',
    'н': 'n', 'о': 'o', 'п': 'p', 'р': 'r', 'с': 's', 'т': 't', 'у': 'u',
    'ф': 'f', 'х': 'kh', 'ц': 'ts', 'ч': 'ch', 'ш': 'sh', 'щ': 'shch',
    'ъ': '', 'ы': 'y', 'ь': '', 'э': 'e', 'ю': 'iu', 'я': 'ia',
  };
  final t = title.toLowerCase().split('').map((c) => map[c] ?? c).join();
  return t
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

// 19. Слова в заметке
int wordCount(String text) =>
    text.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;

// 20. Хештеги
List<String> hashtags(String text) =>
    RegExp(r'#[\p{L}\p{N}_]+', unicode: true).allMatches(text).map((m) => m.group(0)!).toList();

// ---------- Блок 3: списки (21–30) ----------
class Product {
  final String name, category;
  final double price, rating;
  final bool inStock;
  const Product(this.name, this.category, this.price, this.rating, this.inStock);
  @override
  String toString() => name;
}

class Task {
  final String title;
  final bool isCompleted;
  const Task(this.title, this.isCompleted);
}

// 21. Фильтр по цене
List<Product> byPrice(List<Product> l, double lo, double hi) =>
    l.where((p) => p.price >= lo && p.price <= hi).toList();

// 22. Невыполненные задачи
List<Task> pending(List<Task> t) => t.where((e) => !e.isCompleted).toList();

// 23. Инверсия без копии: lazy Iterable
Iterable<T> reversedView<T>(List<T> l) => l.reversed;

// 24. Склейка баннеров
List<String> mergeBanners(List<String> a, List<String> b) => [...a, ...b];

// 25. Макс. рейтинг через reduce
Product topRated(List<Product> l) => l.reduce((a, b) => a.rating >= b.rating ? a : b);

// 26. Реклама после каждого 5-го
List<String> withAds(List<String> feed, String ad) => [
      for (int i = 0; i < feed.length; i++) ...[
        feed[i],
        if ((i + 1) % 5 == 0) ad,
      ]
    ];

// 27. Идентичность списков
bool sameLists<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

// 28. Уникальные категории
List<String> categories(List<Product> l) => l.map((p) => p.category).toSet().toList();

// 29. Сортировка: сначала в наличии, затем по цене
List<Product> sortCatalog(List<Product> l) => [...l]
  ..sort((a, b) {
    if (a.inStock != b.inStock) return a.inStock ? -1 : 1;
    return a.price.compareTo(b.price);
  });

// 30. Chunking
List<List<T>> chunk<T>(List<T> l, int size) => [
      for (int i = 0; i < l.length; i += size) l.sublist(i, math.min(i + size, l.length))
    ];

// ---------- Блок 4: Map (31–40) ----------
// 31. Десериализация профиля
({int id, String name, bool isPremium, String theme}) parseProfile(Map<String, dynamic> j) => (
      id: j['id'] as int? ?? 0,
      name: j['name'] as String? ?? 'Гость',
      isPremium: j['isPremium'] as bool? ?? false,
      theme: (j['settings'] as Map?)?['theme'] as String? ?? 'light',
    );

class User {
  final int id;
  final String name;
  User(this.id, this.name);
}

// 32. List<User> -> Map<int, User>
Map<int, User> usersById(List<User> l) => {for (final u in l) u.id: u};

// 33. Слияние (приоритет сервера)
Map<String, dynamic> mergeSettings(Map<String, dynamic> cache, Map<String, dynamic> server) =>
    {...cache, ...server};

// 34. Удаление null
Map<String, dynamic> removeNulls(Map<String, dynamic> m) =>
    Map.of(m)..removeWhere((k, v) => v == null);

// 35. LRU на 5 элементов (LinkedHashMap сохраняет порядок вставки)
class PageCache {
  final int capacity;
  final Map<String, String> _m = {};
  PageCache([this.capacity = 5]);
  void open(String page, String content) {
    _m.remove(page); // обновление "свежести"
    _m[page] = content;
    if (_m.length > capacity) _m.remove(_m.keys.first); // удаляем самый старый
  }
  List<String> get pages => _m.keys.toList();
}

// 36. Инверсия карты
Map<String, String> invert(Map<String, String> m) =>
    {for (final e in m.entries) e.value: e.key};

// 37. Сумма по категориям
Map<String, double> sumByCategory(List<Map<String, dynamic>> items) {
  final r = <String, double>{};
  for (final i in items) {
    final c = i['category'] as String;
    r[c] = (r[c] ?? 0) + (i['price'] as num).toDouble();
  }
  return r;
}

// 38. Обязательные поля
bool hasRequired(Map<String, dynamic> m) =>
    ['status', 'data', 'timestamp'].every(m.containsKey);

// 39. Дерево категорий (вложенная структура: дети лежат внутри родителя)
List<Map<String, dynamic>> categoryTree(List<Map<String, dynamic>> flat) {
  final nodes = {
    for (final c in flat) c['id'] as int: {...c, 'children': <Map<String, dynamic>>[]}
  };
  final roots = <Map<String, dynamic>>[];
  for (final n in nodes.values) {
    final parent = nodes[n['parentId']];
    if (parent == null) {
      roots.add(n); // parentId == null (или родитель не найден) -> корень
    } else {
      (parent['children'] as List<Map<String, dynamic>>).add(n);
    }
  }
  return roots;
}

// 40. Параметры фильтра в URL
String toQuery(Map<String, dynamic> m) =>
    m.entries.map((e) => '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent('${e.value}')}').join('&');

// ---------- Блок 5: Null Safety, Records, Patterns (41–50) ----------
// 41. Геолокация
(double lat, double lon)? parseGeo(String s) {
  final p = s.split(',');
  if (p.length != 2) return null;
  final lat = double.tryParse(p[0].trim());
  final lon = double.tryParse(p[1].trim());
  if (lat == null || lon == null) return null;
  return (lat, lon);
}

// 42. Состояние загрузки
String uiState(({bool isLoading, bool hasError}) s) => switch (s) {
      (isLoading: true, hasError: false) => 'Загрузка...',
      (isLoading: false, hasError: true) => 'Ошибка загрузки',
      (isLoading: false, hasError: false) => 'Данные загружены',
      _ => 'Некорректное состояние',
    };

// 43. Deep null traversal
class Address { final String? street; Address(this.street); }
class Company { final Address? address; Company(this.address); }
class UserC { final Company? company; UserC(this.company); }
String street(UserC? user) => user?.company?.address?.street ?? 'Адрес не указан';

// 44. Сопоставление типов ответа
String handleResponse(Object? r) => switch (r) {
      int code => 'Код: $code',
      String error => 'Ошибка: $error',
      Map data => 'Данные: ${data.length} полей',
      _ => 'Неизвестный ответ',
    };

// 45. Деструктуризация в цикле
int sumPoints(List<(int x, int y)> points) {
  var s = 0;
  for (var (x, y) in points) {
    s += x + y;
  }
  return s;
}

// 46. Swap
(int, int) swap(int a, int b) {
  (a, b) = (b, a);
  return (a, b);
}

// 47. Валидатор формы
({bool isValid, List<String> errors}) validateForm(String name, String email, String pass) {
  final errors = <String>[];
  if (name.trim().isEmpty) errors.add('Имя не может быть пустым');
  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) errors.add('Некорректный email');
  if (pass.length < 8) errors.add('Пароль короче 8 символов');
  return (isValid: errors.isEmpty, errors: errors);
}

// 48. Switch guard
String volumeMsg(int volume) => switch (volume) {
      int v when v > 80 => 'Слишком громко!',
      int v when v < 0 => 'Некорректное значение',
      int v when v < 10 => 'Почти не слышно',
      _ => 'Нормально',
    };

// 49. Очистка телефонной книги
Set<String> cleanPhones(List<String?> raw) => {
      for (final s in raw)
        if (s != null && s.trim().isNotEmpty) ...[
          if (s.replaceAll(RegExp(r'\D'), '').length >= 10) _normPhone(s),
        ]
    };
String _normPhone(String s) {
  var d = s.replaceAll(RegExp(r'\D'), '');
  if (d.length == 11 && d.startsWith('8')) d = '7${d.substring(1)}';
  if (d.length == 10) d = '7$d';
  return '+$d';
}

// 50 (часть). Категории товаров в корзине
Set<String> cartCategories(List<Map<String, dynamic>> cart) =>
    {for (final i in cart) if (i['category'] != null) i['category'] as String};

// 50. Аналитика корзины
({double total, double discountAmount, bool isFreeDelivery}) analyzeCart(
    List<Map<String, dynamic>> cart) {
  double total = 0, discount = 0;
  for (final i in cart) {
    final price = (i['price'] as num).toDouble();
    final qty = (i['qty'] as num?)?.toInt() ?? 1;
    final pct = (i['discount'] as num?)?.toDouble() ?? 0; // в процентах
    final line = price * qty;
    final d = line * pct / 100;
    total += line - d;
    discount += d;
  }
  return (total: total, discountAmount: discount, isFreeDelivery: total >= 2000);
}

void runPart2() {
  final catalog = [
    Product('Телефон', 'Электроника', 30000, 4.5, true),
    Product('Чехол', 'Аксессуары', 500, 4.8, true),
    Product('Наушники', 'Электроника', 5000, 4.2, false),
    Product('Кабель', 'Аксессуары', 300, 3.9, true),
  ];
  _m(1);
  show('finalPrice(1000)', finalPrice(1000));
  show('finalPrice(10000) — скидка ограничена 500', finalPrice(10000));
  _m(2);
  show('formatPrice(15400900.5)', formatPrice(15400900.5));
  _m(3);
  show('cashback(1250)', cashback(1250));
  _m(4);
  show('clampVolume(1.7)', clampVolume(1.7));
  show('clampVolume(-0.2)', clampVolume(-0.2));
  _m(5);
  show('bytesToMb(5 МБ + 300 000 байт)', bytesToMb(5 * 1024 * 1024 + 300000));
  _m(6);
  show('progress(3, 10)', progress(3, 10));
  show('progress(15, 10)', progress(15, 10));
  _m(7);
  show('roundUp10(43)', roundUp10(43));
  show('roundUp10(50)', roundUp10(50));
  _m(8);
  show('deliveryCost(3 км)', deliveryCost(3));
  show('deliveryCost(8 км)', deliveryCost(8));
  _m(9);
  show('isMultipleOf1024(4096)', isMultipleOf1024(4096));
  show('isMultipleOf1024(5000)', isMultipleOf1024(5000));
  _m(10);
  show("parsePriceRange('1500 - 4500 руб')", parsePriceRange('1500 - 4500 руб'));

  _m(11);
  show("validPassword('Abcdef12')", validPassword('Abcdef12'));
  show("validPassword('abcdef12')", validPassword('abcdef12'));
  show("validPassword('Ab1')", validPassword('Ab1'));
  _m(12);
  show("cleanSearch('  Flutter  #Dart  \$ %  Tips ')", cleanSearch('  Flutter  #Dart  \$ %  Tips '));
  _m(13);
  show("shortName('Иванов Иван Иванович')", shortName('Иванов Иван Иванович'));
  _m(14);
  show("hexToColor('#FF5722') в hex", hexToColor('#FF5722').toRadixString(16));
  _m(15);
  show('formatTimer(125)', formatTimer(125));
  _m(16);
  show("maskPhone('+79991234567')", maskPhone('+79991234567'));
  _m(17);
  show("hasCyrillic('hello')", hasCyrillic('hello'));
  show("hasCyrillic('привет')", hasCyrillic('привет'));
  _m(18);
  show("slugify('Быстрый старт во Flutter!')", slugify('Быстрый старт во Flutter!'));
  _m(19);
  show("wordCount('раз два\\nтри   четыре')", wordCount('раз два\nтри   четыре'));
  _m(20);
  show("hashtags('Привет #flutter и #dart_lang!')", hashtags('Привет #flutter и #dart_lang!'));

  _m(21);
  show('byPrice(каталог, 400, 6000)', byPrice(catalog, 400, 6000));
  _m(22);
  show('pending(задачи).length (1 из 2 не выполнена)', pending([Task('a', true), Task('b', false)]).length);
  _m(23);
  show('reversedView([1, 2, 3])', reversedView([1, 2, 3]).toList());
  _m(24);
  show("mergeBanners(['A'], ['B', 'C'])", mergeBanners(['A'], ['B', 'C']));
  _m(25);
  show('topRated(каталог)', topRated(catalog));
  _m(26);
  show('withAds(11 элементов, «AD»)', withAds(List.generate(11, (i) => 'n${i + 1}'), 'AD'));
  _m(27);
  show('sameLists([1, 2], [1, 2])', sameLists([1, 2], [1, 2]));
  show('sameLists([1, 2], [2, 1])', sameLists([1, 2], [2, 1]));
  _m(28);
  show('categories(каталог)', categories(catalog));
  _m(29);
  show('sortCatalog(каталог)', sortCatalog(catalog));
  _m(30);
  show('chunk(список 0..24, 10) — размеры пачек', chunk(List.generate(25, (i) => i), 10).map((c) => c.length).toList());

  _m(31);
  show("parseProfile({'id': 1, 'name': 'Аня', 'settings': {'theme': 'dark'}})", parseProfile({'id': 1, 'name': 'Аня', 'settings': {'theme': 'dark'}}));
  show('parseProfile({})', parseProfile({}));
  _m(32);
  show('usersById([User(1), User(2)]).keys', usersById([User(1, 'A'), User(2, 'B')]).keys.toList());
  _m(33);
  show("mergeSettings({theme: light, lang: ru}, {theme: dark})", mergeSettings({'theme': 'light', 'lang': 'ru'}, {'theme': 'dark'}));
  _m(34);
  show("removeNulls({'a': 1, 'b': null, 'c': 'x'})", removeNulls({'a': 1, 'b': null, 'c': 'x'}));
  _m(35);
  final cache = PageCache();
  for (final p in ['1', '2', '3', '4', '5', '6']) {
    cache.open(p, 'c');
  }
  show('открыто 6 страниц, в кэше (лимит 5)', cache.pages);
  _m(36);
  show("invert({'a': 'x', 'b': 'y'})", invert({'a': 'x', 'b': 'y'}));
  _m(37);
  show('sumByCategory(...)', sumByCategory([{'category': 'f', 'price': 10}, {'category': 'f', 'price': 5.5}, {'category': 'g', 'price': 1}]));
  _m(38);
  show('hasRequired({status, data, timestamp})', hasRequired({'status': 1, 'data': 2, 'timestamp': 3}));
  show("hasRequired({'status': 1})", hasRequired({'status': 1}));
  _m(39);
  show('categoryTree(плоский список)', categoryTree([{'id': 1, 'parentId': null}, {'id': 2, 'parentId': 1}, {'id': 3, 'parentId': 2}]));
  _m(40);
  show("toQuery({'brand': 'Apple', 'minPrice': 50000})", toQuery({'brand': 'Apple', 'minPrice': 50000}));

  _m(41);
  show("parseGeo('54.01, 38.29')", parseGeo('54.01, 38.29'));
  show("parseGeo('oops')", parseGeo('oops'));
  _m(42);
  show('uiState(isLoading: true, hasError: false)', uiState((isLoading: true, hasError: false)));
  show('uiState(isLoading: false, hasError: true)', uiState((isLoading: false, hasError: true)));
  show('uiState(isLoading: false, hasError: false)', uiState((isLoading: false, hasError: false)));
  _m(43);
  show('street(null)', street(null));
  show("street(UserC(Company(Address('Ленина 1'))))", street(UserC(Company(Address('Ленина 1')))));
  _m(44);
  show('handleResponse(404)', handleResponse(404));
  show("handleResponse('boom')", handleResponse('boom'));
  show("handleResponse({'a': 1})", handleResponse({'a': 1}));
  show('handleResponse(1.5)', handleResponse(1.5));
  _m(45);
  show('sumPoints([(1, 2), (3, 4)])', sumPoints([(1, 2), (3, 4)]));
  _m(46);
  show('swap(1, 2)', swap(1, 2));
  _m(47);
  show("validateForm('', 'bad', '123')", validateForm('', 'bad', '123'));
  show("validateForm('Аня', 'a@b.ru', '12345678')", validateForm('Аня', 'a@b.ru', '12345678'));
  _m(48);
  show('volumeMsg(95)', volumeMsg(95));
  show('volumeMsg(5)', volumeMsg(5));
  show('volumeMsg(50)', volumeMsg(50));
  _m(49);
  show('cleanPhones([...])', cleanPhones(['89991234567', null, '', '+7 (999) 123-45-67', 'abc', '9991234567']));
  _m(50);
  final cart = [
    {'price': 1000, 'qty': 2, 'discount': 10, 'category': 'A'},
    {'price': 500, 'qty': 1, 'category': 'B'},
  ];
  show('analyzeCart(корзина)', analyzeCart(cart));
  show('cartCategories(корзина)', cartCategories(cart));
}


// ===================== АВТОПРОВЕРКИ =====================
int _ok = 0;
void check(String name, Object? actual, Object? expected) {
  if (actual.toString() == expected.toString()) {
    _ok++;
  } else {
    print('❌ $name: получено $actual, ожидалось $expected');
  }
}

void runTests() {
  check('1.1', convertCurrency(10000, 92.5), '108.11');
  check('1.2', [parseAge('25'), parseAge('abc')], [25, -1]);
  check('1.5', [isEven(4), isEven(7)], [true, false]);
  check('2.1', maskEmail('ivanov.flutter@gmail.com'), 'i************r@gmail.com');
  check('2.3', monogram('Александр Пушкин'), 'АП');
  check('3.2', [isBlank(null), isBlank(''), isBlank('  '), isBlank('a')], [true, true, true, false]);
  check('4.1', unique([1, 2, 2, 3, 1]), [1, 2, 3]);
  check('4.2', getPage(List.generate(25, (i) => i), 3, 10), [20, 21, 22, 23, 24]);
  check('5.2', symDiff({'a', 'b'}, {'b', 'c'}), {'a', 'c'});
  check('6.5', [firstOrMinusOne(null), firstOrMinusOne([]), firstOrMinusOne([5])], [-1, -1, 5]);
  check('Б1.1', [finalPrice(1000), finalPrice(10000)], [850.0, 9500.0]);
  check('Б1.2', formatPrice(15400900.5), '15 400 900.50 ₽');
  check('Б1.7', [roundUp10(43), roundUp10(50)], [50, 50]);
  check('Б1.8', [deliveryCost(3), deliveryCost(8)], [200.0, 290.0]);
  check('Б1.10', parsePriceRange('1500 - 4500 руб'), '(1500, 4500)');
  check('Б2.11', [validPassword('Abcdef12'), validPassword('abcdef12'), validPassword('Ab1')], [true, false, false]);
  check('Б2.13', shortName('Иванов Иван Иванович'), 'Иванов И. И.');
  check('Б2.14', hexToColor('#FF5722'), 0xFFFF5722);
  check('Б2.15', formatTimer(125), '02:05');
  check('Б2.16', maskPhone('+79991234567'), '+7 (999) ***-**-67');
  check('Б2.18', slugify('Быстрый старт во Flutter!'), 'bystryi-start-vo-flutter');
  check('Б2.20', hashtags('Привет #flutter и #dart_lang!'), ['#flutter', '#dart_lang']);
  check('Б3.26', withAds(List.generate(6, (i) => 'n${i + 1}'), 'AD'), ['n1', 'n2', 'n3', 'n4', 'n5', 'AD', 'n6']);
  check('Б3.30', chunk(List.generate(100, (i) => i), 10).length, 10);
  check('Б4.35', (PageCache()..open('1', '')..open('2', '')..open('3', '')..open('4', '')..open('5', '')..open('6', '')).pages, ['2', '3', '4', '5', '6']);
  check('Б4.40', toQuery({'brand': 'Apple', 'minPrice': 50000}), 'brand=Apple&minPrice=50000');
  final tree = categoryTree([{'id': 1, 'parentId': null}, {'id': 2, 'parentId': 1}]);
  check('Б4.39', (tree[0]['children'] as List).length, 1);
  check('Б5.41', parseGeo('54.01, 38.29'), '(54.01, 38.29)');
  check('Б5.42', uiState((isLoading: true, hasError: false)), 'Загрузка...');
  check('Б5.46', swap(1, 2), '(2, 1)');
  check('Б5.49', cleanPhones(['89991234567', null, '', '+7 (999) 123-45-67']), {'+79991234567'});
  final r = analyzeCart([
    {'price': 1000, 'qty': 2, 'discount': 10, 'category': 'A'},
    {'price': 500, 'qty': 1, 'category': 'B'},
  ]);
  check('Б5.50', r, '(discountAmount: 200.0, isFreeDelivery: true, total: 2300.0)');
  print(_ok == 0 ? 'Тесты не прошли' : '✅ Пройдено проверок: $_ok');
}

void main(List<String> args) {
  if (args.contains("--test")) {
    runTests();
    return;
  }
  runPart1();
  runPart2();
}
