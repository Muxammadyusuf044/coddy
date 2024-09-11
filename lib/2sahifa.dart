import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:ui';

class WindPage extends StatefulWidget {
  @override
  _WindPageState createState() => _WindPageState();
}

class _WindPageState extends State<WindPage> {
  List<Map<String, String>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems(); // Загрузка данных при запуске приложения
  }

  // Метод для загрузки сохраненных данных
  void _loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? items = prefs.getString('items');
    if (items != null) {
      setState(() {
        _items = List<Map<String, String>>.from(
            json.decode(items).map((item) => Map<String, String>.from(item)));
      });
    }
  }

  // Метод для сохранения данных
  void _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('items', json.encode(_items));
  }

  // Метод для удаления элемента из списка
  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _saveItems(); // Сохранение изменений после удаления
    });
  }

  // Метод для редактирования элемента
  void _editItem(int index) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return EditItemDialog(
          initialText: _items[index]['text']!,
          initialTime: _items[index]['time']!,
          initialDate: _items[index]['date']!,
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _items[index] = result;
        _saveItems(); // Сохранение данных после редактирования элемента
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Фоновое изображение
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/q.webp"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Список элементов
          _items.isEmpty
              ? Center(
                  child: Text(
                    '',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " ${_items[index]['text']}",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Time: ${_items[index]['time']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "Date: ${_items[index]['date']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit, // Иконка для редактирования
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _editItem(
                                  index); // Редактирование элемента при нажатии
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete, // Иконка для удаления
                              color: Colors.black,
                            ),
                            onPressed: () {
                              _removeItem(
                                  index); // Удаление элемента при нажатии
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple.shade200,
        onPressed: () async {
          final result = await showDialog<Map<String, String>>(
            context: context,
            builder: (BuildContext context) {
              return AddItemDialog();
            },
          );

          if (result != null && result.isNotEmpty) {
            setState(() {
              _items.add(result);
              _saveItems(); // Сохранение данных после добавления нового элемента
            });
          }
        },
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors
          .transparent, // Сделаем фон прозрачным, чтобы было видно изображение
    );
  }
}

// Виджет для эффекта стеклянного морфизма
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;

  GlassmorphicContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6), // Уменьшенный margin
      padding: EdgeInsets.all(8), // Уменьшенный padding
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8), // Уменьшенный borderRadius
        color: Colors.white.withOpacity(0.2), // Полупрозрачный белый цвет
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: BackdropFilter(
        filter:
            ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0), // Уменьшенное размытие
        child: child,
      ),
    );
  }
}

class AddItemDialog extends StatefulWidget {
  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  TextEditingController _textFieldController = TextEditingController();
  DateTime _currentDateTime = DateTime.now(); // Текущая дата и время

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text("Ma'lumot kiriting"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              labelText: 'Ism kiriting',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'text': _textFieldController.text,
              'time':
                  "${_currentDateTime.hour}:${_currentDateTime.minute}", // Авто время
              'date':
                  "${_currentDateTime.day}/${_currentDateTime.month}/${_currentDateTime.year}", // Авто дата
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Add",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class EditItemDialog extends StatefulWidget {
  final String initialText;
  final String initialTime;
  final String initialDate;

  EditItemDialog({
    required this.initialText,
    required this.initialTime,
    required this.initialDate,
  });

  @override
  _EditItemDialogState createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  TextEditingController _textFieldController = TextEditingController();
  DateTime _currentDateTime = DateTime.now(); // Текущие дата и время

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.initialText;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text("Edit Item"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
              labelText: 'Text',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop({
              'text': _textFieldController.text,
              'time':
                  "${_currentDateTime.hour}:${_currentDateTime.minute}", // Авто время
              'date':
                  "${_currentDateTime.day}/${_currentDateTime.month}/${_currentDateTime.year}", // Авто дата
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
