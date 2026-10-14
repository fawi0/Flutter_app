import 'dart:async';

// ==================== 1. ENUMS (Перечисления) ====================
enum Brand { apple, samsung, google, xiaomi, unknown }

enum OrderStatus { created, processing, paid, shipped, cancelled }

enum PaymentMethod { card, sbp, crypto, cash }

// ==================== 2. EXTENSIONS (Расширения) ====================
extension OrderStatusX on OrderStatus {
String get description {
  switch (this) {
    case OrderStatus.created:
      return 'Заказ создан и ожидает подтверждения';
    case OrderStatus.processing:
      return 'Заказ комплектуется на складе';
    case OrderStatus.paid:
      return 'Заказ успешно оплачен';
    case OrderStatus.shipped:
      return 'Заказ передан в курьерскую службу';
    case OrderStatus.cancelled:
      return 'Заказ отменен';
  }
}
}

extension PaymentMethodX on PaymentMethod {
  // Возвращает процент комиссии в зависимости от способа оплаты
  double get feePercentage {
    return switch (this) {
      PaymentMethod.card => 0.02,   // 2% комиссия
      PaymentMethod.sbp => 0.0,     // Без комиссии
      PaymentMethod.crypto => 0.01, // 1% комиссия
      PaymentMethod.cash => 0.0,
    };
  }
}

extension PriceFormatterX on double {
  String toRubles() => '${toStringAsFixed(2)} руб.';
}

// ==================== 3. КЛАССЫ И ООП ====================
// Абстрактный базовый класс для любого товара в магазине
abstract class StoreItem {
  final String id;
  final String title;
  double _basePrice; // Приватное поле

  StoreItem(this.id, this.title, this._basePrice);

  // Геттер для получения цены
  double get price => _basePrice;

  // Сеттер с валидацией (как в лекции)
  set price(double newPrice) {
    if (newPrice >= 0) {
      _basePrice = newPrice;
    } else {
      print('Ошибка: цена не может быть отрицательной!');
    }
  }

  String get info;
}

// Класс смартфона, наследующийся от базового товара
class Smartphone extends StoreItem {
  final Brand brand;
  final int ramGb;
  final int storageGb;
  int stockCount;

  // Основной конструктор с параметрами и вызовом super
  Smartphone({
    required String id,
    required String title,
    required double price,
    required this.brand,
    required this.ramGb,
    required this.storageGb,
    this.stockCount = 1,
  }) : super(id, title, price);

  // Именованный конструктор для быстрого создания флагманов Apple
  Smartphone.appleFlagship({
    required String id,
    required String modelName,
    required double price,
    required this.storageGb,
    this.stockCount = 5,
  })  : brand = Brand.apple,
        ramGb = 8,
        super(id, modelName, price);

  bool get isInStock => stockCount > 0;

  @override
  String get info =>
      '[${brand.name.toUpperCase()}] $title ($ramGb/$storageGb ГБ) — ${price.toRubles()} (В наличии: $stockCount шт.)';
}

// ==================== 4. GENERICS (Дженерики) ====================
// Универсальный репозиторий для хранения любых товаров, наследуемых от StoreItem
class StorageRepository<T extends StoreItem> {
  final List<T> _items = [];

  void add(T item) => _items.add(item);

  void addAll(List<T> newItems) => _ite ms.addAll(newItems);

  List<T> get allItems => List.unmodifiable(_items);

  // Поиск элементов с использованием анонимной функции-предиката
  List<T> filter(bool Function(T item) predicate) {
    final List<T> result = [];
    for (final item in _items) {
      if (predicate(item)) {
        result.add(item);
      }
    }
    return result;
  }
}

// Класс заказа
class Order {
  static int _orderCounter = 100; // Статическое поле для генерации номеров
  final int orderNumber;
  final String customerName;
  final List<Smartphone> items;
  final PaymentMethod paymentMethod;
  OrderStatus status;

  Order({
    required this.customerName,
    required this.items,
    required this.paymentMethod,
  })  : orderNumber = ++_orderCounter,
        status = OrderStatus.created;

  // Подсчет суммы заказа с помощью анонимной функции в методе fold
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.price);

  double get totalWithFee {
    final fee = subtotal * paymentMethod.feePercentage;
    return subtotal + fee;
  }

  void printReceipt() {
    print('\n========================================');
    print('ЧЕК ЗАКАЗА #$orderNumber для клиента: $customerName');
    print('Статус: ${status.description}');
    print('----------------------------------------');
    // Классический цикл for со счетчиком
    for (int i = 0; i < items.length; i++) {
      print('${i + 1}. ${items[i].title} — ${items[i].price.toRubles()}');
    }
    print('----------------------------------------');
    print('Сумма без комиссии: ${subtotal.toRubles()}');
    print('Способ оплаты: ${paymentMethod.name} (Комиссия: ${(paymentMethod.feePercentage * 100)}%)');
    print('ИТОГО К ОПЛАТЕ: ${totalWithFee.toRubles()}');
    print('========================================\n');
  }
}

// ==================== 5. АСИНХРОННОСТЬ (Future) И ЛОГИКА ====================
class ShopEngine {
  final StorageRepository<Smartphone> warehouse;

  ShopEngine(this.warehouse);

  // Асинхронная имитация загрузки базы данных с сервера
  Future<void> initializeDatabase() async {
    print('⏳ Подключение к серверу склада...');
    await Future.delayed(const Duration(milliseconds: 600));

    warehouse.addAll([
      Smartphone.appleFlagship(
        id: 'ip17',
        modelName: 'iPhone 17 Black',
        price: 99990.0,
        storageGb: 256,
        stockCount: 3,
      ),
      Smartphone(
        id: 'px11',
        title: 'Google Pixel 11 Obsidian',
        price: 79990.0,
        brand: Brand.google,
        ramGb: 12,
        storageGb: 512,
        stockCount: 2,
      ),
      Smartphone(
        id: 's26',
        title: 'Samsung Galaxy S26',
        price: 89990.0,
        brand: Brand.samsung,
        ramGb: 12,
        storageGb: 256,
        stockCount: 0, // Нет в наличии
      ),
      Smartphone(
        id: 'mi15',
        title: 'Xiaomi 15 Pro',
        price: 69990.0,
        brand: Brand.xiaomi,
        ramGb: 16,
        storageGb: 512,
        stockCount: 4,
      ),
    ]);

    print('✅ База данных успешно загружена! Товаров в каталоге: ${warehouse.allItems.length}\n');
  }

  // Асинхронная обработка заказа с использованием циклов и Future
  Future<bool> processOrder(Order order) async {
    print('🔄 Начинаем обработку заказа #${order.orderNumber}...');
    order.status = OrderStatus.processing;
    await Future.delayed(const Duration(milliseconds: 500));

    // Проверим наличие товаров с помощью цикла while, continue и break
    int index = 0;
    bool allAvailable = true;

    while (index < order.items.length) {
      final phone = order.items[index];
      index++;

      if (phone.isInStock) {
        continue; // Если товар есть, переходим к следующему
      } else {
        print('❌ Ошибка комплектации: смартфон "${phone.title}" закончился на складе!');
        allAvailable = false;
        break; // Прерываем проверку при первой же нехватке товара
      }
    }

    if (!allAvailable) {
      order.status = OrderStatus.cancelled;
      return false;
    }

    // Уменьшаем остатки на складе (цикл for-in)
    for (final phone in order.items) {
      phone.stockCount -= 1;
    }

    print('💳 Проведение транзакции через шлюз (${order.paymentMethod.name})...');
    await Future.delayed(const Duration(milliseconds: 800));

    order.status = OrderStatus.paid;
    print('✅ Оплата прошла успешно!');
    return true;
  }
}

// ==================== ТОЧКА ВХОДА (MAIN) ====================
Future<void> main() async {
  print('=== ЗАПУСК СИСТЕМЫ УПРАВЛЕНИЯ МАГАЗИНОМ ===\n');

  final storage = StorageRepository<Smartphone>();
  final shop = ShopEngine(storage);

  // 1. Ждем инициализации БД
  await shop.initializeDatabase();

  // 2. Используем сеттер для изменения цены одного из товаров (акция)
  final firstPhone = storage.allItems.first;
  print('🔥 Снижение цены на ${firstPhone.title}!');
  firstPhone.price = 94990.0;

  // 3. Выводим все товары через анонимную функцию в forEach
  print('\n--- Текущий каталог всех смартфонов ---');
  storage.allItems.forEach((phone) => print(phone.info));

  // 4. Фильтрация с помощью Generics-метода и анонимной функции
  final availableFlagships = storage.filter(
        (phone) => phone.isInStock && phone.storageGb >= 256,
  );

  print('\n--- Доступные для покупки смартфоны (от 256 ГБ) ---');
  for (final item in availableFlagships) {
    print('• ${item.title} (${item.price.toRubles()})');
  }

  // 5. Создаем заказ для клиента
  final myOrder = Order(
    customerName: 'Герасин Иван',
    items: [availableFlagships[0], availableFlagships[1]],
    paymentMethod: PaymentMethod.card,
  );

  // 6. Обрабатываем заказ асинхронно
  final isSuccess = await shop.processOrder(myOrder);

  // 7. Демонстрация Future API (.then), как в конце лекции
  if (isSuccess) {
    Future.delayed(const Duration(milliseconds: 400)).then((_) {
      myOrder.status = OrderStatus.shipped;
      myOrder.printReceipt();
    });
  }
}