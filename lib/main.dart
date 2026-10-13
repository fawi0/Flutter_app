import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.black12)),
      home: const MyHomePage(title: 'Герасин Иван ПИбд-31'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Color _color = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: _color, title: Text(widget.title)),
      body: const MyWidget(),
    );
  }
}

class _CardData {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageURL;

  _CardData(this.text, {
    required this.descriptionText,
    this.icon = Icons.ac_unit_outlined,
    this.imageURL,
  });


}


class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); //ключи

  @override

  Widget build(BuildContext context) {

    final data = [
      _CardData(
        'iPhone 17 8/256Gb Black',
        descriptionText: 'Экран: 6.1" OLED (120 Гц)\nПроцессор: Apple A19\nКамера: 48+12 Мп\nАккумулятор: 4000 мАч',
        icon: Icons.apple,
        imageURL:
          'https://ir.ozone.ru/s3/multimedia-1-6/wc1000/8126773170.jpg'
      ),
      _CardData(
          'Google Pixel 11 12/512Gb Obsidian',
          descriptionText: 'Экран: 6.3" OLED (120 Гц)\nПроцессор: Google Tensor G6\nКамера: 50+48+48 Мп\nАккумулятор: 4600 мАч',
          icon: Icons.android,
          imageURL:
            'https://ir.ozone.ru/s3/multimedia-1-u/wc1000/15240413874.jpg'
      ),
      _CardData(
          'Samsung Galaxy S26 12/256Gb Black',
          descriptionText: 'Экран: 6.2" AMOLED (120 Гц)\nПроцессор: Snapdragon 8 Gen 5\nКамера: 50+12+10 Мп\nАккумулятор: 4200 мАч',
          icon: Icons.android,
          imageURL:
            'https://ir.ozone.ru/s3/multimedia-1-s/wc1000/9135512056.jpg'
      ),

    ];
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: data.map((e) => _Card.fromData(e)).toList(),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String text;
  final String descriptionText;
  final IconData icon;
  final String? imageURL;

  const _Card(
    this.text, {
    this.icon = Icons.ac_unit_outlined,
    required this.descriptionText,
    this.imageURL,
  });

  factory _Card.fromData(_CardData data) =>
      _Card(
        data.text,
        descriptionText: data.descriptionText,
        icon: data.icon,
        imageURL: data.imageURL,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: Colors.grey,
            width: 2
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.5),
              spreadRadius:4,
              offset: const Offset(0,5),
              blurRadius: 8,
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
                height: 140,
                width: 90,
                child: Image.network(
                    imageURL ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Placeholder(),
              ),
            ),
          ),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        text,
                        style: const TextStyle(fontSize: 18, fontWeight:  FontWeight.bold)
                    ),
                    Text(
                      descriptionText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Icon(icon),
          ),
        ],
      ),
    );
  }
}
