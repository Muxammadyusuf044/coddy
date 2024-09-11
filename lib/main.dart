import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '1sahifa.dart';
import '2sahifa.dart';
import '3sahifa.dart';
import '4sahifa.dart';
import '5sahifa.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Imtixon(),
  ));
}

class Imtixon extends StatefulWidget {
  const Imtixon({super.key});

  @override
  State<Imtixon> createState() => _ImtixonState();
}

class _ImtixonState extends State<Imtixon> {
  int currentIndex = 2;

  // Создадим список с экранами
  final List<Widget> pages = [
    HomePage(),
    WindPage(),
    ProfilePage(),
    SettingsPage(),
    MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex], // Отображаем текущую страницу
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.transparent,
        color: Colors.blue.shade900,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            currentIndex = index; // Обновляем индекс при выборе
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.black),
          Icon(Icons.wind_power, color: Colors.black),
          Icon(Icons.person, color: Colors.black),
          Icon(Icons.settings, color: Colors.black),
          Icon(Icons.format_align_justify_outlined, color: Colors.black),
        ],
      ),
    );
  }
}
