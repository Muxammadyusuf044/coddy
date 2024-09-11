import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<String> mangaImages = [
    "assets/rasm1.jpg",
    "assets/rasm2.jpg",
    "assets/rasm3.jpeg",
    "assets/rasm4.jpeg",
    "assets/rasm5.jpeg",
    "assets/rasm6.jpeg",
    "assets/rasm7.jpeg",
    "assets/rasm8.jpeg",
    "assets/rasm9.jpeg",
    "assets/rasm10.jpeg",
    "assets/rasm11.jpeg",
    "assets/rasm12.jpeg",
    "assets/rasm13.jpeg",
    "assets/rasm14.jpeg",
    "assets/rasm15.jpeg",
  ];

  List<Map<int, bool>> visibleCards = [];
  List<String> gameBoard = [];
  List<int> selectedCards = [];

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void restartGame() {
    setState(() {
      initGame();
    });
  }

  void initGame() {
    gameBoard = List.from(mangaImages)..addAll(mangaImages);
    gameBoard.shuffle();
    visibleCards = List.generate(gameBoard.length, (index) => {index: false});
    selectedCards = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '1989',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        actions: [
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                restartGame();
              },
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/refresh.png"),
                backgroundColor: Colors.blue.shade900,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
        child: Container(
          child: GridView.builder(
            itemCount: gameBoard.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => onCardTapped(index),
                child: Card(
                  color: visibleCards[index][index]!
                      ? Colors.white
                      : Colors.blueGrey[400],
                  child: visibleCards[index][index]!
                      ? Image.asset(
                          gameBoard[index],
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void onCardTapped(int index) {
    setState(() {
      visibleCards[index][index] = true;
      selectedCards.add(index);

      if (selectedCards.length == 2) {
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            if (gameBoard[selectedCards[0]] == gameBoard[selectedCards[1]]) {
              visibleCards[selectedCards[0]][selectedCards[0]] = true;
              visibleCards[selectedCards[1]][selectedCards[1]] = true;
            } else {
              visibleCards[selectedCards[0]][selectedCards[0]] = false;
              visibleCards[selectedCards[1]][selectedCards[1]] = false;
            }
            selectedCards.clear();
          });
        });
      }
    });
  }
}
