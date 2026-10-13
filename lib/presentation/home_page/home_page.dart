import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/presentation/details_page/details_page.dart';

part 'card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color _color = Colors.blueAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: _color, title: Text(widget.title),centerTitle: true,),
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key}); //ключи

  @override
  Widget build(BuildContext context) {
    final data = [
      CardData(
        'iPhone 17 8/256Gb Black',
        descriptionText: 'Экран: 6.1" OLED (120 Гц)\nПроцессор: Apple A19\nКамера: 48+12 Мп\nАккумулятор: 4000 мАч',
        icon: Icons.apple,
        imageURL: 'https://ir.ozone.ru/s3/multimedia-1-6/wc1000/8126773170.jpg',
      ),
      CardData(
        'Google Pixel 11 12/512Gb Obsidian',
        descriptionText: 'Экран: 6.3" OLED (120 Гц)\nПроцессор: Google Tensor G6\nКамера: 50+48+48 Мп\nАккумулятор: 4600 мАч',
        icon: Icons.android,
        imageURL:
            'https://ir.ozone.ru/s3/multimedia-1-u/wc1000/15240413874.jpg',
      ),
      CardData(
        'Samsung Galaxy S26 12/256Gb Black',
        descriptionText: 'Экран: 6.2" AMOLED (120 Гц)\nПроцессор: Snapdragon 8 Gen 5\nКамера: 50+12+10 Мп\nАккумулятор: 4200 мАч',
        icon: Icons.android,
        imageURL: 'https://ir.ozone.ru/s3/multimedia-1-s/wc1000/9135512056.jpg',
      ),
    ];
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: data.map((data) {
            return _Card.fromData(
              data,
              onLike: (String title, bool isLiked) =>
                  _showSnackBar(context, title, isLiked),
              onTap: () => _navToDetails(context, data),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _navToDetails(BuildContext context, CardData data) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DetailsPage(data)),
    );
  }

  void _showSnackBar(BuildContext context, String title, bool isLiked) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Racoon $title ${isLiked ? 'liked!' : 'disliked :('}',
            style: Theme.of(context).textTheme.bodyLarge,
          ), //Text
          backgroundColor: Colors.blueAccent,
          duration: const Duration(seconds: 1),
        ),
      ); //SnackBar
    });
  }
}
