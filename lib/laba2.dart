import 'dart:async';

enum Brand { apple, samsung, google, xiaomi, unknown }
enum OrderStatus { created, processing, paid, shipped, cancelled }
enum PaymentMethod { card, sbp, crypto, cash }

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
  double get feePercentage {
    return switch (this) {
      PaymentMethod.card => 0.02,
      PaymentMethod.sbp => 0.0,
      PaymentMethod.crypto => 0.1,
      PaymentMethod.cash => 0.0,
    };
  }
}

extension PriceFormatterX on double {
  String toRubles() => '${toStringAsFixed(2)} руб.';
}

abstract class StoreItem {
  final String id;
  final String title;
  double _basePrice;

  StoreItem(this.id, this.title, this._basePrice);

  double get price => _basePrice;
  set price(double newPrice) {
    if (newPrice >= 0) {
      _basePrice = newPrice;
    } else {
      print('Ошибка: цена не может быть отрицательной!');
    }
  }

  String get info;
}

class Smartphone extends StoreItem {
  final Brand brand;
  final int ramGb;
  final int storageGb;
  int stockCount;//количество на складе


  Smartphone({
    required String id,
    required String title,
    required double price,
    required this.brand,
    required this.ramGb,
    required this.storageGb,
    this.stockCount = 1,
  }) : super(id, title, price);

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


class StorageRepository<T extends StoreItem> {
  final List<T> _items = [];

  void add(T item) => _items.add(item);

  void addAll(List<T> newItems) => _items.addAll(newItems);

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

class Order {
  static int _orderCounter = 100;
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

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.price);

  double get totalWithFee {
    final fee = subtotal * paymentMethod.feePercentage;
    return subtotal + fee;
  }

  void printReceipt() {
    print('ЧЕК ЗАКАЗА #$orderNumber для клиента: $customerName');
    print('Статус: ${status.description}\n');
    for (int i = 0; i < items.length; i++) {
      print('${i + 1}. ${items[i].title} — ${items[i].price.toRubles()}');
    }
    print('Сумма без комиссии: ${subtotal.toRubles()}');
    print('Способ оплаты: ${paymentMethod.name} (Комиссия: ${(paymentMethod.feePercentage * 100)}%)');
    print('ИТОГО К ОПЛАТЕ: ${totalWithFee.toRubles()}');
    print('\n');
  }
}

class ShopEngine {
  final StorageRepository<Smartphone> warehouse;

  ShopEngine(this.warehouse);

  // Асинхронная имитация загрузки базы данных с сервера
  Future<void> initializeDatabase() async {
    print('Подключение к серверу склада...');
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
        storageGb: 128,
        stockCount: 4,
      ),
    ]);

    print('База данных загружена. Товаров в каталоге: ${warehouse.allItems.length}\n');
  }

  Future<bool> processOrder(Order order) async {
    print('Обработка заказа #${order.orderNumber}...');
    order.status = OrderStatus.processing;
    await Future.delayed(const Duration(milliseconds: 500));

    int index = 0;
    bool allAvailable = true;
    while (index < order.items.length) {
      final phone = order.items[index];
      index++;
      if (phone.isInStock) {
        continue;
      } else {
        print('Ошибка комплектации: смартфон "${phone.title}" закончился на складе!');
        allAvailable = false;
        break;
      }
    }

    if (!allAvailable) {
      order.status = OrderStatus.cancelled;
      return false;
    }

    for (final phone in order.items) {
      phone.stockCount -= 1;
    }

    print('Проведение транзакции через (${order.paymentMethod.name})...');
    await Future.delayed(const Duration(milliseconds: 800));

    order.status = OrderStatus.paid;
    print('Оплата прошла успешно!');
    return true;
  }
}


Future<void> main() async {
  print('\n');

  final storage = StorageRepository<Smartphone>();
  final shop = ShopEngine(storage);

  await shop.initializeDatabase();

  final firstPhone = storage.allItems.first;
  print('Снижение цены на ${firstPhone.title}!');
  firstPhone.price = 94990.0;

  print('\n--- Текущий каталог всех смартфонов ---');
  storage.allItems.forEach((phone) => print(phone.info));

  final availableFlagships = storage.filter(
        (phone) => phone.isInStock && phone.storageGb >= 256,
  );

  print('\nДоступные для покупки смартфоны (от 256 ГБ)');
  for (final item in availableFlagships) {
    print('• ${item.title} (${item.price.toRubles()})');
  }

  // 5. Создаем заказ для клиента
  final myOrder = Order(
    customerName: 'Герасин Иван',
    items: [availableFlagships[0], availableFlagships[1]],
    paymentMethod: PaymentMethod.card,
  );

  final isSuccess = await shop.processOrder(myOrder);

  if (isSuccess) {
    Future.delayed(const Duration(milliseconds: 400)).then((_) {
      myOrder.status = OrderStatus.shipped;
      myOrder.printReceipt();
    });
  }
}