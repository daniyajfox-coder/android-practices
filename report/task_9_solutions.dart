import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

// ================= ТЕМА 1. Future и async/await =================

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Неверный логин или пароль']);
  @override
  String toString() => 'AuthException: $message';
}

// 1.1 Симулятор авторизации (задержку можно сократить для тестов)
Future<bool> login(String user, String pass, {Duration delay = const Duration(milliseconds: 1500)}) async {
  await Future.delayed(delay);
  if (pass == '1234') return true;
  throw AuthException();
}

// 1.2 Параллельное чтение конфигов с разной задержкой -> одна карта
Future<Map<String, String>> loadConfigs({int scaleMs = 100}) async {
  Future<MapEntry<String, String>> read(String name, int ms) async {
    await Future.delayed(Duration(milliseconds: ms * scaleMs ~/ 100));
    return MapEntry(name, 'config of $name');
  }

  final entries = await Future.wait([read('network', 300), read('theme', 100), read('user', 200)]);
  return Map.fromEntries(entries);
}

// 1.3 Гонка зеркал: Future.any
Future<String> fastestMirror({int scaleMs = 1}) => Future.any([
      Future.delayed(Duration(milliseconds: 800 * scaleMs), () => 'mirror-1'),
      Future.delayed(Duration(milliseconds: 1200 * scaleMs), () => 'mirror-2'),
    ]);

// 1.4 Retry: до maxAttempts попыток с паузой
Future<T> retry<T>(Future<T> Function() task,
    {int maxAttempts = 3, Duration delay = const Duration(seconds: 1)}) async {
  for (var attempt = 1;; attempt++) {
    try {
      return await task();
    } catch (_) {
      if (attempt >= maxAttempts) rethrow;
      await Future.delayed(delay);
    }
  }
}

// 1.5 То же, что 1.1, но через then / catchError / whenComplete
Future<String> loginWithThen(String user, String pass,
    {Duration delay = const Duration(milliseconds: 1500), void Function()? onFinally}) {
  return login(user, pass, delay: delay)
      .then((ok) => 'Добро пожаловать, $user')
      .catchError((Object e) => 'Ошибка: $e')
      .whenComplete(() => onFinally?.call());
}

// ================= ТЕМА 2. Stream и async* =================

// 2.1 Секундомер (бесконечный; потребитель ограничивает .take(n))
Stream<int> stopWatch({Duration tick = const Duration(seconds: 1)}) async* {
  var i = 0;
  while (true) {
    await Future.delayed(tick);
    yield ++i;
  }
}

// 2.2 Имитация GPS
Stream<(double lat, double lon)> gpsStream(
    {int count = 5, Duration interval = const Duration(milliseconds: 500), int seed = 1}) async* {
  final rnd = math.Random(seed);
  var lat = 55.751244, lon = 37.618423;
  for (var i = 0; i < count; i++) {
    await Future.delayed(interval);
    lat += (rnd.nextDouble() - 0.5) * 0.0005;
    lon += (rnd.nextDouble() - 0.5) * 0.0005;
    yield (lat, lon);
  }
}

// 2.3 Broadcast котировок
Stream<double> quotes({int count = 5, Duration interval = const Duration(milliseconds: 10)}) async* {
  var price = 100.0;
  for (var i = 0; i < count; i++) {
    await Future.delayed(interval);
    price += i.isEven ? 1.5 : -0.5;
    yield price;
  }
}

// 2.4 fold: сумма 10 чисел
Future<int> sumStream(Stream<int> s) => s.fold(0, (a, b) => a + b);

// 2.5 yield*: последовательное объединение
Stream<T> concatStreams<T>(Stream<T> a, Stream<T> b) async* {
  yield* a;
  yield* b;
}

// ================= ТЕМА 3. StreamController, StreamTransformer =================

// 3.1 Трансформер: верхний регистр
final StreamTransformer<String, String> upperCaseTransformer =
    StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) => sink.add(data.toUpperCase()));

// 3.2 Обёртка поискового ввода: посимвольный ввод -> очищенная строка
class SearchControllerWrapper {
  final _input = StreamController<String>();
  final _output = StreamController<String>.broadcast();
  final StringBuffer _buffer = StringBuffer();

  SearchControllerWrapper() {
    _input.stream.listen((ch) {
      _buffer.write(ch);
      _output.add(_buffer.toString().replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase());
    });
  }

  Sink<String> get sink => _input.sink;
  Stream<String> get cleaned => _output.stream;

  Future<void> dispose() async {
    await _input.close();
    await _output.close();
  }
}

// 3.3 Ошибки в контроллере
Future<List<String>> errorDemo() async {
  final c = StreamController<int>();
  final log = <String>[];
  final done = Completer<void>();
  c.stream.listen((v) => log.add('data:$v'),
      onError: (Object e) => log.add('error:$e'), onDone: done.complete);
  c.sink.add(1);
  c.sink.addError(Exception('Сбой датчика'));
  c.sink.add(2);
  await c.close();
  await done.future;
  return log;
}

// 3.4 Проверка isClosed
bool safeAdd<T>(StreamController<T> c, T value) {
  if (c.isClosed) return false;
  c.add(value);
  return true;
}

// 3.5 Счётчик подписчиков через onListen/onCancel
class TrackedBroadcast<T> {
  int listeners = 0;
  final List<String> log = [];
  late final StreamController<T> controller;

  TrackedBroadcast() {
    controller = StreamController<T>.broadcast(
      onListen: () => log.add('onListen'),
      onCancel: () => log.add('onCancel'),
    );
  }

  StreamSubscription<T> listen(void Function(T) f) {
    listeners++;
    return controller.stream.listen(f);
  }

  Future<void> cancel(StreamSubscription<T> s) async {
    listeners--;
    await s.cancel();
  }
}

// ================= ТЕМА 4. Изоляты =================

class DataRecord {
  final int id;
  final String name;
  final double value;
  const DataRecord(this.id, this.name, this.value);
}

// 4.1 Генерация и парсинг JSON в изоляте
String generateJson(int n) =>
    jsonEncode([for (var i = 0; i < n; i++) {'id': i, 'name': 'item$i', 'value': i * 1.5}]);

List<DataRecord> _parseRecords(String json) => [
      for (final m in (jsonDecode(json) as List).cast<Map<String, dynamic>>())
        DataRecord(m['id'] as int, m['name'] as String, (m['value'] as num).toDouble())
    ];

Future<List<DataRecord>> parseJsonInIsolate(String json) => Isolate.run(() => _parseRecords(json));

// 4.2 Простые числа
int countPrimesUpTo(int limit) {
  final sieve = List<bool>.filled(limit + 1, true);
  if (limit >= 0) sieve[0] = false;
  if (limit >= 1) sieve[1] = false;
  for (var i = 2; i * i <= limit; i++) {
    if (sieve[i]) {
      for (var j = i * i; j <= limit; j += i) {
        sieve[j] = false;
      }
    }
  }
  return sieve.where((e) => e).length;
}

Future<int> primesInBackground(int limit, {void Function()? onDot, Duration dotEvery = const Duration(seconds: 1)}) async {
  final timer = Timer.periodic(dotEvery, (_) => onDot?.call());
  try {
    return await Isolate.run(() => countPrimesUpTo(limit));
  } finally {
    timer.cancel();
  }
}

// 4.3 Двусторонний обмен через порты
class CalculatorIsolate {
  late final Isolate _isolate;
  late final SendPort _send;
  final ReceivePort _receive = ReceivePort();
  late final StreamIterator<dynamic> _it;

  static Future<CalculatorIsolate> start() async {
    final c = CalculatorIsolate();
    c._it = StreamIterator(c._receive);
    c._isolate = await Isolate.spawn(_calcEntry, c._receive.sendPort);
    await c._it.moveNext();
    c._send = c._it.current as SendPort; // воркер сообщает свой порт
    return c;
  }

  Future<num> add(num a, num b) async {
    _send.send(['add', a, b]);
    await _it.moveNext();
    return _it.current as num;
  }

  Future<void> stop() async {
    _send.send('stop');
    await _it.cancel();
    _receive.close();
    _isolate.kill(priority: Isolate.immediate);
  }
}

void _calcEntry(SendPort main) {
  final port = ReceivePort();
  main.send(port.sendPort);
  port.listen((msg) {
    if (msg == 'stop') {
      port.close();
    } else if (msg is List && msg[0] == 'add') {
      main.send((msg[1] as num) + (msg[2] as num));
    }
  });
}

// 4.4 Блокировка главного потока vs изолят: считаем, сколько тиков таймера успело сработать
int heavyLoop(int iterations) {
  var sum = 0;
  for (var i = 0; i < iterations; i++) {
    sum += i % 3;
  }
  return sum;
}

Future<({int ticksSync, int ticksIsolate})> responsivenessTest(int iterations) async {
  Future<int> measure(Future<void> Function() work) async {
    var ticks = 0;
    final t = Timer.periodic(const Duration(milliseconds: 10), (_) => ticks++);
    await Future.delayed(Duration.zero);
    await work();
    t.cancel();
    return ticks;
  }

  final sync = await measure(() async => heavyLoop(iterations)); // блокирует Event Loop -> тиков ~0
  final iso = await measure(() => Isolate.run(() => heavyLoop(iterations))); // таймер живёт
  return (ticksSync: sync, ticksIsolate: iso);
}

// 4.5 Убийство бесконечного изолята
void _infiniteWorker(SendPort p) {
  var i = 0;
  while (true) {
    i++;
    if (i % 50000000 == 0) p.send(i);
  }
}

Future<bool> spawnAndKill() async {
  final rp = ReceivePort();
  final iso = await Isolate.spawn(_infiniteWorker, rp.sendPort);
  final exitPort = ReceivePort();
  iso.addOnExitListener(exitPort.sendPort);
  iso.kill(priority: Isolate.immediate);
  final exited = await exitPort.first.timeout(const Duration(seconds: 3), onTimeout: () => 'timeout');
  rp.close();
  exitPort.close();
  return exited != 'timeout';
}

// ================= БЛОК 1 (1–10): Future, сеть, таймеры =================

class ApiException implements Exception {
  final int status;
  final String message;
  ApiException(this.status, this.message);
  @override
  String toString() => 'ApiException($status): $message';
}

// 1. Имитация HTTP GET
Future<Map<String, dynamic>> fetchData(String url, {Duration latency = const Duration(milliseconds: 1200)}) async {
  await Future.delayed(latency);
  final status = url.contains('/missing') ? 404 : (url.contains('/broken') ? 500 : 200);
  switch (status) {
    case 200:
      return {'status': 200, 'url': url, 'data': {'ok': true}};
    case 404:
      throw ApiException(404, 'Ресурс не найден');
    default:
      throw ApiException(500, 'Внутренняя ошибка сервера');
  }
}

// 2. Exponential backoff: 1с, 2с, 4с, 8с при SocketException
Future<T> retryWithBackoff<T>(Future<T> Function() request,
    {List<int> delaysSec = const [1, 2, 4, 8], Duration unit = const Duration(seconds: 1)}) async {
  for (var attempt = 0;; attempt++) {
    try {
      return await request();
    } on SocketException {
      if (attempt >= delaysSec.length) rethrow;
      await Future.delayed(unit * delaysSec[attempt]);
    }
  }
}

// 3. Параллельная загрузка с лимитом параллелизма
Future<List<T>> runLimited<T>(List<Future<T> Function()> tasks, int limit) async {
  final results = List<T?>.filled(tasks.length, null);
  var next = 0;
  Future<void> worker() async {
    while (true) {
      final i = next++;
      if (i >= tasks.length) return;
      results[i] = await tasks[i]();
    }
  }

  await Future.wait([for (var i = 0; i < math.min(limit, tasks.length); i++) worker()]);
  return results.cast<T>();
}

// 4. Первый УСПЕШНО ответивший сервер (упавшие игнорируем, в отличие от Future.any)
Future<String> firstAlive(List<String> urls, Future<void> Function(String url) ping) {
  final c = Completer<String>();
  var failed = 0;
  for (final u in urls) {
    ping(u).then((_) {
      if (!c.isCompleted) c.complete(u);
    }).catchError((Object _) {
      if (++failed == urls.length && !c.isCompleted) c.completeError(StateError('Ни один сервер не отвечает'));
    });
  }
  return c.future;
}

// 41 (нужен раньше). Токен отмены
class CancellationException implements Exception {
  @override
  String toString() => 'CancellationException: операция отменена';
}

class CancelToken {
  bool _cancelled = false;
  final _c = Completer<void>();
  bool get isCancelled => _cancelled;
  Future<void> get whenCancelled => _c.future;
  void cancel() {
    if (_cancelled) return;
    _cancelled = true;
    _c.complete();
  }

  void throwIfCancelled() {
    if (_cancelled) throw CancellationException();
  }
}

// Отменяемая задержка/запрос
Future<T> cancellable<T>(CancelToken token, Future<T> Function() op) async {
  token.throwIfCancelled();
  final result = await Future.any<T>([
    op(),
    token.whenCancelled.then<T>((_) => throw CancellationException()),
  ]);
  token.throwIfCancelled();
  return result;
}

// 5. Сохранение профиля с таймаутом 3 с и аварийным прерыванием
Future<String> saveProfile(CancelToken token, {Duration work = const Duration(seconds: 10)}) =>
    cancellable(token, () async {
      await Future.delayed(work);
      return 'saved';
    });

Future<String> saveProfileWithTimeout({Duration work = const Duration(seconds: 10), Duration timeout = const Duration(seconds: 3)}) async {
  final token = CancelToken();
  try {
    return await saveProfile(token, work: work).timeout(timeout);
  } on TimeoutException {
    token.cancel(); // прерываем операцию, а не просто бросаем ожидание
    rethrow;
  }
}

// 6. Асинхронная FIFO-очередь
class AsyncQueue {
  Future<void> _tail = Future.value();
  final List<int> completionOrder = [];
  int _counter = 0;

  Future<T> add<T>(Future<T> Function() task) {
    final id = _counter++;
    final result = _tail.then((_) => task());
    _tail = result.then((_) => completionOrder.add(id), onError: (Object _) => completionOrder.add(id));
    return result;
  }
}

// 7. Замер времени
Future<({T result, int ms})> benchmark<T>(Future<T> Function() task) async {
  final sw = Stopwatch()..start();
  final r = await task();
  sw.stop();
  return (result: r, ms: sw.elapsedMilliseconds);
}

// 8. Ленивый асинхронный синглтон
class AppConfig {
  static int loads = 0;
  static Future<AppConfig>? _future;
  final Map<String, String> values;
  AppConfig._(this.values);

  static Future<AppConfig> getInstance() => _future ??= _load();

  static Future<AppConfig> _load() async {
    loads++;
    await Future.delayed(const Duration(milliseconds: 30)); // чтение из асинхронного источника
    return AppConfig._({'env': 'prod'});
  }

  static void resetForTests() {
    _future = null;
    loads = 0;
  }
}

// 9. Локальные данные vs сеть: сеть, если успела за 300 мс, иначе локальный кэш
Future<T> localOrNetwork<T>(Future<T> Function() local, Future<T> Function() network,
    {Duration wait = const Duration(milliseconds: 300)}) async {
  final localFuture = local();
  final netFuture = network();
  try {
    return await netFuture.timeout(wait);
  } on TimeoutException {
    return localFuture;
  } catch (_) {
    return localFuture; // сеть упала — отдаём локальные
  }
}

// 10. Debounce
class Debouncer {
  final Duration delay;
  Timer? _timer;
  Debouncer(this.delay);
  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() => _timer?.cancel();
}

// ================= БЛОК 2 (11–20): Stream API =================

// 11. Котировки BTC (имитация WebSocket) и фильтр выбросов: отбрасываем цены, отличающиеся
// от последней принятой более чем на 5% (трактовка «отфильтруйте всплески»)
Stream<double> btcPriceStream({int count = 20, Duration interval = const Duration(milliseconds: 200), int seed = 7}) async* {
  final rnd = math.Random(seed);
  var price = 60000.0;
  for (var i = 0; i < count; i++) {
    await Future.delayed(interval);
    final spike = rnd.nextInt(6) == 0; // иногда «всплеск»
    price *= spike ? 1 + (rnd.nextBool() ? 0.08 : -0.08) : 1 + (rnd.nextDouble() - 0.5) * 0.01;
    yield price;
  }
}

Stream<double> filterSpikes(Stream<double> prices, {double maxJump = 0.05}) async* {
  double? last;
  await for (final p in prices) {
    if (last == null || (p - last).abs() / last <= maxJump) {
      last = p;
      yield p;
    }
  }
}

// 12. Прогресс скачивания
Stream<int> downloadProgress({Duration step = const Duration(milliseconds: 300)}) async* {
  for (var p = 0; p <= 100; p += 10) {
    if (p > 0) await Future.delayed(step);
    yield p;
  }
}

// 13. Merge двух потоков
Stream<T> mergeStreams<T>(Stream<T> a, Stream<T> b) {
  final c = StreamController<T>();
  var open = 2;
  void done() {
    if (--open == 0) c.close();
  }

  final s1 = a.listen(c.add, onError: c.addError, onDone: done);
  final s2 = b.listen(c.add, onError: c.addError, onDone: done);
  c.onCancel = () async {
    await s1.cancel();
    await s2.cancel();
  };
  return c.stream;
}

sealed class NavEvent {}

class LocationEvent extends NavEvent {
  final double lat, lon;
  LocationEvent(this.lat, this.lon);
}

class CompassEvent extends NavEvent {
  final double heading;
  CompassEvent(this.heading);
}

Stream<NavEvent> navigationStream(Stream<(double, double)> geo, Stream<double> compass) =>
    mergeStreams<NavEvent>(geo.map((g) => LocationEvent(g.$1, g.$2)), compass.map(CompassEvent.new));

// 14. Throttle: не чаще одного события за период
Stream<T> throttle<T>(Stream<T> source, Duration period) async* {
  DateTime? last;
  await for (final e in source) {
    final now = DateTime.now();
    if (last == null || now.difference(last) >= period) {
      last = now;
      yield e;
    }
  }
}

// 15. Шагомер по акселерометру: шаг = пересечение порога снизу вверх
Stream<double> accelerometerMagnitude(List<double> samples, {Duration interval = const Duration(milliseconds: 1)}) async* {
  for (final s in samples) {
    await Future.delayed(interval);
    yield s;
  }
}

Stream<int> stepCounter(Stream<double> magnitude, {double threshold = 11.0}) async* {
  var steps = 0;
  var above = false;
  await for (final m in magnitude) {
    if (m > threshold && !above) {
      above = true;
      yield ++steps;
    } else if (m <= threshold) {
      above = false;
    }
  }
}

// 16. Автопереподключение
class ResilientListener<T> {
  final Stream<T> Function() connect;
  final void Function(T) onData;
  final Duration retryDelay;
  int reconnects = 0;
  bool _stopped = false;
  StreamSubscription<T>? _sub;
  Timer? _timer;

  ResilientListener(this.connect, this.onData, {this.retryDelay = const Duration(seconds: 2)}) {
    _subscribe();
  }

  void _subscribe() {
    if (_stopped) return;
    _sub = connect().listen(onData, onError: (Object _) {
      _sub?.cancel();
      _timer = Timer(retryDelay, () {
        reconnects++;
        _subscribe();
      });
    }, cancelOnError: true);
  }

  Future<void> stop() async {
    _stopped = true;
    _timer?.cancel();
    await _sub?.cancel();
  }
}

// 17. Буферизация: пачка по count элементов или раз в period
Stream<List<T>> bufferCountOrTime<T>(Stream<T> source, int count, Duration period) {
  late StreamController<List<T>> c;
  StreamSubscription<T>? sub;
  Timer? timer;
  var buf = <T>[];

  void flush() {
    if (buf.isNotEmpty) {
      c.add(buf);
      buf = <T>[];
    }
  }

  c = StreamController<List<T>>(
    onListen: () {
      timer = Timer.periodic(period, (_) => flush());
      sub = source.listen((e) {
        buf.add(e);
        if (buf.length >= count) flush();
      }, onError: c.addError, onDone: () {
        flush();
        timer?.cancel();
        c.close();
      });
    },
    onCancel: () async {
      timer?.cancel();
      await sub?.cancel();
    },
  );
  return c.stream;
}

// 18. OTP: обратный отсчёт; по завершении срок кода истёк
Stream<int> otpCountdown({int seconds = 60, Duration tick = const Duration(seconds: 1), void Function()? onExpired}) async* {
  for (var left = seconds; left >= 0; left--) {
    yield left;
    if (left == 0) {
      onExpired?.call();
      break;
    }
    await Future.delayed(tick);
  }
}

// 19. Скользящее среднее по последним N
Stream<double> movingAverage(Stream<num> source, {int window = 5}) async* {
  final buf = <num>[];
  await for (final v in source) {
    buf.add(v);
    if (buf.length > window) buf.removeAt(0);
    yield buf.reduce((a, b) => a + b) / buf.length;
  }
}

// 20. Последнее значение конечного потока
Future<T> lastOf<T>(Stream<T> s) => s.last;
// ================= БЛОК 3 (21–30): StreamController и шины =================

// 21. Глобальная шина событий (синглтон)
class EventBus {
  static final EventBus _instance = EventBus._();
  factory EventBus() => _instance;
  EventBus._();

  final StreamController<Object> _c = StreamController<Object>.broadcast();
  void fire(Object event) => _c.add(event);
  Stream<T> on<T extends Object>() => _c.stream.where((e) => e is T).cast<T>();
}

// 22. Реактивная корзина
class CartSnapshot {
  final int count;
  final double total;
  const CartSnapshot(this.count, this.total);
  @override
  String toString() => 'Cart($count, $total)';
}

class CartStore {
  final Map<String, (double price, int qty)> _items = {};
  final _c = StreamController<CartSnapshot>.broadcast();
  Stream<CartSnapshot> get stream => _c.stream;

  CartSnapshot get snapshot {
    var n = 0;
    var sum = 0.0;
    for (final (price, qty) in _items.values) {
      n += qty;
      sum += price * qty;
    }
    return CartSnapshot(n, sum);
  }

  void add(String name, double price) {
    final cur = _items[name];
    _items[name] = (price, (cur?.$2 ?? 0) + 1);
    _c.add(snapshot);
  }

  void remove(String name) {
    final cur = _items[name];
    if (cur == null) return;
    if (cur.$2 <= 1) {
      _items.remove(name);
    } else {
      _items[name] = (cur.$1, cur.$2 - 1);
    }
    _c.add(snapshot);
  }

  Future<void> dispose() => _c.close();
}

// 23. Бейдж непрочитанных
class UnreadBadgeController {
  int _count = 0;
  final _c = StreamController<int>.broadcast();
  Stream<int> get stream => _c.stream;
  int get count => _count;
  void onNewMessage() => _c.add(++_count);
  void markAllRead() {
    _count = 0;
    _c.add(0);
  }

  Future<void> dispose() => _c.close();
}

// 24. AudioPlayerBloc
sealed class PlayerState {}

class PlayerStopped extends PlayerState {}

class PlayerPlaying extends PlayerState {
  final String track;
  PlayerPlaying(this.track);
}

class PlayerPaused extends PlayerState {
  final String track;
  PlayerPaused(this.track);
}

class AudioPlayerBloc {
  PlayerState _state = PlayerStopped();
  final _c = StreamController<PlayerState>.broadcast();
  Stream<PlayerState> get states => _c.stream;
  PlayerState get state => _state;

  void _emit(PlayerState s) {
    _state = s;
    _c.add(s);
  }

  void play(String track) => _emit(PlayerPlaying(track));
  void pause() {
    if (_state case PlayerPlaying(:final track)) _emit(PlayerPaused(track));
  }

  void resume() {
    if (_state case PlayerPaused(:final track)) _emit(PlayerPlaying(track));
  }

  void stop() => _emit(PlayerStopped());
  Future<void> dispose() => _c.close();
}

String describePlayer(PlayerState s) => switch (s) {
      PlayerStopped() => 'Остановлено',
      PlayerPlaying(:final track) => 'Играет: $track',
      PlayerPaused(:final track) => 'Пауза: $track',
    };

// 25. Пагинация событием LoadNextPage
class LoadNextPage {}

class FeedPaginator {
  final Future<List<String>> Function(int page) loadPage;
  final _events = StreamController<LoadNextPage>();
  final _out = StreamController<List<String>>.broadcast();
  final List<String> _all = [];
  int _page = 0;
  bool _loading = false;

  FeedPaginator(this.loadPage) {
    _events.stream.listen((_) async {
      if (_loading) return; // игнорируем повторные события пока грузится
      _loading = true;
      try {
        _all.addAll(await loadPage(++_page));
        _out.add(List.unmodifiable(_all));
      } catch (e) {
        _page--;
        _out.addError(e);
      } finally {
        _loading = false;
      }
    });
  }

  Stream<List<String>> get feed => _out.stream;
  void add(LoadNextPage e) => _events.add(e);
  Future<void> dispose() async {
    await _events.close();
    await _out.close();
  }
}

// 26. BehaviorSubject-подобный контроллер и менеджер темы
// (ThemeMode — обычно из Flutter; здесь свой enum, чтобы запускалось на чистом Dart)
enum ThemeMode { light, dark }

class BehaviorSubject<T> {
  T _value;
  final _c = StreamController<T>.broadcast();
  BehaviorSubject(this._value);
  T get value => _value;

  /// Новый подписчик сразу получает текущее значение, затем все последующие.
  Stream<T> get stream => Stream<T>.multi((ctrl) {
        ctrl.add(_value);
        final sub = _c.stream.listen(ctrl.add, onError: ctrl.addError, onDone: ctrl.close);
        ctrl.onCancel = sub.cancel;
      }, isBroadcast: true);

  void add(T v) {
    if (_c.isClosed) return;
    _value = v;
    _c.add(v);
  }

  Future<void> close() => _c.close();
}

class ThemeManager {
  final _subject = BehaviorSubject<ThemeMode>(ThemeMode.light);
  Stream<ThemeMode> get themeStream => _subject.stream;
  ThemeMode get current => _subject.value;
  void toggle() => _subject.add(current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  Future<void> dispose() => _subject.close();
}

// 27. Статус сети
enum ConnectionType { wifi, cellular, none }

class ConnectivityController {
  ConnectionType _current = ConnectionType.none;
  final _c = StreamController<ConnectionType>.broadcast();
  Stream<ConnectionType> get changes => _c.stream;
  ConnectionType get current => _current;
  void update(ConnectionType t) {
    if (t == _current) return; // дубликаты не рассылаем
    _current = t;
    _c.add(t);
  }

  Future<void> dispose() => _c.close();
}

// 28. Auto-dispose: закрываемся, когда ушёл последний подписчик
class AutoDisposeController<T> {
  late final StreamController<T> _c;
  int _listeners = 0;
  AutoDisposeController() {
    _c = StreamController<T>.broadcast(
      onListen: () => _listeners++,
      onCancel: () {
        // onCancel у broadcast вызывается при уходе ПОСЛЕДНЕГО слушателя
        _listeners = 0;
        _c.close();
      },
    );
  }
  bool get isClosed => _c.isClosed;
  bool get hasListeners => _c.hasListener;
  Stream<T> get stream => _c.stream;
  void add(T v) {
    if (!_c.isClosed) _c.add(v);
  }
}

// 29. Валидация формы: combineLatest из двух потоков
Stream<R> combineLatest2<A, B, R>(Stream<A> a, Stream<B> b, R Function(A, B) combiner) {
  late StreamController<R> c;
  StreamSubscription<A>? sa;
  StreamSubscription<B>? sb;
  A? la;
  B? lb;
  var hasA = false, hasB = false, open = 2;

  void emit() {
    if (hasA && hasB) c.add(combiner(la as A, lb as B));
  }

  void done() {
    if (--open == 0) c.close();
  }

  c = StreamController<R>(
    onListen: () {
      sa = a.listen((v) {
        la = v;
        hasA = true;
        emit();
      }, onError: c.addError, onDone: done);
      sb = b.listen((v) {
        lb = v;
        hasB = true;
        emit();
      }, onError: c.addError, onDone: done);
    },
    onCancel: () async {
      await sa?.cancel();
      await sb?.cancel();
    },
  );
  return c.stream;
}

bool isValidEmail(String e) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(e);

class RegistrationFormBloc {
  final _email = StreamController<String>.broadcast();
  final _password = StreamController<String>.broadcast();
  Sink<String> get emailSink => _email.sink;
  Sink<String> get passwordSink => _password.sink;

  Stream<bool> get isSubmitEnabled =>
      combineLatest2<String, String, bool>(_email.stream, _password.stream, (e, p) => isValidEmail(e) && p.length >= 8);

  Future<void> dispose() async {
    await _email.close();
    await _password.close();
  }
}

// 30. Логгер крашей: неотловленные ошибки -> StreamController -> модуль отправки
class CrashReport {
  final Object error;
  final StackTrace stack;
  CrashReport(this.error, this.stack);
}

class CrashLogger {
  final _c = StreamController<CrashReport>.broadcast();
  final List<String> sent = []; // "отправлено в аналитику"
  late final StreamSubscription<CrashReport> _sub;

  CrashLogger() {
    _sub = _c.stream.listen((r) => sent.add('${r.error}'));
  }

  Stream<CrashReport> get reports => _c.stream;

  /// Запускает [body] в защищённой зоне: все неотловленные ошибки попадают в поток.
  Future<void> guard(Future<void> Function() body) {
    final done = Completer<void>();
    runZonedGuarded(() async {
      await body();
      if (!done.isCompleted) done.complete();
    }, (e, s) {
      if (!_c.isClosed) _c.add(CrashReport(e, s));
      if (!done.isCompleted) done.complete();
    });
    return done.future;
  }

  Future<void> dispose() async {
    await _sub.cancel();
    await _c.close();
  }
}

// ================= БЛОК 4 (31–40): изоляты =================

// 31. Миниатюра: RGBA-байты, уменьшение в [factor] раз (nearest-neighbor)
Uint8List _downscale(Uint8List rgba, int w, int h, int factor) {
  final nw = w ~/ factor, nh = h ~/ factor;
  final out = Uint8List(nw * nh * 4);
  for (var y = 0; y < nh; y++) {
    for (var x = 0; x < nw; x++) {
      final src = ((y * factor) * w + (x * factor)) * 4;
      final dst = (y * nw + x) * 4;
      out.setRange(dst, dst + 4, rgba, src);
    }
  }
  return out;
}

Future<Uint8List> generateThumbnail(Uint8List rgba, int w, int h, {int factor = 2}) =>
    Isolate.run(() => _downscale(rgba, w, h, factor));

// 32. XOR-шифрование большого текста в изоляте (учебное; для реальных данных — AES из пакета)
Uint8List _xorBytes(Uint8List data, Uint8List key) {
  final out = Uint8List(data.length);
  for (var i = 0; i < data.length; i++) {
    out[i] = data[i] ^ key[i % key.length];
  }
  return out;
}

Future<Uint8List> encryptInIsolate(String text, String key) {
  final data = Uint8List.fromList(utf8.encode(text));
  final k = Uint8List.fromList(utf8.encode(key));
  return Isolate.run(() => _xorBytes(data, k));
}

String decryptXor(Uint8List cipher, String key) =>
    utf8.decode(_xorBytes(cipher, Uint8List.fromList(utf8.encode(key))));

// 33. Полнотекстовый поиск: top-10 по числу вхождений слов запроса
List<(int index, int score)> _search(String query, List<String> docs) {
  final words = query.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  final scored = <(int, int)>[];
  for (var i = 0; i < docs.length; i++) {
    final d = docs[i].toLowerCase();
    var s = 0;
    for (final w in words) {
      var from = 0;
      while (true) {
        final idx = d.indexOf(w, from);
        if (idx < 0) break;
        s++;
        from = idx + w.length;
      }
    }
    if (s > 0) scored.add((i, s));
  }
  scored.sort((a, b) => b.$2 != a.$2 ? b.$2.compareTo(a.$2) : a.$1.compareTo(b.$1));
  return scored.take(10).toList();
}

Future<List<(int, int)>> searchInIsolate(String query, List<String> docs) => Isolate.run(() => _search(query, docs));

// 34. GeoJSON: районы города
class District {
  final String name;
  final List<(double lon, double lat)> ring;
  const District(this.name, this.ring);
}

List<District> _parseGeoJson(String src) {
  final root = jsonDecode(src) as Map<String, dynamic>;
  return [
    for (final f in (root['features'] as List).cast<Map<String, dynamic>>())
      District(
        (f['properties'] as Map)['name'] as String,
        [
          for (final p in ((((f['geometry'] as Map)['coordinates'] as List)[0]) as List))
            ((p as List)[0].toDouble() as double, p[1].toDouble() as double)
        ],
      )
  ];
}

Future<List<District>> parseGeoJsonInIsolate(String src) => Isolate.run(() => _parseGeoJson(src));

String buildGeoJson(int districts) => jsonEncode({
      'type': 'FeatureCollection',
      'features': [
        for (var i = 0; i < districts; i++)
          {
            'type': 'Feature',
            'properties': {'name': 'Район $i'},
            'geometry': {
              'type': 'Polygon',
              'coordinates': [
                [[37.0 + i, 55.0], [37.1 + i, 55.0], [37.1 + i, 55.1], [37.0 + i, 55.0]]
              ]
            }
          }
      ]
    });

// 35. Сжатие логов (gzip — встроенный в dart:io; формат ZIP потребовал бы пакет archive)
Future<Uint8List> compressLogs(List<String> lines) =>
    Isolate.run(() => Uint8List.fromList(gzip.encode(utf8.encode(lines.join('\n')))));

String decompressLogs(Uint8List data) => utf8.decode(gzip.decode(data));

// 36. Пул из двух постоянных воркеров (round-robin, ответ через одноразовый ReceivePort)
class WorkerPool {
  final List<SendPort> _ports = [];
  final List<Isolate> _isolates = [];
  final List<int> jobsPerWorker = [];
  int _next = 0;
  int get size => _ports.length;

  static Future<WorkerPool> start(int size) async {
    final pool = WorkerPool();
    for (var i = 0; i < size; i++) {
      final rp = ReceivePort();
      pool._isolates.add(await Isolate.spawn(_replyWorker, rp.sendPort));
      pool._ports.add(await rp.first as SendPort);
      pool.jobsPerWorker.add(0);
    }
    return pool;
  }

  Future<int> primesUpTo(int n) async {
    final w = _next++ % _ports.length; // round-robin
    jobsPerWorker[w]++;
    final reply = ReceivePort();
    _ports[w].send((n, reply.sendPort));
    final r = await reply.first as int;
    reply.close();
    return r;
  }

  void stop() {
    for (final i in _isolates) {
      i.kill(priority: Isolate.immediate);
    }
  }
}

void _replyWorker(SendPort mainPort) {
  final rp = ReceivePort();
  mainPort.send(rp.sendPort);
  rp.listen((msg) {
    final (n, reply) = msg as (int, SendPort);
    reply.send(countPrimesUpTo(n));
  });
}

// 37. Годовой финансовый отчёт (текстовая структура) в изоляте
String _buildReport(List<double> monthlyRevenue, List<double> monthlyCosts) {
  final b = StringBuffer('ФИНАНСОВЫЙ ОТЧЁТ ЗА ГОД\n');
  var total = 0.0;
  for (var m = 0; m < 12; m++) {
    final profit = monthlyRevenue[m] - monthlyCosts[m];
    total += profit;
    b.writeln('${(m + 1).toString().padLeft(2, '0')}: выручка ${monthlyRevenue[m].toStringAsFixed(2)}, '
        'расходы ${monthlyCosts[m].toStringAsFixed(2)}, прибыль ${profit.toStringAsFixed(2)}');
  }
  b.write('ИТОГО прибыль: ${total.toStringAsFixed(2)}');
  return b.toString();
}

Future<String> buildYearReport(List<double> revenue, List<double> costs) =>
    Isolate.run(() => _buildReport(revenue, costs));

// 38. Сортировка 1 000 000 чисел: главный поток vs изолят
List<int> _sorted(List<int> a) => (List<int>.of(a))..sort();

Future<({int mainMs, int isolateMs, bool same})> compareSort(int n, {int seed = 3}) async {
  final rnd = math.Random(seed);
  final data = List<int>.generate(n, (_) => rnd.nextInt(1 << 30));
  final sw = Stopwatch()..start();
  final a = _sorted(data);
  final mainMs = sw.elapsedMilliseconds;
  sw.reset();
  final b = await Isolate.run(() => _sorted(data));
  final isoMs = sw.elapsedMilliseconds;
  var same = a.length == b.length;
  for (var i = 0; same && i < a.length; i++) {
    same = a[i] == b[i];
  }
  return (mainMs: mainMs, isolateMs: isoMs, same: same);
}

// 39. Аудио: Int16 PCM -> Float32 [-1, 1] с нормализацией по пику
Float32List _convertSamples(Int16List pcm) {
  final out = Float32List(pcm.length);
  var peak = 1;
  for (final s in pcm) {
    if (s.abs() > peak) peak = s.abs();
  }
  for (var i = 0; i < pcm.length; i++) {
    out[i] = pcm[i] / peak;
  }
  return out;
}

Future<Float32List> convertSamples(Int16List pcm) => Isolate.run(() => _convertSamples(pcm));

// 40. TransferableTypedData: буфер уходит в изолят без копирования
Future<({int checksum, Uint8List back})> processTransferable(Uint8List big) async {
  final ttd = TransferableTypedData.fromList([big]); // после этого big использовать нельзя
  return Isolate.run(() {
    final bytes = ttd.materialize().asUint8List();
    var sum = 0;
    for (final b in bytes) {
      sum = (sum + b) & 0x7FFFFFFF;
    }
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = 255 - bytes[i]; // «обработка»: инверсия
    }
    return (checksum: sum, back: bytes);
  });
}

// ================= БЛОК 5 (41–50): сложные архитектуры =================
// 41 (CancelToken, CancellationException) — выше, в блоке 1.

// 42. Репликация с разрешением конфликтов: last-write-wins по timestamp
class Change {
  final String key;
  final String value;
  final int timestamp;
  const Change(this.key, this.value, this.timestamp);
  @override
  String toString() => '$key=$value@$timestamp';
}

Future<Map<String, Change>> replicate(Future<List<Change>> Function() queueA, Future<List<Change>> Function() queueB) async {
  final results = await Future.wait([queueA(), queueB()]);
  final merged = <String, Change>{};
  for (final c in results.expand((l) => l)) {
    final cur = merged[c.key];
    if (cur == null || c.timestamp > cur.timestamp) merged[c.key] = c;
  }
  return merged;
}

// 43. Офлайн-очередь заказов
class OfflineOrderQueue {
  final Future<void> Function(String order) send;
  final List<String> _pending = [];
  final List<String> sentOrders = [];
  bool _online = false, _draining = false;
  StreamSubscription<bool>? _sub;

  OfflineOrderQueue(this.send, Stream<bool> connectivity) {
    _sub = connectivity.listen((online) {
      _online = online;
      if (online) _drain();
    });
  }

  int get pendingCount => _pending.length;

  Future<void> placeOrder(String order) async {
    _pending.add(order);
    if (_online) await _drain();
  }

  Future<void> _drain() async {
    if (_draining) return;
    _draining = true;
    try {
      while (_online && _pending.isNotEmpty) {
        try {
          await send(_pending.first);
          sentOrders.add(_pending.removeAt(0)); // удаляем только после успеха — заказ не потеряется
        } catch (_) {
          break; // оставим в очереди до следующего восстановления сети
        }
      }
    } finally {
      _draining = false;
    }
  }

  Future<void> dispose() async => _sub?.cancel();
}

// 44. Circuit Breaker
enum BreakerState { closed, open, halfOpen }

class CircuitOpenException implements Exception {
  @override
  String toString() => 'CircuitOpenException: сервис временно отключён';
}

class CircuitBreaker {
  final int failureThreshold;
  final Duration openFor;
  final DateTime Function() now;
  int _failures = 0;
  DateTime? _openedAt;

  CircuitBreaker({this.failureThreshold = 5, this.openFor = const Duration(seconds: 30), DateTime Function()? now})
      : now = now ?? DateTime.now;

  BreakerState get state {
    if (_openedAt == null) return BreakerState.closed;
    return now().difference(_openedAt!) >= openFor ? BreakerState.halfOpen : BreakerState.open;
  }

  Future<T> call<T>(Future<T> Function() request) async {
    if (state == BreakerState.open) throw CircuitOpenException();
    try {
      final r = await request();
      _failures = 0;
      _openedAt = null; // успех (в т.ч. пробный в halfOpen) закрывает цепь
      return r;
    } catch (_) {
      _failures++;
      if (state == BreakerState.halfOpen || _failures >= failureThreshold) _openedAt = now();
      rethrow;
    }
  }
}

// 45. Асинхронный семафор
class Semaphore {
  final int maxConcurrent;
  int _running = 0;
  int peak = 0;
  final Queue<Completer<void>> _waiters = Queue();
  Semaphore(this.maxConcurrent);

  Future<void> acquire() async {
    if (_running < maxConcurrent) {
      _running++;
      peak = math.max(peak, _running);
      return;
    }
    final c = Completer<void>();
    _waiters.add(c);
    await c.future; // место передаётся напрямую от release()
  }

  void release() {
    if (_waiters.isNotEmpty) {
      _waiters.removeFirst().complete(); // _running не меняется: слот переходит ожидающему
    } else {
      _running--;
    }
  }

  Future<T> withPermit<T>(Future<T> Function() task) async {
    await acquire();
    try {
      return await task();
    } finally {
      release();
    }
  }
}

// 46. Гонка при вводе: применяется только ответ на САМЫЙ ПОСЛЕДНИЙ запрос
class LatestOnlySearch {
  final Future<List<String>> Function(String q) backend;
  int _latestId = 0;
  List<String> results = [];
  LatestOnlySearch(this.backend);

  /// Возвращает true, если результат применён; false — если ответ устарел.
  Future<bool> search(String q) async {
    final id = ++_latestId;
    final r = await backend(q);
    if (id != _latestId) return false; // пришёл более новый запрос — старый ответ выбрасываем
    results = r;
    return true;
  }
}

// 47. Жизненный цикл: пауза всех подписок при сворачивании
enum AppLifecycleState { resumed, paused }

class LifecycleSubscriptionManager {
  final List<StreamSubscription<dynamic>> _subs = [];
  void add(StreamSubscription<dynamic> s) => _subs.add(s);

  void onLifecycleChanged(AppLifecycleState state) {
    for (final s in _subs) {
      if (state == AppLifecycleState.paused) {
        if (!s.isPaused) s.pause();
      } else {
        if (s.isPaused) s.resume();
      }
    }
  }

  Future<void> dispose() async {
    for (final s in _subs) {
      await s.cancel();
    }
    _subs.clear();
  }
}

// 48. Конечный автомат синхронизации
sealed class SyncState {}

class SyncIdle extends SyncState {}

class Syncing extends SyncState {
  final double progress;
  Syncing(this.progress);
}

class SyncSuccess extends SyncState {}

class SyncError extends SyncState {
  final String message;
  SyncError(this.message);
}

class SyncMachine {
  SyncState _state = SyncIdle();
  final _c = StreamController<SyncState>.broadcast();
  Stream<SyncState> get states => _c.stream;
  SyncState get state => _state;

  void _set(SyncState s) {
    _state = s;
    _c.add(s);
  }

  /// Возвращает false, если синхронизация уже идёт.
  Future<bool> start(Future<void> Function(void Function(double) report) job) async {
    if (_state is Syncing) return false;
    _set(Syncing(0));
    try {
      await job((p) => _set(Syncing(p.clamp(0.0, 1.0).toDouble())));
      _set(SyncSuccess());
    } catch (e) {
      _set(SyncError('$e'));
    }
    return true;
  }

  void reset() {
    if (_state is! Syncing) _set(SyncIdle());
  }

  Future<void> dispose() => _c.close();
}

// 49. Кэш Memory -> Disk -> Network
class MultiLevelCache {
  final Map<String, String> _memory = {};
  final Future<String?> Function(String key) readDisk;
  final Future<void> Function(String key, String value) writeDisk;
  final Future<String> Function(String key) fetchNetwork;
  final List<String> trace = [];

  MultiLevelCache({required this.readDisk, required this.writeDisk, required this.fetchNetwork});

  Future<String> get(String key) async {
    final m = _memory[key];
    if (m != null) {
      trace.add('memory');
      return m;
    }
    final d = await readDisk(key);
    if (d != null) {
      trace.add('disk');
      _memory[key] = d; // «прогреваем» верхний уровень
      return d;
    }
    trace.add('network');
    final n = await fetchNetwork(key);
    _memory[key] = n;
    await writeDisk(key, n);
    return n;
  }
}

// 50. Финансовый терминал
class TerminalUpdate {
  final double price;
  final double volatility;
  TerminalUpdate(this.price, this.volatility);
  @override
  String toString() => 'price=${price.toStringAsFixed(2)} vol=${volatility.toStringAsFixed(4)}';
}

double _volatility(List<double> prices) {
  if (prices.length < 2) return 0;
  final returns = [for (var i = 1; i < prices.length; i++) math.log(prices[i] / prices[i - 1])];
  final mean = returns.reduce((a, b) => a + b) / returns.length;
  final variance = returns.map((r) => math.pow(r - mean, 2)).reduce((a, b) => a + b) / returns.length;
  return math.sqrt(variance);
}

// Вынесено в top-level: замыкание внутри метода класса захватило бы `this` (с контроллерами),
// а его нельзя отправить в другой изолят.
Future<double> _volatilityInIsolate(List<double> prices) => Isolate.run(() => _volatility(prices));

class FinancialTerminal {
  final Stream<double> Function() connect; // имитатор WebSocket (может падать с ошибкой)
  final int window;
  final Duration reconnectDelay;
  final Duration uiInterval; // 1000/60 ≈ 16 мс — не более 60 кадров/с

  final _quotes = StreamController<double>.broadcast();
  final _ui = StreamController<TerminalUpdate>.broadcast();
  final List<double> _window = [];
  StreamSubscription<double>? _socketSub;
  StreamSubscription<TerminalUpdate>? _uiSub;
  Timer? _reconnectTimer;
  bool _disposed = false, _calculating = false;
  double _lastVol = 0;
  int reconnects = 0;
  int rawQuotes = 0;

  FinancialTerminal(this.connect,
      {this.window = 20,
      this.reconnectDelay = const Duration(milliseconds: 500),
      this.uiInterval = const Duration(milliseconds: 16)});

  Stream<TerminalUpdate> get ui => _ui.stream;

  void start() {
    // Троттлинг обновлений экрана
    // onCancel нужен: без него cancel() подписки ждёт закрытия контроллера и dispose() зависает
    final raw = StreamController<TerminalUpdate>(onCancel: () {});
    _quotes.stream.listen((p) => raw.add(TerminalUpdate(p, _lastVol)), onDone: raw.close);
    _uiSub = throttle(raw.stream, uiInterval).listen(_ui.add);
    _connect();
  }

  void _connect() {
    if (_disposed) return;
    _socketSub = connect().listen(
      (price) {
        rawQuotes++;
        _window.add(price);
        if (_window.length > window) _window.removeAt(0);
        if (!_quotes.isClosed) _quotes.add(price);
        _recalcVolatility();
      },
      onError: (Object _) => _scheduleReconnect(),
      onDone: () => _scheduleReconnect(),
      cancelOnError: true,
    );
  }

  void _recalcVolatility() {
    if (_calculating || _window.length < 5) return; // не копим очередь тяжёлых задач
    _calculating = true;
    final snapshot = List<double>.of(_window);
    _volatilityInIsolate(snapshot).then((v) {
      _lastVol = v;
    }).whenComplete(() => _calculating = false);
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(reconnectDelay, () {
      reconnects++;
      _connect();
    });
  }

  Future<void> dispose() async {
    if (_disposed) return;
    _disposed = true;
    _reconnectTimer?.cancel();
    await _socketSub?.cancel();
    // Сначала закрываем источник: генератор async* (throttle) завершается только когда
    // поток-источник закрыт, иначе cancel() подписки на него зависнет.
    await _quotes.close();
    await _uiSub?.cancel();
    await _ui.close();
  }
}
// ================= ПРОВЕРКИ И ДЕМО =================
int _ok = 0, _bad = 0;
void check(String name, Object? actual, Object? expected) {
  if (actual.toString() == expected.toString()) {
    _ok++;
  } else {
    _bad++;
    print('❌ $name: получено <$actual>, ожидалось <$expected>');
  }
}

Future<void> checkThrowsAsync(String name, Future<void> Function() f, [bool Function(Object)? test]) async {
  try {
    await f();
    _bad++;
    print('❌ $name: исключение не выброшено');
  } catch (e) {
    if (test == null || test(e)) {
      _ok++;
    } else {
      _bad++;
      print('❌ $name: выброшено не то исключение: $e');
    }
  }
}

Future<void> wait(int ms) => Future.delayed(Duration(milliseconds: ms));
const _fast = Duration(milliseconds: 5);

Future<void> runTests() async {
  // ---------- Тема 1 ----------
  check('1.1 ok', await login('a', '1234', delay: _fast), true);
  await checkThrowsAsync('1.1 fail', () => login('a', 'x', delay: _fast), (e) => e is AuthException);
  final cfg = await loadConfigs(scaleMs: 10);
  check('1.2', cfg.keys.toList()..sort(), ['network', 'theme', 'user']);
  check('1.3', await fastestMirror(scaleMs: 0), 'mirror-1'); // 800*0 vs 1200*0: оба 0 — порядок создания
  check('1.3 реальные задержки быстрее', await Future.any([wait(10).then((_) => 'a'), wait(30).then((_) => 'b')]), 'a');
  var attempts = 0;
  check('1.4 успех со 2-й попытки', await retry(() async {
    if (++attempts < 2) throw Exception('fail');
    return 'ok';
  }, delay: _fast), 'ok');
  var attempts2 = 0;
  await checkThrowsAsync('1.4 исчерпаны', () => retry<void>(() async {
        attempts2++;
        throw Exception('always');
      }, maxAttempts: 3, delay: _fast));
  check('1.4 число попыток', attempts2, 3);
  var finallyCalled = false;
  check('1.5 ok', await loginWithThen('Аня', '1234', delay: _fast, onFinally: () => finallyCalled = true), 'Добро пожаловать, Аня');
  check('1.5 whenComplete', finallyCalled, true);
  check('1.5 error', await loginWithThen('Аня', 'bad', delay: _fast), 'Ошибка: AuthException: Неверный логин или пароль');

  // ---------- Тема 2 ----------
  check('2.1', await stopWatch(tick: const Duration(milliseconds: 2)).take(4).toList(), [1, 2, 3, 4]);
  final gps = await gpsStream(count: 3, interval: _fast).toList();
  check('2.2', [gps.length, gps.first.$1 != gps.last.$1], [3, true]);
  final bq = quotes(count: 3).asBroadcastStream();
  final ui = <double>[], logger = <double>[];
  final s1 = bq.listen(ui.add), s2 = bq.listen(logger.add);
  await wait(100);
  await s1.cancel();
  await s2.cancel();
  check('2.3', [ui.length, logger.length, ui.toString() == logger.toString()], [3, 3, true]);
  check('2.4', await sumStream(Stream.fromIterable(List.generate(10, (i) => i + 1))), 55);
  check('2.5', await concatStreams(Stream.fromIterable([1, 2]), Stream.fromIterable([3, 4])).toList(), [1, 2, 3, 4]);

  // ---------- Тема 3 ----------
  check('3.1', await Stream.fromIterable(['a', 'bc']).transform(upperCaseTransformer).toList(), ['A', 'BC']);
  final sw = SearchControllerWrapper();
  final out = <String>[];
  sw.cleaned.listen(out.add);
  for (final ch in ['  F', 'l', 'u', 't']) {
    sw.sink.add(ch);
  }
  await wait(20);
  check('3.2', out.last, 'flut');
  await sw.dispose();
  check('3.3', await errorDemo(), ['data:1', 'error:Exception: Сбой датчика', 'data:2']);
  final cc = StreamController<int>();
  cc.stream.listen((_) {});
  final r1 = safeAdd(cc, 1);
  await cc.close();
  check('3.4', [r1, safeAdd(cc, 2)], [true, false]);
  final tb = TrackedBroadcast<int>();
  final sa = tb.listen((_) {}), sb = tb.listen((_) {});
  final two = tb.listeners;
  await tb.cancel(sa);
  await tb.cancel(sb);
  check('3.5', [two, tb.listeners, tb.log], [2, 0, ['onListen', 'onCancel']]);

  // ---------- Тема 4 ----------
  final recs = await parseJsonInIsolate(generateJson(10000));
  check('4.1', [recs.length, recs.last.name], [10000, 'item9999']);
  check('4.2 примеры', [countPrimesUpTo(100), countPrimesUpTo(1000000)], [25, 78498]);
  var dots = 0;
  final pc = await primesInBackground(2000000, onDot: () => dots++, dotEvery: const Duration(milliseconds: 5));
  check('4.2 фон', [pc, dots > 0], [148933, true]);
  final calc = await CalculatorIsolate.start();
  check('4.3', [await calc.add(2, 3), await calc.add(1.5, 2.5)], [5, 4.0]);
  await calc.stop();
  final resp = await responsivenessTest(150000000);
  check('4.4', [resp.ticksIsolate > resp.ticksSync], [true]);
  print('   (4.4: тиков таймера при блокировке: ${resp.ticksSync}, при изоляте: ${resp.ticksIsolate})');
  check('4.5', await spawnAndKill(), true);

  // ---------- Блок 1 ----------
  final ok = await fetchData('https://x.ru/items', latency: _fast);
  check('Б1.1 200', ok['status'], 200);
  await checkThrowsAsync('Б1.1 404', () => fetchData('https://x.ru/missing', latency: _fast), (e) => e is ApiException && e.status == 404);
  await checkThrowsAsync('Б1.1 500', () => fetchData('https://x.ru/broken', latency: _fast), (e) => e is ApiException && e.status == 500);
  var tries = 0;
  final sw2 = Stopwatch()..start();
  final v = await retryWithBackoff(() async {
    if (++tries < 4) throw const SocketException('нет сети');
    return 'ok';
  }, unit: const Duration(milliseconds: 10));
  check('Б1.2', [v, tries], ['ok', 4]);
  check('Б1.2 паузы 1+2+4 ≥ 70 мс', sw2.elapsedMilliseconds >= 65, true);
  await checkThrowsAsync('Б1.2 не сокет — без ретрая', () => retryWithBackoff<void>(() async => throw StateError('x')), (e) => e is StateError);
  var running = 0, peak = 0;
  final lim = await runLimited<int>(List.generate(5, (i) => () async {
        peak = math.max(peak, ++running);
        await wait(20);
        running--;
        return i * i;
      }), 2);
  check('Б1.3', [lim, peak], [[0, 1, 4, 9, 16], 2]);
  check('Б1.4', await firstAlive(['a', 'b', 'c'], (u) async {
        if (u == 'a') throw Exception('down');
        await wait(u == 'b' ? 30 : 10);
      }), 'c');
  await checkThrowsAsync('Б1.4 все упали', () => firstAlive(['a'], (u) async => throw Exception('x')));
  await checkThrowsAsync('Б1.5', () => saveProfileWithTimeout(work: const Duration(milliseconds: 200), timeout: const Duration(milliseconds: 20)), (e) => e is TimeoutException);
  final q = AsyncQueue();
  final order = <int>[];
  await Future.wait([
    q.add(() async { await wait(30); order.add(1); }),
    q.add(() async { await wait(5); order.add(2); }),
    q.add(() async { order.add(3); }),
  ]);
  check('Б1.6', order, [1, 2, 3]);
  final bm = await benchmark(() async { await wait(50); return 7; });
  check('Б1.7', [bm.result, bm.ms >= 45], [7, true]);
  AppConfig.resetForTests();
  final cfgs = await Future.wait([AppConfig.getInstance(), AppConfig.getInstance(), AppConfig.getInstance()]);
  check('Б1.8', [AppConfig.loads, identical(cfgs[0], cfgs[2])], [1, true]);
  check('Б1.9 сеть успела', await localOrNetwork(() async => 'local', () async { await wait(10); return 'net'; }), 'net');
  check('Б1.9 сеть медленная', await localOrNetwork(() async => 'local', () async { await wait(500); return 'net'; }, wait: const Duration(milliseconds: 30)), 'local');
  check('Б1.9 сеть упала', await localOrNetwork(() async => 'local', () async => throw Exception('x')), 'local');
  var searches = 0;
  final deb = Debouncer(const Duration(milliseconds: 40));
  for (var i = 0; i < 5; i++) {
    deb.run(() => searches++);
    await wait(10);
  }
  await wait(80);
  check('Б1.10', searches, 1);

  // ---------- Блок 2 ----------
  final prices = await filterSpikes(btcPriceStream(count: 30, interval: const Duration(milliseconds: 1))).toList();
  var maxJump = 0.0;
  for (var i = 1; i < prices.length; i++) {
    maxJump = math.max(maxJump, (prices[i] - prices[i - 1]).abs() / prices[i - 1]);
  }
  check('Б2.11', [prices.isNotEmpty, maxJump <= 0.05], [true, true]);
  check('Б2.12', await downloadProgress(step: const Duration(milliseconds: 1)).toList(), [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]);
  final nav = await navigationStream(Stream.fromIterable([(55.0, 37.0)]), Stream.fromIterable([90.0, 180.0])).toList();
  check('Б2.13', [nav.length, nav.whereType<LocationEvent>().length, nav.whereType<CompassEvent>().length], [3, 1, 2]);
  final clicks = Stream.periodic(const Duration(milliseconds: 10), (i) => i).take(25);
  final thr = await throttle(clicks, const Duration(milliseconds: 100)).toList();
  check('Б2.14', [thr.length >= 2 && thr.length <= 4, thr.first], [true, 0]);
  final steps = await stepCounter(accelerometerMagnitude([9.8, 12, 12.5, 9, 9.5, 13, 10, 11.5, 9])).toList();
  check('Б2.15', steps, [1, 2, 3]);
  var connects = 0;
  final got = <int>[];
  final rl = ResilientListener<int>(() {
    connects++;
    if (connects == 1) return Stream<int>.error(Exception('обрыв'));
    return Stream.fromIterable([1, 2, 3]);
  }, got.add, retryDelay: const Duration(milliseconds: 20));
  await wait(120);
  check('Б2.16', [got, rl.reconnects, connects], [[1, 2, 3], 1, 2]);
  await rl.stop();
  final bufs = await bufferCountOrTime<int>(Stream.fromIterable(List.generate(12, (i) => i)), 5, const Duration(seconds: 3)).toList();
  check('Б2.17', bufs.map((b) => b.length).toList(), [5, 5, 2]);
  var expired = false;
  final otp = await otpCountdown(seconds: 3, tick: const Duration(milliseconds: 2), onExpired: () => expired = true).toList();
  check('Б2.18', [otp, expired], [[3, 2, 1, 0], true]);
  check('Б2.19', await movingAverage(Stream.fromIterable([1, 2, 3, 4, 5, 6, 7]), window: 5).toList(), [1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0]);
  check('Б2.20', await lastOf(Stream.fromIterable([1, 2, 9])), 9);

  // ---------- Блок 3 ----------
  final bus = EventBus();
  final ev = <String>[];
  final bsub = bus.on<String>().listen(ev.add);
  final bsub2 = bus.on<int>().listen((i) => ev.add('int$i'));
  bus.fire('привет');
  bus.fire(5);
  await wait(10);
  await bsub.cancel();
  await bsub2.cancel();
  check('Б3.21', [ev, identical(EventBus(), EventBus())], [['привет', 'int5'], true]);
  final cart = CartStore();
  final snaps = <CartSnapshot>[];
  cart.stream.listen(snaps.add);
  cart
    ..add('a', 100)
    ..add('a', 100)
    ..add('b', 50)
    ..remove('a');
  await wait(10);
  check('Б3.22', snaps.map((s) => s.toString()).toList(), ['Cart(1, 100.0)', 'Cart(2, 200.0)', 'Cart(3, 250.0)', 'Cart(2, 150.0)']);
  await cart.dispose();
  final badge = UnreadBadgeController();
  final bv = <int>[];
  badge.stream.listen(bv.add);
  badge..onNewMessage()..onNewMessage()..markAllRead();
  await wait(10);
  check('Б3.23', bv, [1, 2, 0]);
  await badge.dispose();
  final player = AudioPlayerBloc();
  final texts = <String>[];
  player.states.listen((s) => texts.add(describePlayer(s)));
  player..play('Song')..pause()..resume()..stop()..pause();
  await wait(10);
  check('Б3.24', texts, ['Играет: Song', 'Пауза: Song', 'Играет: Song', 'Остановлено']);
  await player.dispose();
  final pag = FeedPaginator((p) async { await wait(5); return ['n${p}a', 'n${p}b']; });
  final feeds = <int>[];
  pag.feed.listen((f) => feeds.add(f.length));
  pag.add(LoadNextPage());
  pag.add(LoadNextPage()); // игнорируется: страница ещё грузится
  await wait(40);
  pag.add(LoadNextPage());
  await wait(40);
  check('Б3.25', feeds, [2, 4]);
  await pag.dispose();
  final theme = ThemeManager();
  final tseen = <ThemeMode>[];
  theme.toggle(); // dark
  final tsub = theme.themeStream.listen(tseen.add); // новый подписчик сразу получает текущее
  theme.toggle(); // light
  await wait(10);
  await tsub.cancel();
  check('Б3.26', tseen, [ThemeMode.dark, ThemeMode.light]);
  await theme.dispose();
  final conn = ConnectivityController();
  final cs = <ConnectionType>[];
  conn.changes.listen(cs.add);
  conn..update(ConnectionType.wifi)..update(ConnectionType.wifi)..update(ConnectionType.none);
  await wait(10);
  check('Б3.27', cs, [ConnectionType.wifi, ConnectionType.none]);
  await conn.dispose();
  final ad = AutoDisposeController<int>();
  final l1 = ad.stream.listen((_) {}), l2 = ad.stream.listen((_) {});
  await l1.cancel();
  final openAfterOne = !ad.isClosed;
  await l2.cancel();
  check('Б3.28', [openAfterOne, ad.isClosed], [true, true]);
  final form = RegistrationFormBloc();
  final flags = <bool>[];
  final fsub = form.isSubmitEnabled.listen(flags.add);
  // между вводами — паузы, как у живого пользователя (события разных контроллеров не должны склеиваться)
  form.emailSink.add('a@b.ru');
  await wait(5);
  form.passwordSink.add('123');
  await wait(5);
  form.passwordSink.add('12345678');
  await wait(5);
  form.emailSink.add('bad');
  await wait(10);
  await fsub.cancel();
  check('Б3.29', flags, [false, true, false]);
  await form.dispose();
  final crash = CrashLogger();
  await crash.guard(() async {
    Timer(Duration.zero, () => throw StateError('необработанная ошибка'));
    await wait(30);
  });
  await wait(10);
  check('Б3.30', crash.sent, ['Bad state: необработанная ошибка']);
  await crash.dispose();

  // ---------- Блок 4 ----------
  final rgba = Uint8List.fromList(List.generate(4 * 4 * 4, (i) => i));
  final thumb = await generateThumbnail(rgba, 4, 4, factor: 2);
  check('Б4.31', [thumb.length, thumb.sublist(0, 4)], [16, [0, 1, 2, 3]]);
  final bigText = 'Секретная заметка. ' * 20000;
  final enc = await encryptInIsolate(bigText, 'k3y');
  check('Б4.32', [enc.length > 0, decryptXor(enc, 'k3y') == bigText], [true, true]);
  final docs = List.generate(100000, (i) => i % 1000 == 0 ? 'flutter dart flutter doc$i' : 'обычный документ $i');
  final found = await searchInIsolate('flutter', docs);
  check('Б4.33', [found.length, found.first.$2], [10, 2]);
  final dist = await parseGeoJsonInIsolate(buildGeoJson(500));
  check('Б4.34', [dist.length, dist[3].name, dist[3].ring.length], [500, 'Район 3', 4]);
  final lines = List.generate(5000, (i) => 'INFO 2026-11-08 запрос #$i выполнен');
  final gz = await compressLogs(lines);
  check('Б4.35', [gz.length < lines.join('\n').length, decompressLogs(gz) == lines.join('\n')], [true, true]);
  final pool = await WorkerPool.start(2);
  final pr = await Future.wait([pool.primesUpTo(100), pool.primesUpTo(1000), pool.primesUpTo(10000), pool.primesUpTo(10)]);
  check('Б4.36', [pr, pool.size, pool.jobsPerWorker], [[25, 168, 1229, 4], 2, [2, 2]]);
  pool.stop();
  final rep = await buildYearReport(List.filled(12, 1000.0), List.filled(12, 400.0));
  check('Б4.37', [rep.contains('ИТОГО прибыль: 7200.00'), rep.split('\n').length], [true, 14]);
  final cs2 = await compareSort(1000000);
  check('Б4.38', cs2.same, true);
  print('   (4.38: сортировка 1 млн — главный поток ${cs2.mainMs} мс, изолят ${cs2.isolateMs} мс)');
  final conv = await convertSamples(Int16List.fromList([0, 16384, -32768, 8192]));
  check('Б4.39', conv.toList(), [0.0, 0.5, -1.0, 0.25]);
  final buf = Uint8List.fromList(List.generate(1 << 20, (i) => i % 256));
  final tr = await processTransferable(buf);
  check('Б4.40', [tr.back.length, tr.back[0], tr.back[1], tr.checksum], [1 << 20, 255, 254, (1 << 20) ~/ 256 * 32640]);

  // ---------- Блок 5 ----------
  final tok = CancelToken();
  final pending = cancellable(tok, () async { await wait(300); return 'done'; });
  await wait(10);
  tok.cancel();
  await checkThrowsAsync('Б5.41', () => pending, (e) => e is CancellationException);
  await checkThrowsAsync('Б5.41 уже отменён', () => cancellable(tok, () async => 1), (e) => e is CancellationException);
  final merged = await replicate(
      () async => [const Change('name', 'A', 10), const Change('age', '20', 5)],
      () async => [const Change('name', 'B', 20), const Change('city', 'M', 1)]);
  check('Б5.42', merged.values.map((c) => '$c').toList()..sort(), ['age=20@5', 'city=M@1', 'name=B@20']);
  final net = StreamController<bool>();
  final sent = <String>[];
  final oq = OfflineOrderQueue((o) async { await wait(2); sent.add(o); }, net.stream);
  await oq.placeOrder('order-1');
  await oq.placeOrder('order-2');
  final pendingOffline = oq.pendingCount;
  net.add(true);
  await wait(50);
  await oq.placeOrder('order-3'); // онлайн — уходит сразу
  check('Б5.43', [pendingOffline, sent, oq.pendingCount], [2, ['order-1', 'order-2', 'order-3'], 0]);
  await oq.dispose();
  await net.close();
  var clock = DateTime(2026, 1, 1);
  final br = CircuitBreaker(now: () => clock);
  for (var i = 0; i < 5; i++) {
    try {
      await br<int>(() async => throw Exception('fail'));
    } catch (_) {}
  }
  final stOpen = br.state;
  await checkThrowsAsync('Б5.44 open', () => br(() async => 1), (e) => e is CircuitOpenException);
  clock = clock.add(const Duration(seconds: 31));
  final stHalf = br.state;
  final res = await br(() async => 'ok');
  check('Б5.44', [stOpen, stHalf, res, br.state], [BreakerState.open, BreakerState.halfOpen, 'ok', BreakerState.closed]);
  final sem = Semaphore(3);
  await Future.wait(List.generate(10, (i) => sem.withPermit(() => wait(10))));
  check('Б5.45', sem.peak, 3);
  var delayFirst = true;
  final ls = LatestOnlySearch((q) async {
    if (q == 'fl' && delayFirst) {
      delayFirst = false;
      await wait(60); // старый запрос отвечает медленно
    } else {
      await wait(5);
    }
    return ['результат для $q'];
  });
  final slow = ls.search('fl');
  await wait(5);
  final fast = ls.search('flutter');
  check('Б5.46', [await fast, await slow, ls.results], [true, false, ['результат для flutter']]);
  final lc = LifecycleSubscriptionManager();
  final tick = <int>[];
  lc.add(Stream.periodic(const Duration(milliseconds: 5), (i) => i).listen(tick.add));
  await wait(40);
  lc.onLifecycleChanged(AppLifecycleState.paused);
  final atPause = tick.length;
  await wait(40);
  final afterPause = tick.length;
  lc.onLifecycleChanged(AppLifecycleState.resumed);
  await wait(40);
  check('Б5.47', [afterPause - atPause <= 1, tick.length > afterPause], [true, true]);
  await lc.dispose();
  final sm = SyncMachine();
  final states = <String>[];
  sm.states.listen((s) => states.add(switch (s) {
        SyncIdle() => 'idle',
        Syncing(:final progress) => 'syncing ${progress.toStringAsFixed(1)}',
        SyncSuccess() => 'success',
        SyncError() => 'error',
      }));
  final first = sm.start((report) async {
    report(0.5);
    await wait(30);
  });
  final second = await sm.start((report) async {}); // защита от повторного запуска
  await first;
  await sm.start((report) async => throw Exception('сеть'));
  await wait(10);
  check('Б5.48', [second, states], [false, ['syncing 0.0', 'syncing 0.5', 'success', 'syncing 0.0', 'error']]);
  await sm.dispose();
  final disk = <String, String>{};
  final cache = MultiLevelCache(
      readDisk: (k) async => disk[k], writeDisk: (k, v) async => disk[k] = v, fetchNetwork: (k) async => 'value-of-$k');
  await cache.get('a');
  await cache.get('a');
  disk['b'] = 'from-disk';
  await cache.get('b');
  check('Б5.49', [cache.trace, disk['a']], [['network', 'memory', 'disk'], 'value-of-a']);

  var socketCalls = 0;
  final term = FinancialTerminal(() {
    socketCalls++;
    if (socketCalls == 1) {
      return Stream<double>.periodic(const Duration(milliseconds: 3), (i) => 100.0 + i).take(12).map((p) {
        if (p == 108.0) throw Exception('обрыв соединения');
        return p;
      });
    }
    return Stream<double>.periodic(const Duration(milliseconds: 3), (i) => 200.0 + i).take(40);
  }, reconnectDelay: const Duration(milliseconds: 30), uiInterval: const Duration(milliseconds: 16));
  final updates = <TerminalUpdate>[];
  term.ui.listen(updates.add);
  term.start();
  await wait(500);
  final countBeforeDispose = updates.length;
  await term.dispose();
  await wait(100);
  final lastVol = updates.isEmpty ? 0.0 : updates.last.volatility;
  check('Б5.50', [term.reconnects >= 1, term.rawQuotes > updates.length, updates.length == countBeforeDispose, updates.isNotEmpty], [true, true, true, true]);
  check('Б5.50 волатильность посчитана в изоляте', lastVol > 0, true);
  print('   (5.50: котировок получено ${term.rawQuotes}, обновлений экрана после троттлинга ${updates.length}, переподключений ${term.reconnects})');

  print(_bad == 0 ? '✅ Пройдено проверок: $_ok' : '⚠ Пройдено: $_ok, провалено: $_bad');
}

void _t(int topic, int n) => print('── Тема $topic · задание $n ──');
void _m(int n) => print('── Смешанное задание $n ──');
void show(String label, Object? v) => print('$label → $v');
Future<void> _w(int ms) => Future.delayed(Duration(milliseconds: ms));

Future<void> runDemo() async {
  print('=== Event Loop: порядок выполнения ===');
  print('1. синхронный код');
  Timer.run(() => print('4. событие (Event Queue)'));
  scheduleMicrotask(() => print('3. микрозадача (Microtask)'));
  Future(() => print('5. Future(...) — тоже Event Queue'));
  print('2. конец синхронного кода');
  await _w(50);

  // ---------------- Тема 1 ----------------
  _t(1, 1);
  var sw = Stopwatch()..start();
  show("login('Аня', '1234')", await login('Аня', '1234'));
  show('прошло времени', '${sw.elapsedMilliseconds} мс (≈1500)');
  try {
    await login('Аня', 'bad');
  } on AuthException catch (e) {
    show("login('Аня', 'bad')", e);
  }
  _t(1, 2);
  show('loadConfigs() — три Future.wait() параллельно', await loadConfigs());
  _t(1, 3);
  sw = Stopwatch()..start();
  show('fastestMirror() — зеркала 800 мс и 1200 мс', await fastestMirror());
  show('прошло времени', '${sw.elapsedMilliseconds} мс (≈800)');
  _t(1, 4);
  var attempt = 0;
  sw = Stopwatch()..start();
  show('retry: 2 неудачи, 3-я попытка успешна', await retry(() async {
    attempt++;
    print('  попытка $attempt');
    if (attempt < 3) throw Exception('сбой');
    return 'успех';
  }));
  show('прошло времени (две паузы по 1 с)', '${sw.elapsedMilliseconds} мс');
  attempt = 0;
  try {
    await retry<void>(() async {
      attempt++;
      throw Exception('всегда падает');
    }, maxAttempts: 3);
  } catch (e) {
    show('retry: задача всегда падает → попыток', '$attempt, итог: $e');
  }
  _t(1, 5);
  show("loginWithThen('Аня', '1234')", await loginWithThen('Аня', '1234', onFinally: () => print('  whenComplete: выполнено')));
  show("loginWithThen('Аня', 'bad')", await loginWithThen('Аня', 'bad', onFinally: () => print('  whenComplete: выполнено')));

  // ---------------- Тема 2 ----------------
  _t(2, 1);
  await for (final s in stopWatch().take(3)) {
    print('тик секундомера: $s');
  }
  _t(2, 2);
  await for (final (lat, lon) in gpsStream(count: 4)) {
    print('GPS: ${lat.toStringAsFixed(6)}, ${lon.toStringAsFixed(6)}');
  }
  _t(2, 3);
  final bq = quotes(count: 4).asBroadcastStream();
  final s1 = bq.listen((p) => print('UI-виджет получил цену $p'));
  final s2 = bq.listen((p) => print('Логгер аналитики записал цену $p'));
  await _w(150);
  await s1.cancel();
  await s2.cancel();
  _t(2, 4);
  show('fold: сумма чисел 1..10', await sumStream(Stream.fromIterable(List.generate(10, (i) => i + 1))));
  _t(2, 5);
  show('concatStreams([1, 2], [3, 4])', await concatStreams(Stream.fromIterable([1, 2]), Stream.fromIterable([3, 4])).toList());

  // ---------------- Тема 3 ----------------
  _t(3, 1);
  show("['привет', 'dart'] → верхний регистр", await Stream.fromIterable(['привет', 'dart']).transform(upperCaseTransformer).toList());
  _t(3, 2);
  final search = SearchControllerWrapper();
  search.cleaned.listen((v) => print('очищенная строка: «$v»'));
  for (final ch in ['  F', 'l', 'u', 't', 't', 'e', 'r ']) {
    search.sink.add(ch);
  }
  await _w(20);
  await search.dispose();
  _t(3, 3);
  (await errorDemo()).forEach(print);
  _t(3, 4);
  final cc = StreamController<int>();
  cc.stream.listen((_) {});
  show('safeAdd до close()', safeAdd(cc, 1));
  await cc.close();
  show('safeAdd после close() — без исключения', safeAdd(cc, 2));
  _t(3, 5);
  final tb = TrackedBroadcast<int>();
  final a = tb.listen((_) {}), b = tb.listen((_) {});
  show('подписчиков после двух listen()', tb.listeners);
  await tb.cancel(a);
  await tb.cancel(b);
  show('подписчиков после двух cancel()', tb.listeners);
  show('журнал onListen/onCancel', tb.log);

  // ---------------- Тема 4 ----------------
  _t(4, 1);
  final json = generateJson(10000);
  show('размер JSON-строки', '${json.length} символов, 10 000 записей');
  final recs = await parseJsonInIsolate(json);
  show('разобрано объектов в изоляте', recs.length);
  show('последний объект', '${recs.last.id}, ${recs.last.name}, ${recs.last.value}');
  _t(4, 2);
  var dots = StringBuffer();
  final pc = await primesInBackground(1000000, onDot: () => dots.write('.'), dotEvery: const Duration(milliseconds: 5));
  show('точки в главном потоке (по одной за тик таймера)', dots.isEmpty ? '(расчёт завершился быстрее первого тика)' : dots);
  show('простых чисел до 1 000 000', pc);
  _t(4, 3);
  final calc = await CalculatorIsolate.start();
  show('2 + 3 (ответ из изолята)', await calc.add(2, 3));
  show('1.5 + 2.5', await calc.add(1.5, 2.5));
  await calc.stop();
  _t(4, 4);
  final resp = await responsivenessTest(2000000000);
  show('цикл 2 млрд итераций синхронно: тиков таймера', resp.ticksSync);
  show('цикл 2 млрд итераций в Isolate.run: тиков таймера', resp.ticksIsolate);
  _t(4, 5);
  show('Isolate.spawn + kill(priority: Isolate.immediate) — изолят завершён', await spawnAndKill());

  // ---------------- Блок 1 ----------------
  _m(1);
  show("fetchData('https://api.site.ru/items')", await fetchData('https://api.site.ru/items'));
  for (final url in ['https://api.site.ru/missing', 'https://api.site.ru/broken']) {
    try {
      await fetchData(url);
    } on ApiException catch (e) {
      show(url, e);
    }
  }
  _m(2);
  var tries = 0;
  sw = Stopwatch()..start();
  show('SocketException ×3, потом успех (паузы 1+2+4 «секунды» уменьшены в 10 раз)', await retryWithBackoff(() async {
    tries++;
    print('  попытка $tries, +${sw.elapsedMilliseconds} мс');
    if (tries < 4) throw const SocketException('нет сети');
    return 'ответ получен';
  }, unit: const Duration(milliseconds: 100)));
  _m(3);
  var running = 0, peak = 0;
  final meta = await runLimited<String>(List.generate(5, (i) => () async {
        peak = math.max(peak, ++running);
        await _w(100);
        running--;
        return 'картинка_${i + 1}.jpg';
      }), 2);
  show('метаданные 5 картинок', meta);
  show('максимум одновременных запросов', peak);
  _m(4);
  show('firstAlive: a — не отвечает, b — 300 мс, c — 100 мс', await firstAlive(['a', 'b', 'c'], (u) async {
    if (u == 'a') throw Exception('сервер недоступен');
    await _w(u == 'b' ? 300 : 100);
  }));
  _m(5);
  sw = Stopwatch()..start();
  try {
    await saveProfileWithTimeout();
  } on TimeoutException {
    show('сохранение профиля (10 с) с таймаутом 3 с', 'TimeoutException через ${sw.elapsedMilliseconds ~/ 100 / 10} с, операция прервана');
  }
  _m(6);
  final q = AsyncQueue();
  final order = <String>[];
  await Future.wait([
    q.add(() async { await _w(60); order.add('медленная задача'); }),
    q.add(() async { await _w(5); order.add('быстрая задача'); }),
    q.add(() async { order.add('мгновенная задача'); }),
  ]);
  show('порядок выполнения (строго по очереди)', order);
  _m(7);
  final bm = await benchmark(() async { await _w(120); return 'результат'; });
  show('benchmark: результат / время', '${bm.result} / ≥100 мс: ${bm.ms >= 100}');
  _m(8);
  AppConfig.resetForTests();
  final cfgs = await Future.wait([AppConfig.getInstance(), AppConfig.getInstance(), AppConfig.getInstance()]);
  show('три вызова getInstance() → загрузок', AppConfig.loads);
  show('все три — один и тот же объект', identical(cfgs[0], cfgs[2]));
  _m(9);
  show('сеть успела за 100 мс', await localOrNetwork(() async => 'локальные данные', () async { await _w(100); return 'данные из сети'; }));
  show('сеть ответила за 600 мс (лимит 300)', await localOrNetwork(() async => 'локальные данные', () async { await _w(600); return 'данные из сети'; }));
  _m(10);
  var searches = 0;
  final deb = Debouncer(const Duration(milliseconds: 300));
  for (var i = 0; i < 5; i++) {
    deb.run(() => searches++);
    await _w(50);
  }
  await _w(400);
  show('5 нажатий клавиш подряд → поисковых запросов', searches);

  // ---------------- Блок 2 ----------------
  _m(11);
  var raw = 0;
  final filtered = <double>[];
  await for (final p in filterSpikes(btcPriceStream(count: 15, interval: const Duration(milliseconds: 10)))) {
    filtered.add(p);
  }
  raw = 15;
  show('получено котировок / прошло фильтр (скачок > 5% отбрасывается)', '$raw / ${filtered.length}');
  show('первые цены', filtered.take(3).map((e) => e.toStringAsFixed(2)).toList());
  _m(12);
  await for (final p in downloadProgress(step: const Duration(milliseconds: 100))) {
    print('загружено $p%');
  }
  _m(13);
  await for (final e in navigationStream(gpsStream(count: 2, interval: const Duration(milliseconds: 20)), Stream.fromIterable([90.0, 180.0]))) {
    switch (e) {
      case LocationEvent(:final lat, :final lon):
        print('координаты: ${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}');
      case CompassEvent(:final heading):
        print('компас: $heading°');
    }
  }
  _m(14);
  final thr = await throttle(Stream.periodic(const Duration(milliseconds: 10), (i) => i).take(30), const Duration(milliseconds: 100)).toList();
  show('30 событий за ~300 мс, throttle 100 мс → пропущено в UI', thr);
  _m(15);
  final samples = [9.8, 12.0, 12.5, 9.0, 9.5, 13.0, 10.0, 11.5, 9.0];
  show('сигнал акселерометра', samples);
  show('шаги (порог 11.0)', await stepCounter(accelerometerMagnitude(samples)).toList());
  _m(16);
  var connects = 0;
  final got = <int>[];
  final rl = ResilientListener<int>(() {
    connects++;
    print('  подключение №$connects');
    if (connects == 1) return Stream<int>.error(Exception('обрыв'));
    return Stream.fromIterable([1, 2, 3]);
  }, got.add, retryDelay: const Duration(milliseconds: 100));
  await _w(300);
  show('получено после переподключения', got);
  show('переподключений', rl.reconnects);
  await rl.stop();
  _m(17);
  final bufs = await bufferCountOrTime<int>(Stream.fromIterable(List.generate(12, (i) => i)), 5, const Duration(seconds: 3)).toList();
  show('12 событий, пачки по 5', bufs);
  _m(18);
  final shown = <int>[];
  await for (final left in otpCountdown(seconds: 60, tick: const Duration(milliseconds: 5), onExpired: () => print('срок действия кода истёк'))) {
    shown.add(left);
  }
  show('обратный отсчёт 60 → 0 (шаг ускорен: 5 мс вместо 1 с)', '${shown.first} … ${shown.last}, значений: ${shown.length}');
  _m(19);
  show('скользящее среднее (окно 5) для 1..7', await movingAverage(Stream.fromIterable([1, 2, 3, 4, 5, 6, 7])).toList());
  _m(20);
  show('lastOf(Stream([1, 2, 9]))', await lastOf(Stream.fromIterable([1, 2, 9])));

  // ---------------- Блок 3 ----------------
  _m(21);
  final bus = EventBus();
  final ev = <String>[];
  final bs1 = bus.on<String>().listen((e) => ev.add('строка: $e'));
  final bs2 = bus.on<int>().listen((e) => ev.add('число: $e'));
  bus.fire('привет');
  bus.fire(5);
  await _w(10);
  await bs1.cancel();
  await bs2.cancel();
  show('полученные события', ev);
  show('EventBus() — один экземпляр', identical(EventBus(), EventBus()));
  _m(22);
  final cart = CartStore();
  cart.stream.listen((s) => print('корзина: $s'));
  cart
    ..add('Чехол', 100)
    ..add('Чехол', 100)
    ..add('Кабель', 50)
    ..remove('Чехол');
  await _w(10);
  await cart.dispose();
  _m(23);
  final badge = UnreadBadgeController();
  badge.stream.listen((n) => print('бейдж: $n'));
  badge..onNewMessage()..onNewMessage()..markAllRead();
  await _w(10);
  await badge.dispose();
  _m(24);
  final player = AudioPlayerBloc();
  player.states.listen((s) => print('состояние: ${describePlayer(s)}'));
  player..play('Song')..pause()..resume()..stop();
  await _w(10);
  await player.dispose();
  _m(25);
  final pag = FeedPaginator((p) async { await _w(20); return ['новость $p-1', 'новость $p-2']; });
  pag.feed.listen((f) => print('лента: ${f.length} элементов'));
  pag.add(LoadNextPage());
  pag.add(LoadNextPage());
  await _w(100);
  pag.add(LoadNextPage());
  await _w(100);
  await pag.dispose();
  _m(26);
  final theme = ThemeManager();
  theme.toggle();
  final tsub = theme.themeStream.listen((t) => print('тема: ${t.name}'));
  theme.toggle();
  await _w(10);
  await tsub.cancel();
  await theme.dispose();
  _m(27);
  final conn = ConnectivityController();
  conn.changes.listen((c) => print('сеть: ${c.name}'));
  conn..update(ConnectionType.wifi)..update(ConnectionType.wifi)..update(ConnectionType.none);
  await _w(10);
  await conn.dispose();
  _m(28);
  final ad = AutoDisposeController<int>();
  final l1 = ad.stream.listen((_) {}), l2 = ad.stream.listen((_) {});
  await l1.cancel();
  show('ушёл первый слушатель — контроллер закрыт?', ad.isClosed);
  await l2.cancel();
  show('ушёл последний слушатель — контроллер закрыт?', ad.isClosed);
  _m(29);
  final form = RegistrationFormBloc();
  final fsub = form.isSubmitEnabled.listen((v) => print('кнопка «Зарегистрироваться» активна: $v'));
  print('ввод email: a@b.ru');
  form.emailSink.add('a@b.ru');
  await _w(10);
  print('ввод пароля: 123');
  form.passwordSink.add('123');
  await _w(10);
  print('ввод пароля: 12345678');
  form.passwordSink.add('12345678');
  await _w(10);
  print('ввод email: bad');
  form.emailSink.add('bad');
  await _w(10);
  await fsub.cancel();
  await form.dispose();
  _m(30);
  final crash = CrashLogger();
  await crash.guard(() async {
    Timer(Duration.zero, () => throw StateError('необработанная ошибка'));
    await _w(30);
  });
  await _w(10);
  show('отправлено в аналитику', crash.sent);
  await crash.dispose();

  // ---------------- Блок 4 ----------------
  _m(31);
  final rgba = Uint8List.fromList(List.generate(4 * 4 * 4, (i) => i));
  final thumb = await generateThumbnail(rgba, 4, 4, factor: 2);
  show('изображение 4×4 (64 байта) → миниатюра 2×2', '${thumb.length} байта');
  _m(32);
  final bigText = 'Секретная заметка. ' * 20000;
  final enc = await encryptInIsolate(bigText, 'k3y');
  show('шифрование текста ${bigText.length} символов в изоляте → байт', enc.length);
  show('расшифровка совпадает с исходным текстом', decryptXor(enc, 'k3y') == bigText);
  _m(33);
  final docs = List.generate(100000, (i) => i % 1000 == 0 ? 'flutter dart flutter doc$i' : 'обычный документ $i');
  sw = Stopwatch()..start();
  final found = await searchInIsolate('flutter', docs);
  show('поиск «flutter» по 100 000 документов: найдено (индекс, релевантность)', found.take(3).toList());
  show('всего в топе', found.length);
  _m(34);
  final dist = await parseGeoJsonInIsolate(buildGeoJson(500));
  show('разобрано районов', dist.length);
  show('район №4', '${dist[3].name}, точек контура: ${dist[3].ring.length}');
  _m(35);
  final lines = List.generate(5000, (i) => 'INFO 2026-11-08 запрос #$i выполнен');
  final gz = await compressLogs(lines);
  final plain = lines.join('\n').length;
  show('логи до / после сжатия (байт)', '$plain / ${gz.length}');
  show('распаковка совпадает', decompressLogs(gz) == lines.join('\n'));
  _m(36);
  final pool = await WorkerPool.start(2);
  final pr = await Future.wait([pool.primesUpTo(100), pool.primesUpTo(1000), pool.primesUpTo(10000), pool.primesUpTo(10)]);
  show('простые числа до 100 / 1000 / 10000 / 10', pr);
  show('воркеров / задач на каждого', '${pool.size} / ${pool.jobsPerWorker}');
  pool.stop();
  _m(37);
  final rep = await buildYearReport(List.filled(12, 1000.0), List.filled(12, 400.0));
  print(rep);
  _m(38);
  final cs = await compareSort(1000000);
  show('сортировка 1 000 000 чисел в главном потоке', '${cs.mainMs} мс');
  show('сортировка в изоляте', '${cs.isolateMs} мс');
  show('результаты совпадают', cs.same);
  _m(39);
  final conv = await convertSamples(Int16List.fromList([0, 16384, -32768, 8192]));
  show('Int16 [0, 16384, -32768, 8192] → Float32', conv.toList());
  _m(40);
  final buf = Uint8List.fromList(List.generate(1 << 20, (i) => i % 256));
  final trn = await processTransferable(buf);
  show('буфер 1 МБ передан без копирования (TransferableTypedData): размер', trn.back.length);
  show('первые байты после инверсии', trn.back.sublist(0, 4));
  show('контрольная сумма', trn.checksum);

  // ---------------- Блок 5 ----------------
  _m(41);
  final tok = CancelToken();
  final pending = cancellable(tok, () async { await _w(300); return 'готово'; });
  await _w(20);
  tok.cancel();
  try {
    await pending;
  } on CancellationException catch (e) {
    show('отмена по токену во время выполнения', e);
  }
  _m(42);
  final merged = await replicate(
      () async => [const Change('name', 'A', 10), const Change('age', '20', 5)],
      () async => [const Change('name', 'B', 20), const Change('city', 'Москва', 1)]);
  show('очередь 1: name=A@10, age=20@5; очередь 2: name=B@20, city=Москва@1', '');
  show('результат (побеждает новее по timestamp)', merged.values.toList());
  _m(43);
  final net = StreamController<bool>();
  final sent = <String>[];
  final oq = OfflineOrderQueue((o) async { await _w(5); sent.add(o); print('  отправлен: $o'); }, net.stream);
  await oq.placeOrder('заказ-1');
  await oq.placeOrder('заказ-2');
  show('нет сети → в очереди заказов', oq.pendingCount);
  print('сеть восстановлена');
  net.add(true);
  await _w(100);
  show('в очереди осталось', oq.pendingCount);
  show('отправлено по порядку', sent);
  await oq.dispose();
  await net.close();
  _m(44);
  var clock = DateTime(2026, 1, 1);
  final br = CircuitBreaker(now: () => clock);
  for (var i = 1; i <= 5; i++) {
    try {
      await br<int>(() async => throw Exception('сервер упал'));
    } catch (_) {}
    print('запрос $i провалился, состояние: ${br.state.name}');
  }
  try {
    await br(() async => 1);
  } on CircuitOpenException catch (e) {
    show('запрос при открытой цепи', e);
  }
  clock = clock.add(const Duration(seconds: 31));
  show('через 31 с (время подменено)', br.state.name);
  show('пробный запрос', await br(() async => 'ок'));
  show('состояние после успеха', br.state.name);
  _m(45);
  final sem = Semaphore(3);
  await Future.wait(List.generate(10, (i) => sem.withPermit(() => _w(30))));
  show('10 задач, семафор на 3 → максимум одновременно', sem.peak);
  _m(46);
  var slowFirst = true;
  final lsrch = LatestOnlySearch((q) async {
    if (q == 'fl' && slowFirst) {
      slowFirst = false;
      await _w(150);
    } else {
      await _w(20);
    }
    return ['результат для «$q»'];
  });
  final slow = lsrch.search('fl');
  await _w(10);
  final fast = lsrch.search('flutter');
  show("быстрый ответ на 'flutter' применён", await fast);
  show("старый медленный ответ на 'fl' применён", await slow);
  show('на экране', lsrch.results);
  _m(47);
  final lc = LifecycleSubscriptionManager();
  var ticks = 0;
  lc.add(Stream.periodic(const Duration(milliseconds: 10), (i) => i).listen((_) => ticks++));
  await _w(100);
  lc.onLifecycleChanged(AppLifecycleState.paused);
  final atPause = ticks;
  print('приложение свёрнуто (paused)');
  await _w(100);
  show('тиков за время паузы', ticks - atPause <= 1 ? '0 (подписка приостановлена)' : ticks - atPause);
  lc.onLifecycleChanged(AppLifecycleState.resumed);
  print('приложение развёрнуто (resumed)');
  final afterPause = ticks;
  await _w(100);
  show('после возврата тики идут снова', ticks > afterPause);
  await lc.dispose();
  _m(48);
  final sm = SyncMachine();
  sm.states.listen((s) => print('состояние: ${switch (s) {
        SyncIdle() => 'Idle',
        Syncing(:final progress) => 'Syncing(${progress.toStringAsFixed(1)})',
        SyncSuccess() => 'Success',
        SyncError(:final message) => 'Error($message)',
      }}'));
  final first = sm.start((report) async {
    report(0.5);
    await _w(50);
  });
  show('повторный запуск во время синхронизации', await sm.start((report) async {}));
  await first;
  await sm.start((report) async => throw Exception('нет сети'));
  await _w(10);
  await sm.dispose();
  _m(49);
  final disk = <String, String>{};
  final cache = MultiLevelCache(readDisk: (k) async => disk[k], writeDisk: (k, v) async => disk[k] = v, fetchNetwork: (k) async => 'значение-$k');
  await cache.get('a');
  await cache.get('a');
  disk['b'] = 'с диска';
  await cache.get('b');
  show('обращения a, a, b → источники', cache.trace);
  _m(50);
  var socketCalls = 0;
  final term = FinancialTerminal(() {
    socketCalls++;
    if (socketCalls == 1) {
      return Stream<double>.periodic(const Duration(milliseconds: 3), (i) => 100.0 + i).take(12).map((p) {
        if (p == 108.0) throw Exception('обрыв соединения');
        return p;
      });
    }
    return Stream<double>.periodic(const Duration(milliseconds: 3), (i) => 200.0 + i).take(40);
  }, reconnectDelay: const Duration(milliseconds: 30));
  final updates = <TerminalUpdate>[];
  term.ui.listen(updates.add);
  term.start();
  await _w(500);
  await term.dispose();
  final updatesAtDispose = updates.length;
  show('котировок получено от «WebSocket»', term.rawQuotes);
  show('обновлений экрана после троттлинга (≈60 кадров/с)', updates.length);
  show('автопереподключений после обрыва', term.reconnects);
  show('последнее обновление экрана (цена, волатильность из изолята)', updates.last);
  await _w(100);
  show('после dispose() новых обновлений нет', updates.length == updatesAtDispose);
  print('Готово.');
}


Future<void> main(List<String> args) async {
  if (args.contains('--test')) {
    await runTests();
  } else {
    await runDemo();
  }
}
