import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _usdRate = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchDollarRate();
  }

  // Метод для получения курса доллара
  Future<void> _fetchDollarRate() async {
    final response = await http
        .get(Uri.parse('https://cbu.uz/uz/arkhiv-kursov-valyut/json/'));

    if (response.statusCode == 200) {
      List<dynamic> rates = json.decode(response.body);
      setState(() {
        // Находим курс USD
        var usdRate = rates.firstWhere((rate) => rate['Ccy'] == 'USD');
        _usdRate = usdRate['Rate'].toString();
      });
    } else {
      setState(() {
        _usdRate = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('kurs: $_usdRate UZS'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ChristmasTree(),
        ),
      ),
    );
  }
}

class ChristmasTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Высота елки
    int height = 50;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(height, (i) {
        // Количество символов "X" увеличивается на каждом уровне
        String row = 'X' * (i + 1);
        return Text(
          row,
          style: TextStyle(fontSize: 20, fontFamily: 'Courier'),
        );
      }),
    );
  }
}
