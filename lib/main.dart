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
        'Iphone 17',
        descriptionText: 'ahahahha',
        icon: Icons.apple,
        imageURL:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR3WBtmM5iATFCf7YUOdqg1aeZda-QLZAleCmlHaiGlTfcObBDGvPu1njKM&s=10'
      ),
      _CardData(
          'oh',
          descriptionText: 'ahahahha',
          icon: Icons.android,
          imageURL:
            'https://ir.ozone.ru/s3/multimedia-1-8/wc1000/7546850828.jpg'
      ),
      _CardData(
          ')',
          descriptionText: 'mb',
          icon: Icons.android,
          imageURL:
            'https://ir.ozone.ru/s3/multimedia-1-g/wc1000/15030916504.jpg'
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
                    fit: BoxFit.cover,
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
                        style: Theme.of(context).textTheme.headlineLarge,
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
